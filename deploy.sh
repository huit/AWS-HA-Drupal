#!/bin/bash

#
# File locations
#
TEMPLATE_IN_FILE=resources/cf.json
USERDATE_IN_FILE=resources/user-data
TEMPLATE_OUT_FILE=template.json 

#
# AWS stack create command line and options
#
usage() {
	echo Usage:
	echo   $0 [subcommand]
	echo
	echo Where subcommand is 'create-stack', 'update-stack', or 'delete-stack'
	exit 1
}

if [ "$#" -ne 1 ]; then
    usage
fi
CloudCommand=$1

#
# Ensure that a value for Label has been set
#
if [ -z "${Label}" ]; then
	echo "Please set the \"Label\" environment variable to proceed."
	exit 1
fi

#
# Ensure that a value for CloudCommand has been set to either create-stack, update-stack, or delete-stack
#
if [ -z "${CloudCommand}" ]; then
	echo ""
	echo "You have not set the CloudCommand environment variable."
	echo ""
	echo "Please set the \"CloudCommand\" environment variable to create-stack, update-stack, or delete-stack and then re-run deploy.sh to proceed."
	echo ""

	#
	# Get a listing of all cloudformation 
	#   stacks current in AWS and display them 
	#   to ensure the user picks the corret stack to 
	#   perform operations on.
	#

	CMD="aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE"

    echo ""
    echo "Listing of current CloudFormation Stacks that completed successfully"
    echo "-----------------------"
    echo ""
    echo "In 5 seconds I will display all Completed Cloud Formation Stacks in Amazon..."
    echo ""
    
    sleep 5
    echo "Listing............"
    echo ""
    echo $CMD

	$CMD
        
    echo ""
    echo "You have not set the CloudCommand environment variable."
    echo ""
	echo "Please set the \"CloudCommand\" environment variable to create-stack, update-stack, or delete-stack and then re-run deploy.sh to proceed."
    echo ""
	exit 1
fi

if [ "${CloudCommand}" != 'delete-stack' ]; then

	#
	# Generate CloudFormation JSON (this is ugly! REP)
	#
	USERDATA1=resources/user-data
	USERDATA2=$(mktemp -t user-data.XXXXXXXXXX)
	cat resources/user-data | sed 's/LaunchConfig1/AdminLaunchConfig/g' > ${USERDATA2}

	TMPFILE=$(mktemp -t cf.XXXXXXXXXX)
	./bin/gen_cf_json "${TEMPLATE_IN_FILE}" "${USERDATE_IN_FILE}" LaunchConfig1 > ${TMPFILE}
	./bin/gen_cf_json "${TMPFILE}"          "${USERDATA2}"        AdminLaunchConfig > ${TEMPLATE_OUT_FILE}

	rm -f ${USERDATA2} ${TMPFILE}

	#
	# Load parameters from environment and build params argument line for
	#

	PARAM_ARGS=
	PARAM_NAMES=$( ./bin/find_cf_params ${TEMPLATE_IN_FILE} )

	for P in ${PARAM_NAMES}
	do
	        V=$( eval echo \${${P}} )
	        if ! [ -z $V ]; then
	                PARAM_ARGS="$PARAM_ARGS ParameterKey=${P},ParameterValue=${V}"
	        fi
	done

  	if ! [ x =  "x${PARAM_ARGS}" ]; then
        PARAM_ARGS="--parameters $PARAM_ARGS"
  	fi
fi

#
# Build my create-stack command with Arguments
#


#
# If CloudCommand has been set to create-stack then set ROLLBACK_ARG
#
if [ "${CloudCommand}" == 'create-stack' ]; then

	ROLLBACK_ARG=" --disable-rollback "
	CMD="aws cloudformation ${CloudCommand} \
		--capabilities CAPABILITY_IAM \
		--stack-name ${Label} \
		${ROLLBACK_ARG} \
		--template-body file://${TEMPLATE_OUT_FILE}"
	echo "Performing an create-stack in AWS of the Cloudstack named ${Label}!"

	#
	# Build my create-stack command with Arguments
	#
	CMD="$CMD $PARAM_ARGS"

fi

#
# If CloudCommand has been set to update-stack then remove ROLLBACK_ARG and all PARAM_ARGS
#
if [ "${CloudCommand}" == 'update-stack' ]; then

	CMD="aws cloudformation ${CloudCommand} \
        --capabilities CAPABILITY_IAM \
        --stack-name ${Label} \
        --template-body file://${TEMPLATE_OUT_FILE}"
    echo "Performing an update-stack in AWS of the Cloudstack named ${Label}!"

	#
	# Build my update-stack command with Arguments and PARAM_ARGS
	#
	CMD="$CMD $PARAM_ARGS"

fi

#
# If CloudCommand has been set to delete-stack then remove ROLLBACK_ARG and all PARAM_ARGS
#
if [ "${CloudCommand}" == 'delete-stack' ]; then
	
	CMD="aws cloudformation ${CloudCommand} \
        --stack-name ${Label}"
	echo "Performing an delete-stack in AWS of the Cloudstack named ${Label}!"

fi

#
# Report and then run it
#

echo "Command to execute:"
echo "-----------------------"
echo $CMD

$CMD

