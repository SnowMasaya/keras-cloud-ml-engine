export BUCKET_NAME={your gcs path}
export JOB_NAME="mnist_mlp_train_$(date +%Y%m%d_%H%M%S)"
export JOB_DIR=gs://$BUCKET_NAME/$JOB_NAME
export REGION=us-east1

gcloud ml-engine local train \
  --job-dir $JOB_DIR \
  --module-name trainer.mnist_mlp \
  --package-path ./trainer \
  -- \
  --train-file ./data/mnist.pkl