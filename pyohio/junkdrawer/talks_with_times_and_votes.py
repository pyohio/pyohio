# vim: set expandtab ts=4 sw=4 filetype=python fileencoding=utf8:

import argparse
import os
import textwrap

import psycopg2

def create_view(pgconn):

    cursor = pgconn.cursor()

    cursor.execute("drop view if exists all_proposals")

    # It would be cooler to use pkg_resources for this.
    sql_file = os.path.join(
        os.path.dirname(__file__),
        "talks_with_times_and_votes.sql")


    cursor.execute(open(sql_file).read())

def dump_to_csv(pgconn):

    copy_query = textwrap.dedent("""
        copy (
            select *
            from all_proposals
        )
        to stdout
        with csv header""")

    cursor = pgconn.cursor()

    cursor.copy_expert(
        copy_query,
        open("/var/pyohio2015/proposals.csv", "w"))

def dump_to_json(pgconn):

    query = textwrap.dedent("""
        select to_json(array_agg(ap))
        from all_proposals ap
        """)

    cursor = pgconn.cursor()

    cursor.execute(query)

    outfile = open("/var/pyohio2015/proposals.json", "w")

    outfile.write(",\n".join(row[0] for row in cursor))

    # subprocess.check_call(["jq", "'.'", "/var/pyohio/proposals.json",
    # ">", "/var/pyohio/pretty-proposals.json"])

    outfile.close()


if __name__ == "__main__":

    pgconn = psycopg2.connect(database="pyohio2015")

    create_view(pgconn)

    dump_to_csv(pgconn)

    dump_to_json(pgconn)

    pgconn.commit()
