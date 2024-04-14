#!/bin/bash
export ts=$(date +%Y-%m-%d%Z%H%M)
# Generate IAM Credential Report
aws iam generate-credential-report

echo "Pausing for 2 minutes..."
sleep 120s

# Pull Credential Report from AWS Console and convert it from base64 to human-readable format
aws iam get-credential-report --output text --query Content | base64 -d > raw.csv

# Gathering user GROUP and attached POLICY data, then formatting it into a single dataframe for later use.
echo "Processing IAM User Group and Policy affiliations..."

mkdir list
cd list
mkdir groups policies

for user in $(aws iam list-users --query 'Users[].UserName' --output text | awk 'BEGIN { OFS = "\n" } { $1=$1; print tolower($0) }'); do
        aws iam list-groups-for-user --user-name $user --query 'Groups[].GroupName' --output text | awk 'BEGIN { OFS = " || " } { $1=$1; print }' > groups/$user.csv
        aws iam list-attached-user-policies --user-name $user --query 'AttachedPolicies[].PolicyName' --output text | awk 'BEGIN { OFS = " || " } { $1=$1; print }' > policies/$user.csv
done
echo "onepiece,doesexist" > all-blue.csv
paste -d "\n" groups/* > all-grp.csv
paste -d "\n" policies/* > all-pol.csv
paste -d "," all-grp.csv all-pol.csv >> all-blue.csv
cd ..

# Data cleansing with Python (3.x)
echo "Cleaning and formatting Credential Report..."
python3 - << EOF

import pandas as pd
import numpy as np

creds=pd.read_csv('./raw.csv')
creds.insert(loc=0,column='row_num',value=np.arange(len(creds)))
creds=creds.drop(['arn','user_creation_time','access_key_1_last_used_region','access_key_2_last_used_region','cert_1_last_rotated','cert_2_last_rotated'],axis=1)
creds.set_index('row_num',inplace=True)
affiliate=pd.read_csv('./list/all-blue.csv',names=['user_group','user_attached_policy'])
onepiece=creds.join(affiliate)
onepiece=onepiece.drop([0])
onepiece.to_csv('./report.csv')

EOF

mv report.csv iam-report-$ts.csv
rm raw.csv
rm -rf list

# Push the latest IAM report to S3 bucket, 'iam-report'
#aws s3 cp iam-report-$ts.csv s3://iam-report/

echo "IAM Report complete!"

exit 0
