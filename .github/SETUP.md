# CI/CD Setup Guide

This repository uses GitHub Actions for automated syntax checking with CWTools, semantic versioning, and publishing to Steam Workshop.

## Pipeline Overview

The CI/CD pipeline consists of four main jobs:

### 1. Syntax Check (`syntax-check`)
- **Trigger**: On every push and pull request to main/master branches
- **Tool**: [CWTools Action](https://github.com/cwtools/cwtools-action)
- **Purpose**: Validates Stellaris mod syntax and provides inline feedback on PRs
- **Languages**: Checks both English and German localizations
- **Output**: Creates `cwtools-output` artifact with detailed analysis

### 2. Semantic Release (`semantic-release`)
- **Trigger**: On push to main/master branches (after successful syntax check)
- **Tool**: [semantic-release](https://github.com/semantic-release/semantic-release)
- **Purpose**: Automatically determines version numbers from conventional commits
- **Features**:
  - Analyzes commit messages to determine version bump (major/minor/patch)
  - Generates changelog from commit history
  - Creates GitHub releases automatically
  - Updates `descriptor.mod` with new version

### 3. Steam Workshop Publishing (`publish-to-steam`)
- **Trigger**: Only when semantic-release creates a new version
- **Dependencies**: Requires successful syntax check and semantic-release
- **Tool**: SteamCMD
- **Purpose**: Automatically publishes mod updates to Steam Workshop
- **Features**:
  - Uses mod metadata from `descriptor.mod`
  - Auto-generates Steam Workshop description with BBCode formatting
  - Includes version information and changelog from release
  - Uploads build logs as artifacts

### 4. Manual Release Support (`publish-to-steam-manual`)
- **Trigger**: On published GitHub releases (manual releases)
- **Purpose**: Backward compatibility for manual release process
- **Features**: Same as automatic Steam publishing but triggered by manual releases

## Required Secrets

To use this pipeline, you need to configure the following repository secrets:

### GitHub Secrets Setup

1. Go to your repository → Settings → Secrets and variables → Actions
2. Add the following secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `STEAM_USERNAME` | Your Steam account username | `your_username` |
| `STEAM_PASSWORD` | Your Steam account password | `your_password` |
| `STEAM_WORKSHOP_ID` | Your mod's Steam Workshop ID | `3498954181` |

### Finding Your Steam Workshop ID

1. Go to your mod's Steam Workshop page
2. Look at the URL: `https://steamcommunity.com/sharedfiles/filedetails/?id=XXXXXXXXXX`
3. The number after `id=` is your Workshop ID

## Usage

### Conventional Commits (Recommended)

This project now supports **automatic semantic versioning** using conventional commits. When you push to main/master, the system automatically:

1. Analyzes your commit messages
2. Determines the appropriate version bump
3. Creates a GitHub release
4. Publishes to Steam Workshop
5. Updates `descriptor.mod`

#### Commit Message Format

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Examples

```bash
# Feature addition - creates minor version bump (1.0.0 → 1.1.0)
git commit -m "feat: add new mining district bonuses"

# Bug fix - creates patch version bump (1.0.0 → 1.0.1)
git commit -m "fix: correct energy district job calculations"

# Breaking change - creates major version bump (1.0.0 → 2.0.0)
git commit -m "feat!: rewrite planet generation system"

# No release (documentation, style, etc.)
git commit -m "docs: update installation instructions"
```

#### Supported Types

- `feat:` - New feature (minor version bump)
- `fix:` - Bug fix (patch version bump)
- `perf:` - Performance improvement (patch version bump)  
- `refactor:` - Code refactoring (patch version bump)
- `docs:` - Documentation (no version bump)
- `style:` - Formatting (no version bump)
- `test:` - Tests (no version bump)
- `chore:` - Maintenance (no version bump)

**Breaking Changes**: Add `!` after type or include `BREAKING CHANGE:` in footer for major version bump.

See [CONVENTIONAL_COMMITS.md](.github/CONVENTIONAL_COMMITS.md) for detailed examples.

### For Pull Requests
- Every PR automatically gets syntax checking
- CWTools will add inline comments pointing out any issues
- PR must pass syntax check before merging

### For Releases (Manual - Legacy Method)

> **Note**: With conventional commits enabled, you typically don't need to create manual releases. The system will automatically create releases when you push commits with the proper format to the main branch.

For manual releases (legacy support):

1. **Create a Release**:

   ```bash
   git tag v1.2.0
   git push origin v1.2.0
   ```

   Or use GitHub's web interface to create a release

2. **Automatic Actions**:

   - Syntax check runs first
   - If successful, mod is published to Steam Workshop
   - Version in `descriptor.mod` is automatically updated
   - Build artifacts are saved for debugging

### Local Development
You can run CWTools locally using the CLI:
```bash
# Install CWTools CLI (requires .NET)
dotnet tool install -g cwtools.cli

# Run syntax check
cwtools --game stellaris --locLanguages english german
```

## File Structure

```
.github/
├── workflows/
│   └── ci-cd.yml           # Main pipeline configuration
├── SETUP.md                # This file
└── README.md               # Repository documentation

# Your mod files
descriptor.mod              # Mod metadata (auto-updated)
common/                     # Game data files
events/                     # Event definitions
localisation/              # Text translations
```

## Customization

### Changing Languages
Edit the `locLanguages` parameter in `.github/workflows/ci-cd.yml`:
```yaml
locLanguages: "english spanish french german"
```

### Modifying Steam Description
The Steam Workshop description is auto-generated from your mod information. To customize it, edit the `description` field in the workflow file.

### Adding More Games
CWTools supports multiple Paradox games. Change the `game` parameter:
```yaml
game: stellaris  # or hoi4, eu4, ck2, ir, vic2
```

## Troubleshooting

### Common Issues

1. **Syntax Check Fails**
   - Check the CWTools output artifact for detailed error messages
   - Fix syntax errors in your mod files
   - Ensure localization files use correct YAML format

2. **Steam Publishing Fails**
   - Verify Steam credentials in repository secrets
   - Check that Steam Workshop ID is correct
   - Ensure Steam account has permissions to edit the workshop item
   - Review build logs artifact for SteamCMD errors

3. **Version Update Fails**
   - Ensure GitHub token has write permissions
   - Check that `descriptor.mod` exists and has correct format

### Security Notes

- **Steam Credentials**: Consider using a dedicated Steam account for automation
- **Token Permissions**: The GitHub token needs push permissions for version updates
- **Secrets**: Never commit Steam credentials to your repository

## Advanced Configuration

### Custom Rules Repository
You can specify custom CWTools rules:
```yaml
- uses: cwtools/cwtools-action@v1.1.0
  with:
    game: stellaris
    rules: "https://github.com/yourname/custom-stellaris-rules.git"
    rulesRef: "main"
```

### Suppressing Specific Warnings
```yaml
suppressedOffenceCategories: '{"failure":["CW110"], "warning":[], "notice":[]}'
```

### Publishing Only Specific Files
Modify the `contentfolder` in the VDF to point to a subdirectory if needed.

## Support

- **CWTools Issues**: [CWTools Action Repository](https://github.com/cwtools/cwtools-action/issues)
- **Steam Workshop API**: [Steamworks Documentation](https://partner.steamgames.com/doc/features/workshop/implementation)
- **General Questions**: Create an issue in this repository
