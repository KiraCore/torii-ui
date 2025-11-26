# Contributing to Torii UI

## Development Workflow

### Branch Structure

- `dev` - Main development branch. All PRs should target this branch.

### Version Management

The app version is defined in `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

**Important:** You must bump the version in `pubspec.yaml` for every PR to `dev`. The CI will reject PRs where the working branch version is not greater than the `dev` branch version.

### Scripts

Located in `/scripts`:

| Script | Purpose |
|--------|---------|
| `version.sh` | Extracts normalized version (X.Y.Z) from pubspec.yaml |
| `compare_versions.py` | Compares two versions, returns True if second > first |

### CI/CD Pipeline

#### On Pull Request to `dev`

1. **Version Check** (`version_and_tests.yaml`)
   - Extracts version from `dev` branch
   - Extracts version from your working branch
   - Fails if working branch version ≤ dev branch version

2. **Unit Tests** (`version_and_tests.yaml`)
   - Runs `flutter pub get`
   - Runs `flutter analyze`
   - Runs `flutter test "test/unit" --platform chrome`

3. **Build Preview** (`deploy_and_release.yaml`)
   - Builds web app with canvaskit renderer
   - Pins to IPFS with temporary version `0.0.1`
   - No GitHub release created

#### On Push/Merge to `dev`

1. **Build** (`deploy_and_release.yaml`)
   - Builds web app: `flutter build web --web-renderer canvaskit`
   - Creates `html-web-app.zip`

2. **IPFS Deployment**
   - Pins build to IPFS via Pinata
   - Upload name: `torii-www-{version}`
   - Available at:
     - `https://ipfs.kira.network/ipfs/{hash}`
     - `https://ipfs.io/ipfs/{hash}`

3. **GitHub Release**
   - Creates release with tag matching version
   - Signs `html-web-app.zip` with cosign
   - Attaches:
     - `html-web-app.zip`
     - `html-web-app.zip.sig`

### Making a Contribution

1. Create a feature branch from `dev`:
   ```bash
   git checkout dev
   git pull origin dev
   git checkout -b feature/my-feature
   ```

2. Make your changes

3. Bump version in `pubspec.yaml`:
   ```yaml
   # Before
   version: 1.0.0+1

   # After (example)
   version: 1.0.1+1
   ```

4. Run tests locally:
   ```bash
   flutter pub get
   flutter analyze
   flutter test "test/unit" --platform chrome
   ```

5. Push and create PR targeting `dev`

6. Wait for CI checks to pass

7. Get review and merge

### Required Secrets (for maintainers)

The following GitHub secrets must be configured:

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
flutter build web --web-renderer canvaskit
```

### Flutter Version

This project uses Flutter `3.29.0` (stable channel). Ensure you have a compatible version installed.
