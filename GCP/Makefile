IMAGE_NAME=mlflow-gcp
GCP_PROJECT=mlflow-gcp
AR_REGISTRY_NAME=mlflow-gcp
AR_REGION=europe-west2
VERSION=latest
build:
	docker build -t "${IMAGE_NAME}" .
	
build-m1:
	docker build --platform linux/amd64 -t "${IMAGE_NAME}" .

docker-auth:
	gcloud auth configure-docker

tag:
	docker tag "${IMAGE_NAME}" "${AR_REGION}-docker.pkg.dev/${GCP_PROJECT}/${AR_REGISTRY_NAME}/${IMAGE_NAME}:${VERSION}"

push:
	docker push "${AR_REGION}-docker.pkg.dev/${GCP_PROJECT}/${AR_REGISTRY_NAME}/${IMAGE_NAME}:${VERSION}"
