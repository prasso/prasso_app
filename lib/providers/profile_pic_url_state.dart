import 'package:flutter/material.dart';

String noDpUrl = 'https://d2bj0u1jhmvqgo.cloudfront.net/default/user.png';

class ProfilePicUrlState with ChangeNotifier {
  String _profilePicUrl = noDpUrl;

  String get profilePicUrl => _profilePicUrl;

  void setProfilePicUrl(String newUrl) {
    _profilePicUrl = newUrl;
    notifyListeners();
  }
}
