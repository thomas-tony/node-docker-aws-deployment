# Node.js Docker AWS Deployment

This project demonstrates how to Dockerize a Node.js application and deploy it to AWS ECS using AWS ECR.

## Prerequisites

- AWS Account
- AWS CLI installed and configured
- Docker installed
- Node.js installed

## Dockerizing the Application

1. **Build the Docker image**:

   ```sh
   docker build -t my-node-app .

1. **Run the Docker container locally**:

   ```sh
   docker run -d -p 8080:8080 --name my-node-app-container my-node-app .

# Deploying to AWS
## Push to AWS ECR

1. **Run the push-to-ecr.sh script**:

   ```sh
   ./scripts/push-to-ecr.sh .

## Deploy to AWS ECS

1. **Run the deploy-to-ecs.sh script**:

   ```sh
   ./scripts/deploy-to-ecs.sh .

# Accessing the Application
- Locally: Open http://localhost:8000
- AWS: The URL provided by your load balancer
