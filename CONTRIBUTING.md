# Contributing

## Working Agreement

- Implementation is driven by the automation maintainer for each modernization task.
- Review feedback is expected on every pull request before merge.
- Optional reviewer commits are welcome on active pull request branches.
- GitHub Copilot agent behavior for this repository is defined in .github/copilot-instructions.md.

## Branch and Pull Request Workflow

1. Use focused branches for cohesive changes.
2. Keep each pull request small and scoped to one concern.
3. Use stacked pull requests for dependent work.
4. Link parent and child pull requests when stacking.

## Pull Request Checklist

- Scope is focused and does not include unrelated edits.
- Operational and security impact is documented.
- Validation evidence is attached.
- Follow-up tasks are identified if needed.

## Commit Guidance

- Write clear commit messages that describe infrastructure intent.
- Avoid mixing refactors and behavior changes in one commit.
- Prefer incremental commits that are easy to review.

## Validation Requirements

Run relevant checks before requesting review. Examples:

- Ansible: syntax checks and ansible-lint
- YAML: yamllint
- Bash: shellcheck
- Docker: lint and vulnerability checks when Docker files are changed

## Security and Secrets

- Do not commit credentials, tokens, private keys, or decrypted secret files.
- Treat inventory and bootstrap configuration as sensitive and high review priority.
- Escalation-related changes require explicit reviewer acknowledgement.

## Review Expectations

- Reviewer confirms scope, safety, and validation quality.
- Author resolves review comments and summarizes updates.
- Merge only after approvals and passing checks.
