// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/constants/constants.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

class ProfileFormChildren extends HookConsumerWidget {
  const ProfileFormChildren({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(
      builder: (dynamic context) => const ProfileFormChildren(),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _viewmodel = ref.watch(editUserProfileViewModel);
    final auth = ref.watch(prassoApiService as ProviderListenable<PrassoApiRepository>);
    final database = ref.watch(databaseProvider as ProviderListenable<FirestoreDatabase>);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildForm(_viewmodel, context, auth, database),
        ),
      ),
    );
  }

  Widget _buildForm(EditUserProfileViewModel _viewmodel, BuildContext context,
      PrassoApiRepository auth, FirestoreDatabase database) {
    return Form(
      key: _viewmodel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(_viewmodel, context, auth, database),
      ),
    );
  }

  List<Widget> _buildFormChildren(
      EditUserProfileViewModel _viewmodel,
      BuildContext context,
      PrassoApiRepository auth,
      FirestoreDatabase database) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double algo = screenWidth / perfectWidth;

    return [
      SingleChildScrollView(
        child: Stack(
            children: [
              Opacity(
                opacity: _viewmodel.uploadingDp ? 0.5 : 1.0,
                child: Hero(
                  tag: 'myProfile',
                  child: CircleAvatar(
                    radius: algo * 120.0,
                    backgroundColor: Colors.white,
                    backgroundImage: _viewmodel.profileImage,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: _viewmodel.uploadingDp
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
                    _viewmodel.pickImage(context, auth, database);
                  },
                  child: CircleAvatar(
                    backgroundColor: PrassoColors.lightGray,
                    radius: algo * 30.0,
                    child: Icon(
                      Icons.camera_alt,
                      color: PrassoColors.olive,
                      size: algo * 33.0,
                    ),
                  ),
                ),
              ),
           
          TextFormField(
            decoration: const InputDecoration(labelText: Strings.emailLabel),
            keyboardAppearance: Brightness.light,
            initialValue: _viewmodel.email,
            validator: (value) =>
                value!.isNotEmpty ? null : Strings.emailCantbeEmpty,
            onSaved: (value) => _viewmodel.email = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: Strings.nameLabel),
            keyboardAppearance: Brightness.light,
            initialValue: _viewmodel.displayName,
            onSaved: (value) => _viewmodel.displayName = value,
          ),
          
          
        ]))]

    ;
  }

}
