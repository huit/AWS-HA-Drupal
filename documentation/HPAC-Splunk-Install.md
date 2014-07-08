#HPAC Splunk Installation Guide
======================

Welcome to the HPAC Splunk Installation Guide.  This file contains all of the documentation for adding Splunk Logging capabilities to the production AWS HA Drupal instances using automated scripts and CloudFormation Stack Templates.

###Service Description

The following code needs to be added to your CloudFormation Template that will automate the creation and redirection of specific logs to an S3 bucket.

### S3 Bucket Standard Creation Parameters
```
S3 Bucket Name: hpac_splunk_logging_bucket
S3 Location (Region): US Standard
S3 Lifecycle Rules In Place: Delete Entire Bucket every 45 Days
```

### Splunk Script

```
# Begin Splunk Installation
# Installing s3 cmd tools in proper directory on the server and install it!
cd /home/ec2-user
git clone https://github.com/s3tools/s3cmd.git
cd s3cmd
python setup.py install

# Enable system logging to s3 by configuring log rotate
cat <<\syslogEOF > /etc/logrotate.d/syslog
/var/log/cron
/var/log/maillog
/var/log/messages
/var/log/secure
/var/log/spooler
{
  missingok
# Set the initial size of the log to 1 that will force the creation of the INSTANCE_ID directories being created
# during the hourly log rotate operation
  size 1
  sharedscripts
  dateext
  dateformat -%Y-%m-%d-%s
  postrotate
    /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
    BUCKET=hpac_splunk_logging_bucket
    INSTANCE_ID=`curl --silent http://169.254.169.254/latest/meta-data/instance-id | sed -e "s/i-//"`
    /usr/bin/s3cmd -m text/plain sync /var/log/messages-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
    /usr/bin/s3cmd -m text/plain sync /var/log/cron-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
    /usr/bin/s3cmd -m text/plain sync /var/log/maillog-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
    /usr/bin/s3cmd -m text/plain sync /var/log/secure-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
    /usr/bin/s3cmd -m text/plain sync /var/log/spooler-* s3://${BUCKET}/${INSTANCE_ID}/var/log/
  endscript
}
syslogEOF

# Enable system logging to s3 by configuring log rotate for httpd
cat <<\httpdEOF > /etc/logrotate.d/httpd
/var/log/httpd/*log {
  missingok
# Set the initial size of the log to 1 that will force the creation of the INSTANCE_ID directories being created
# during the hourly log rotate operation
  size 1
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

# Setup up cron to run this hourly 
mv /etc/cron.daily/logrotate /etc/cron.hourly/.
# End Splunk Installation

```

### Manual Rotation of Server Logs:
Description: In the event that you need to perform a manual rotation of the server logs needs, execute the following commands on your linux instances.
```
$> sudo logrotate -v -f /etc/logrotate.conf
```
