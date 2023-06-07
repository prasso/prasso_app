# Prasso App - A Mobile App Template.

## Prasso is a mobile app platform that allows you to rapidly view your design, make changes, and view the updated screen in both iOS and Android.

An app framework for your no-code web site. Or a springboard for your Flutter mobile app. 
> Prasso allows you to see how controls would feel in a real-world setting.

> View the same control in iOS and then in Android.

> Prasso is a mobile application that allows you to customize your app as you are working with it in your hand. 


## Prasso Concept
1. everything is based on a site.
    
    a site is determined by it’s url
    
2. Apps have an association to a site.
    1. an app is configured with tabs 
        1. tabs point to views by url or html source that is stored at Prasso.io
    2. an app is identified at the backend by the host of the request
        1. the host is associated with the site, the site is associated with the app
    3. when a request is received the host is used to look up the tab configuration that will be loaded by the app
    4. the tab configuration is sent back to the app in json format. 
    5. the app receives the json, parses the data into tabs and shows the tabs.
    6. the user is able to interact with the tabs as they have been configured
3. changing the tab configuration of an app is done through the admin panel
    1. users are associated with sites based on the team they are a member of
    2. teams are assigned to sites
    3. users have roles. admin and user
    4. admins can setup apps through the admin panel based on what sites they have been associated with through their team
4. teams are the basic unit in a social group. teams have coaches and members
### relationships
* team
  * users
     * roles
  * sites
    * apps
      * tabs
    * pages

1. *Site* Url is a site. The software is configured to use CMS pages based on the site configuration. Sites are configured in the Admin.
2. *Site* Sites have Teams
3. *Site* Sites have site pages. These can be created and maintained using a visual editor, that is GrapesJs
4. *Team* Teams have users. Users belong to teams. When a user registers, a private team is assigned. Users can also be included in other teams.
5. *Team* Teams have sites. Sites have apps. When a user who is a member of a team logs into the Prasso app, the default-designated app will be loaded for use.
6. *Apps* Apps have tabs. App tabs are web page urls. Custom header information can be sent to the url with the request to enable application specific sessions.
7. *Users* Users have roles.
    * how roles work: Allow anyone with a login to log into the app. No role required
      * site-admins can log into the sites they have association with
      * super-admins can access any site admin area
        // INSERT INTO `yourdatabase`.`roles` (`role_name`) VALUES ('super-admin');
        // INSERT INTO `yourdatabase`.`roles` (`role_name`) VALUES ('site-admin');


## No Code Apps
Prasso unites multiple web tools into one mobile app.  For example, a flarum.cloud forum could be a tab,  a YouTube channel could be a tab, a calendar scheduler could be a tab. Together the tabs assemble into a personalized app. 

Prasso is also a rapid prototyping tool. Assemble your app using no-code pages which have been built to prove your concept. Then release it to prove the concept works. 

When a user first registers, the mobile app has tabs that will direct the user to setup their app. The api web site has entry forms for users to assign web pages to the tabs. 
This allows for prototypes to be ran on mobile immediately, when the web page has been setup through some other no-code solutions.



# Overview of functionality


A Prasso site is both business information site and Prasso api site. The api serves the Prasso apps. Apps can be assembled/ built at a Prasso site using the admin tools. And then when a user with an assigned team and app logs into the mobile app, the assembled presentation becomes their personalized mobile app.

## How the mobile app works as a "No-Code" user-built mobile app

Prasso apps consist of User registration and login based on Firebase authentication
And a framework that creates an app dynamically based on the server configuration received for a logged in user.

