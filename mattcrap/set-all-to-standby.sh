#!/bin/bash -e

TALK_PROPOSALS=`psql -d pyohio2015 -c 'select id from proposals_proposalbase where id in (select proposalbase_ptr_id from proposals_talkproposal) order by submitted desc;' -t`

for talk_id in $TALK_PROPOSALS
do

    /usr/bin/curl "http://www.pyohio.org/reviews/review/$talk_id/" \
    -H 'Origin: http://www.pyohio.org' \
    -H 'Accept-Language: en-US,en;q=0.8' \
    -H 'User-Agent: Mozilla/5.0 (X11; CrOS x86_64 6812.88.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.153 Safari/537.36' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
    -H 'Cache-Control: no-cache' \
    -H 'Referer: http://www.pyohio.org/reviews/review/226/' \
    -H 'Cookie: PYOHIO2015=clzhzcyjx6a606r1r32w2fvy7qcjz364; csrftoken=1vrpV60CawRyDujWpWtLMqn9FjcP78ct' \
    -H 'Connection: keep-alive' \
    -H 'DNT: 1' \
    --data 'csrfmiddlewaretoken=1vrpV60CawRyDujWpWtLMqn9FjcP78ct&result_submit=standby' \
    --compressed \

done;

TOOT_PROPOSALS=`psql -d pyohio2015 -c 'select id from
proposals_proposalbase where id in (select proposalbase_ptr_id from proposals_tutorialproposal) order by submitted desc;' -t`

for toot_id in $TOOT_PROPOSALS
do

    /usr/bin/curl "http://www.pyohio.org/reviews/review/$toot_id/" \
    -H 'Origin: http://www.pyohio.org' \
    -H 'Accept-Language: en-US,en;q=0.8' \
    -H 'User-Agent: Mozilla/5.0 (X11; CrOS x86_64 6812.88.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.153 Safari/537.36' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
    -H 'Cache-Control: no-cache' \
    -H 'Referer: http://www.pyohio.org/reviews/review/226/' \
    -H 'Cookie: PYOHIO2015=clzhzcyjx6a606r1r32w2fvy7qcjz364; csrftoken=1vrpV60CawRyDujWpWtLMqn9FjcP78ct' \
    -H 'Connection: keep-alive' \
    -H 'DNT: 1' \
    --data 'csrfmiddlewaretoken=1vrpV60CawRyDujWpWtLMqn9FjcP78ct&result_submit=standby' \
    --compressed \

done;

echo "All done!"
