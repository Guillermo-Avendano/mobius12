#!/bin/bash

# Nombre del job y espacio de nombres
JOB_NAME="job-mobiusdatasampler-main"
NAMESPACE="mobius12"

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
          value: "http://mobiusview12:8080/mobius"
        - name: MV_REPOSITORY
          value: "Mobius"         
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
