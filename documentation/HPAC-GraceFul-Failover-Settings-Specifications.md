#HPAC Failover Settings and Specifications 
======================

Welcome to the HPAC Production Drupal document that specifies the settings that are inherent in the cloudformation template that is used to build the production web server and databases instances in Amazon Web Services.  This file contains all of the settings and syntax associated during the creating of the production AWS HA Drupal instances using automated scripts and CloudFormation Stack Templates.

## HPAC HA Drupal Infrastructure Initial Build
Qty 1 - Elastic Load Balancer
Qty 3 - Drupal Webserver Instances
        - 2 Web Server Instances in the us-east-1d Availability Zone
        - 1 Web Server Instance in the us-east-1a Availability Zone
Qty 1 - Drupal Admin Server
        - 1 Web Server Instance in the us-east-1a Availability Zone
Qty 2 - MySql MultiAZDatabase Configuration
        -  1 RDS Instance PRIMARY us-east-1d
        -  1 RDS Instance SECONDARY us-east-1a

### Drupal WebServer Instances

###Drupal WebServer Instance Failover Specifications

Customer Requirement: A minimum of 2 Drupal WebServers must exist at all times within 1 availability zone.

Supporting Template Syntax
```
"WebServerCapacity": {
            "ConstraintDescription": "must be between 1 and 5 EC2 instances.",
            "Default": "3",
            "Description": "The initial number of WebServer instances",
            "MaxValue": "5",
            "MinValue": "2",
            "Type": "Number"
        },
```

Customer Requirement: Under load, the Drupal WebServers will auto-scale to handle any abnormal or increased load.
```
NOT SEEING AUTO-SCALING
```

###Drupal AdminServer Instance Failover Specifications

Customer Requirement: A minimum of 1 Drupal ADMIN WebServes must exist at all times within 1 availability zone.

Supporting Template Syntax
```
"WebServerCapacitySingle": {
            "ConstraintDescription": "must be between 1 and 1 EC2 instances.",
            "Default": "1",
            "Description": "The initial number of WebServer instances",
            "MaxValue": "1",
            "MinValue": "1",
            "Type": "Number"
        }
```
### Drupal Database Instance Failover Specifications

Customer Requirement:  A mininum of 1 Drupal MySql Database must be operational at all times within 1 availability zone.

Supporting Template Syntax
```
"MultiAZDatabase": {
            "AllowedValues": [
                "true",
                "false"
            ],
            "ConstraintDescription": "must be either true or false.",
            "Default": "true",
            "Description": "Create a multi-AZ MySQL Amazon RDS database instance",
            "Type": "String"
        },
```
### Elastic LoadBalancer Failover Specifications

Customer Requirement:  A load balancer must be utilized that is redundant across availability zones, that is constantly performing health checks of WebServer, Admin and Database instances every 10 seconds with an expected response time of 2 seconds..

Supporting Template Syntax

```
"ElasticLoadBalancer": {
            "Metadata": {
                "Comment": "Configure the Load Balancer with a simple health check and cookie-based stickiness"
            },
            "Properties": {
                "AvailabilityZones": [
                    "us-east-1a",
                    "us-east-1d"
                ],
                "HealthCheck": {
                    "HealthyThreshold": "2",
                    "Interval": "10",
                    "Target": "HTTP:80/",
                    "Timeout": "5",
                    "UnhealthyThreshold": "5"
                },
                "LBCookieStickinessPolicy": [
                    {
                        "CookieExpirationPeriod": "30",
                        "PolicyName": "CookieBasedPolicy"
                    }
                ],
```
