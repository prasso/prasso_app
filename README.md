# Prasso App - no-code mobile app development

## Project Timeline
#### originally forked from  Demo for Flutter & Firebase Realtime Apps

This project, Prasso App, started out as a fork of the **reference architecture demo** that can be used as a **starting point** for apps using Flutter & Firebase. The code is modified to support running web apps which can be built from various no-code sites around the web.

*Also see the marvelous [codewithandrea_flutter_packages repo](https://github.com/bizz84/codewithandrea_flutter_packages), which contains the most reusable parts of this project as packages.*

Then the code was migrated into a format closer to what you would see in MVVM architecture. And then Riverpod Hooks has been added.
Now we are cooking with gas!

## Setup instructions such as they are:

## AWS
### Image storage
#### this app uses AWS Cognito and S3 to provide image upload and storage
The plugin used to accomplish this, amazon_s3_cognito, has been forked from https://pub.dev/packages/amazon_s3_cognito
In the fork, available here: https://github.com/prasso/amazon_s3_cognito, the ios uploads are now using AWSTransferUtility. In the original code AWSTransferManager was used. But it would not work in XCode 12, uploads did not complete. I also had some issues getting the region in from my configuration since Android used a different enum value than ios.

### env file
This app uses a configuration similar to what you would see in a web app. The configuration file is excluded from source control since it contains information specific to private installations.
#### Reference info
The configuration reference in pubspec.yaml is
flutter_config
#### env file locations
Two .env files are required, and a pointer to them. These are detailed at the pub.dev location for flutter_config. https://pub.dev/packages/flutter_config
#### example env contents
API_URL=YOUR_API_URL
AWS_IDENTITY_POOL='YOUR_COGNITO_IDENTITY_POOL_ID'
AWS_REGION='YOUR_AWS_REGION'
CLOUDFRONT_WEB='YOUR_IMAGE_SERVING_URL'

For more info, I'm happy to help if I can. Shoot me an email or ping me on Twitter if you need info. Contact info is on the Prasso main page, https://prasso.io

## [License: MIT](LICENSE.md)
