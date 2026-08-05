# Governance

## Purpose

This document defines change risk tiers, approval gates, and required controls for infrastructure updates.

## Risk Tiers

### Tier 1 Low Risk

Examples:
- Documentation updates
- Non-behavioral formatting changes
- Comment-only changes

Requirements:
- Standard review
- Relevant lint checks

### Tier 2 Medium Risk

Examples:
- Non-sensitive automation logic updates
- New validation tasks
- Makefile target normalization

Requirements:
- At least one reviewer approval
- Validation evidence in pull request

### Tier 3 High Risk

Examples:
- Inventory and host targeting changes
- Privilege escalation behavior changes
- Bootstrap and cloud-init user-data changes
- Secret-handling configuration changes

Requirements:
- Explicit high-risk acknowledgement in review
- Validation evidence plus rollback notes
- No merge with unresolved security questions

## Required Pull Request Content

Every pull request must include:

- Summary of intent
- Scope boundaries
- Risk tier declaration
- Validation results
- Operational rollback notes for Tier 3 changes

## Stacked Pull Request Policy

- Parent pull request must be reviewed before child merge.
- Child pull request scope must contain only deltas from parent.
- Rebase stack as needed to keep review diffs clean.

## Security Baseline

- Never commit plaintext secrets.
- Prefer managed secret paths over local static secret files.
- Security-impacting defaults must be documented and reviewed.

## Enforcement Path

- Local checks are required before review request.
- CI checks are required before merge.
- Exceptions require documented approval in pull request discussion.
