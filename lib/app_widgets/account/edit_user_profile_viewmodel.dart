// Flutter imports:
// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:prasso_app/app_widgets/initial_profile/create_profile_input_model.dart';
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
    } else {
      photoviewmodel.setProfilePicUrl('');
    }
    profileImage = photoviewmodel.profilePicUrl.isNotEmpty
        ? CachedNetworkImageProvider(photoviewmodel.profilePicUrl)
        : null;
    pnToken = usr?.pnToken;
    coachUid = usr?.coachUid;
    unreadmessages = usr?.unreadmessages;
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
  bool enableMealReminders;
  List<RoleModel> roles;
  int personalTeamId;
  int teamCoachId;
  List<TeamMemberModel> teamMembers;
  String pnToken;
  String coachUid;
  bool unreadmessages;
  String currentWeight;
  String goalWeight;
  String maleFemale;
  String heightFtIn;
  String heightIn;
  String currentActivityLevel;
  String goalActivityLevel;
  String calories;
  String fat;
  String carbs;
  String protein;

  List<String> availableTimezones = <String>[];

  Future<void> _initData() async {
 
    try {
      availableTimezones = await FlutterNativeTimezone.getAvailableTimezones();
    } catch (e) {
      print('Could not get available timezones');
    }
    if (usr != null) {
      notifyListeners();
    }
  }

  void setMaleFemale(String value) {
    maleFemale = value;
    notifyListeners();
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

  void setFromProfileViewModel(CreateProfileInputModel vm, ApiUser apiUser) {
    email = apiUser.email;
    photoURL = photoviewmodel.profilePicUrl;
    displayName = '${vm.firstName} ${vm.lastName}';
    enableMealReminders = false;
    roles = apiUser.roles;
    personalTeamId = apiUser.personalTeamId;
    teamCoachId = apiUser.teamCoachId;
    teamMembers = apiUser.teamMembers;
    pnToken = apiUser.pnToken;
    coachUid = apiUser.coachUid;
    unreadmessages = apiUser.unreadmessages;
    currentWeight = vm.currentWeight;
    goalWeight = vm.goalWeight;
    maleFemale = vm.gender;
    heightFtIn = vm.heightFeet;
    heightIn = vm.heightInches;
    currentActivityLevel = vm.currentActivityLevel;
    goalActivityLevel = vm.goalActivityLevel;
    calories = vm.caloriesAllowed;
    fat = vm.fatAllowed;
    carbs = vm.carbsAllowed;
    protein = vm.proteinAllowed;
    notifyListeners();
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
      //the user has changed. allow it to be saved
      print('${usr.uid} ${uneditedUser.uid}');
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
