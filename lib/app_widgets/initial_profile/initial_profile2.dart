// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Package imports:
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:prasso_app/app_widgets/initial_profile/create_profile_input_model.dart';
import 'package:prasso_app/app_widgets/initial_profile/profile_model.dart';
import 'package:prasso_app/app_widgets/initial_profile/profile_view_model.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog progressDialog;

DateTime selectedDate = DateTime(2000, 1, 1);
String fromClass;

class InitialProfile extends StatefulWidget {
  InitialProfile(String className) {
    fromClass = className;
  }

  @override
  State<StatefulWidget> createState() => InitialProfilePageState();
}

class InitialProfilePageState extends State<InitialProfile> {
  InitialProfilePageState() {
    if (fromClass == Strings.fromClassEditUserProfile) {
      _isApiRequired = true;
    } else {
      _isApiRequired = false;
    }
  }

  static final TextEditingController _firsNameTextController =
      TextEditingController();
  static final TextEditingController _lastNameTextController =
      TextEditingController();

  bool _isApiRequired = false;
  bool _isApiFinished = false;
  final ProfileModel _profileModel = ProfileModel();

  @override
  void initState() {
    super.initState();
    if (_isApiRequired) {
      callFetchProfileData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _setViews(context);
  }

  // Get Profile API
  Future<bool> callFetchProfileData() async {
    setState(() {
      _isApiFinished = true;
    });
    return true;
  }

  Widget _setViews(BuildContext context) {
    if (_isApiRequired) {
      if (_isApiFinished) {
        if (_profileModel != null) {
          if (_profileModel.statusCode == 200 &&
              _profileModel.message == null) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: _buildProfileData(context, _profileModel),
            );
          } else if (_profileModel.statusCode == 401 ||
              _profileModel.statusCode == 404) {
            showErrorToast('Authorization has been denied for this request');
            return Container();
          } else if (_profileModel.message != null &&
              _profileModel.message.isNotEmpty) {
            return Text(_profileModel.message);
          } else {
            return const Text('Something went wrong!!');
          }
        } else {
          return const Text('No data!!!');
        }
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    } else {
      return _buildProfileData(context, _profileModel);
    }
  }

  void setInitialValues(ProfileModel profileModel) {
    if (profileModel != null && profileModel.firstName != null) {
      _firsNameTextController.text = profileModel.firstName;
      _lastNameTextController.text = profileModel.lastName;
    }
  }

  // Save Profile Button
  Widget showSaveProfileButton(BuildContext context) {
    String buttonText = 'Save Profile';
    if (fromClass == Strings.fromClassEditUserProfile) {
      buttonText = 'Save Profile';
    } else {
      buttonText = 'Save and Get Started';
      //return const Padding(padding: EdgeInsets.all(0.0));
    }
    return Column(children: [
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: PrassoColors.brightOrange,
            onPrimary: Colors.white,
            shadowColor: PrassoColors.olive,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0)),
            minimumSize: const Size(100, 40), //////// HERE
          ),
          onPressed: () {
            validateFieldAndSaveProfile(context);
          },
          child: Text(buttonText),
        ),
      )
    ]);
  }

  // Validate fields for saving
  void validateFieldAndSaveProfile(BuildContext context) {
    final auth = context.read(prassoApiService);
    final user = auth.currentUser;

    final CreateProfileInputModel createProfileInputModel =
        CreateProfileInputModel();
    createProfileInputModel.setReasonableDefaults(user);

    if (_firsNameTextController.text.isNotEmpty) {
      createProfileInputModel.firstName = _firsNameTextController.text;
    } else {
      showErrorToast('First name is required.');
      return;
    }

    if (_lastNameTextController.text.isNotEmpty) {
      createProfileInputModel.lastName = _lastNameTextController.text;
    }

    progressDialog.show();
    createProfileApi(context, createProfileInputModel);
  }

  // Save Profile API
  Future<void> createProfileApi(BuildContext context,
      CreateProfileInputModel createProfileInputModel) async {
    final _profileViewModel = context.read(profileViewModelProvider);
    final result = await _profileViewModel.createProfileAPI(
        createProfileInputModel, context);
    print(result);
    await progressDialog.hide();
    if (result != null) {
      showSuccessToast('Saved successfully');
      await PrassoApiRepository.instance.cupertinoHomeScaffoldVM
          .goToDashboard(context);
    } else {
      showErrorToast('The data was not saved, an error occurred');
    }
  }

  // Clear All Input fields
  void clearAllFields() {
    _firsNameTextController.clear();
    _lastNameTextController.clear();
  }

  Widget _customTextFieldForm(String textLabel, String hintText,
      TextEditingController inputController, String inputType) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            child: Text(
              textLabel,
              style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          ),
          TextField(
            controller: inputController,
            keyboardType: getInputKeyboardType(inputType),
            style: getInputTextStyle(),
            decoration: getTextInputDecorator(hintText),
          )
        ]);
  }

// Get TextInput Keyboard type
  TextInputType getInputKeyboardType(String inputType) {
    if (inputType == Strings.inputTypeNumber) {
      return TextInputType.number;
    } else {
      return TextInputType.text;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Get Text Input TextStyle
  TextStyle getInputTextStyle() {
    return const TextStyle(
        fontSize: 12.0, color: Colors.black, fontFamily: 'Roboto');
  }

  Widget dateOfBirth() {
    return Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Date of birth',
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Text("${selectedDate.toLocal()}".split(' ')[0]),
                //SizedBox(height: 20.0,),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  child: Text('${selectedDate.toLocal()}'.split(' ')[0]),
                )
              ],
            ),
          ],
        ));
  }

  // Get TextInput Decorator
  InputDecoration getTextInputDecorator(String hintText) {
    return InputDecoration(
      isDense: true,
      fillColor: Colors.white,
      filled: true,
      // important line
      contentPadding: const EdgeInsets.fromLTRB(5, 20, 20, 5),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      hintText: hintText,
    );
  }

  Widget _buildProfileData(BuildContext context, ProfileModel profileModel) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'Please wait..');
    if (fromClass == Strings.fromClassEditUserProfile) {
      setInitialValues(profileModel);
    }

    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
            Container(
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(3),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const PickImageLayout(),
                    _customTextFieldForm('FIRST NAME', 'First Name',
                        _firsNameTextController, Strings.inputTypeText),
                    _customTextFieldForm('LAST NAME', 'Last Name',
                        _lastNameTextController, Strings.inputTypeText),
                    showSaveProfileButton(context),
                    const SizedBox(height: 64)
                  ]),
            )
          ],
        ));
  }
}

// ImagePicker Class
class PickImageLayout extends StatefulWidget {
  const PickImageLayout() : super();

  @override
  PickImageState createState() => PickImageState();
}

class PickImageState extends State<PickImageLayout> {
  File _imageFile;

  Future getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(image.path);
    });
  }

  Future getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_imageFile == null)
            const CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage('media/avatar.png'),
            )
          else
            ClipOval(
                child: Image.file(_imageFile,
                    width: 80, height: 80, fit: BoxFit.cover)),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 5.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            minimumSize: const Size(100, 40), //////// HERE
                          ),
                          onPressed: () {
                            getImageFromGallery();
                          },
                          child: const Text('SELECT A NEW PHOTO'),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 0.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            minimumSize: const Size(100, 40), //////// HERE
                          ),
                          onPressed: () {
                            setState(() {
                              _imageFile = null;
                            });
                          },
                          child: const Text('REMOVE PHOTO'),
                        ))
                  ]))
        ]);
  }
}
