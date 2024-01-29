# Dependencies

Prasso App relies on the following key dependencies:

## Flutter

- Flutter SDK 2.0 or higher
- Dart programming language

Flutter is used for building the cross-platform mobile app.

## Firebase

- Firebase project with Authentication and Cloud Firestore Database
- Firebase iOS and Android config files

Firebase provides backend services like authentication and database.

## Android / iOS

- Android SDK
- Xcode (for iOS development)

Required for building the native Android and iOS apps.

## Prasso API

- Custom API endpoint (e.g. https://myapp.prasso.io/api)
- Prasso admin site for configuring apps

The Prasso API provides app configuration data and handles backend logic.

## Other

- `pubspec.yaml` - manages Flutter dependencies
- Android Studio / VS Code - IDEs for development

See [Customizing.md](Customizing.md) for steps to customize Prasso App including:

- Modifying app name, identifier, assets
- Setting up Firebase services  
- Theming and branding 
- Configuring onboarding flow
- Building for app stores

## Summary 

Prasso App relies mainly on Flutter, Firebase, and the Prasso API. Customizing the app involves modifying identifiers, assets, Firebase config, API endpoints, and more based on your specific project needs.