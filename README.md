# Torii UI

Torii is a cross-chain bridge wallet for transferring tokens between the KIRA Network and Ethereum using Ethereum Threshold Signing (ETS).

## Features

- **Multi-Chain Wallet Support**
  - KIRA Network wallet (mnemonic or keyfile sign-in)
  - Ethereum wallet via MetaMask integration

- **Cross-Chain Token Transfers**
  - Export KEX tokens from KIRA to Ethereum (wKEX)
  - Import wKEX tokens from Ethereum to KIRA
  - Secure passphrase-based claim system

- **Transaction Management**
  - Real-time transaction tracking
  - Transaction history with details
  - Claim pending transactions

- **Network Configuration**
  - Custom RPC endpoint configuration
  - Network status monitoring via Interx API

## Architecture

```
lib/
├── data/           # API clients, DTOs, local storage
├── domain/         # Business logic, models, repositories, services
├── presentation/   # UI layer (pages, widgets, BLoC/Cubit)
└── utils/          # Helpers, router, theme, cryptography
```

The app follows clean architecture with:
- **BLoC/Cubit** for state management
- **GetIt + Injectable** for dependency injection
- **GoRouter** for navigation
- **Dio** for HTTP requests

## Prerequisites

- Flutter SDK `^3.7.0` (tested with `3.29.0`)
- Chrome browser (for web development)
- MetaMask browser extension (for Ethereum features)

## Getting Started

### Installation

```bash
# Clone the repository
git clone https://github.com/kiracore/torii-ui.git
cd torii-ui

# Install dependencies
flutter pub get

# Generate code (routing, DI)
dart run build_runner build --delete-conflicting-outputs

# Generate translations
dart pub global run intl_utils:generate
```

### Running

```bash
# Run in Chrome (development)
flutter run -d chrome

# Run with KIRA-ETH bridge enabled
flutter run -d chrome --dart-define=KIRA_ETH_ENABLED=true
```

### Building

```bash
# Build web release
flutter build web --web-renderer canvaskit

# Build with KIRA-ETH bridge enabled
flutter build web --web-renderer canvaskit --dart-define=KIRA_ETH_ENABLED=true
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `KIRA_ETH_ENABLED` | `false` | Enable KIRA-Ethereum bridge features |
| `IS_TEST_ENVIRONMENT` | `false` | Enable test environment mode |

### Network Configuration

The app connects to KIRA Network via Interx API. Configure the RPC endpoint through the Network settings in the UI or via URL parameter.

## Usage Flow

1. **Connect Wallet**
   - KIRA: Sign in with 24-word mnemonic or keyfile
   - Ethereum: Connect MetaMask

2. **Transfer Tokens**
   - Select source chain and amount
   - Enter destination address
   - Set a secure passphrase for claiming

3. **Claim Tokens**
   - Monitor pending transactions
   - Claim tokens on destination chain using passphrase

## Development

### Code Generation

After modifying routes or injectable services:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Translations

After modifying `.arb` files in `lib/utils/l10n/`:

```bash
dart pub global run intl_utils:generate
```

### Testing

```bash
# Run unit tests
flutter test "test/unit" --platform chrome

# Run analyzer
flutter analyze
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development workflow and CI/CD details.

## License

This project is part of the KIRA Network ecosystem.
