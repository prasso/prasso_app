
# Prasso App

Prasso App is a mobile app framework that allows you to quickly build and customize your own mobile app using "low code" web pages.

## What it does

With Prasso App, you can:

- Assemble a mobile app from web pages built with various "low code" site builders like [Prasso.io](https://prasso.io), Bubble, Appgyver, etc.
- View your app design on both iOS and Android.   
- Make changes to the design and see them update in real-time on your device.
- Use it as a tool for rapidly prototyping app ideas before investing in full development.

## How it works

- Everything starts with a Prasso site, like prasso.io. This is configured in the Prasso admin tool.
- Sites have Teams, Users, and Apps associated with them.   
- When a user logs into the mobile app, it pulls their app configuration based on the Team they belong to.
- The app configuration consists of Tabs, which are just URLs to web pages.
- These web pages can be built using various "no code" site builders, allowing you to quickly throw together an app.
- As you make changes on the web, they are instantly reflected in the mobile app.

## Getting started

To use Prasso App:

1. Set up a Prasso site with the Prasso API enabled.
2. Create Teams, Users, and Apps on the site using the admin tool.   
3. Assign Users to Teams and configure App Tabs.
4. Download the Flutter project and follow the setup steps in section Installation
5. Build the app and install on your device.   
6. Log in with your User credentials and start viewing your no code app!

## Installation

Install Flutter
Clone Prasso_app
Run the following in the base folder
    flutter pub get
Change to ios directory
     cd ios
Run pod install
Bobbi@Bobbis-MacBook-Pro ios % pod install

    * when having issues with xcode compiling, try this
Quit xcode
 rm -Rf ios/Flutter/Flutter.framework
 rm -Rf ios/Pods
 rm -Rf ios/.symlinks
 flutter clean
 flutter run
Once the project successfully run on the simulator,  I will open the workspace and run the project using xcode

## Customizing

The project includes instructions on:

- Changing the app name, identifier, images, etc.
- Setting up Firebase authentication and database.  
- Modifying the theme colors and branding.
- Updating the onboarding flow for your app.

## Contributing

We welcome contributions to Prasso App! To contribute:

- Fork the repository
- Create a new branch for your changes
- Make your changes and test them thoroughly
- Submit a pull request describing your changes

See [Contributing.md](Contributing.md) for full details on how to contribute.

## Dependencies

Prasso App requires the following to run:

- Flutter SDK
- Android SDK/Xcode (for mobile development)
- Firebase project configured for authentication and database
- Prasso API endpoint

See [Dependencies.md](Dependencies.md) for full details on dependencies.

## Summary

Prasso App provides a unique way to leverage no code tools for quickly assembling and testing mobile app ideas. The project is open source (MIT license) so you can fully customize it to your needs. Check out the repo for more details.
