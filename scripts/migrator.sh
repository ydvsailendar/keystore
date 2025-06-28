#!/bin/bash
set -e

AWS_REGION="eu-west-2"
AWS_PROFILE="iamrootnexus"
CLUSTER_NAME="OssEcsClusterApp"
TASK_DEF_NAME_PATTERN="OssEcsTaskDefMigrator"
VPC_NAME="OssVpc"
SUBNET_NAME_PREFIX="OssAppSubnet"
SECURITY_GROUP_NAME="OssSgMigrator"

# Get AWS account ID dynamically
ACCOUNT_ID=$(aws sts get-caller-identity --profile "$AWS_PROFILE" --query Account --output text --region "$AWS_REGION")

# Get cluster ARN dynamically based on cluster name
CLUSTER_ARN=$(aws ecs list-clusters --profile "$AWS_PROFILE" --region "$AWS_REGION" --query "clusterArns[?contains(@, '$CLUSTER_NAME')]" --output text)

if [[ -z "$CLUSTER_ARN" ]]; then
  echo "❌ ECS cluster '$CLUSTER_NAME' not found in region $AWS_REGION"
  exit 1
fi

# Get the latest migrator task definition ARN using jq
TASK_DEF_ARN=$(aws ecs list-task-definitions --profile "$AWS_PROFILE" --region "$AWS_REGION" --output json \
  | jq -r --arg pattern "$TASK_DEF_NAME_PATTERN" '
      .taskDefinitionArns
      | map(select(contains($pattern)))
      | sort_by(
          (. | split(":") | .[-1] | tonumber)
        )
      | last
    ')

if [[ -z "$TASK_DEF_ARN" || "$TASK_DEF_ARN" == "null" ]]; then
  echo "❌ Task definition for migrator not found"
  exit 1
fi

# Get VPC ID by VPC name tag
VPC_ID=$(aws ec2 describe-vpcs --profile "$AWS_PROFILE" --region "$AWS_REGION" \
  --filters "Name=tag:Name,Values=$VPC_NAME" \
  --query "Vpcs[0].VpcId" --output text)

if [[ "$VPC_ID" == "None" || -z "$VPC_ID" ]]; then
  echo "❌ VPC named '$VPC_NAME' not found"
  exit 1
fi

# Get subnet IDs matching the subnet name prefix inside that VPC
SUBNET_IDS=($(aws ec2 describe-subnets --profile "$AWS_PROFILE" --region "$AWS_REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=${SUBNET_NAME_PREFIX}*" \
  --query "Subnets[].SubnetId" --output text))

if [[ ${#SUBNET_IDS[@]} -eq 0 ]]; then
  echo "❌ No subnets found matching prefix '$SUBNET_NAME_PREFIX' in VPC $VPC_ID"
  exit 1
fi

# Get security group IDs by name tag inside the VPC
SECURITY_GROUP_IDS=($(aws ec2 describe-security-groups --profile "$AWS_PROFILE" --region "$AWS_REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=$SECURITY_GROUP_NAME" \
  --query "SecurityGroups[].GroupId" --output text))

if [[ ${#SECURITY_GROUP_IDS[@]} -eq 0 ]]; then
  echo "❌ No security groups named '$SECURITY_GROUP_NAME' found in VPC $VPC_ID"
  exit 1
fi

# Join array items with commas
subnets=$(IFS=, ; echo "${SUBNET_IDS[*]}")
security_groups=$(IFS=, ; echo "${SECURITY_GROUP_IDS[*]}")

echo "Running migrator ECS task..."

TASK_ARN=$(aws ecs run-task \
  --cluster "$CLUSTER_ARN" \
  --launch-type FARGATE \
  --task-definition "$TASK_DEF_ARN" \
  --network-configuration "awsvpcConfiguration={subnets=[$subnets],securityGroups=[$security_groups],assignPublicIp=DISABLED}" \
  --region "$AWS_REGION" \
  --profile "$AWS_PROFILE" \
  --query 'tasks[0].taskArn' \
  --output text)

echo "Started task $TASK_ARN, waiting for it to finish..."

aws ecs wait tasks-stopped --cluster "$CLUSTER_ARN" --tasks "$TASK_ARN" --region "$AWS_REGION" --profile "$AWS_PROFILE"

# Get detailed task info
TASK_DETAILS=$(aws ecs describe-tasks \
  --cluster "$CLUSTER_ARN" \
  --tasks "$TASK_ARN" \
  --region "$AWS_REGION" \
  --profile "$AWS_PROFILE" \
  --output json)

EXIT_CODE=$(echo "$TASK_DETAILS" | jq -r '.tasks[0].containers[0].exitCode')
LAST_STATUS=$(echo "$TASK_DETAILS" | jq -r '.tasks[0].containers[0].lastStatus')
STOPPED_REASON=$(echo "$TASK_DETAILS" | jq -r '.tasks[0].stoppedReason // empty')

if [[ "$EXIT_CODE" != "0" ]]; then
  echo "❌ Migrator task failed."
  echo "Exit Code: $EXIT_CODE"
  echo "Last Status: $LAST_STATUS"
  if [[ -n "$STOPPED_REASON" ]]; then
    echo "Stopped Reason: $STOPPED_REASON"
  fi
  exit 1
fi

echo "✅ Migrator task completed successfully."
