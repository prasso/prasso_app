# Prasso App - A Rapid Prototyping Tool.

## Prasso is a mobile app platform that allows you to rapidly view your design, make changes, and view the updated screen in both iOS and Android.

An app framework for your no-code web site. Or a springboard for your Flutter mobile app. 
> Prasso allows you to see how controls would feel in a real-world setting.

> View the same control in iOS and then in Android.

> Prasso is a mobile application that allows you to customize your app as you are working with it in your hand. 

## Project Timeline
#### originally forked from  Demo for Flutter & Firebase Realtime Apps

This project, Prasso App, started out as a fork of the **reference architecture demo** that can be used as a **starting point** for apps using Flutter & Firebase. The code is modified to support running web apps which can be built from various no-code sites around the web.

*Also see the marvelous [codewithandrea_flutter_packages repo](https://github.com/bizz84/codewithandrea_flutter_packages), which contains the most reusable parts of this project as packages.*

Then the code was migrated into a format closer to what you would see in MVVM architecture. And then Riverpod Hooks has been added.
Now we are cooking with gas!

## Setup instructions such as they are:

## Firebase
  Add a Firebase project. Enable Authentication with Email and Password.  Enable Cloud Firestore and create a database. 
## AWS
### Image storage
#### 

### env file
This app uses a configuration similar to what you would see in a web app. The configuration file is excluded from source control since it contains information specific to private installations.
#### Reference info
The configuration reference in pubspec.yaml is
flutter_config
#### env file locations
Two .env files are required, and a pointer to them. These are detailed at the pub.dev location for flutter_config. https://pub.dev/packages/flutter_config
#### example env contents
API_URL=YOUR_API_URL
AWS_REGION='YOUR_AWS_REGION'
CLOUDFRONT_WEB='YOUR_IMAGE_SERVING_URL'

For more info, I'm happy to help if I can. Shoot me an email or ping me on Twitter if you need info. Contact info is on the Prasso main page, https://prasso.io

## [License: MIT](LICENSE.md)
