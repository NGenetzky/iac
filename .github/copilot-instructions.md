# GitHub Copilot Agent Instructions for This Repository

This repository is maintained by two people:

- Primary implementer: Copilot agent working with the repository owner.
- Reviewer and contributor: repository owner.

## Workflow Rules

1. Use small, cohesive stacked pull requests.
2. Keep each pull request focused on one concern.
3. Before editing, check current branch status and existing diffs.
4. Never mix unrelated refactors with behavior changes.

## Required Before Review

1. Summarize scope and risk in pull request body.
2. Provide validation evidence relevant to changed files.
3. Confirm no secrets were added.
4. Confirm changed files end with a newline.

## Infrastructure Safety Rules

1. Do not commit plaintext credentials, private keys, or vault secrets.
2. Treat inventory, cloud-init bootstrap data, privilege escalation tasks, and ansible.cfg security settings as sensitive.
3. For sensitive changes, include rollback notes and explicit reviewer acknowledgement request.

## Repository Conventions

1. Line endings must be LF.
2. Files must end with a newline.
3. Prefer ASCII unless file context requires Unicode.
4. Preserve existing directory-specific conventions unless intentionally standardizing.

## Communication Rules

1. Be explicit about what changed and why.
2. Call out assumptions when repository behavior is ambiguous.
3. If unexpected unrelated modifications appear, stop and ask for direction before proceeding.

## Planning and Delivery

1. Drive the next action after each review cycle.
2. Keep branch naming and PR titles consistent with the modernization stack.
3. Track remaining tasks and immediately start the next approved stacked PR.