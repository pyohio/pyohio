#!/bin/bash -e

/bin/rm -f /tmp/pyohio2015.pg_dump

cd /home/matt/checkouts/pyohio2015

/home/matt/.virtualenvs/pyohio2015/bin/gondor sqldump primary > /tmp/pyohio2015.pg_dump 2> /dev/null

/usr/bin/dropdb --if-exists pyohio2015

/usr/bin/createdb pyohio2015

/usr/bin/psql --quiet pyohio2015 < /tmp/pyohio2015.pg_dump > /dev/null

cd pyohio/junkdrawer

PGOPTIONS='--client-min-messages=warning' /usr/bin/psql --pset pager=off --quiet --no-psqlrc -d pyohio2015 --single-transaction -v ON_ERROR_STOP=1 -f talks_with_times_and_votes.sql

/usr/bin/jq '.' /var/pyohio2015/proposals.json > /var/pyohio2015/pretty-proposals.json

PGOPTIONS='--client-min-messages=warning' /usr/bin/psql --pset pager=off --quiet --no-psqlrc -d pyohio2015 \
--single-transaction -v ON_ERROR_STOP=1 \
-f schedule.sql

/home/matt/.virtualenvs/pyohio2015/bin/python talks_with_times_and_votes.py pyohio2015
