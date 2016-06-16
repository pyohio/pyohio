# vim: set expandtab ts=4 sw=4 filetype=python fileencoding=utf8:

import argparse
import logging
import os
import textwrap

import psycopg2

logging.basicConfig(level=logging.DEBUG)

log = logging.getLogger("junkdrawer")

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
        open("/var/pyohio/{0}.csv".format(table_name), "w"))

def dump_to_json(pgconn, table_name):

    query = textwrap.dedent("""
        select to_json(array_agg(xxx))
        from {0} xxx
        """.format(table_name))

    cursor = pgconn.cursor()

    cursor.execute(query)

    log.debug("rows: {0}".format(cursor.rowcount))

    outfile = open("/var/pyohio/{0}.json".format(table_name), "w")

    outfile.write(",\n".join(row[0] for row in cursor if row[0]))

    # subprocess.check_call(["jq", "'.'", "/var/pyohio/proposals.json",
    # ">", "/var/pyohio/pretty-proposals.json"])

    outfile.close()

def dump_schedule_for_upload(pgconn):

    """
    Dump out a CSV that looks like this:

    "date","time_start","time_end","kind"," room "
    "12/12/2013","10:00 AM","11:00 AM","plenary","Room2"
    "12/12/2013","10:00 AM","11:00 AM","plenary","Room1"
    "12/12/2013","11:00 AM","12:00 PM","talk","Room1"
    "12/12/2013","11:00 AM","12:00 PM","talk","Room2"
    "12/12/2013","12:00 PM","12:45 PM","plenary","Room1"
    "12/12/2013","12:00 PM","12:45 PM","plenary","Room2"
    "12/13/2013","10:00 AM","11:00 AM","plenary","Room2"
    "12/13/2013","10:00 AM","11:00 AM","plenary","Room1"
    "12/13/2013","11:00 AM","12:00 PM","talk","Room1"
    "12/13/2013","11:00 AM","12:00 PM","talk","Room2"
    "12/13/2013","12:00 PM","12:45 PM","plenary","Room1"
    "12/13/2013","12:00 PM","12:45 PM","plenary","Room2"

    """

    qry = textwrap.dedent("""
        copy (
            select
            to_char(start_time, 'MM/DD/YYYY') as date,
            to_char(start_time, 'HH12:MI PM') as time_start,

            to_char(
                start_time + (interval '1 hour' * proposal_length),
                'HH12:MI PM')
            as time_end,

            'talk' as kind,

            room

            from pretty_schedule
        )
        to stdout
        with csv header
        """)

    cursor = pgconn.cursor()

    cursor.copy_expert(
        qry,
        open("/var/pyohio/upload.csv", "w"))



if __name__ == "__main__":

    args = set_up_args()

    pgconn = psycopg2.connect(database=args.database_name)

    for table_name in ["all_proposals", "top_proposals",
        ]:

        dump_to_csv(pgconn, table_name)
        dump_to_json(pgconn, table_name)

    # dump_schedule_for_upload(pgconn)
