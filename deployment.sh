#!/bin/bash

ARTIFACTORY_REGISTRY="trialpfvj0w.jfrog.io"
DOCKER_REPO="dockerdemo-docker"
IMAGE_NAME="spring-app"
S3_BUCKET="spring-app-artifactory/JFrog_Artifacts"
IMAGE_VERSION_FILE="image_version.txt"

# JFrog Credentials
ARTIFACTORY_USER="aditerraform@gmail.com"
ARTIFACTORY_PASSWORD="cmVmdGtuOjAxOjE3NzM4MDUyODY6b3Z4OFFGenhqTUlqTFBLQ0VKMm5vaG80Z000"

# AWS Credentials
AWS_ACCESS_KEY_ID="AKIATN2GZOAATZ2AYTW5"
AWS_SECRET_ACCESS_KEY="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"

# Step 1: Fetch the latest image version from S3
echo "Fetching latest image version from S3..."
aws s3 cp "s3://$S3_BUCKET/$IMAGE_VERSION_FILE" .

if [ ! -f "$IMAGE_VERSION_FILE" ]; then
    echo "Error: Image version file not found!"
    exit 1
fi

IMAGE_VERSION=$(cat "$IMAGE_VERSION_FILE" | tr -d '\n')
LATEST_IMAGE_TAG="$ARTIFACTORY_REGISTRY/$DOCKER_REPO/$IMAGE_NAME:$IMAGE_VERSION"

echo "Latest image version: $IMAGE_VERSION"
echo "Docker Image: $LATEST_IMAGE_TAG"

# Step 2: Login to JFrog Artifactory
echo "Logging into JFrog Artifactory..."
echo "$ARTIFACTORY_PASSWORD" | docker login -u "$ARTIFACTORY_USER" --password-stdin "$ARTIFACTORY_REGISTRY"

# Step 3: Stop and remove existing container (if running)
echo "Stopping and removing old container..."
docker stop $IMAGE_NAME 2>/dev/null || true
docker rm $IMAGE_NAME 2>/dev/null || true

# Step 4: Pull the latest Docker image
echo "Pulling the latest Docker image..."
docker pull "$LATEST_IMAGE_TAG"

# Step 5: Run the new container
echo "Starting the new container..."
docker run -d --name $IMAGE_NAME -p 8080:8080 "$LATEST_IMAGE_TAG"

# Step 6: Cleanup unused Docker images
echo "Removing unused Docker images..."
docker image prune -f

echo "Deployment completed successfully!"