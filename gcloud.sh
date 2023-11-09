 1  gcloud dataproc clusters create example-cluster --region us-central1 --zone us-central1-f --master-machine-type n2-standard-2 --master-boot-disk-size 500 --num-workers 2 --worker-machine-type n2-standard-2 --worker-boot-disk-size 500 --image-version 2.1-debian11 --project inner-cinema-392713
    2  gcloud auth list
    3  gcloud config list
    4  gcloud storage list
    5  gcloud storage buckets list
    6  gcloud storage objects list
    7  gcloud storage ls
    8  gcloud storage ls  gs://my-test-storage-rama/
    9  edit gs://my-test-storage-rama/comand.txt
   10  gsutil ls
   11  gsutil ls gs://my-test-storage-rama/
   12  gsutil cat gs://my-test-storage-rama/comand.txt
   13  gsutil vi  gs://my-test-storage-rama/comand.txt
   14  gsutil cat gs://my-test-storage-rama/comand.txt
   15  gcloud storage ls --all-versions gs://my-test-storage-rama
   16  gcloud storage buckets describe gs://my-test-storage-rama --format="default(versioning)"
   17  gcloud storage buckets update gs://my-test-storage-rama --versioning
   18  gcloud storage buckets update gs://my-test-storage-rama-demo --versioning
   19  gcloud storage buckets describe gs://my-test-storage-rama-demo --format="default(versioning)"
   20  gsutil cat gs://my-test-storage-rama-demo/comand.txt
   21  gcloud storage ls --all-versions gs://my-test-storage-rama-demo
   22  gsutil cat gs://my-test-storage-rama-demo/comand.txt#1694103002201735
   23  gcloud storage ls --all-versions gs://my-test-storage-rama-demo
   24  gcloud storage cat gs://my-test-storage-rama-demo/comand.txt#1694102847417534
   25  gcloud storage ls --all-versions gs://my-test-storage-rama-demo
   26  gcloud storage cat gs://my-test-storage-rama-demo/comand.txt#1694103002201735
   27  gcloud storage cat gs://my-test-storage-rama-demo/comand.txt#1694103365556466
   28  gcloud storage ls --all-versions gs://my-test-storage-rama-demo
   29  gcloud storage ls
   30  gcloud storage ls gs://my-test-storage-rama-demo/
   31  gcloud storage cat s://my-test-storage-rama-demo/comand.txt
   32  gcloud storage cat gs://my-test-storage-rama-demo/comand.txt
   33  gcloud storage ls
   34  gcloud storage ls gs://my-test-storage-rama-demo/
   35  gcloud storage ls gs://my-test-storage-rama-demo/comand.txt
   36  gcloud storage cat gs://my-test-storage-rama-demo/comand.txt
   37  git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
   38  ls -ltr
   39  cd python-docs-samples/
   40  ls 
   41  cd appengine/
   42  cd standard
   43  ls -ltr
   44  cd hello_world/
   45  ls -ltr
   46  gcloud init
   47  gcloud auth login
   48  gcloud app deploy
   49  gcloud app browse
   50  gcloud app deploy
   51  gcloud app browse
   52  gcloud app deploy
   53  gcloud app browse
   54  gcloud app services delete default
   55  ls -ltr
   56  gcloud confif set project effective-cacao-398419
   57  gcloud config set project effective-cacao-398419
   58  ls -ltr
   59  gcloud app deploy 
   60  gcloud app browse
   61  gcloud app deploy 
   62  gcloud app browse
   63  git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
   64  ls -ltr
   65  cd python-docs-samples/
   66  ls
   67  cd appengine/
   68  ls
   69  cd standard
   70  ls
   71  cd hello_world/
   72  gcloud app deploy
   73  docker --version
   74  kubctl --version
   75  kubectl --version
   76  gcloud functions add-invoker-policy-binding demo-auto-schedule-cloudsql-bkp       --region="us-central1"       --member="MEMBER_NAME"
   77  gcloud functions add-invoker-policy-binding demo-auto-schedule-cloudsql-bkp --region="us-central1" --member="sqlbkp-automation@kinetic-object-400913.iam.gserviceaccount.com"
   78  gcloud sql connect demo --user=postgres --quiet
   79  gcloud sql connect demo --user=postgres 
   80  git clone https://github.com/GoogleCloudPlatform/training-data-analyst.git
   81  export PROJECT_ID=`gcloud config get-value project`
   82  export DEMO="sql-backup-tutorial"
   83  export BUCKET_NAME=${USER}-MySQL-$(date +%s)
   84  export SQL_INSTANCE="${DEMO}-sql"
   85  export GCF_NAME="${DEMO}-gcf"
   86  export PUBSUB_TOPIC="${DEMO}-topic"
   87  export SCHEDULER_JOB="${DEMO}-job"
   88  export SQL_ROLE="sqlBackupCreator"
   89  export STORAGE_ROLE="simpleStorageRole"
   90  export REGION="us-west2"
   91  export PROJECT_ID=`gcloud config get-value project`
   92  export DEMO="sql-backup-tutorial"
   93  export BUCKET_NAME=${USER}-MySQL-$(date +%s)
   94  export SQL_INSTANCE="${DEMO}-sql"
   95  export GCF_NAME="${DEMO}-gcf"
   96  export PUBSUB_TOPIC="${DEMO}-topic"
   97  export SCHEDULER_JOB="${DEMO}-job"
   98  export SQL_ROLE="sqlBackupCreator"
   99  export STORAGE_ROLE="simpleStorageRole"
  100  export REGION="us-west2"
  101  gcloud iam roles create ${STORAGE_ROLE} --project ${PROJECT_ID}     --title "Simple Storage role"     --description "Grant permissions to view and create objects in Cloud Storage"     --permissions "storage.objects.create,storage.objects.get"
  102  gcloud iam roles create ${STORAGE_ROLE} --project ${PROJECT_ID}     --title "Simple Storage role"     --description "Grant permissions to view and create objects in Cloud Storage"     --permissions "storage.objects.create,storage.objects.get"
  103  gcloud iam roles create ${SQL_ROLE} --project ${PROJECT_ID}     --title "SQL Backup role"     --description "Grant permissions to backup data from a Cloud SQL instance"     --permissions "cloudsql.backupRuns.create"
  104  gsutil mb -l ${REGION} gs://${BUCKET_NAME}
  105  export BUCKET_NAME=${USER}-MySQL-$(date +%s)
  106  clear
  107  export BUCKET_NAME=${USER}-MySQL-$(date +%s)
  108  gsutil mb -l ${REGION} gs://${BUCKET_NAME}
  109  export BUCKET_NAME=$PROJECT_ID-MySQL-$(date +%s)
  110  gsutil mb -l ${REGION} gs://${BUCKET_NAME}
  111  export BUCKET_NAME=$PROJECT_ID-$(date +%s)
  112  gsutil mb -l ${REGION} gs://${BUCKET_NAME}
  113  gcloud iam roles create ${STORAGE_ROLE} --project ${PROJECT_ID}     --title "Simple Storage role"     --description "Grant permissions to view and create objects in Cloud Storage"     --permissions "storage.objects.create,storage.objects.get"
  114  gcloud iam roles create ${SQL_ROLE} --project ${PROJECT_ID}     --title "SQL Backup role"     --description "Grant permissions to backup data from a Cloud SQL instance"     --permissions "cloudsql.backupRuns.create"
  115  sh gcloud sql instances create ${SQL_INSTANCE} --database-version MYSQL_5_7 --region ${REGION}
  116  CLEAR
  117  CLEAR
  118  clear
  119  cls
  120  gcloud sql instances list --filter name=${SQL_INSTANCE}
  121  exit
  122  ```sh
  123  gsutil mb -l ${REGION} gs://${BUCKET_NAME}
  124  ```
  125  gcloud sql instances list --filter name=${SQL_INSTANCE}
  126  clear
  127  export SQL_SA=(`gcloud sql instances describe ${SQL_INSTANCE} \
  128      --project ${PROJECT_ID} \
  129      --format "value(serviceAccountEmailAddress)"`)
  130  gsutil iam ch serviceAccount:${SQL_SA}:projects/${PROJECT_ID}/roles/${STORAGE_ROLE} gs://${BUCKET_NAME}
  131  export SQL_SA=(`gcloud sql instances describe ${SQL_INSTANCE} \
  132      --project ${PROJECT_ID} \
  133      --format "value(serviceAccountEmailAddress)"`)
  134  gsutil iam ch serviceAccount:${SQL_SA}:projects/${PROJECT_ID}/roles/${STORAGE_ROLE} gs://${BUCKET_NAME}
  135  export BUCKET_NAME=${PROJECT_ID}-$(date +%s)
  136  gsutil iam ch serviceAccount:${SQL_SA}:projects/${PROJECT_ID}/roles/${STORAGE_ROLE} gs://${BUCKET_NAME}
  137  gsutil iam ch serviceAccount:${SQL_SA}:projects/${PROJECT_ID}/roles/${STORAGE_ROLE} gs://kinetic-object-400913-1699452070
  138  CLEAR
  139  cd training-data-analyst/CPB100/lab3a/cloudsql
  140  clear
  141  ls
  142  ls -ltr
  143  gsutil cp * gs://${BUCKET_NAME}
  144  gsutil cp * gs://kinetic-object-400913-1699452070
  145  gcloud sql import sql ${SQL_INSTANCE} gs://${BUCKET_NAME}/table_creation.sql --project ${PROJECT_ID}
  146  gcloud sql import sql ${SQL_INSTANCE} gs://kinetic-object-400913-1699452070/table_creation.sql --project ${PROJECT_ID}
  147  clear
  148  gcloud sql import csv ${SQL_INSTANCE} gs://kinetic-object-400913-1699452070/accommodation.csv     --database recommendation_spark     --table Accommodation
  149  gcloud sql import csv ${SQL_INSTANCE} gs://kinetic-object-400913-1699452070/rating.csv     --database recommendation_spark     --table Rating
  150  PS1=$
  151  ls -ltr
  152  pwd
  153  clear
  154  gcloud iam service-accounts create ${GCF_NAME}     --display-name "Service Account for GCF and SQL Admin API"
  155  gcloud projects add-iam-policy-binding ${PROJECT_ID}     --member="serviceAccount:${GCF_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"     --role="projects/${PROJECT_ID}/roles/${SQL_ROLE}"
  156  cler
  157  clear
  158  gcloud pubsub topics create ${PUBSUB_TOPIC}
  159  cat <<EOF > main.py
  160  import base64
  161  import logging
  162  import json
  163  from datetime import datetime
  164  from httplib2 import Http
  165  from googleapiclient import discovery
  166  from googleapiclient.errors import HttpError
  167  from oauth2client.client import GoogleCredentials
  168  def main(event, context):
  169      pubsub_message = json.loads(base64.b64decode(event['data']).decode('utf-8'))
  170      credentials = GoogleCredentials.get_application_default()
  171      service = discovery.build('sqladmin', 'v1beta4', http=credentials.authorize(Http()), cache_discovery=False)
  172      try:
  173        request = service.backupRuns().insert(
  174              project=pubsub_message['project'],
  175              instance=pubsub_message['instance']
  176          )
  177        response = request.execute()
  178      except HttpError as err:
  179          logging.error("Could NOT run backup. Reason: {}".format(err))
  180      else:
  181        logging.info("Backup task status: {}".format(response))
  182  EOF
  183  ls
  184  ls -ltr
  185  cat <<EOF > requirements.txt
  186  google-api-python-client
  187  Oauth2client
  188  EOF
  189  ls -al
  190  clear
  191  gcloud functions deploy ${GCF_NAME}     --trigger-topic ${PUBSUB_TOPIC}     --runtime python37     --entry-point main     --service-account ${GCF_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
  192  gcloud app create --region=${REGION}
  193  clear
  194  gcloud scheduler jobs create pubsub ${SCHEDULER_JOB} --schedule "0 * * * *" --topic ${PUBSUB_TOPIC} --message-body '{"instance":'\"${SQL_INSTANCE}\"',"project":'\"${PROJECT_ID}\"'}' --time-zone 'America/Los_Angeles'
  195  clear
  196  gcloud scheduler jobs run ${SCHEDULER_JOB}
  197  gcloud sql operations list --instance ${SQL_INSTANCE} --limit 1
  198  gcloud scheduler jobs run ${SCHEDULER_JOB}
  199  gcloud sql operations list --instance ${SQL_INSTANCE} --limit 1
  200  clear
  201  gcloud scheduler jobs run ${SCHEDULER_JOB}
  202  gcloud scheduler jobs run ${SCHEDULER_JOB}
  203  gcloud scheduler jobs run ${SCHEDULER_JOB}
  204  history
  205  pwd
  206  ls -al
  207  echo "# Schedule-Cloud-SQL-database-backups" >> README.md
  208  git init
  209  git add .
  210  git commit -m "first commit"
  211  git branch -M main
  212  git remote add origin https://github.com/bgirigcloud/Schedule-Cloud-SQL-database-backups.git
  213  git push -u origin main
  214  git config --global user.email "mr.bgiri26@gmail.com"
  215    git config --global user.name "bgiri_gcloud"
  216  git commit -m "first commit"
  217  git branch -M main
  218  git remote add origin https://github.com/bgirigcloud/Schedule-Cloud-SQL-database-backups.git
  219  git push -u origin main
  220  git push -u origin main
  221  git remote add origin https://github.com/bgirigcloud/Schedule-Cloud-SQL-database-backups.git
  222  git push -u origin main
  223  git push -u origin main
  224  pwd
  225  gsutil cp -R /home/sahooritendra302/training-data-analyst/CPB100/lab3a/cloudsql/ gs://kinetic-object-400913/
