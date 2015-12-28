#!/bin/bash

clear
keyName=www
stackName="blog-$(date +%Y%m%d-%H%M)"
cfnFile="file://cloudformation.json"
echo
echo "$stackName :: $cfnFile"
echo
echo
echo "==> load variables:"
echo
cfnParameters+=" ParameterKey=KeyName,ParameterValue=$keyName "
echo $cfnParameters
echo
echo
echo "==> source bundle to s3:"
echo
echo
rm -fv blog.zip
echo
echo
origin=$(pwd | rev | cut -f1 -d/ | rev)
cd ../hex7 && zip ../$origin/blog.zip -r *
cd ../$origin
echo
echo
aws s3 cp blog.zip s3://hex7/
echo
echo
echo "==> launch beanstalk stack:"
echo
echo
aws cloudformation create-stack --stack-name $stackName --disable-rollback --template-body $cfnFile --parameters $cfnParameters 
echo
echo
