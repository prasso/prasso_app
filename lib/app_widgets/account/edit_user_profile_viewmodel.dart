import 'dart:developer' as developer;
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/models/role_model.dart';
import 'package:prasso_app/models/team_member_model.dart';
import 'package:prasso_app/providers/profile_pic_url_state.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';
import 'package:prasso_app/utils/filename_helper.dart';

final editUserProfileViewModel = ChangeNotifierProvider((ref) =>
    EditUserProfileViewModel(
        usr: ref.read(prassoApiService).currentUser,
        photoviewmodel: ref.read(profilePicUrlState)));

class EditUserProfileViewModel extends ChangeNotifier {
  EditUserProfileViewModel(
      {@required this.usr, @required this.photoviewmodel}) {
    //(usr == null) happens on new app installs and failed registrations
    email = usr?.email;
    photoURL = usr?.photoURL;
    displayName = usr?.displayName;
    if (photoURL != null && photoURL.isNotEmpty) {
      photoviewmodel.setProfilePicUrl(photoURL);
    }
    profileImage = photoviewmodel.profilePicUrl.isNotEmpty
        ? CachedNetworkImageProvider(photoviewmodel.profilePicUrl)
        : null;
    pnToken = usr?.pnToken;
    appName = usr?.appName;
    _initData();
  }

  final ApiUser usr;
  final ProfilePicUrlState photoviewmodel;

  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  ImageProvider profileImage;
  bool uploadingDp = false;

  String email;
  String photoURL;
  String displayName;
  List<RoleModel> roles;
  int personalTeamId;
  int teamCoachId;
  List<TeamMemberModel> teamMembers;
  String pnToken;
  String appName;

  List<String> availableTimezones = <String>[];

  Future<void> _initData() async {
    if (usr != null) {
      notifyListeners();
    }
  }

  void setUploadingOn() {
    uploadingDp = true;
    notifyListeners();
  }

  void setUploadingOff() {
    uploadingDp = false;
    notifyListeners();
  }

  Future pickImage(BuildContext context, PrassoApiRepository auth,
      FirestoreDatabase database) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setUploadingOn();
      final filename = FilenameHelper.getFilenameFromPath(pickedFile.path);

      final uploadedpath = await auth.uploadFile(pickedFile.path, filename);
      print('uploaded: $uploadedpath');

      setUploadingOff();
    }
  }

  bool _validateAndSaveForm() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<bool> submit(BuildContext context, PrassoApiRepository auth,
      FirestoreDatabase database) async {
    if (_validateAndSaveForm()) {
      try {
        await saveUser(context, auth, database);
      } catch (e) {
        unawaited(showExceptionAlertDialog(
          context: context,
          title: 'Operation failed',
          exception: e,
        ));
      }
    }
    return true;
  }

  Future<bool> saveUser(BuildContext context, PrassoApiRepository auth,
      FirestoreDatabase database,
      {bool canPop = true}) async {
    final uneditedUser = auth.currentUser;

    if (usr?.uid != uneditedUser.uid) {
      throw Exception('Program error');
    }
    final ApiUser newusr = ApiUser.fromLocatorUpdated(uneditedUser, this);
    await auth.saveUserProfileData(context, newusr, database);
    notifyListeners();

    //don't pop unless we have something to pop
    if (canPop) {
      Navigator.of(context).pop();
    }
    return true;
  }
}
