
#!/usr/bin/env python3
"""
MIT 8103 - Advanced Database Systems
Portfolio 3: Transactions and Concurrency Control

Organisation: Sotai Digital Solutions
System: Enterprise IT Service Management and Asset Monitoring System
Database: PostgreSQL 16
"""

import os
import json
import threading
from pathlib import Path

import psycopg2
from psycopg2 import errors

# --------------------------------------------------
# CONFIGURATION
# --------------------------------------------------

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "evidence" / "portfolio-3"
OUT.mkdir(parents=True, exist_ok=True)

PARAMS = {
    "host": os.getenv("PGHOST", "127.0.0.1"),
    "port": int(os.getenv("PGPORT", "5432")),
    "dbname": os.getenv("PGDATABASE", "sotai_itsm"),
    "user": os.getenv("PGUSER", "sotai_admin"),
    "password": os.getenv(
        "POSTGRES_PASSWORD",
        os.getenv("PGPASSWORD", "")
    ),
    "connect_timeout": 5,
}

logs = []


def log(message):
    print(message, flush=True)
    logs.append(message)


def conn():
    connection = psycopg2.connect(**PARAMS)
    connection.autocommit = False

    with connection.cursor() as cursor:
        cursor.execute("SET lock_timeout = '3000ms'")
        cursor.execute("SET statement_timeout = '10000ms'")

    connection.commit()
    return connection


def scalar(connection, sql, args=()):
    with connection.cursor() as cursor:
        cursor.execute(sql, args)
        return cursor.fetchone()[0]


def test_connection():
    with conn() as connection:
        database = scalar(
            connection,
            "SELECT current_database()"
        )

    log(f"DATABASE CONNECTION PASS: {database}")


# --------------------------------------------------
# MAIN TEST SUITE
# --------------------------------------------------

