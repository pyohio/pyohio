#!/bin/bash -e

SCHEDULED_PROPOSALS=`psql -d pyohio2015 -c 'select proposal_id from schedule' -t`

for proposal_id in $SCHEDULED_PROPOSALS
do


    curl "http://www.pyohio.org/reviews/review/$proposal_id/" \
    -H 'Cookie: PYOHIO2015=z4q4hzyz61f28qa12ynemjclg4ze8rz4; csrftoken=A4xCQHGf4bXClQHad3pnbaXJGbmEiyUZ' \
    -H 'Origin: http://www.pyohio.org' \
    -H 'Accept-Encoding: gzip, deflate' \
    -H 'Accept-Language: en-US,en;q=0.8' \
    -H 'User-Agent: Mozilla/5.0 (X11; CrOS x86_64 6946.58.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.125 Safari/537.36' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
    -H 'Cache-Control: max-age=0' \
    -H 'Referer: http://www.pyohio.org/reviews/review/277/' \
    -H 'Connection: keep-alive' \
    -H 'DNT: 1' \
    --data 'csrfmiddlewaretoken=A4xCQHGf4bXClQHad3pnbaXJGbmEiyUZ&result_submit=accept' \
    --compressed

done;

echo "All done!"
