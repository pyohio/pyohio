#!/bin/bash -e

/bin/rm -f /tmp/pyohio.pg_dump
ssh pyohio@pyohio.org pg_dump -Fc -d pyohio > /tmp/pyohio.pg_dump

/usr/bin/dropdb --if-exists pyohio

/usr/bin/createdb pyohio

/usr/bin/pg_restore -d pyohio /tmp/pyohio.pg_dump

for script in talks_with_times_and_votes.sql schedule.sql speaker_preferences.sql
do

    PGOPTIONS='--client-min-messages=warning' /usr/bin/psql \
    --pset pager=off \
    --quiet \
    --no-psqlrc \
    -d pyohio \
    --single-transaction \
    -v ON_ERROR_STOP=1 \
    -f $script

done

$VIRTUAL_ENV/bin/python talks_with_times_and_votes.py pyohio

/usr/bin/jq '.' /var/pyohio/proposals.json > /var/pyohio/pretty-proposals.json
