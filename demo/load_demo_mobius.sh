#!/bin/bash

# Nombre del job y espacio de nombres
JOB_NAME="job-mobiusdatasampler-main"
NAMESPACE="mobius12"

MV_REPOSITORY="http://mobiusview12:8080/mobius"
MV_REPOSITORY="Mobius" 
MV_BASIC_AUTH_USER="admin"
MV_BASIC_AUTH_PASS="ASG_ENC(c1LpoXEIRe3h7b6TVoDfNP91rGK/9wGM)"  #admin
MV_SECRET_SEC="5##)MbIPy?%_vFx*5Cm0G15MLc0rV/SK.cY"   

MV_EFS_VOLUME="pvc-mobius12-efs"

sed "s#@MV_REPOSITORY@#$MV_REPOSITORY#g" template/job_template.yaml >  template/job_template.tmp
sed "s#@MV_URL@#$MV_URL#g" template/job_template.tmp >  template/job_template.tmp1
sed "s#@MV_BASIC_AUTH_USER@#$MV_BASIC_AUTH_USER#g" template/job_template.tmp1 >  template/job_template.tmp
sed "s#@MV_BASIC_AUTH_PASS@#$MV_BASIC_AUTH_PASS#g" template/job_template.tmp >  template/job_template.tmp1
sed "s#@MV_REPOSITORY@#$MV_REPOSITORY#g" template/job_template.tmp1 >  template/job_template.tmp
sed "s#@MV_EFS_VOLUME@#$MV_EFS_VOLUME#g" template/job_template.tmp >  jobs_datasampler_mobius.yaml

# Job Main
cat <<EOF | kubectl apply -n $NAMESPACE -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: $JOB_NAME
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: my-job-mobiusdatasampler-main
        image: mobiusdatasampler:1.0
        env:
          - name: MV_URL
            value: "$MV_URL"
          - name: MV_REPOSITORY
            value: "$MV_REPOSITORY"
          - name: MV_BASIC_AUTH_USER
            value: "$MV_BASIC_AUTH_USER"
          - name: MV_BASIC_AUTH_PASS 
            value: "$MV_BASIC_AUTH_PASS"               
EOF

# Wait till the Job finished
echo "Wait for 5 minutes till the Job finish..."
kubectl wait --for=condition=complete --timeout=300s -n $NAMESPACE job/$JOB_NAME

# Check the main job status
JOB_STATUS=$(kubectl get -n $NAMESPACE job/$JOB_NAME -o jsonpath='{.status.conditions[0].status}')
if [ "$JOB_STATUS" == "True" ]; then
  echo "Main Job finished with success."
  kubectl apply -f ./jobs_datasampler_mobius.yaml -n $NAMESPACE
else
  echo "Main Job failed."
fi