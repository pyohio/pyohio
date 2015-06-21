# vim: set expandtab ts=4 sw=4 filetype=python fileencoding=utf8:

import argparse
import os
import textwrap

import psycopg2

def set_up_args():

    ap = argparse.ArgumentParser()
    ap.add_argument("database_name")
    return ap.parse_args()

def dump_to_csv(pgconn, table_name):

    copy_query = textwrap.dedent("""
        copy (
            select *
            from {0}
        )
        to stdout
        with csv header""".format(table_name))

    cursor = pgconn.cursor()

    cursor.copy_expert(
        copy_query,
        open("/var/pyohio2015/{0}.csv".format(table_name), "w"))

def dump_to_json(pgconn, table_name):

    query = textwrap.dedent("""
        select to_json(array_agg(xxx))
        from {0} xxx
        """.format(table_name))

    cursor = pgconn.cursor()

    cursor.execute(query)

    outfile = open("/var/pyohio2015/{0}.json".format(table_name), "w")

    outfile.write(",\n".join(row[0] for row in cursor))

    # subprocess.check_call(["jq", "'.'", "/var/pyohio/proposals.json",
    # ">", "/var/pyohio/pretty-proposals.json"])

    outfile.close()


if __name__ == "__main__":

    args = set_up_args()

    pgconn = psycopg2.connect(database=args.database_name)

    for table_name in ["all_proposals", "top_proposals",
        "pretty_schedule", "unscheduled_proposals"]:

        dump_to_csv(pgconn, table_name)
        dump_to_json(pgconn, table_name)
