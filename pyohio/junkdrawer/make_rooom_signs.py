# vim: set expandtab ts=4 sw=4 filetype=python fileencoding=utf8:

import argparse
import csv
import datetime
import logging
import sys
import textwrap


htmltop = textwrap.dedent(u"""
    <!DOCTYPE html>

    <html>

    <head>

    <title>Room assignments for PyOhio 2016</title>

    <script src="https://code.jquery.com/jquery-3.1.0.js"
    integrity="sha256-slogkvB1K3VOkzAI8QITxV3VzpOnkeNVsKvtkYLMjfk="
    crossorigin="anonymous"></script>

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
    integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
    crossorigin="anonymous">

    <!-- Optional theme -->
    <link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
    integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
    crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
    integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
    crossorigin="anonymous"></script>

    <style>
    @media print {

        div.room-talk-time {
            page-break-before: always;
        }

    }
    </style>

    </head>

    <body>

    <div class="container">

    """).lstrip()

htmlbottom = textwrap.dedent(u"""
    </div><!-- container -->

    </body>

    </html>
    """)

html_room_tmpl = textwrap.dedent(u"""
    <div class="room-talk-time">

    <img class="pull-right" src="http://pyohio.org/site_media/static/images/py-small-logo.png" />

    <h1 class="talk-title text-success">{talk_title}</h1>
    <h2 class="speaker-name"><small>Speaker:</small> {name}</h2>
    <h2 class="room-name"><small>Room:</small> {room_name}</h2>
    <h2 class="start-time"><small>Starts:</small> {start_time:%A, %b %d, %Y %I:%M %P}</h2>
    <h2 class="end-time"><small>Ends:</small> {end_time:%I:%M %P}</h2>

    </div>
    """)

def set_up_args():

    ap = argparse.ArgumentParser()

    ap.add_argument("csvfile")

    ap.add_argument("outfile")

    args = ap.parse_args()

    return args

def yield_divs(csvfile):

    for row in csv.DictReader(open(csvfile)):

        # Convert all values to unicode.
        for (k, v) in row.items():
            row[k] = u"{0}".format(v.decode("utf-8"))

        dtstr = "{date} {start}".format(**row)

        row["start_time"] = datetime.datetime.strptime(
            dtstr,
            "%Y-%m-%d %H:%M:%S")

        row["end_time"] = datetime.datetime.strptime(
            "{date} {end}".format(**row),
            "%Y-%m-%d %H:%M:%S")

        row["talk_title"] = row["title"].replace(u"\u2019", u"'")

        div = html_room_tmpl.format(**row)

        if row["name"].startswith("Philip"):

            print row["title"]
            print type(row["title"])
            print row["talk_title"]
            print div

        yield div

if __name__ == "__main__":

    args = set_up_args()

    outfile = open(args.outfile, "w")

    outfile.write(htmltop)

    for divnum, div in enumerate(yield_divs(args.csvfile), start=1):

        outfile.write(unicode(div).encode("utf-8"))

    outfile.write(htmlbottom)
