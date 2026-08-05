# IaC Repository

This repository contains infrastructure automation for home and lab environments across Ansible, cloud-init, Docker, DebOps, and Vagrant.

## Goals

- Keep infrastructure changes reproducible and reviewable.
- Prefer small, cohesive changes with clear validation evidence.
- Improve safety and delivery speed with automation and policy checks.

## Repository Map

- ansible: playbooks, roles, inventory, and environment-specific orchestration.
- cloud-init: bootstrap assets for VM and device initialization.
- docker: container build and runtime definitions for utility workloads.
- debops: DebOps-based configuration paths.
- vagrant: local virtualization and provisioning flows.
- bash: helper scripts.

## Getting Started

1. Clone the repository.
2. Review CONTRIBUTING.md for workflow and validation requirements.
3. Review .github/copilot-instructions.md for GitHub Copilot agent rules.
4. Start work from a short-lived branch.

## Delivery Model

- Work lands through small stacked pull requests.
- Each pull request covers one concern only.
- Each pull request includes validation output relevant to changed files.

## Validation Baseline

Current baseline varies by subdirectory and is being standardized. Typical checks include:

- ansible syntax checks and ansible-lint
- yaml lint checks
- shell script lint checks
- container and secret hygiene checks

## Documentation Status

This root documentation is the baseline for modernization and will be expanded as workflows are standardized.

## Agent Configuration

Repository-specific GitHub Copilot agent behavior is defined in .github/copilot-instructions.md.
