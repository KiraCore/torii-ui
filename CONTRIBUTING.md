# Contributing to Torii UI

## Development Workflow

### Branch Structure

- `master` - Production branch. PRs from feature branches target this.
- `feature/*` - New features
- `hotfix/*` - Critical production fixes
- `bugfix/*` - Bug fixes
- `perf/*` - Performance improvements
- `refactor/*` - Code refactoring
- `chore/*` - Maintenance tasks

### Version Management

**Automatic Semver Bumping** - Version is automatically bumped on merge to `master`:

| Commit/Branch Pattern | Bump Type | Example |
|-----------------------|-----------|---------|
| `BREAKING CHANGE`, `major:`, `!:` | Major | 1.0.0 → 2.0.0 |
| `feat:`, `feature:`, `feature/*` branch | Minor | 1.0.0 → 1.1.0 |
| `fix:`, `hotfix:`, `bugfix:`, `perf:`, etc. | Patch | 1.0.0 → 1.0.1 |

The version is stored in `pubspec.yaml` and updated automatically by CI.

### CI/CD Pipeline

#### On Push to Feature Branches (`preview.yaml`)

Triggers on push to: `feature/*`, `hotfix/*`, `bugfix/*`, `perf/*`, `refactor/*`, `chore/*`

1. **Build** - Builds web app with `flutter build web --dart-define-from-file=.env`
2. **Deploy Preview** - Pins to IPFS for testing
3. **Output URLs** - Preview URLs shown in workflow summary

#### On Pull Request to `master` (`test.yaml`)

1. **Lint** - Runs `flutter analyze`
2. **Unit Tests** - Runs `flutter test "test/unit" --platform chrome`
3. **Build Check** - Verifies the build succeeds

#### On Merge to `master` (`release.yaml`)

1. **Version Bump** - Auto-increments version based on commit message/branch
2. **Build** - Builds production web app
3. **IPFS Deployment** - Pins to IPFS via Pinata
4. **Sign** - Signs artifacts with cosign
5. **Release** - Creates GitHub release with:
   - `html-web-app.zip`
   - `html-web-app.zip.sig`
   - IPFS gateway URLs

### Making a Contribution

1. Create a feature branch from `master`:
   ```bash
   git checkout master
   git pull origin master
   git checkout -b feature/my-feature
   ```

2. Make your changes

3. Push to trigger preview deployment:
   ```bash
   git push origin feature/my-feature
   ```
   Check the workflow summary for preview URLs.

4. Create PR targeting `master`

5. Wait for tests to pass

6. Get review and merge

7. Release is created automatically with bumped version

### Conventional Commits (Recommended)

Use conventional commit messages for clear version bumping:

```bash
# Patch bump (default)
git commit -m "fix: resolve login issue"
git commit -m "perf: optimize image loading"

# Minor bump
git commit -m "feat: add dark mode toggle"

# Major bump (breaking change)
git commit -m "feat!: redesign authentication flow"
git commit -m "feat: new API

BREAKING CHANGE: removed legacy endpoints"
```

### Required Secrets (for maintainers)

| Secret | Purpose |
|--------|---------|
| `PINATA_API_JWT` | Pinata API token for IPFS pinning |
| `COSIGN_PRIVATE_KEY` | Cosign private key for signing releases |
| `COSIGN_PASSWORD` | Password for cosign private key |

### Local Development

```bash
# Install dependencies
flutter pub get

# Generate code (routing, DI)
dart run build_runner build --delete-conflicting-outputs

# Generate translations
dart pub global run intl_utils:generate

# Run web version
flutter run -d chrome

# Build web version
flutter build web --dart-define-from-file=.env
```

### Testing

```bash
# Run unit tests
flutter test "test/unit" --platform chrome

# Run analyzer
flutter analyze
```

### Flutter Version

This project uses Flutter `3.29.0` (stable channel).
