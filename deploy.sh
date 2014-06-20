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
STACK_NAME=${STACK_NAME:-Drupal-Stack}
ROLLBACK_ARG=" --disable-rollback "

CMD="aws cloudformation create-stack \
        --capabilities CAPABILITY_IAM \
        --stack-name ${STACK_NAME} \
        ${ROLLBACK_ARG} \
        --template-body file://${TEMPLATE_OUT_FILE}"


#
# Generate CF JSON
#
USERDATA1=resources/user-data
USERDATA2=$(mktemp -t user-data)
cat resources/user-data | sed 's/LaunchConfig1/LaunchConfig2/g' > ${USERDATA2}

TMPFILE=$(mktemp -t cf)
./bin/gen_cf_json "${TEMPLATE_IN_FILE}" "${USERDATE_IN_FILE}" LaunchConfig1 > ${TMPFILE}
./bin/gen_cf_json "${TMPFILE}"          "${USERDATA2}"        LaunchConfig2 > ${TEMPLATE_OUT_FILE}

rm -f ${USERDATA2} ${TMPFILE}

#
# Load parameters from environment and build params argument line for 
#

PARAM_ARGS=""
PARAM_NAMES=$( ./bin/find_cf_params ${TEMPLATE_IN_FILE} )

for P in ${PARAM_NAMES}
do
	V=$( eval echo \${${P}} )
	if ! [ -z $V ]; then 
  		PARAM_ARGS="$PARAM_ARGS --parameter ParameterKey=${P},ParameterValue=${V}"
  	fi
done

#
# Report and then run it
#
CMD="$CMD $PARAM_ARGS"
echo "Command to execute:"
echo "-----------------------"
echo $CMD

$CMD

