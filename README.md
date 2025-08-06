# Flutter Boilerplate

## Installation

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
flutter create --platforms=linux .
flutter create --platforms=web .
flutter create --platforms=ios .
flutter create --platforms=android .
```

### Misellaneous

```bash
flutter clean # Clean the build directory
flutter pub get # Get dependencies
flutter pub upgrade # Upgrade dependencies
flutter pub outdated # Check for outdated dependencies
flutter pub deps # Show dependency tree
flutter pub run build_runner build --delete-conflicting-outputs # Generate code using build_runner
flutter pub run build_runner watch --delete-conflicting-outputs # Watch for changes and regenerate code
flutter analyze # Analyze the code for issues
flutter test # Run tests
flutter test --coverage # Run tests with coverage
flutter format . # Format the code
flutter format --set-exit-if-changed . # Format the code and exit with an error if changes were made
```

### Versions

[Version Backend API (Laravel)](https://github.com/wisusdev/boilerplate_backend_api_laravel)

[Version Frontend Web (Angular)](https://github.com/wisusdev/boilerplate_frontend_web_angular)