def run():

    test_connection()

    # STEP 1 - RESET TEST DATA

    with conn() as connection:
        with connection.cursor() as cursor:

            cursor.execute(
                "SELECT to_regclass(%s)",
                ("public.transaction_tickets",)
            )

            if cursor.fetchone()[0] is None:
                raise RuntimeError(
                    "transaction_tickets missing. Run setup.sql first."
                )

            cursor.execute(
                """
                SELECT COUNT(*)
                FROM transaction_tickets
                WHERE ticket_id BETWEEN 101 AND 105
                """
            )

            if cursor.fetchone()[0] != 5:
                raise RuntimeError(
                    "Expected five test tickets (101-105)."
                )

            cursor.execute(
                """
                UPDATE transaction_tickets
                SET status = 'Open',
                    version_number = 1
                WHERE ticket_id BETWEEN 101 AND 105
                """
            )

            cursor.execute(
                """
                DELETE FROM transaction_audit
                WHERE ticket_id BETWEEN 101 AND 105
                """
            )

    log("RESET PASS: Five test tickets reset successfully")

    # STEP 2 - COMMIT

    with conn() as connection:
        with connection.cursor() as cursor:

            cursor.execute(
                """
                UPDATE transaction_tickets
                SET status = 'In Progress',
                    version_number = version_number + 1
                WHERE ticket_id = 101
                """
            )

            cursor.execute(
                """
                INSERT INTO transaction_audit(ticket_id, action)
                VALUES (101, 'Automated commit test')
                """
            )

    with conn() as connection:
        assert scalar(
            connection,
            """
            SELECT status
            FROM transaction_tickets
            WHERE ticket_id = 101
            """
        ) == "In Progress"

    log("COMMIT PASS: Ticket 101 changes persisted")

    # STEP 3 - ROLLBACK

    connection = conn()

    try:
        with connection.cursor() as cursor:
            cursor.execute(
                """
                UPDATE transaction_tickets
                SET status = 'Closed'
                WHERE ticket_id = 102
                """
            )

        connection.rollback()

    finally:
        connection.close()

    with conn() as connection:
        assert scalar(
            connection,
            """
            SELECT status
            FROM transaction_tickets
            WHERE ticket_id = 102
            """
        ) == "Open"

    log("ROLLBACK PASS: Ticket 102 remains Open")

    # STEP 4 - SAVEPOINT

    with conn() as connection:
        with connection.cursor() as cursor:

            cursor.execute(
                """
                UPDATE transaction_tickets
                SET status = 'In Progress'
                WHERE ticket_id = 103
                """
            )

            cursor.execute("SAVEPOINT before_closure")

            cursor.execute(
                """
                UPDATE transaction_tickets
                SET status = 'Closed'
                WHERE ticket_id = 103
                """
            )

            cursor.execute(
                "ROLLBACK TO SAVEPOINT before_closure"
            )

    with conn() as connection:
        assert scalar(
            connection,
            """
            SELECT status
            FROM transaction_tickets
            WHERE ticket_id = 103
            """
        ) == "In Progress"

    log("SAVEPOINT PASS: Partial rollback successful")

    # STEP 5 - ATOMICITY

    connection = conn()

    try:
        with connection.cursor() as cursor:

            cursor.execute(
                """
                UPDATE transaction_tickets
                SET status = 'Resolved'
                WHERE ticket_id = 104
                """
            )

            try:
                cursor.execute(
                    """
                    INSERT INTO transaction_audit(ticket_id, action)
                    VALUES (9999, 'Invalid foreign key')
                    """
                )

                raise AssertionError(
                    "Expected foreign key violation"
                )

            except errors.ForeignKeyViolation:
                connection.rollback()

    finally:
        connection.close()

    with conn() as connection:
        assert scalar(
            connection,
            """
            SELECT status
            FROM transaction_tickets
            WHERE ticket_id = 104
            """
        ) == "Open"

    log("ATOMICITY PASS: Invalid transaction rolled back")

    # STEP 6 - OPTIMISTIC CONCURRENCY

    with conn() as connection:
        with connection.cursor() as cursor:

            cursor.execute(
                """
                UPDATE transaction_tickets
                SET status = 'In Progress',
                    version_number = version_number + 1
                WHERE ticket_id = 105
                  AND version_number = 1
                """
            )

            first = cursor.rowcount

            cursor.execute(
                """
                UPDATE transaction_tickets
                SET status = 'Closed',
                    version_number = version_number + 1
                WHERE ticket_id = 105
                  AND version_number = 1
                """
            )

            second = cursor.rowcount

    assert (first, second) == (1, 0)

    log(
        "OPTIMISTIC CONCURRENCY PASS: "
        "Stale version update rejected"
    )

    # STEP 7 - TRANSACTION ISOLATION

    isolation = []

    for level in ("READ COMMITTED", "REPEATABLE READ"):

        with conn() as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    UPDATE transaction_tickets
                    SET status = 'Open'
                    WHERE ticket_id = 102
                    """
                )

        a = conn()
        b = conn()

        try:
            with a.cursor() as ca, b.cursor() as cb:

                ca.execute(
                    "SET TRANSACTION ISOLATION LEVEL " + level
                )

                ca.execute(
                    """
                    SELECT status
                    FROM transaction_tickets
                    WHERE ticket_id = 102
                    """
                )

                before = ca.fetchone()[0]

                cb.execute(
                    """
                    UPDATE transaction_tickets
                    SET status = 'Resolved'
                    WHERE ticket_id = 102
                    """
                )

                b.commit()

                ca.execute(
                    """
                    SELECT status
                    FROM transaction_tickets
                    WHERE ticket_id = 102
                    """
                )

                after = ca.fetchone()[0]

            a.commit()

        finally:
            a.close()
            b.close()

        expected = (
            "Resolved"
            if level == "READ COMMITTED"
            else "Open"
        )

        assert (before, after) == ("Open", expected)

        isolation.append({
            "level": level,
            "first_read": before,
            "second_read": after
        })

        log(
            f"ISOLATION PASS ({level}): "
            f"first={before}, second={after}"
        )

    # STEP 8 - DEADLOCK DETECTION

    a = conn()
    b = conn()

    result = {}

    ready_a = threading.Event()
    ready_b = threading.Event()
    go = threading.Event()

    def worker(name, connection, first, second, ready):

        try:
            with connection.cursor() as cursor:

                cursor.execute(
                    "SET deadlock_timeout = '200ms'"
                )

                cursor.execute(
                    "SET lock_timeout = '5s'"
                )

                cursor.execute(
                    """
                    UPDATE transaction_tickets
                    SET status = 'In Progress'
                    WHERE ticket_id = %s
                    """,
                    (first,)
                )

                ready.set()

                if not go.wait(4):
                    raise RuntimeError(
                        "Synchronization timeout"
                    )

                cursor.execute(
                    """
                    UPDATE transaction_tickets
                    SET status = 'Resolved'
                    WHERE ticket_id = %s
                    """,
                    (second,)
                )

                result[name] = "completed"

        except errors.DeadlockDetected:
            result[name] = (
                "deadlock detected (SQLSTATE 40P01)"
            )

        except Exception as exc:
            result[name] = (
                f"ERROR: {type(exc).__name__}: {exc}"
            )

        finally:
            connection.rollback()

    try:
        ta = threading.Thread(
            target=worker,
            args=("A", a, 101, 102, ready_a)
        )

        tb = threading.Thread(
            target=worker,
            args=("B", b, 102, 101, ready_b)
        )

        ta.start()
        tb.start()

        if not (
            ready_a.wait(5)
            and ready_b.wait(5)
        ):
            go.set()
            raise RuntimeError(
                "Could not acquire initial locks"
            )

        go.set()

        ta.join(8)
        tb.join(8)

        if ta.is_alive() or tb.is_alive():
            raise RuntimeError(
                "Deadlock test did not terminate"
            )

        assert any(
            "deadlock detected" in value
            for value in result.values()
        ), result

        assert any(
            value == "completed"
            for value in result.values()
        ), result

        log(
            "DEADLOCK PASS: "
            + json.dumps(result, sort_keys=True)
        )

    finally:
        go.set()

        # Ensure workers finish before closing connections.
        if "ta" in locals():
            ta.join(timeout=6)
        if "tb" in locals():
            tb.join(timeout=6)

        a.close()
        b.close()

    # STEP 9 - FINAL DATABASE VERIFICATION

    with conn() as connection:
        with connection.cursor() as cursor:

            cursor.execute(
                """
                SELECT ticket_id, status, version_number
                FROM transaction_tickets
                WHERE ticket_id BETWEEN 101 AND 105
                ORDER BY ticket_id
                """
            )

            rows = cursor.fetchall()

    log(
        "FINAL TEST TICKETS: "
        + json.dumps(rows)
    )

    # STEP 10 - SAVE EVIDENCE

    results = {
        "organisation": "Sotai Digital Solutions",
        "course": "MIT 8103",
        "portfolio": "Transactions and Concurrency Control",
        "isolation": isolation,
        "deadlock": result,
        "tickets": rows
    }

    (OUT / "automated-results.json").write_text(
        json.dumps(results, indent=2) + "\n",
        encoding="utf-8"
    )

    log("ALL TESTS PASSED")


if __name__ == "__main__":

    try:
        run()

    except Exception as exc:
        log("TEST FAILED: " + repr(exc))
        raise

    finally:
        (OUT / "automated-results.txt").write_text(
            "\n".join(logs) + "\n",
            encoding="utf-8"
        )
