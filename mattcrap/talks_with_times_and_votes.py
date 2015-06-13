# vim: set expandtab ts=4 sw=4 filetype=python fileencoding=utf8:

import argparse
import os
import textwrap

import psycopg2

def dump_to_csv(pgconn):

    sql_file = os.path.join(
        os.path.dirname(__file__),
        "talks_with_times_and_votes.sql")

    copy_query = textwrap.dedent("""
        copy (

        {0}
        )
        to stdout
        with csv header""").format(open(sql_file).read())

    cursor = pgconn.cursor()

    cursor.copy_expert(
        copy_query,
        open("/tmp/proposals.csv", "w"))

if __name__ == "__main__":

    pgconn = psycopg2.connect(database="pyohio2015")

    dump_to_csv(pgconn)


