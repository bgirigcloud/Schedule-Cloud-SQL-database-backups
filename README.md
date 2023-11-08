# Schedule-Cloud-SQL-database-backups
This tutorial shows how to use Cloud Scheduler and Cloud Functions to schedule manual backups for a Cloud SQL database.

This tutorial takes approximately 30 minutes to complete.

First, you set up the environment by cloning a git repository that contains test databases and storing those databases in a Cloud Storage bucket.

Then, you create a Cloud SQL for MySQL database instance and import the test databases from the Cloud Storage bucket into the instance.

After the environment is set up, you create a Cloud Scheduler job that posts a backup trigger message at a scheduled date and time on a Pub/Sub topic. The message contains information about the Cloud SQL instance name and the project ID. The message triggers a Cloud Function. The function uses the Cloud SQL Admin API to start a database backup on Cloud SQL. The following diagram illustrates this workflow:

Workflow from Cloud Scheduler to Pub/Sub, which triggers a Cloud Functions that starts the backup.

Google Cloud components
In this document, you use the following billable components of Google Cloud:

To generate a cost estimate based on your projected usage, use the pricing calculator.
Cloud Storage: Stores the test databases that you import into Cloud SQL.
Cloud SQL instance: Contains the database to backup.
Cloud Scheduler: Posts messages to a Pub/Sub topic on a set schedule.
Pub/Sub: Contains messages sent from the Cloud Scheduler.
Cloud Functions: Subscribes to the Pub/Sub topic and when triggered, makes an API call to the Cloud SQL instance to initiate the backup.
When you finish the tasks that are described in this document, you can avoid continued billing by deleting the resources that you created. For more information, see Clean up.

Before you begin
In the Google Cloud console, on the project selector page, select or create a Google Cloud project.

Note: If you don't plan to keep the resources that you create in this procedure, create a project instead of selecting an existing project. After you finish these steps, you can delete the project, removing all resources associated with the project.
Go to project selector

Make sure that billing is enabled for your Google Cloud project.

In the Google Cloud console, go to the APIs page, and enable the following APIs:

Cloud SQL Admin API
Cloud Functions API
Cloud Scheduler API
Cloud Build API
App Engine Admin API
Go to APIs

Throughout the rest of this tutorial, you run all commands from Cloud Shell.

Set up your environment
To get started, you first clone the repository that contains the sample data. You then configure your environment and create custom roles that have the permissions needed for this tutorial.

You can do everything in this tutorial in Cloud Shell.

Clone the repository that contains the sample data:


git clone 
You use the data from the training-data-analyst repository to create a database with some mock records.

Configure the following environment variables:


export PROJECT_ID=`gcloud config get-value project`
export DEMO="sql-backup-tutorial"
export BUCKET_NAME=${USER}-MySQL-$(date +%s)
export SQL_INSTANCE="${DEMO}-sql"
export GCF_NAME="${DEMO}-gcf"
export PUBSUB_TOPIC="${DEMO}-topic"
export SCHEDULER_JOB="${DEMO}-job"
export SQL_ROLE="sqlBackupCreator"
export STORAGE_ROLE="simpleStorageRole"
export REGION="us-west2"
Create two custom roles that have only the permissions needed for this tutorial:


gcloud iam roles create ${STORAGE_ROLE} --project ${PROJECT_ID} \
    --title "Simple Storage role" \
    --description "Grant permissions to view and create objects in Cloud Storage" \
    --permissions "storage.objects.create,storage.objects.get"

gcloud iam roles create ${SQL_ROLE} --project ${PROJECT_ID} \
    --title "SQL Backup role" \
    --description "Grant permissions to backup data from a Cloud SQL instance" \
    --permissions "cloudsql.backupRuns.create"
