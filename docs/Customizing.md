# Customization / Prasso App setup		

 ## The following is a checklist for making this Prasso code into another app.		
 ### Checklist: Steps to Convert/Run Prasso and Setup Apps for the App Stores		

 1. Modify the name of the app in the code's `pubspec.yaml` file. Change `name: prasso_app` to `name: gogo_delivery` (replace with your app name).		
 2. Update the output file name in `android/app/build.gradle`. Replace "Prasso_" with your app name.		
 3. Change the app name in `android/app/src/main/res/values/strings.xml` to match your app.		
 4. Perform a string replace to update all occurrences of `package:prasso_app` with `package:yourapp` (e.g., replace with `package:gogo_delivery`).		
 5. Replace the API endpoints of [prasso.io](http://prasso.io) with your app's API endpoint. For example, replace:		
     ```dart		
     //static const String prodUrl = 'https://prasso.io/api/';		
     ```		
     with:		
     ```dart		
     //static const String prodUrl = 'https://gogodeliveryonline.com/api/';		
     ```		
		
 6. Create an identifier at Apple and a new app that uses it. If you don't have one already, create an APNS auth key to be used at Firebase.		
 7. Search through the code and replace all instances of `'com.faxt.prasso'` with your new app identifier.		
 8. Adjust the theme to match your app's branding. Modify `lib/utils/prasso_themedata.dart`.		
 9. Set up the project at Firestore.		
 10. Create an Apple app and place the `GoogleService-info.plist` file into the `ios/Runner` folder of Prasso.		
 11. Create an Android app and place the `google-services.json` file into the `android/app` folder of Prasso.		
 12. Create a Cloud Firestore database. Consider using the provided rules for security.		
     * To create a Cloud Firestore database in Firebase and use the provided rules for security, you can follow these steps:		
         - Go to the Firebase console and select your project.		
         - Click on the "Firestore Database" tab on the left-hand side. If you don't see it, look under Build.		
         - Click on the "Create database" button.		
         - Choose a location for your database and select "Start in test mode".		
         - Click on "Enable".		
         - Click on the "Rules" tab.		
         - Replace the existing rules with the following:		
           ```		
             rules_version = '2';		
             service cloud.firestore {		
               match /databases/{database}/documents {		
                 match /{document=**} {		
                   allow read, write: if request.auth != null;		
                 }		
               }		
             }		
           ```		
         These rules allow read and write access to authenticated users only. You can modify the rules to fit your specific use case.		
		
 Enable Authentication with Email and Password.		
 create a		
		
 14. For Firestore setup continued:		
     - Create a web app to obtain the API key.		
     - Copy the config settings to `index.html`.		
     - Replace the Prasso Firebase config in `main.dart` with the new configuration.		
 15. Obtain the server key from the Cloud Messaging tab under project settings and add it to the `.env` file of the API.		
 16. In Firebase, add the APNS key to the Cloud Messaging tab of project settings for the iOS app.		
 17. In Firebase, go to Authentication and enable email and password authentication.		
     * To enable authentication with email and password in Firebase, you can follow these steps:		
         - Go to the Firebase console and select your project.		
         - Click on the "Authentication" tab on the left-hand side. If you don't see it initially, look under Engage tab.		
         - Click on the "Sign-in method" tab.		
         - Enable the "Email/Password" sign-in method.		
     That's it! Now your users can sign in to your Firebase app using their email and password.		
 18. Update the images for both Google and Firebase. Use apetools (https://apetools.webprofusion.com/#/tools/imagegorilla) and pass an existing PNG to update the images.		
 19. Once you have downloaded the apetools image package, place the images into your app's assets folder and replace the existing Prasso images. Use Android Studio and XCode's built-in resource editors for this step to ensure the index files are correctly updated.		
 20. Modify the welcome screen in `lib/app_widgets/onboarding/intro_page.dart` to include content specific to your app's needs.		
 21. Modify the name of the app (CFBundleName) in ios/Flutter/AppFrameworkInfo.plist, ios/Runner/Info.plist.		
 22. Insert the correct Firebase configuration data into lib/main.dart		
 23. Update the androidPlatformChannelSpecifics variable in lib/main.dart