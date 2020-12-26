class FirestorePath {
  static String app(String uid, String appId) => 'users/$uid/apps/$appId';
  static String apps(String uid) => 'users/$uid/apps';
  static String users(String uid) => 'users/$uid';
}
