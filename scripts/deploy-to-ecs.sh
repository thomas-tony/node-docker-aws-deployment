#!/bin/bash

# Variables
CLUSTER_NAME="my-cluster"
SERVICE_NAME="my-node-app-service"
TASK_FAMILY="my-node-app-task"
IMAGE_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:latest"
SUBNET_IDS="subnet-0123456789abcdef0,subnet-0123456789abcdef1"
SECURITY_GROUP="sg-0123456789abcdef0"

# Register the task definition
TASK_DEFINITION=$(cat <<EOF
{
  "family": "$TASK_FAMILY",
  "networkMode": "awsvpc",
  "containerDefinitions": [
    {
      "name": "$REPO_NAME",
      "image": "$IMAGE_URI",
      "essential": true,
      "memory": 512,
      "cpu": 256,
      "portMappings": [
        {
          "containerPort": 8000,
          "hostPort": 8080,
          "protocol": "tcp"
        }
      ]
    }
  ],
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512"
}
EOF
)

echo "$TASK_DEFINITION" > task-definition.json
aws ecs register-task-definition --cli-input-json file://task-definition.json

# Create or update the ECS service
SERVICE_EXIST=$(aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME --query 'failures' --output text)

if [ -z "$SERVICE_EXIST" ]; then
  aws ecs create-service --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --task-definition $TASK_FAMILY --desired-count 1 --launch-type FARGATE --network-configuration "awsvpcConfiguration={subnets=[$SUBNET_IDS],securityGroups=[$SECURITY_GROUP],assignPublicIp=ENABLED}" --load-balancers "targetGroupArn=<target-group-arn>,containerName=$REPO_NAME,containerPort=8080"
else
  aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --task-definition $TASK_FAMILY
fi