#!/bin/bash -e

POPULAR_PROPOSALS=`psql -d pyohio2015 -c 'select id from all_proposals where plus_1_votes > 2;' -t`

for proposal_id in $POPULAR_PROPOSALS
do

    curl "http://www.pyohio.org/reviews/review/$proposal_id/" \
    -H 'Cookie: PYOHIO2015=e5e5hzxlu4cq8mm4j2klicbfe2bzt83r; csrftoken=ph6VT1y0yCkSxKdmFJxxywkikIULulso' \
    -H 'Origin: http://www.pyohio.org' \
    -H 'Accept-Encoding: gzip, deflate' \
    -H 'Accept-Language: en-US,en;q=0.8' \
    -H 'User-Agent: Mozilla/5.0 (X11; CrOS x86_64 6946.55.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
    -H 'Cache-Control: max-age=0' \
    -H 'Referer: http://www.pyohio.org/reviews/review/197/' \
    -H 'Connection: keep-alive' \
    -H 'DNT: 1'  \
    --data 'csrfmiddlewaretoken=ph6VT1y0yCkSxKdmFJxxywkikIULulso&result_submit=accept'  \
    --compressed

done;

echo "All done!"