Note: If you're prompted to authorize Cloud Shell, then click Authorize. Also, if you see the error message: (gcloud.iam.roles.create) You do not currently have an active account selected, run the gcloud auth login command, and then follow the steps that appear in Cloud Shell.
These roles reduce the scope of access of Cloud Functions and Cloud SQL service accounts, following the principle of least privilege.

Create a Cloud SQL instance
In this section, you create a Cloud Storage bucket and a Cloud SQL for MySQL instance. Then you upload the test database to the Cloud Storage bucket and import the database from there into the Cloud SQL instance.

Create a Cloud Storage bucket
You use the gsutil command-line tool to create a Cloud Storage bucket.


```sh
gsutil mb -l ${REGION} gs://${BUCKET_NAME}
```
Create a Cloud SQL instance and grant permissions to its service account
Next, you create a Cloud SQL instance and grant its service account the permissions to create backup runs.

Create a Cloud SQL for MySQL instance:

sh gcloud sql instances create ${SQL_INSTANCE} --database-version MYSQL_5_7 --region ${REGION}

This operation takes a few minutes to complete.

Verify that the Cloud SQL instance is running:


gcloud sql instances list --filter name=${SQL_INSTANCE}
The output looks similar to the following:


NAME                     DATABASE_VERSION  LOCATION    TIER              PRIMARY_ADDRESS  PRIVATE_ADDRESS  STATUS
sql-backup-tutorial      MYSQL_5_7         us-west2-b  db-n1-standard-1  x.x.x.x     -                RUNNABLE
Note: For this tutorial the PRIMARY_ADDRESS field is shown as "x.x.x.x". In your case an actual IP address is displayed.
Grant your Cloud SQL service account the permissions to export data to Cloud Storage with the Simple Storage role:


export SQL_SA=(`gcloud sql instances describe ${SQL_INSTANCE} \
    --project ${PROJECT_ID} \
    --format "value(serviceAccountEmailAddress)"`)

gsutil iam ch serviceAccount:${SQL_SA}:projects/${PROJECT_ID}/roles/${STORAGE_ROLE} gs://${BUCKET_NAME}
Populate the Cloud SQL instance with sample data
Now you can upload files to your bucket and create and populate your sample database.

Go to the repository that you cloned:


cd training-data-analyst/CPB100/lab3a/cloudsql
IMPORTANT: Remain in this directory for the rest of the tutorial.
Upload the files in the directory to your new bucket:


gsutil cp * gs://${BUCKET_NAME}
Create a sample database; at the "Do you want to continue (Y/n)?" prompt, enter Y (Yes) to continue.


gcloud sql import sql ${SQL_INSTANCE} gs://${BUCKET_NAME}/table_creation.sql --project ${PROJECT_ID}
Populate the database; at the "Do you want to continue (Y/n)?" prompt, enter Y (Yes) to continue.


gcloud sql import csv ${SQL_INSTANCE} gs://${BUCKET_NAME}/accommodation.csv \
    --database recommendation_spark \
    --table Accommodation

gcloud sql import csv ${SQL_INSTANCE} gs://${BUCKET_NAME}/rating.csv \
    --database recommendation_spark \
    --table Rating
Create a topic, a function, and a scheduler job
In this section, you create a custom IAM service account and bind it to the custom SQL role that you created in Set up your environment. You then create a Pub/Sub topic and a Cloud Function that subscribes to the topic, and uses the Cloud SQL Admin API to initiate a backup. Finally, you create a Cloud Scheduler job to post a message to the Pub/Sub topic periodically.

Create a service account for the Cloud Function
The first step is to create a custom service account and bind it to the custom SQL role that you created in Set up your environment.

Create an IAM service account to be used by the Cloud Function:


gcloud iam service-accounts create ${GCF_NAME} \
    --display-name "Service Account for GCF and SQL Admin API"
Grant the Cloud Function service account access to the custom SQL role:


gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${GCF_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="projects/${PROJECT_ID}/roles/${SQL_ROLE}"
Create a Pub/Sub topic
The next step is to create a Pub/Sub topic that's used to trigger the Cloud Function that interacts with the Cloud SQL database.


```sh
gcloud pubsub topics create ${PUBSUB_TOPIC}
```
Create a Cloud Function
Next, you create the Cloud Function.

Create a main.py file by pasting the following into Cloud Shell:


cat <<EOF > main.py

import base64
import logging
import json

from datetime import datetime
from httplib2 import Http

from googleapiclient import discovery
from googleapiclient.errors import HttpError
from oauth2client.client import GoogleCredentials

def main(event, context):
    pubsub_message = json.loads(base64.b64decode(event['data']).decode('utf-8'))
    credentials = GoogleCredentials.get_application_default()

    service = discovery.build('sqladmin', 'v1beta4', http=credentials.authorize(Http()), cache_discovery=False)

    try:
      request = service.backupRuns().insert(
            project=pubsub_message['project'],
            instance=pubsub_message['instance']
        )
      response = request.execute()
    except HttpError as err:
        logging.error("Could NOT run backup. Reason: {}".format(err))
    else:
      logging.info("Backup task status: {}".format(response))
EOF
Create a requirements.txt file by pasting the following into Cloud Shell:


cat <<EOF > requirements.txt
google-api-python-client
Oauth2client
EOF
Deploy the code:


gcloud functions deploy ${GCF_NAME} \
    --trigger-topic ${PUBSUB_TOPIC} \
    --runtime python37 \
    --entry-point main \
    --service-account ${GCF_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
Create a Cloud Scheduler job
Finally, you create a Cloud Scheduler job to periodically trigger the data backup function on an hourly basis. Cloud Scheduler uses an App Engine instance for deployment.

Create an App Engine instance for the Cloud Scheduler job:


gcloud app create --region=${REGION}
Create a Cloud Scheduler job:


gcloud scheduler jobs create pubsub ${SCHEDULER_JOB} \
--schedule "0 * * * *" \
--topic ${PUBSUB_TOPIC} \
--message-body '{"instance":'\"${SQL_INSTANCE}\"',"project":'\"${PROJECT_ID}\"'}' \
--time-zone 'America/Los_Angeles'
Test your solution
The final step is to test your solution. You start by running the Cloud Scheduler job.

Run the Cloud Scheduler job manually to trigger a MySQL dump of your database.


gcloud scheduler jobs run ${SCHEDULER_JOB}
List the operations performed on the MySQL instance, and verify that there's an operation of type BACKUP_VOLUME:


gcloud sql operations list --instance ${SQL_INSTANCE} --limit 1
The output shows a completed backup job. For example:


NAME                                  TYPE           START                          END                            ERROR  STATUS
8b031f0b-9d66-47fc-ba21-67dc20193749  BACKUP_VOLUME  2020-02-06T21:55:22.240+00:00  2020-02-06T21:55:32.614+00:00  -      DONE
Clean up
You can avoid incurring charges to your Google Cloud account for the resources used in this tutorial by following these steps. The easiest way to eliminate billing is to delete the project you created for the tutorial.

Caution: Deleting a project has the following effects:
Everything in the project is deleted. If you used an existing project for the tasks in this document, when you delete it, you also delete any other work you've done in the project.
Custom project IDs are lost. When you created this project, you might have created a custom project ID that you want to use in the future. To preserve the URLs that use the project ID, such as an appspot.com URL, delete selected resources inside the project instead of deleting the whole project.
In the Google Cloud console, go to the Manage resources page.
Go to Manage resources

In the project list, select the project that you want to delete, and then click Delete.
In the dialog, type the project ID, and then click Shut down to delete the project.
If you don't want to delete the entire project, then delete each of the resources you created. To do this, go to the appropriate pages in the Google Cloud console, selecting the resource, and deleting it.

Go to Cloud Functions

Go to Cloud Storage

Go to Cloud SQL Instances

Go to Pub/Sub

Go to Cloud Scheduler


