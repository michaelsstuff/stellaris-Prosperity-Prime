# Conventional Commits Setup

This project uses automated semantic versioning based on conventional commits. This means your commit messages will automatically determine the version number and trigger releases.

## Commit Message Format

Use the following format for your commit messages:

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- **feat**: A new feature (bumps MINOR version, e.g., 1.0.0 → 1.1.0)
- **fix**: A bug fix (bumps PATCH version, e.g., 1.0.0 → 1.0.1)
- **perf**: A performance improvement (bumps PATCH version)
- **refactor**: Code refactoring (bumps PATCH version)
- **revert**: Reverting a previous commit (bumps PATCH version)
- **docs**: Documentation changes (no version bump)
- **style**: Code formatting, no logic changes (no version bump)
- **test**: Adding or updating tests (no version bump)
- **build**: Changes to build system (no version bump)
- **ci**: Changes to CI configuration (no version bump)
- **chore**: Maintenance tasks (no version bump)

### Breaking Changes

Add `!` after the type or include `BREAKING CHANGE:` in the footer to trigger a MAJOR version bump (e.g., 1.0.0 → 2.0.0):

```text
feat!: remove deprecated planet designation system

BREAKING CHANGE: Old planet designations are no longer supported
```

## Examples

```bash
# Feature addition - will create v1.1.0 (if current is v1.0.0)
git commit -m "feat: add new mining district bonuses"

# Bug fix - will create v1.0.1 (if current is v1.0.0)
git commit -m "fix: correct energy district job calculations"

# Performance improvement
git commit -m "perf: optimize planet modifier calculations"

# Breaking change - will create v2.0.0 (if current is v1.x.x)
git commit -m "feat!: rewrite planet generation system"

# Documentation update (no release)
git commit -m "docs: update installation instructions"

# Multiple changes
git commit -m "feat: add asteroid mining stations

- Implement new asteroid mining mechanics
- Add specialized mining station buildings
- Balance resource output for game progression"
```

## How It Works

1. **Syntax Check**: Every push/PR runs CWTools syntax validation
2. **Auto-Versioning**: On main branch, conventional commits trigger semantic-release
3. **Auto-Release**: Creates GitHub release with changelog
4. **Steam Publishing**: Automatically publishes to Steam Workshop
5. **Version Update**: Updates `descriptor.mod` with new version

## Setup Requirements

### GitHub Secrets

Add these secrets to your GitHub repository settings:

1. **STEAM_USERNAME**: Your Steam username
2. **STEAM_PASSWORD**: Your Steam password
3. **STEAM_WORKSHOP_ID**: Workshop item ID (already set: 3498954181)

### First Release

To create your first semantic release, make sure your first commit follows the convention:

```bash
git commit -m "feat: initial mod release with prosperity prime system"
```

This will create version 1.0.0 and trigger the first Steam Workshop upload.

## Workflow Triggers

- **Pull Requests**: Syntax check only
- **Push to main/master**: Syntax check + auto-versioning + Steam publishing (if version bumped)
- **Manual Releases**: Legacy support for manual GitHub releases

## Generated Files

The workflow automatically generates:

- `CHANGELOG.md`: Auto-generated changelog from commit messages
- Updated `descriptor.mod`: Version field updated automatically
- GitHub Releases: With detailed release notes

## Tips

- Use clear, descriptive commit messages
- Group related changes in single commits when possible
- Use `fix:` for bug fixes, `feat:` for new features
- Add `!` or `BREAKING CHANGE:` for breaking changes
- Use `docs:`, `style:`, `chore:` for non-functional changes
