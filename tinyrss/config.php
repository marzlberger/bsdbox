<?php
 putenv('TTRSS_PHP_EXECUTABLE=/usr/local/bin/php');
 putenv("PATH=/usr/local/bin/:" . getenv("PATH"));
 #putenv('TTRSS_SINGLE_USER_MODE=true');
 #putenv('TTRSS_SELF_URL_PATH=');
 putenv('TTRSS_DB_TYPE=pgsql');
 putenv('TTRSS_DB_HOST=localhost');
 putenv('TTRSS_DB_USER=ttrss');
 putenv('TTRSS_DB_NAME=ttrss');
 putenv('TTRSS_DB_PASS= ttRSS123!');
