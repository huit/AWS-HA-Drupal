CloudFormation Syntax Documentation
======================

Welcome to the HPAC Production Drupal github repository.  This file contains all of the documentation associated with the syntax for creating and updating the production AWS HA Drupal instances. 

### Cloudformation Template

All of the below cloudformation commands are using the cloudformation template located here   	
https://s3.amazonaws.com/hpacdrupalstack-s3bucket-12npg1o22mj36/hpac_multi_az_replica_production The commands differ in how they inject this template (either by file reference on a local computer or from an S3 bucket)

### CloudFormation create-stack using file reference

```
$> aws cloudformation create-stack --capabilities CAPABILITY_IAM --stack-name HPACDrupalStack --template-body file://////Users/spm888/git/cloud-boot-camp-linux-ex1/Drupal_Multi_AZ.template --parameters ParameterKey=KeyName,ParameterValue=HPACDrupalKeyPair
```
### CloudFormation create-stack template-url reference

```
$> aws cloudformation create-stack --capabilities CAPABILITY_IAM --stack-name HPACDrupalStack1 --template-url https://s3.amazonaws.com/hpacdrupalstack-s3bucket-12npg1o22mj36/hpac_multi_az_replica_production --parameters ParameterKey=KeyName,ParameterValue=HPACDrupalKeyPair
```

### CloudFormation update-stack using file reference

```
$> aws cloudformation update-stack --stack-name HPACDrupalStack --capabilities CAPABILITY_IAM --template-body file:///Users/jhick/git_repos/cloud-boot-camp-linux-ex1/Drupal_Multi_AZ.template
```
