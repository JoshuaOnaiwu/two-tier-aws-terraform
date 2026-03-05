# Incident 001 — ECS Service Outage Simulation

## Problem
Application became unavailable due to ECS service scaling down to zero tasks.

## Timeline
18:40 — Service scaled to 0 tasks.
18:41 — ALB health checks failed.
18:42 — Requests returned errors.
18:44 — Service scaled back to 2 tasks.
18:45 — ECS tasks became healthy.

## Root Cause
Manual scaling of ECS service to zero tasks removed all running containers.

## Fix
Scaled ECS service back to desired count of 2.

## Prevention
Implement CloudWatch alarm on ECS running task count.
Add minimum service capacity guardrails in Terraform.