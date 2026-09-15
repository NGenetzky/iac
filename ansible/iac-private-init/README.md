# iac-private-init

Generates the initial skeleton for a **private** companion repository
(`iac-private`) that holds inventories, host variables, and secrets that
should not live in this public `iac` repo.

It does not print or embed any real inventory data - it only creates the
directory layout, `.gitignore`, docs placeholder, and one starter inventory
of each supported type, ready for you to fill in and push to a private
Gitea/Gogs/gitweb remote.

## Layout produced

```
<dest>/
├── .gitignore              # committed first, per usual workflow
├── README.md
├── Makefile
├── docs/                   # private notes; some files here may be generated
│   └── README.md
└── inventories/
    ├── debops/              # designed for use with `debops`
    │   ├── .debops.cfg
    │   ├── run.debops.sh
    │   ├── README.md
    │   └── ansible/inventory/hosts.yml
    ├── home/                # vanilla ansible-playbook inventory
    │   ├── ansible.cfg
    │   ├── hosts.yml
    │   ├── README.md
    │   ├── group_vars/all/vars.yml
    │   └── host_vars/
    └── lab/                 # another vanilla ansible-playbook inventory
        └── ... (same layout as home/)
```

The set of inventories (name, type, description) is defined in
[roles/iac_private_scaffold/defaults/main.yml](roles/iac_private_scaffold/defaults/main.yml)
and can be overridden with `-e`.

Each vanilla inventory's `ansible.cfg` sets `roles_path` to point at
`../../../iac/ansible/roles`, assuming `iac-private` is checked out as a
sibling of this `iac` clone (or `iac` is added as a git submodule at that
path).

## Usage

```bash
./generate.sh --dest ~/git/iac-private
cd ~/git/iac-private
git log --oneline   # .gitignore is committed automatically as the first commit
git remote add origin <your gitea/gogs/gitweb url>
git push -u origin main
```

Re-running against an existing destination fails by default so you don't
clobber real data; pass `-e iac_private_scaffold_force=true` to reuse a directory.

## Running via the devcontainer / Docker image

[Dockerfile](Dockerfile) builds the base image with `ansible`, `ansible-lint`,
`debops`, and `git` - the minimal dependencies needed to run this generator
and to work in the resulting `iac-private` repo. [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json)
builds on top of that same image so opening this folder in VS Code gives you
a ready-to-use environment.

```bash
make docker-build
```

## Secrets

Nothing here encrypts secrets for you. Once real host variables exist in
`iac-private`, encrypt them with `ansible-vault encrypt_string` (or a full
`ansible-vault encrypt`) before committing, even though the repo is private.
