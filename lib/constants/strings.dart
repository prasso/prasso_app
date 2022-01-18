enum WidgetType { navigateToJournal, setMealType, none }

class Strings {
  // Generic strings
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String done = 'Done';
  static const String teamId = '1';

  //env Flutter Config strings
  static const String apiUrl = 'API_URL';
  static const String appId = 'appId';

  static const String prodUrl = 'https://invenbin.com/api/';
  //static const String prodUrl = 'https://prasso.io/api/';
  //static const String prodUrl = 'http://localhost:8000/api/';

  static const String awsIdentityPool = 'AWS_IDENTITY_POOL';
  static const String awsRegion = 'AWS_REGION';
  static const String cloudFrontID = 'CLOUDFRONT_WEB';
  static const String awsBucket = 'barimorphosisuploads';

  // api route definitions
  static const String updateProfile = 'user/profile-information';
  static const String signinUrl = 'record_login';
  static const String logoutUrl = 'logout';
  static const String saveApp = 'save_app';
  static const String save = 'Save';
  static const String shortEditProfileText = 'Update Your Info';
  static const String editProfileText = 'Edit Profile';
  static const String subscribePageUrl = 'subscribepage';

  // Logout
  static const String logout = 'Logout';
  static const String reload = 'Reload';
  static const String logoutAreYouSure =
      'Are you sure that you want to logout?';
  static const String logoutFailed = 'Logout failed';
  static const String refreshFailed = 'Refresh failed';

  // Sign In Page

  static const String signIn = 'Sign in';
  static const String signInWithEmailPassword = 'Log In';
  static const String signUpWithEmailPassword = 'Sign Up';
  static const String goAnonymous = 'Go anonymous';
  static const String or = 'or';
  static const String signInFailed = 'Sign in failed';

  // Subscription Page
  static const String qonversionId = 'aia0X4D0r_I3bDzjBYHubVMwZsW2Z_61';

  // Home page
  static const String homePage = 'Home Page';
  static const String introPages = 'Welcome and Info';

  // Jobs page
  static const String apps = 'Apps';

  // Dynamic page
  static const String dynamicPageTitle = 'Run';

  // Account page
  static const String account = 'Account';
  static const String accountPage = 'Account Page';
  static const String appsTabTitle = 'Run';
  static const sessionProfilePictureUrl = 'sessionProfilePictureUrl';

  // Recipe page
  static const String editButtonText = 'Edit';

  // More page
  static const String more = 'More';
  static const String morePageUrl = 'More()';
  static const String morePage = 'More Page';

  static const String appName = 'Prasso';
  static const String accountPageUrl = 'AccountPage()';

  // Profile page
  static const String scheduleRemindersTitle = 'Enable Meal Reminders';
  static const String mealReminderTimesLabel = 'Meal Reminder Times';
  static const String newuser = 'New User';
  static const String edituser = 'Edit User';
  static const String emailLabel = 'Email';
  static const String emailCantbeEmpty = 'Email can\'t be empty';
  static const String photoUrl = 'Photo Url';
  static const String nameLabel = 'Name';
  static const String appNameLabel = 'App Name';
  // InputTypes
  static const String inputTypeText = 'text';
  static const String inputTypeMultiline = 'multiline';
  static const String inputTypeNumber = 'number';

  // From Class
  static const String fromClassIntroPage = 'IntroPage';
  static const String fromClassEditUserProfile = 'EditUserProfile';

  static const int searchModeGeneric = 100;
  static const int searchModeBranded = 200;
  static const int searchModeCustom = 300;
  static const String noResults = 'No results';

  static const String emergencyDefaultTabs = '';
}
