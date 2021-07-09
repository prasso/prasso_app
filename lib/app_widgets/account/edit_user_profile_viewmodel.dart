import 'dart:developer' as developer;
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/constants/paths.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/api_user.dart';
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
    email = usr.email;
    photoURL = usr.photoURL;
    displayName = usr.displayName;
    if (photoURL != null && photoURL.isNotEmpty) {
      photoviewmodel.setProfilePicUrl(photoURL);
    }
    profileImage = photoviewmodel.profilePicUrl.isNotEmpty
        ? CachedNetworkImageProvider(photoviewmodel.profilePicUrl)
        : null;
  }

  final ApiUser usr;
  final ProfilePicUrlState photoviewmodel;

  final formKey = GlobalKey<FormState>();
  final String _awsRegion = FlutterConfig.get(Strings.awsRegion).toString();
  final String _awsIdentityPool =
      FlutterConfig.get(Strings.awsIdentityPool).toString();
  final String _cloudfrontWeb =
      FlutterConfig.get(Strings.cloudFrontID).toString();
  final picker = ImagePicker();
  ImageProvider profileImage;
  bool uploadingDp = false;

  String email;
  String photoURL;
  String displayName;

  void setUploadingOn() {
    uploadingDp = true;
    notifyListeners();
  }

  void setUploadingOff() {
    uploadingDp = false;
    notifyListeners();
  }

  Future<String> uploadFile(String filepath, String destinationpath) async {
    print('upload info ${Strings.awsBucket} $destinationpath');
    print('_awsIdentityPool: $_awsIdentityPool');
    try {
      return AmazonS3Cognito.upload(filepath, Strings.awsBucket,
          _awsIdentityPool, destinationpath, _awsRegion, _awsRegion);
    } catch (e) {
      developer.log(
        'email password log data',
        name: 'prasso.app.email_password_sign_in',
        error: e.toString(),
      );
    }
    return 'an error occurred';
  }

  Future pickImage(BuildContext context, PrassoApiRepository auth,
      FirestoreDatabase database) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setUploadingOn();
      final _uid = usr?.uid;
      final filename = FilenameHelper.getFilenameFromPath(pickedFile.path);
      final destinationPath = '${Paths.profilePicturePath}$_uid/$filename';
      print('destinationPath: $destinationPath');
      final uploadedpath = await uploadFile(pickedFile.path, destinationPath);
      print('uploaded: $uploadedpath');
      if (uploadedpath.contains('s3')) {
        photoURL = _cloudfrontWeb + destinationPath;
        await saveUser(context, auth, database);
      }
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
      FirestoreDatabase database) async {
    final uneditedUser = auth.currentUser;

    if (usr?.uid != uneditedUser.uid) {
      throw Exception('Program error');
    }
    final ApiUser newusr = ApiUser.fromLocatorUpdated(uneditedUser, this);
    await auth.saveUserProfileData(context, newusr, database);
    notifyListeners();
    Navigator.of(context).pop();
    return true;
  }
}
