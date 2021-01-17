// Flutter imports:
import 'package:flutter/material.dart';

String noDpUrl = 'https://d2bj0u1jhmvqgo.cloudfront.net/default/user.png';

class ProfilePicUrlState extends ChangeNotifier {
  String _profilePicUrl = noDpUrl;

  String get profilePicUrl => _profilePicUrl;

  void setProfilePicUrl(String newUrl) {
    if (newUrl.isEmpty) {
      _profilePicUrl = noDpUrl;
    } else {
      _profilePicUrl = newUrl;
    }
    notifyListeners();
  }
}
