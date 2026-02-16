# Rundown Task


## Getting Started

```bash
# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Run tests
flutter test

# Build for release
flutter build apk        # Android
flutter build ios         # iOS
flutter build macos       # macOS
```

## Project Structure

```
lib/
├── main.dart                  # Entry point
├── app.dart                   # Root MaterialApp widget
├── core/
│   ├── constants/
│   │   └── app_constants.dart # App-wide constants
│   ├── router/
│   │   └── app_router.dart    # Named route definitions
│   ├── theme/
│   │   ├── app_colors.dart    # Color palette
│   │   └── app_theme.dart     # Light & dark themes
│   └── utils/
│       └── helpers.dart       # Utility functions
├── features/
│   └── home/
│       └── screens/
│           └── home_screen.dart
└── shared/
    └── widgets/               # Reusable widgets (add as needed)
test/
└── app_test.dart              # Widget tests
```