'Prasso by faxt (Fast Api eXtraction Technologies)'
![](https://i.imgur.com/K69SPIt.png)

    
### How the app is built using "No-Code"
1. The hierarchy is Prasso - Site - Site-Pages. Prasso - Teams - Users and Apps. Apps - Tabs
![](https://i.imgur.com/zjpAojl.png)

3. Prasso - SITES are based on a domain. The software is configured to use CMS pages based on the site configuration. Sites are configured in the Admin. When a user enters the URL of a Prasso site into their browser, the Prasso software will show that site as configured in the admin tool.
4. SITES have site pages. These can be created and maintained using a built in visual editor, that is based on GrapesJs opensource project.

    Sites are the landing page of the App home web site.  Example Prasso sites: https://prasso.io, https://optamize.app, https://gogodeliveryonline.com,   https://lileyscapes.prasso.io, https://mercyfullfarm.com 
    

6. Prasso - USERS belong to TEAMS. When a user registers, a private team is assigned. Users can also be included in other teams.
7. TEAMS have APPS. When a user who is a member of a team logs into the Prasso app, the default-designated app will be loaded for use. 
9. APPS have TABS. USERS "build" their apps in the Prasso Admin tool. APP TABS are web page urls. Custom header information can be sent to the url with the request to enable application specific sessions.

## Prasso setup
### Setup instructions such as they are:

### Firebase
Firebase is required for the Prasso app, since users are authenticated at Firebase, but the app data is stored at the API site. 
  Add a Firebase project. Enable Authentication with Email and Password.  Enable Cloud Firestore and create a database. 
- If you don't have a Firebase project configured, create one for your app. 
- Download the files for adding to your iOS and Android projects.
- Enable Authentication for email/password
- Create a Cloud Firestore database.

Three tiers of user roles exist
Super-Admin , Site Admin, and App User

## Admin Site (prasso_api)
### Sites
How sites and sites pages work (prasso_api)
1. At least one site must be configured in the site table. (example: prasso.io ) When the site loads, the host is checked to see if it's url/domain is recorded in the site table.
2. if the site is recorded, the site object from the table is kept available in the app session for use. The site object is the UI configuration of the site.
3. site pages reference the site table, so if a site has pages they can be used in the display as links. These links look like https://prasso.io/page/Welcome-OLDPRASSO
4. Code that runs when a site is loaded uses the current domain to compare with the stored site url to look up the landing page contents. if an entry is found in the site pages table for the site and with label of Welcome, that will be what is shown to the web visitor on the home page.

### Visual Editing (CMS) (the api side code prasso_api)
This code is integrating the GrapesJS editor (https://grapesjs.com) 
When you edit your site you will be able to use the included components to assemble your pages


## AWS
### Image storage
#### 

For more info, I'm happy to help if I can. Shoot me an email or ping me on Twitter if you need info. Contact info is on the Prasso main page, https://prasso.io

## [License: MIT](LICENSE.md)

## License

Prasso is licensed under the [MIT license](https://opensource.org/licenses/MIT).

The Laravel framework (api side) is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).



# The following is a checklist for making this Prasso code into another app.
# Checklist: Steps to Convert Prasso

### Steps to Setup Apps for the App Stores

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
13. For Firestore setup continued:
    - Create a web app to obtain the API key.
    - Copy the config settings to `index.html`.
    - Replace the Prasso Firebase config in `main.dart` with the new configuration.
14. Obtain the server key from the Cloud Messaging tab under project settings and add it to the `.env` file of the API.
15. In Firebase, add the APNS key to the Cloud Messaging tab of project settings for the iOS app.
16. In Firebase, go to Authentication and enable email and password authentication.
17. Update the images for both Google and Firebase. Use apetools (https://apetools.webprofusion.com/#/tools/imagegorilla) and pass an existing PNG to update the images.
18. Once you have downloaded the apetools image package, place the images into your app's assets folder and replace the existing Prasso images. Use Android Studio and XCode's built-in resource editors for this step to ensure the index files are correctly updated.
19. Modify the welcome screen in `lib/app_widgets/onboarding/intro_page.dart` to include content specific to your app's needs.



## Historical Information
Project Timeline started in 2020
#### originally forked from  Demo for Flutter & Firebase Realtime Apps

This project, Prasso App, started out as a fork of the **reference architecture demo** that can be used as a **starting point** for apps using Flutter & Firebase. The code is modified to support running web apps which can be built from various no-code sites around the web.

*Also see the marvelous [codewithandrea_flutter_packages repo](https://github.com/bizz84/codewithandrea_flutter_packages), which contains the most reusable parts of this project as packages.*

Then the code was migrated into a format closer to what you would see in MVVM architecture. And then Riverpod Hooks has been added.


