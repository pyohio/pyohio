dropdb -h localhost pyohio2014; createdb -h localhost pyohio2014 && gondor sqldump primary | ./manage.py dbshell && ./manage.py upgradedb -e
