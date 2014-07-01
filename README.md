Scalable Drupal
======================

Welcome to the HPAC Production Drupal github repository.  This repository contains the cloudformation and scripts need  Please see the wiki located at 

* https://github.com/huit/AWS-HA-Drupal.wiki

for all current documentation.

## Quickstart

To use this repo, start off by setting the needed parameters for the CloudFormation template in your environment, for example to set the SSH key name to use, the parameter is named `KeyName`, so set environment

```
$> export KeyName=my-key
```

In particular, you'll need to set at a minimum the following parameters:
- `Label`
- `KeyName`
- `SitePassword`
- `DBPassword`

Then when ready, you can start the CloudFormation stack using the deploy script

```
$> ./deploy create-stack
```

If there are missing parameters, set them as environment variables, and then start again.  The script will also leave a copy of the generated cloudformation template in the current directory named `template.json`.

To see the list of known parameters, you can use the helper script

```
$> ./bin/find_cf_params ./resources/cf.json
```

The helper tools need python 2.7 (which is also a requirement for the AWS cli tools)

## Details

The contained scripts make it easier to maintain the deplyoment process by separating the `cloud-init` bash script (or whatever valid cloud-init format) from the CloudFormation JSON. The main CloudFormation template is in `resources/cf.json` and the user-data script for cloud-init is in `resources/user-data`.

The CF template creates a file on instances named `/etc/cloud-env.sh` which contains all the needed parameters and values for configuring the host. The script can then `source /etc/cloud-env.sh` to get all these values imported for configuring the system.

There are three helper utilities in `bin/`

* `find_cf_params` : given a cloudformation template, prints out the Parameter names
* `gen_cf_json` : takes a cloudformation and a user-data script, and injects the script into the specified LaunchConfiguration
* `pprint_json` pretty prints out the CF json (or any JSON)





