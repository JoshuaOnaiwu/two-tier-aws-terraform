# ADR-001 — System Architecture for Two-Tier AWS Infrastructure

## Status
Accepted

## Context

The goal of this project is to design and automate a secure, scalable, and observable two-tier application infrastructure on AWS using Infrastructure as Code and CI/CD practices.

The system must satisfy the following constraints:

- Infrastructure must be reproducible and version-controlled
- Deployment should be automated through CI/CD
- Security scanning must be integrated into the pipeline
- Observability must allow monitoring of system behavior
- Cost efficiency should be considered in architectural choices

The architecture consists of an application tier running containerized workloads and a supporting network and infrastructure layer managed through Terraform.

---

# Initial Repository Structure

The project repository was structured to separate concerns between application code, infrastructure, and deployment tooling.


two-tier-aws-terraform/
'''
│
├── app/ # Application code and container artifacts
├── infra/ # Infrastructure documentation and architecture diagrams
├── terraform/ # Terraform infrastructure modules
├── Screenshots/ # Evidence of deployments and monitoring
├── docs/ # Engineering documentation (ADR, incidents)
├── Dockerfile
└── README.md
'''


### Decision

The repository separates **application code** from **infrastructure code** to enable clear ownership and maintainability.

Reasons:

- Infrastructure and application lifecycles evolve independently
- DevOps pipelines operate primarily on infrastructure modules
- Clear separation improves readability and maintainability

---

# Infrastructure as Code — Terraform

Terraform is used to provision AWS infrastructure including:

- VPC
- Subnets
- Route tables
- NAT gateway
- ECS cluster
- Load balancer
- Security groups

Reasons:

- Declarative infrastructure definition
- Version-controlled infrastructure
- Reproducible environments
- Modular architecture support
- Remote state management with locking

---

# Compute Platform — ECS Fargate

The application runs as a containerized service on **Amazon ECS using the Fargate launch type**.

Reasons:

- Serverless container runtime
- No EC2 instance management
- Native AWS networking integration
- Simplified scaling and service management

### Trade-off

Amazon EKS (Kubernetes) was considered.

However:

- EKS introduces cluster management overhead
- Higher operational complexity
- Higher cost for small deployments

ECS Fargate was selected for simplicity and lower operational overhead.

---

# Container Registry — Amazon ECR

Docker images are stored in Amazon Elastic Container Registry.

Reasons:

- Native AWS integration
- Secure image storage
- Image scanning capabilities
- Seamless ECS integration

---

# CI/CD Platform — GitHub Actions

GitHub Actions automates infrastructure deployment and security checks.

Pipeline stages include:

- Terraform initialization
- Terraform planning
- Container vulnerability scanning
- Infrastructure deployment

Reasons:

- Native integration with GitHub repositories
- Built-in runner environments
- Simple YAML-based workflows
- Support for OIDC authentication with AWS

---

# Security Architecture

Security is implemented using multiple layers:

### IAM OIDC Authentication

GitHub Actions assumes an AWS role via OpenID Connect.

Benefits:

- No static AWS credentials
- Short-lived authentication tokens
- Reduced credential leakage risk

### Container Security Scanning

Trivy scans container images during the CI/CD pipeline.

Purpose:

- Detect vulnerabilities before deployment
- Provide security visibility in CI logs
- Encourage shift-left security practices

---

# Observability Strategy

Monitoring is implemented using **AWS CloudWatch dashboards and metrics**.

Metrics monitored include:

- Application Load Balancer request count
- ECS container CPU utilization
- System traffic patterns

Purpose:

- Detect abnormal system behavior
- Monitor service health
- Support troubleshooting during incidents

---

# Incident Management

Failure simulation was performed to validate monitoring.

The system was intentionally degraded by scaling ECS tasks to zero.

Results:

- Load balancer health checks failed
- Monitoring dashboards reflected service disruption
- Incident report documentation was created

Incident reports are stored in: Docs/incidents/


---

# Consequences

### Positive

- Automated infrastructure provisioning
- Secure AWS authentication using OIDC
- Infrastructure reproducibility
- Integrated vulnerability scanning
- Operational monitoring through dashboards

### Negative

- ECS limits Kubernetes ecosystem flexibility
- CloudWatch provides limited observability compared to Prometheus/Grafana

---

# Future Improvements

- Implement CloudWatch alarms for automated alerting
- Introduce autoscaling policies
- Implement blue/green deployment strategies
- Add Prometheus and Grafana for advanced observability

