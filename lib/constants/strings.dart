class Strings {
  // Generic strings
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String teamId = '1';

  //env Flutter Config strings
  static const String apiUrl = 'API_URL';
  static const String appId = 'appId';
  static const String prodUrl = 'https://api.prasso.io/api/';
  //static const String prodUrl = 'http://localhost:8000/api/';
  static const String awsIdentityPool = 'AWS_IDENTITY_POOL';
  static const String awsRegion = 'AWS_REGION';
  static const String cloudFrontID = 'CLOUDFRONT_WEB';
  static const String awsBucket = 'prassouploads';

  // api route definitions
  static const String updateProfile = 'user/profile-information';
  static const String signinUrl = 'record_login';
  static const String logoutUrl = 'logout';
  static const String saveApp = 'save_app';

  // Logout
  static const String logout = 'Logout';
  static const String reload = 'Reload';
  static const String logoutAreYouSure =
      'Are you sure that you want to logout?';
  static const String logoutFailed = 'Logout failed';
  static const String refreshFailed = 'Refresh failed';

  // Sign In Page
  static const String signIn = 'Sign in';
  static const String signInWithEmailPassword =
      'Sign in with email and password';
  static const String goAnonymous = 'Go anonymous';
  static const String or = 'or';
  static const String signInFailed = 'Sign in failed';

  // Home page
  static const String homePage = 'Home Page';

  // Jobs page
  static const String apps = 'Apps';

  // Dynamic page
  static const String dynamicPageTitle = 'Run';

  // Account page
  static const String account = 'Account';
  static const String accountPage = 'Account Page';
  static const String appsTabTitle = 'Run';
  static const sessionProfilePictureUrl = 'sessionProfilePictureUrl';

  // More page
  static const String more = 'More';
  static const String morePageUrl = 'More()';
  static const String morePage = 'More Page';

  static const String appName = 'Prasso App';
  static const String accountPageUrl = 'AccountPage()';
}
