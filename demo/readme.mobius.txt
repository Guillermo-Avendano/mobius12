k3d image load mobiusdatasampler.1.0.tar -c mobius

chmod u+x *.sh

./load_demo_mobius.sh


kubectl delete job/job-mobiusdatasampler-main -n mobius
kubectl delete job/job-mobiusdatasampler-personal -n mobius
kubectl delete job/job-mobiusdatasampler-health -n mobius
kubectl delete job/job-mobiusdatasampler-oneperuser -n mobius
kubectl delete job/job-mobiusdatasampler-manyperuser -n mobius
kubectl delete job/job-mobiusdatasampler-bigreport -n mobius
kubectl delete job/job-mobiusdatasampler-smallreport -n mobius
kubectl delete job/job-mobiusdatasampler-privacy -n mobius
kubectl delete job/job-mobiusdatasampler-statements -n mobius
kubectl delete job/job-mobiusdatasampler-claimdata -n mobius