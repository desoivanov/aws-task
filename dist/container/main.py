import logging
import os
import sys

import boto3
import pymysql

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

ssm = boto3.client('ssm')
rds_host = os.getenv("RDS_HOST", 'invalid-host')

try:
    dbpassword = ssm.get_parameter(Name='/default/database/password/master', WithDecryption=True)['Parameter']['Value']
    dbuser = ssm.get_parameter(Name='/default/database/user/master')['Parameter']['Value']
except:
    logger.error("ERROR: Unexpected error: Could not fetch SSM parameters.")
    sys.exit()
try:
    conn = pymysql.connect(rds_host, user=dbuser, passwd=dbpassword, connect_timeout=10)
except:
    logger.error("ERROR: Unexpected error: Could not connect to MySql instance.")
    sys.exit()

query = 'SHOW VARIABLES LIKE "%version%";'
with conn:
    cur = conn.cursor()
    cur.execute("SELECT VERSION(),CURRENT_USER()")

    version = cur.fetchone()

    print("Database endpoint: {}".format(rds_host))
    print("Database version: {}\nDatabase User: {}\n".format(version[0], version[1]))
