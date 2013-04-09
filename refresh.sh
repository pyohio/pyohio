dropdb -h localhost pyohio-2013; createdb -h localhost pyohio-2013 && gondor sqldump primary | ./manage.py dbshell && ./manage.py upgradedb -e
