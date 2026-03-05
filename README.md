# Two-Tier AWS Infrastructure with Terraform

## Architecture at a Glance

This repository contains a production-style DevOps platform built on AWS using Infrastructure as Code and CI/CD automation.

**Core flow**

Client → Application Load Balancer → ECS Fargate Containers → CloudWatch Monitoring

**Infrastructure automation**

Terraform provisions the entire environment including networking, load balancing, and compute resources.

**Deployment pipeline**

GitHub Actions automatically executes:

* Terraform initialization
* Terraform planning
* Container vulnerability scanning
* Infrastructure deployment

**Security**

Authentication between GitHub and AWS uses OpenID Connect, removing the need for static credentials. Container images are scanned for vulnerabilities using Trivy before deployment.

**Observability**

CloudWatch dashboards track load balancer traffic and container performance, enabling early detection of abnormal system behavior.

**Operational validation**

A controlled outage simulation was performed by scaling ECS tasks to zero. Monitoring captured the disruption, and a root cause analysis was documented in an incident report.


## Project Overview

This project demonstrates a production-style **Two-Tier AWS architecture** deployed using **Terraform Infrastructure as Code** and automated through **GitHub Actions CI/CD pipelines**.

The platform provisions a secure and observable environment where a containerized web application runs on **Amazon ECS Fargate** behind an **Application Load Balancer**, with infrastructure fully managed through Terraform.

The system integrates **security scanning, observability, and incident documentation** to simulate real-world DevOps operational practices.

---

# Architecture Overview

The architecture follows a standard two-tier design:

Client → Application Load Balancer → ECS Fargate Containers

Infrastructure components include:

* VPC with public and private subnets
* Internet Gateway and NAT Gateway
* ECS Cluster (Fargate)
* Application Load Balancer
* Security Groups with least-privilege rules
* Amazon ECR for container images
* CloudWatch for monitoring and observability
* Terraform remote state using S3 and DynamoDB

---

# Technology Stack

Infrastructure as Code

* Terraform

Cloud Platform

* AWS

Container Platform

* Docker
* Amazon ECS (Fargate)

CI/CD

* GitHub Actions
* AWS OIDC authentication

Security

* Trivy container vulnerability scanning
* IAM least privilege roles

Observability

* AWS CloudWatch dashboards and metrics

---

# Repository Structure

two-tier-aws-terraform/

.github/workflows/
CI/CD automation pipeline

app/
Simple web application

Docs/adr/
Architecture Decision Records

Docs/incidents/
Incident simulation reports

infra/backend/
Terraform remote backend configuration

terraform/environment/
Environment-specific infrastructure

terraform/modules/
Reusable Terraform modules

Screenshots/
Deployment and monitoring evidence

Dockerfile
Container build definition

---

# CI/CD Pipeline

The GitHub Actions pipeline performs automated infrastructure deployment.

Pipeline stages include:

1. Repository checkout
2. AWS authentication via OIDC
3. Terraform initialization
4. Terraform planning
5. Trivy container vulnerability scanning
6. Terraform apply

This ensures that infrastructure changes are automatically validated and deployed when changes are pushed to the main branch.

---

# Security Strategy

Security is integrated into the pipeline using a **shift-left security approach**.

Container images are scanned using **Trivy** before infrastructure deployment.

AWS authentication is implemented using **OpenID Connect**, eliminating the need for static AWS credentials inside the repository.

Security principles applied:

* Least privilege IAM roles
* No static AWS credentials
* Container vulnerability scanning
* Private subnet isolation for internal services

---

# Observability

Monitoring is implemented using **AWS CloudWatch dashboards**.

Key metrics monitored include:

* Application Load Balancer request count
* ECS CPU utilization
* System traffic behavior

Observability allows engineers to detect system anomalies and investigate performance issues.

---

# Failure Simulation

To validate monitoring and recovery procedures, an outage simulation was performed.

The ECS service was intentionally scaled to zero tasks, which caused the Application Load Balancer to lose all healthy targets.

The failure was observed through the CloudWatch dashboard and documented in the incident report.

Recovery was achieved by scaling the ECS service back to two running tasks.

Incident documentation can be found in:

Docs/incidents/incident-001-service-outage.md

---

# Screenshots

The Screenshots folder contains evidence artifacts including:

* Terraform plan output
* Successful CI/CD pipeline run
* Security scan results
* CloudWatch observability dashboard
* Incident simulation evidence
* ECS deployment status

These artifacts demonstrate system functionality and operational behavior.

---

# Key DevOps Practices Demonstrated

Infrastructure as Code
Automated CI/CD pipelines
Secure AWS authentication via OIDC
Container vulnerability scanning
Cloud-native observability
Incident documentation and root cause analysis

---

# Conclusion

This project demonstrates how infrastructure automation, security, monitoring, and operational documentation can be combined to build a production-style DevOps platform on AWS.
