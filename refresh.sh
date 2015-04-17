dropdb -h localhost pyohio; createdb -h localhost pyohio && gondor sqldump primary | ./manage.py dbshell && ./manage.py upgradedb -e
