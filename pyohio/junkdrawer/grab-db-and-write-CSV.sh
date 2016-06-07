#!/bin/bash -e

# /bin/rm -f /tmp/pyohio.pg_dump

cd /home/matt/checkouts/pyohio

# $VIRTUAL_ENV/bin/gondor sqldump primary > /tmp/pyohio.pg_dump 2> /dev/null

# /usr/bin/dropdb --if-exists pyohio

# /usr/bin/createdb pyohio

# /usr/bin/psql --quiet pyohio < /tmp/pyohio.pg_dump > /dev/null

cd pyohio/junkdrawer

for script in talks_with_times_and_votes.sql schedule.sql speaker_preferences.sql
do

    PGOPTIONS='--client-min-messages=warning' /usr/bin/psql \
    --pset pager=off --quiet --no-psqlrc -d pyohio2016 \
    --single-transaction -v ON_ERROR_STOP=1 \
    -f $script

done

$VIRTUAL_ENV/bin/python talks_with_times_and_votes.py pyohio2016

/usr/bin/jq '.' /var/pyohio/proposals.json > /var/pyohio/pretty-proposals.json
