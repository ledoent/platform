# Huly Mobile

Flutter mobile client for Huly Platform.

## Features

- **Authentication**: Full flow including Server URL setup, Email/Password, OTP, 2FA, and OAuth (Google).
- **Biometric Security**: Optional biometric lock for app access.
- **Issues**: Browse projects, filter and search issues, create and edit issues with attachments.
- **Chat**: Real-time messaging in channels and direct messages via WebSockets.
- **Push Notifications**: Firebase-powered notifications for mentions and messages.

## Tech Stack

- **Framework**: Flutter
- **State Management**: [Riverpod](https://riverpod.dev)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **API**: [Dio](https://pub.dev/packages/dio) for REST, `web_socket_channel` for Real-time.
- **Persistence**: `flutter_secure_storage` for credentials and tokens.

## Getting Started

1.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
2.  **Generate Models**:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
3.  **Run the App**:
    ```bash
    flutter run
    ```

## Testing

The project uses `flutter_test` and `mocktail` for testing.

- **Unit Tests**: Test providers and API clients.
- **Widget Tests**: Test screen behavior and UI components.

Run all tests:
```bash
flutter test
```

## Architecture

The project follows a feature-based folder structure under `lib/features/`.
- `core/`: Shared models, API clients, theme, and widgets.
- `features/`: Isolated feature modules (auth, chat, issues, etc.).
- `services/`: Global application services (Push, Share Handler).
