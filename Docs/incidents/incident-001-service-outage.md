# Incident Report — Service Outage Simulation

## Incident ID
INC-001

## Date
March 2026

## System
Two-Tier AWS Infrastructure (ECS Fargate + ALB)

---

# Problem

The web application became unavailable when all ECS tasks were stopped.

Users accessing the Application Load Balancer endpoint received failed responses because no healthy backend containers were running.

---

# Timeline

**T0 — Normal Operation**

The ECS service was running with two healthy tasks behind the Application Load Balancer.

CloudWatch dashboards showed normal traffic and system metrics.

---

**T1 — Failure Introduced**

The ECS service was intentionally scaled to zero tasks to simulate an application outage.

Command executed:
aws ecs update-service
--cluster two-tier-cluster
--service two-tier-service
--desired-count 0


---

**T2 — Impact Observed**

Application Load Balancer began receiving requests without any healthy targets.

CloudWatch dashboard displayed abnormal traffic behavior.

Monitoring confirmed that no ECS tasks were available to handle requests.

---

**T3 — Recovery**

The ECS service was restored by scaling the service back to two running tasks.
aws ecs update-service
--cluster two-tier-cluster
--service two-tier-service
--desired-count 2


Service availability was restored after ECS scheduled new tasks.

---

# Root Cause

The service outage occurred because the ECS service had no running tasks to handle incoming requests from the load balancer.

When the desired task count was set to zero, the load balancer had no healthy targets to route traffic to.

---

# Fix

The ECS service was scaled back to two running tasks.

New containers were launched and registered with the Application Load Balancer target group.

Traffic routing resumed normally once the targets passed health checks.

---

# Prevention

Future production systems should implement:

- Minimum task count enforcement
- Auto Scaling policies based on CPU or request load
- CloudWatch alarms for unhealthy target counts
- Deployment safety checks in CI/CD pipelines

These measures help ensure that a service cannot unintentionally scale down to zero tasks.