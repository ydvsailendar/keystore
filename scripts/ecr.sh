#!/bin/bash
set -e

AWS_REGION="eu-west-2"
AWS_PROFILE="iamrootnexus"
ACCOUNT_ID=$(aws sts get-caller-identity --profile "$AWS_PROFILE" --query Account --output text --region "$AWS_REGION")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

SCAN_DIR="$PROJECT_ROOT/scans"
mkdir -p "$SCAN_DIR"

declare -A repos=(
  ["consumer"]="$PROJECT_ROOT/dockerfile/Dockerfile.consumer"
  ["dashboard"]="$PROJECT_ROOT/dockerfile/Dockerfile.dashboard"
  ["migrator"]="$PROJECT_ROOT/dockerfile/Dockerfile.migrator"
  ["producer"]="$PROJECT_ROOT/dockerfile/Dockerfile.producer"
)

# Login once before processing all repos
echo "🔐 Logging into AWS ECR..."
aws ecr get-login-password --profile "$AWS_PROFILE" --region "$AWS_REGION" \
  | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

for repo in "${!repos[@]}"; do
  echo "🔨 Processing repo: $repo"
  ECR_REPO="oss_ecr_repo_$repo"
  IMAGE_TAG="v1.0.0"
  DOCKERFILE_PATH=${repos[$repo]}

  # Build image
  docker buildx build --platform linux/amd64 -t "$ECR_REPO" -f "$DOCKERFILE_PATH" "$PROJECT_ROOT"

  # Scan using Docker Scout
  SARIF_OUTPUT="$SCAN_DIR/scout_result_${repo}.sarif.json"
  echo "🔍 Running Docker Scout scan on $ECR_REPO:latest ..."
  docker scout cves --format sarif --output "$SARIF_OUTPUT" "$ECR_REPO:latest"

  # Block if HIGH or CRITICAL with fix available (parse .message.text)
  VULN_COUNT=$(jq -r '.runs[].results[].message.text' "$SARIF_OUTPUT" | \
    awk '
      BEGIN { RS=""; count=0 }
      /Severity[ ]*:[ ]*(HIGH|CRITICAL)/ && /Fixed version[ ]*:[ ]*[^ ]/ && !/Fixed version[ ]*:[ ]*not fixed/ { count++ }
      END { print count }
    ')

  echo "🛡️ Filtered vulnerabilities (High/Critical with fix): $VULN_COUNT"

  if [[ "$VULN_COUNT" -gt 0 ]]; then
    echo "🚨 Docker Scout found $VULN_COUNT fixable High/Critical vulnerabilities. Aborting push!"
    echo "📋 Vulnerability Summary:"
    jq -r '.runs[].results[].message.text' "$SARIF_OUTPUT" | \
      awk '
        BEGIN { RS=""; }
        /Severity[ ]*:[ ]*(HIGH|CRITICAL)/ && /Fixed version[ ]*:[ ]*[^ ]/ && !/Fixed version[ ]*:[ ]*not fixed/ { print $0 "\n---" }
      '
    # Clean up before exit
    rm -f "$SARIF_OUTPUT"
    docker rmi "$ECR_REPO:latest" || true
    exit 1
  fi

  # Tag and push
  docker tag "$ECR_REPO:latest" "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG"
  docker push "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG"

  echo "✅ Pushed $ECR_REPO:$IMAGE_TAG successfully"

  # Cleanup SARIF file and images after push
  rm -f "$SARIF_OUTPUT"
  docker rmi "$ECR_REPO:latest" "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG" || true
done
