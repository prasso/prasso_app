# Customization / Prasso App Setup

## The following is a checklist for making this Prasso code into another app.

### Checklist: Steps to Convert/Run Prasso and Setup Apps for the App Stores

#### Resource Creation
1. Use [Looka](https://looka.com) to create a logo.
2. After creating the logo, use [Apetools](https://apetools.webprofusion.com/#/tools/imagegorilla) to create assets for the mobile and web apps.

#### Local Code Changes (Apple, Google, and Firebase)
1. **Modify App Name:**
   - In `pubspec.yaml`, change the name of the app:
     ```yaml
     name: your_prasso_app
     ```
   - In `android/app/build.gradle`, update the output file name to replace "Prasso_" with your app name.
   - In `android/app/src/main/res/values/strings.xml`, change the app name to match your app.
   - Perform a string replacement to update all occurrences of `package:prasso_app` with `package:your_prasso_app`.

2. **Update API Endpoints:**
   - Replace the API endpoints of [prasso.io](http://prasso.io) with your app's API endpoint. Example:
     ```dart
     // static const String prodUrl = 'https://prasso.io/api/';
     // Replace with:
     // static const String prodUrl = 'https://yourprassoapp.com/api/';
     ```

3. **Apple Identifier:**
   - Create the identifier at Apple and a new app that uses it. Create an APNS auth key if you don't already have one; you will use it at Firebase.
   - Search through the code and replace all instances of `com.faxt.prasso` with your new app identifier.

4. **Theme Conversion:**
   - Convert the theme to match your app's branding in `lib/utils/prasso_themedata.dart`.

#### Firestore Setup
1. **Create Firestore Project:**
   - Create the project at Firestore.

2. **Create App Instances:**
   - Create an Apple app and place the `GoogleService-info.plist` file into the `ios/Runner` folder of your app.
   - Create an Android app and place the `google-services.json` file into the `android/app` folder of your app.

3. **Create Cloud Firestore Database:**
   - Follow these steps to set up a Cloud Firestore database:
     - Go to the Firebase console and select your project.
     - Click on the "Firestore Database" tab on the left-hand side.
     - Click on the "Create database" button.
     - Choose a location for your database and select "Start in test mode".
     - Click on "Enable".
     - Click on the "Rules" tab.
     - Replace the existing rules with the following:
       ```firestore
       rules_version = '2';
       service cloud.firestore {
         match /databases/{database}/documents {
           match /{document=**} {
             allow read, write: if request.auth != null;
           }
         }
       }
       ```
     These rules allow read and write access to authenticated users only. Modify the rules to fit your specific use case.

4. **Enable Authentication with Email and Password:**
   - Go to the Firebase console and select your project.
   - Click on the "Authentication" tab on the left-hand side.
   - Click on the "Sign-in method" tab.
   - Enable the "Email/Password" sign-in method.

5. **Firestore Setup Continued:**
   - Create a web app to obtain the API key.
   - Copy the config settings to `index.html`.
   - Replace the Prasso Firebase config in `main.dart` with the new configuration.

6. **Firebase Cloud Messaging:**
   - Obtain the server key from the Cloud Messaging tab under project settings and add it to the `.env` file of the API.
   - In Firebase, add the APNS key to the Cloud Messaging tab of project settings for the iOS app.

#### Image Updates
1. **Update Images:**
   - Use Apetools to create updated images.
   - Download the Apetools image package, place the images into your app assets, and replace the existing Prasso images using Android Studio and Xcode's built-in resource editors to ensure index files are properly updated.
   - Alternatively, use a package like [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) to generate icons from a specific image.

#### Additional Modifications
1. **Update Welcome Screen:**
   - Modify the welcome screen in `lib/app_widgets/onboarding/intro_page.dart` to include content specific to your app's needs.

2. **Update App Name in iOS Files:**
   - Modify the name of the app (CFBundleName) in `ios/Flutter/AppFrameworkInfo.plist` and `ios/Runner/Info.plist`.

3. **Insert Firebase Configuration Data:**
   - Insert the correct Firebase configuration data into `lib/main.dart`.

4. **Update Android Platform Channel Specifics:**
   - Update the `androidPlatformChannelSpecifics` variable in `lib/main.dart`.

---

This documentation provides a comprehensive guide to converting and setting up your Prasso app from an existing Gogo Delivery setup. Follow these steps carefully to ensure a successful transition.