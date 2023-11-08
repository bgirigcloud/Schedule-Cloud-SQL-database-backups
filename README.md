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



reference URL https://cloud.google.com/sql/docs/mysql/backup-recovery/scheduling-backups?cloudshell=false
