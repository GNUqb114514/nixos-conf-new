# nixos-conf-new
My NixOS configuration, refactored to be simplified and cache-friendly.

> [!IMPORTANT]
> This configuration is not being usable at present; use it at your own risk.

## Why refactor?
My old configuration is pretty a mess: non-modulated `software-config` and modulated `hm` sub-flake, system-wide and user-local, all those things mixing together, making refactoring becoming extremely painful, while it is still necessary to add new things on top of it making things more messy. I decided to change all of those by rewriting it at all.

## Structure
The directory structure of this configuration is going to be:

- Root directory
  - flake.nix
  - flake.lock
  - hosts/ (Host specification)
	- common.nix
	- ...
  - users/ (User specification)
	- common.nix
	- ...
  - hm/ (Home-manager sub-flake)
	- flake.nix
	- misc/ (Miscellaneous)
		- flake.nix
	- gui/ (GUI- and WM-related stuff)
		- flake.nix
	- emacs/ (Emacs configuration; I think it should be released alone)
      - flake.nix

## Documents
The structure of the documents is in two aspects: commit messages and READMEs.

Commit messages include what modification is made, why, and how. This helps us (includes me in the future) understand the commit. It will be very handy when combined with `git blame`.

READMEs are also a part of documents. They tells us what the directory is focusing to, helping us to locate where a future midification should go.

## Roadmap

- [ ] Create directories
- [ ] Document everything
- [ ] Copy-paste and/or rewrite from original configuration

## Conventional Commits
This repository uses conventional commits with some customization.

Instead of using traditional categorizations used in software projects, this project use the following categories:

- **fix**: Fix a bug.
- **feat**: Add a feature or a new part to the config.
- **lock**: Update lock files. (**NEW!**)
- **docs**: Modify documents.
- **refactor**: Rewrite a part of the config.
- **perf**: Modify structure to make evaluation faster.
- **tweak**: Change the default settings without adding more features. (**NEW!**)

This helps us manage and categorize commits better.
