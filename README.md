# Flutter Boilerplate

### Feature

- Authentication
- Localization
- Dark and light mode
- Secure storage
- Environment variables
- State management
- HTTP requests
- Account management
  - Profile editing
  - Change password
  - Recover password
- Roles and permissions management
- User management
- Responsive design (coming soon)

### Installation

```bash
git clone https://github.com/wisusdev/boilerplate_frontend_mobile_flutter.git
cd boilerplate_frontend_mobile_flutter
flutter pub get
cp .env.example .env
```

### RUN

```bash
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
r # Enable hot reload
R # Enable hot restart
```

### Enable support

```bash
flutter create --platforms=macos .
flutter create --platforms=windows .
flutter create --platforms=web .
flutter create --platforms=android .
```

### IOS

```bash
brew install cocoapods
flutter create --platforms=ios .
cd ios && pod install
```

### Linux

```bash
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
flutter create --platforms=linux .
```

### Miscellaneous

```bash
flutter clean # Clean the build directory
flutter pub get # Get dependencies
flutter pub upgrade # Upgrade dependencies
flutter pub outdated # Check for outdated dependencies
flutter pub deps # Show dependency tree
flutter pub run build_runner build --delete-conflicting-outputs # Generate code using build_runner
flutter pub run build_runner watch --delete-conflicting-outputs # Watch for changes and regenerate code
flutter analyze # Analyze the code for issues
flutter analyze --no-fatal-infos
flutter test # Run tests
flutter test --coverage # Run tests with coverage
flutter format . # Format the code
flutter format --set-exit-if-changed . # Format the code and exit with an error if changes were made
```

### TODO

- [X] Manager Authentication
- [X] Manager languages
- [X] Manager themes
- [X] Dark and light mode
- [X] Manager profile
- [X] Manager roles and permissions
- [X] Manager users
- [X] Responsive design
- [] Manager notifications

### Packages used

- **State Management**: Using [provider](https://pub.dev/packages/provider) for state management.
- **Environment**: Using [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) for environment variables.
- **HTTP Requests**: Using [http](https://pub.dev/packages/http) for making HTTP requests.
- **Secure Storage**: Using [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) for secure storage of sensitive data.
- **Localization**: Using [flutter_localizations](https://pub.dev/packages/flutter_localizations) for localization support.
- **Preferences**: Using [shared_preferences](https://pub.dev/packages/shared_preferences) for storing user preferences.

### Versions

- **Backend**: API [Laravel](https://github.com/wisusdev/boilerplate_backend_api_laravel)
- **Frontend**: Web [Angular](https://github.com/wisusdev/boilerplate_frontend_web_angular)
