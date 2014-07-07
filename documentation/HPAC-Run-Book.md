#HPAC Run Book
======================

Welcome to the HPAC Production Drupal Run Book Document.  This file contains all of the documentation associated with the syntax for creating,updating and deleting the production AWS HA Drupal instances using automated scripts and CloudFormation Stack Templates.

## Preparing Your Environment
<<<<<<< HEAD

###Updating your git environment

The git repository associated with the HPAC Production Drupal HA sites is called "AWS-HA-Drupal".  Please ensure that you are located in the proper directory and that your repository is up to date with the master.  Perform the following commands to ensure that you have the latest code from the "AWS-HA-Drupal" repository.

```
$> git pull

```

Before proceeding, make sure that no errors occurred during the ```git pull```.

### Cloudformation Template Location

The cloudformation template located here ```your_git_user_name/AWS-HA-Drupal```
=======

###Updating your git environment

The git repository associated with the HPAC Production Drupal HA sites is called "AWS-HA-Drupal".  Please ensure that you are located in the proper directory and that your repository is up to date with the master.  Perform the following commands to ensure that you have the latest code from the "AWS-HA-Drupal" repository.

```
$> git pull

```

Before proceeding, make sure that no errors occurred during the ```git pull```.

## Cloudformation Template Location

The cloudformation template located here `your_git_user_name/AWS-HA-Drupal`
>>>>>>> 2a1baeef61c20537788b9c9960ea72f6cae0bc96

### Creating the HPAC Drupal HA Instances using CloudFormation and the aws create-stack command

### The following Arguments need to be exported within your environment before executing the deployment script.

```
$> export Label=HPAC-Drupal-Instance
$> export DBPassword=hpacdbpassword
$> export SitePassword=hpacsitepassword
$> export KeyName=HPACDrupalKeyPair

```

###Executing the script:

```
$> ./deploy.sh create-stack

```

###Output of the script:

```
$> Performing an create-stack in AWS of the Cloudstack named HPAC-Drupal-Instance!
$> Command to execute:
$> -----------------------
$> aws cloudformation create-stack 
          --capabilities CAPABILITY_IAM 
          --stack-name HPAC-Drupal-Instance 
          --disable-rollback 
          --template-body file://template.json 
          --parameters ParameterKey=SitePassword,ParameterValue=hpacsitepassword 
          ParameterKey=DBPassword,ParameterValue=hpacdbpassword ParameterKey=Label,ParameterValue=HPAC-Drupal-Instance ParameterKey=KeyName,ParameterValue=HPACDrupalKeyPair
$> {
<<<<<<< HEAD
$> "StackId": "arn:aws:cloudformation:us-east-1:219880708180:stack/HPAC-Drupal-Instance/e317ad30-fd44-11e3-a961-500162a66cb4"
=======
     "StackId": "arn:aws:cloudformation:us-east-1:219880708180:stack/HPAC-Drupal-Instance/e317ad30-fd44-11e3-a961-500162a66cb4"
>>>>>>> 2a1baeef61c20537788b9c9960ea72f6cae0bc96
$> }

```

###AWS Console

Check the progress of the CloudFormation Stack execution at the below url (need to be logged in)

```
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks?filter=active
```

## Updating the HPAC Drupal HA Instances using CloudFormation and the aws update-stack command

Use:  The update-stack command can be used to recreate HPAC instances that have been destroyed manually within the AWS console.  It will compare the HPAC template against what is running in AWS and re-create any missing infrastructure components.

### The following Arguments need to be exported within your environment before executing the deployment script.

```
$> export Label=HPAC-Drupal-Instance
$> export DBPassword=hpacdbpassword
$> export SitePassword=hpacsitepassword
$> export KeyName=HPACDrupalKeyPair

```

###Executing the script:

```
$> ./deploy.sh update-stack

```

###Output of the script:

###NOTE: The below error occurs because of the resilency of the HPAC Template pararmeters that are in inherent in the HPAC CloudFormation Template.  The instances will typically recreate themselves within minutes thus the reason that "No updates are to be performed".  This may differ if for some reason this resilency fails for someunknown reason, and your output may differ.

```
$> Performing an update-stack in AWS of the Cloudstack named HPAC-Drupal-Instance!
$> Command to execute:
$> -----------------------
$> aws cloudformation update-stack --capabilities CAPABILITY_IAM --stack-name HPAC-Drupal-Instance --template-body file://template.json --parameters ParameterKey=SitePassword,ParameterValue=hpacsitepassword ParameterKey=DBPassword,ParameterValue=hpacdbpassword ParameterKey=Label,ParameterValue=HPAC-Drupal-Instance ParameterKey=KeyName,ParameterValue=HPACDrupalKeyPair

$> A client error (ValidationError) occurred when calling the UpdateStack operation: No updates are to be performed.

```

###AWS Console

Check the progress of the CloudFormation Stack execution at the below url (need to be logged in)

```
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks?filter=active
```

## Deleting the HPAC Drupal HA Instances using CloudFormation and the aws delete-stack command

Use:  The delete-stack command can be used to "terminate" ALL HPAC instances. CAUTION: This command when executed "destroys" all Web Server Instances, Databases, and Elastic Load Balancers that were created using the HPAC template.

### The following Arguments need to be exported within your environment before executing the deployment script.

```
$> export Label=HPAC-Drupal-Instance
```

###Executing the script:

```
$> ./deploy.sh delete-stack
```

###Output of the script:

```
$> Performing an delete-stack in AWS of the Cloudstack named HPAC-Drupal-Instance!
$> Command to execute:
$> -----------------------
$> aws cloudformation delete-stack --stack-name HPAC-Drupal-Instance
```

###AWS Console

Check the progress of the CloudFormation Stack execution at the below url (need to be logged in)

```
https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks?filter=active
```

