dropdb -h localhost pyohio-2014; createdb -h localhost pyohio-2014 && gondor sqldump primary | ./manage.py dbshell && ./manage.py upgradedb -e
