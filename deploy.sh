#!/bin/bash

# get variables from params
for i in "$@"
do
case $i in
  -b=*|--bucket=*)
  S3_BUCKET="${i#*=}"
  shift
  ;;
  -r=*|--region=*)
  REGION="${i#*=}"
  shift 
  ;;
  -g=*|--gateway=*)
  API_GATEWAY_ID="${i#*=}"
  shift
  ;;
esac
done

# exit if no input params are supplied
S3_BUCKET=${S3_BUCKET:?--bucket or -b parameter. This is the S3 bucket which will host Swagger UI. }
REGION=${REGION:? --region or -r parameter is required. This is an AWS Region.}
API_GATEWAY_ID=${API_GATEWAY_ID:? --gateway or -g parameter. This is our API Gateway Id.}

# check if bucket exists /dev/null prevents error
if aws s3api head-bucket --bucket $S3_BUCKET 2>/dev/null;  
then 
  echo 'bucket exists enable hosting'; 
else 
  echo 'no bucket - create it'; 
  aws s3api create-bucket --bucket $S3_BUCKET --region $REGION --create-bucket-configuration LocationConstraint=eu-west-1
fi

# enable static website hosting on the S3 bucket
aws s3 website s3://$S3_BUCKET/ --index-document index.html --error-document error.html

# remove swagger-ui folder then clone repo for the latest version 
rm -rf swagger-ui
git clone https://github.com/swagger-api/swagger-ui.git
# replace reference inside index.html from https://petstore.swagger.io/v2/swagger.json to api.json 
sed -i 's/https:\/\/petstore.swagger.io\/v2\/swagger.json/api.json/g' ./swagger-ui/dist/index.html 

# upload swagger ui to S3 bucket 
aws s3 cp ./swagger-ui/dist s3://$S3_BUCKET/ --recursive --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

# export swagger doc from API Gateway
aws apigateway get-export --parameters extensions='apigateway' --rest-api-id $API_GATEWAY_ID --stage-name dev --export-type swagger ./api.json --region $REGION

# upload exported file to S3
aws s3 cp ./api.json s3://$S3_BUCKET/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

# cleanup
rm -rf swagger-ui

# print your bucket url
echo http://$S3_BUCKET.s3-website-$REGION.amazonaws.com
