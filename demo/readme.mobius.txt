k3d image load mobiusdatasampler.1.0.tar -c mobius12

chmod u+x *.sh

./load_demo_mobius.sh


kubectl delete job/job-mobiusdatasampler-main -n mobius12
kubectl delete job/job-mobiusdatasampler-personal -n mobius12
kubectl delete job/job-mobiusdatasampler-health -n mobius12
kubectl delete job/job-mobiusdatasampler-oneperuser -n mobius12
kubectl delete job/job-mobiusdatasampler-manyperuser -n mobius12
kubectl delete job/job-mobiusdatasampler-bigreport -n mobius12
kubectl delete job/job-mobiusdatasampler-smallreport -n mobius12
kubectl delete job/job-mobiusdatasampler-privacy -n mobius12
kubectl delete job/job-mobiusdatasampler-statements -n mobius12
kubectl delete job/job-mobiusdatasampler-claimdata -n mobius12