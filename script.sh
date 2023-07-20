#!/bin/bash


# ----------------------------------------------------------------------------
#
#
#  Copyright (c) 2023 Levan Kerdikashvili  - levan.kerdikashvili@space.ge
#
#Usage: ./script.sh [PROJECT_KEY] [TEST_CYCLE_NAME] [DEFAULT_TEST_CYCLE_DESCRIPTION] [TOKEN]
# ----------------------------------------------------------------------------


#Arguments:
#  PROJECT_KEY                  (optional) The project key. If not provided, the default value 'HZ' will be used.
#  TEST_CYCLE_NAME              (optional) The test cycle name. If not provided, the default value 'test cycle name is here' will be used.
#  DEFAULT_TEST_CYCLE_DESCRIPTION  (optional) The default test cycle description. If not provided, the default value 'test cycle description is here' will be used.
#  TOKEN                        (optional) The authentication token. If not provided, the default value 'testKey' will be used.


# Check if command-line arguments are provided, otherwise use default values
if [ $# -eq 4 ]; then
    PROJECT_KEY=$1
    TEST_CYCLE_NAME=$2
    DEFAULT_TEST_CYCLE_DESCRIPTION=$3
    TOKEN=$4
else
    PROJECT_KEY="project key is here, example: HZ which used in zephyr scale project"
    TEST_CYCLE_NAME="test cycle name is here"
    DEFAULT_TEST_CYCLE_DESCRIPTION="description is here"
    TOKEN="your tokken is here"
fi

# Create archive
zip -D ./target/junit_tests.zip ./target/surefire-reports/TEST*.xml

URL="https://api.zephyrscale.smartbear.com/v2/automations/executions/junit?projectKey=${PROJECT_KEY}"

# Create a JSON payload with the custom test cycle parameters
JSON_PAYLOAD="{  \"name\": \"$TEST_CYCLE_NAME\", \"description\": \"$DEFAULT_TEST_CYCLE_DESCRIPTION\"}"

# Make a POST request to create the custom executions
curl -X POST -H "Content-Type: multipart/form-data" -H "Authorization: Bearer ${TOKEN}" -F "file=@target/junit_tests.zip" -F "testCycle=$JSON_PAYLOAD;type=application/json" "$URL"
