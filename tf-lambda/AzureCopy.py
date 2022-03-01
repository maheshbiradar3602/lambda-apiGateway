import json
import csv
import boto3

print('Loading function')
s3 = boto3.resource('s3')
bucket = s3.Bucket("azurebillingdata")


def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))
    #print(event)
    from datetime import datetime
    getdata = json.dumps(event)
    readdata = json.loads(getdata)
    newfilename =  datetime.today().strftime('%d_%m_%Y')
    full_path =  "/tmp/azurebilling_" + newfilename +".csv"
    s3filename = "azurebilling_" + newfilename +".csv"
    #f = open(full_path, 'w', newline='')
    keys = readdata[0].keys()
    print(keys)
    with open(full_path, 'w', newline='') as output_file:
        writter = csv.DictWriter(output_file, keys, delimiter=";")
        writter.writeheader()
        writter.writerows(readdata)
    bucket.upload_file(full_path, s3filename)
    return {
        'statuscode': 200,
        'Body': json.dumps('Data Processed and uploaded successfully')
    }
    