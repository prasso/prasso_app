import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prasso_app/constants/constants.dart';
import 'package:prasso_app/constants/paths.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/providers/profile_pic_url_state.dart';
import 'package:prasso_app/services/prasso_api_service.dart';
import 'package:prasso_app/utils/filename_helper.dart';
import 'package:provider/provider.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:pedantic/pedantic.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key key, this.usr}) : super(key: key);
  final ApiUser usr;

  static Future<void> show(BuildContext context, {ApiUser usr}) async {
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
      builder: (context) => EditUserProfile(usr: usr),
      fullscreenDialog: true,
    ));
  }

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ApiUser>('usr', usr));
  }
}

class _EditUserProfileState extends State<EditUserProfile> {
  final _formKey = GlobalKey<FormState>();
  final String _awsRegion = FlutterConfig.get(Strings.awsRegion).toString();
  final String _awsIdentityPool =
      FlutterConfig.get(Strings.awsIdentityPool).toString();
  final String _cloudfrontWeb =
      FlutterConfig.get(Strings.cloudFrontID).toString();
  final picker = ImagePicker();
  ImageProvider profileImage;
  bool uploadingDp = false;

  String _email;
  String _photoURL;
  String _displayName;

  @override
  void initState() {
    super.initState();
    if (widget.usr != null) {
      _email = widget.usr.email;
      _photoURL = widget.usr.photoURL;
      _displayName = widget.usr.displayName;
    }
  }

  Future<String> uploadFile(String filepath, String destinationpath) async {
    return AmazonS3Cognito.upload(filepath, Strings.awsBucket, _awsIdentityPool,
        destinationpath, _awsRegion, _awsRegion);
  }

  Future pickImage(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        uploadingDp = true;
      });
      final _uid = widget.usr?.uid ?? documentIdFromCurrentDate();
      final filename = FilenameHelper.getFilenameFromPath(pickedFile.path);
      final destinationPath = '${Paths.profilePicturePath}$_uid/$filename';

      final uploadedpath = await uploadFile(pickedFile.path, destinationPath);
      print('uploaded: $uploadedpath');
      if (uploadedpath.contains('s3')) {
        _photoURL = _cloudfrontWeb + destinationPath;
        saveUser();
      }
      setState(() {
        uploadingDp = false;
      });
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<bool> _submit(BuildContext context) async {
    if (_validateAndSaveForm()) {
      try {
        saveUser();
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
  void saveUser() async {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final PrassoApiService auth =
        Provider.of<PrassoApiService>(context, listen: false);
    final _uid = widget.usr?.uid ?? documentIdFromCurrentDate();
    final usr = ApiUser(
        uid: _uid,
        email: _email,
        photoURL: _photoURL,
        displayName: _displayName);
    await database.setUser(usr);
    await auth.saveUserProfileData(context, usr);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    profileImage = CachedNetworkImageProvider(
        context.watch<ProfilePicUrlState>().profilePicUrl);

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.usr == null ? 'New User' : 'Edit User'),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _submit(context),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double algo = screenWidth / perfectWidth;

    return [
      Stack(
        children: [
          Opacity(
            opacity: uploadingDp ? 0.5 : 1.0,
            child: Hero(
              tag: 'myProfile',
              child: CircleAvatar(
                radius: algo * 120.0,
                backgroundColor: Colors.white,
                backgroundImage: profileImage,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: uploadingDp
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Container(),
            ),
          ),
          Positioned(
            bottom: algo * 5.0,
            right: algo * 10.0,
            child: GestureDetector(
              onTap: () {
                pickImage(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: algo * 30.0,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.blueGrey,
                  size: algo * 33.0,
                ),
              ),
            ),
          )
        ],
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Email'),
        keyboardAppearance: Brightness.light,
        initialValue: _email,
        validator: (value) => value.isNotEmpty ? null : 'Email can\'t be empty',
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Photo Url'),
        keyboardAppearance: Brightness.light,
        initialValue: _photoURL,
        onSaved: (value) => _photoURL = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Name'),
        keyboardAppearance: Brightness.light,
        initialValue: _displayName,
        onSaved: (value) => _displayName = value,
      ),
    ];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ImagePicker>('picker', picker));
    properties.add(DiagnosticsProperty<ImageProvider<Object>>(
        'profileImage', profileImage));
    properties.add(DiagnosticsProperty<bool>('uploadingDp', uploadingDp));
  }
}
