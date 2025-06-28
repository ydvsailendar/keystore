# Project Scripts Overview

This repo contains bash scripts for Docker image building, vulnerability scanning, AWS ECR pushing, querying RDS engine versions, and ECS container command execution.

---

## Scripts

### 1. ecr.sh

Purpose:  
Builds Docker images for multiple repos, scans with Docker Scout for vulnerabilities, blocks push if fixable High/Critical vulnerabilities found, then pushes to AWS ECR. Cleans up scan files and local images afterward.

Usage:
```bash  
bash ecr.sh
```
Features:

- AWS ECR login done once per run  
- Builds images with docker buildx for linux/amd64  
- Uses Docker Scout to scan and generate SARIF JSON in scans/ folder  
- Blocks push on fixable high/critical vulnerabilities  
- Cleans up SARIF scan reports and local Docker images after push  

---

### 2. engine.sh

Purpose:  
Queries AWS RDS for engine versions (example: Postgres 17.5).

Usage: 
```bash  
bash engine.sh
```
---

### 3. exec.sh

Purpose:  
Runs an interactive shell inside a running ECS container.

Usage:  
Update placeholders <cluster_id>, <task_id>, <container_name> in the script, then run:  
```bash 
bash exec.sh
```
---

## Requirements

- AWS CLI configured with profile iamrootnexus and correct permissions  
- Docker with buildx enabled  
- jq installed  
- Docker Scout installed for vulnerability scanning  

---

## Notes

- Modify the repos array in ecr.sh to add/remove repos or Dockerfiles  
- Confirm AWS region/profile matches your setup  
- Clean-up of scan outputs and images is automatic after pushing images  

---

## Contact

Reach out to @ydvsailendar for any questions or contributions.
