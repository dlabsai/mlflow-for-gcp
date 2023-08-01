IMAGE_NAME=mlflow-gcp
GCP_PROJECT=test-ml-flow-terraform
VERSION=latest
build:
	docker build -t "${IMAGE_NAME}" .

docker-auth:
	gcloud auth configure-docker

tag:
	docker tag "${IMAGE_NAME}" "gcr.io/${GCP_PROJECT}/${IMAGE_NAME}:${VERSION}"

push:
	docker push "gcr.io/${GCP_PROJECT}/${IMAGE_NAME}:${VERSION}"
