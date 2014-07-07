#HPAC Splunk Installation Guide
======================

Welcome to the HPAC Splunk Installation Guide.  This file contains all of the documentation for adding Splunk Logging capabilities to the production AWS HA Drupal instances using automated scripts and CloudFormation Stack Templates.

## Preparing Your Environment
<<<<<<< HEAD

###Updating your git environment

The git repository associated with the HPAC Production Drupal HA sites is called "AWS-HA-Drupal".  Please ensure that you are located in the proper directory and that your repository is up to date with the master.  Perform the following commands to ensure that you have the latest code from the "AWS-HA-Drupal" repository.

```
$> git pull

```

Before proceeding, make sure that no errors occurred during the ```git pull```.

###Service Description
The following code needs to be added to your CloudFormation Template that will automate the creation and redirection of specific logs to an S3 bucket.

### Splunk Script

```
# Added for Splunk functionality start
cd /home/ec2-user
git clone https://github.com/s3tools/s3cmd.git
cd s3cmd
python setup.py install

# Enable system logging to s3
cat <<\syslogEOF > /etc/logrotate.d/syslog
/var/log/cron
/var/log/maillog
/var/log/messages
/var/log/secure
/var/log/spooler
{
  missingok
  sharedscripts
  dateext
  dateformat -%Y-%m-%d-%s
  postrotate
    /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
    BUCKET=boot_camp_logging_bucket
    INSTANCE_ID=`curl --silent http://169.254.169.254/latest/meta-data/instance-id | sed -e "s/i-//"`
    /usr/bin/s3cmd -m text/plain sync /var/log/messages-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
    /usr/bin/s3cmd -m text/plain sync /var/log/cron-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
    /usr/bin/s3cmd -m text/plain sync /var/log/maillog-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
    /usr/bin/s3cmd -m text/plain sync /var/log/secure-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
    /usr/bin/s3cmd -m text/plain sync /var/log/spooler-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
  endscript
}
syslogEOF

# Enable apache logging to s3
cat <<\httpdEOF > /etc/logrotate.d/httpd
/var/log/httpd/*log {
  missingok
  notifempty
  sharedscripts
  dateext
  dateformat -%Y-%m-%d-%s
  postrotate
    BUCKET=boot_camp_logging_bucket
    INSTANCE_ID=`curl --silent http://169.254.169.254/latest/meta-data/instance-id | sed -e "s/i-//"`
    /usr/bin/s3cmd -m text/plain sync /var/log/httpd/*log s3://${BUCKET}/${INSTANCE_ID}/var/log/httpd/
    /sbin/service httpd reload > /dev/null 2>/dev/null || true
  endscript
}
httpdEOF

mv /etc/cron.daily/logrotate /etc/cron.hourly/.
# Added for Splunk functionality end

```

### Manual Rotation of Server Logs:
Description: Currently a manual rotation of the server logs needs to be done initially to instantiate the creation of the S3 Bucket.
S3 Bucket Name: boot_camp_logging_bucket

```
$> sudo logrotate -v -f /etc/logrotate.conf

```

