#!/bin/bash
set -e

AWS_REGION="eu-west-2"
AWS_PROFILE="iamrootnexus"
CLUSTER_NAME="OssEcsClusterApp"

# Get cluster ARN dynamically
CLUSTER_ARN=$(aws ecs list-clusters --profile "$AWS_PROFILE" --region "$AWS_REGION" --query "clusterArns[?contains(@, '${CLUSTER_NAME}')]" --output text)
if [[ -z "$CLUSTER_ARN" ]]; then
  echo "❌ Cluster $CLUSTER_NAME not found."
  exit 1
fi

# List running tasks ARNs
TASK_ARNS=($(aws ecs list-tasks --cluster "$CLUSTER_ARN" --desired-status RUNNING --profile "$AWS_PROFILE" --region "$AWS_REGION" --query 'taskArns' --output text))
if [[ ${#TASK_ARNS[@]} -eq 0 ]]; then
  echo "❌ No running tasks found in cluster $CLUSTER_NAME."
  exit 1
fi

echo "Select a task to exec into:"
for i in "${!TASK_ARNS[@]}"; do
  TASK_ID=${TASK_ARNS[$i]##*/}
  TASK_DESC=$(aws ecs describe-tasks --cluster "$CLUSTER_ARN" --tasks "${TASK_ARNS[$i]}" --profile "$AWS_PROFILE" --region "$AWS_REGION" --query 'tasks[0].[taskDefinitionArn,startedAt]' --output text)
  TASK_DEF_ARN=$(echo "$TASK_DESC" | awk '{print $1}')
  STARTED_AT=$(echo "$TASK_DESC" | awk '{print $2}')

  if [[ "$STARTED_AT" == "None" || -z "$STARTED_AT" ]]; then
    STARTED_AT="N/A"
  fi

  TASK_DEF_FAMILY=$(echo "$TASK_DEF_ARN" | awk -F'/' '{print $2}' | awk -F':' '{print $1}')
  printf "[%d] %s | %s | %s\n" "$i" "$TASK_ID" "$TASK_DEF_FAMILY" "$STARTED_AT"
done

read -rp "Enter choice: " CHOICE
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || (( CHOICE < 0 || CHOICE >= ${#TASK_ARNS[@]} )); then
  echo "❌ Invalid choice."
  exit 1
fi

TASK_ID=${TASK_ARNS[$CHOICE]##*/}
CONTAINER_NAME=$(aws ecs describe-tasks --cluster "$CLUSTER_ARN" --tasks "${TASK_ARNS[$CHOICE]}" --profile "$AWS_PROFILE" --region "$AWS_REGION" --query 'tasks[0].containers[0].name' --output text)

echo "Starting exec session into task $TASK_ID, container $CONTAINER_NAME..."
aws ecs execute-command \
  --cluster "$CLUSTER_ARN" \
  --task "${TASK_ARNS[$CHOICE]}" \
  --container "$CONTAINER_NAME" \
  --interactive \
  --command "/bin/sh" \
  --region "$AWS_REGION" \
  --profile "$AWS_PROFILE"
