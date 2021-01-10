import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:pedantic/pedantic.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/constants/paths.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/providers/profile_pic_url_state.dart';
import 'package:prasso_app/utils/filename_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

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
    profileImage = CachedNetworkImageProvider(photoviewmodel.profilePicUrl);
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
    return AmazonS3Cognito.upload(filepath, Strings.awsBucket, _awsIdentityPool,
        destinationpath, _awsRegion, _awsRegion);
  }

  Future pickImage(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setUploadingOn();
      final _uid = usr?.uid;
      final filename = FilenameHelper.getFilenameFromPath(pickedFile.path);
      final destinationPath = '${Paths.profilePicturePath}$_uid/$filename';

      final uploadedpath = await uploadFile(pickedFile.path, destinationPath);
      print('uploaded: $uploadedpath');
      if (uploadedpath.contains('s3')) {
        photoURL = _cloudfrontWeb + destinationPath;
        saveUser(context);
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

  Future<bool> submit(BuildContext context) async {
    if (_validateAndSaveForm()) {
      try {
        saveUser(context);
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

  // ignore: avoid_void_async
  void saveUser(BuildContext context) async {
    final auth = useProvider(prassoApiService);
    final database = useProvider(databaseProvider);
    final uneditedUser = auth.currentUser;

    if (usr?.uid != uneditedUser.uid) {
      throw Exception('Program error');
    }
    ApiUser.fromLocatorUpdated(uneditedUser, email, photoURL, displayName);
    await auth.saveUserProfileData(context, usr, database);

    Navigator.of(context).pop();
  }
}
