// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

class MorePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final model = useProvider(cupertinoHomeScaffoldVMProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Strings.morePage,
            style: TextStyle(color: PrassoColors.lightGray)),
      ),
      body: _buildMoreInfo(context, model),
    );
  }

  Widget _buildMoreInfo(
      BuildContext context, CupertinoHomeScaffoldViewModel model) {
    final authService = context.read(prassoApiService);
    final user = authService?.currentUser;

    return ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: model.moreItems.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = model.moreItems[index];

        return ListTile(
          leading: Icon(
            item.icon,
            color: Colors.grey,
          ),
          title: Text(item.pageTitle!),
          subtitle: Text(item.title!),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => {
            if (model.moreItems[index].pageUrl == 'PersonalMessaging()')
              {_callNativePage(context, user!)}
            else
              {model.navigateToMoreItem(index, context)}
          },
        );
      },
    );
  }

  Future<bool> _callNativePage(BuildContext context, ApiUser? user) async {
    const platform = MethodChannel('NativeChannel');
    String mRoleId = '3',
        mModelId = '',
        mUserId = '',
        mUserCoachUid = 'hVFxj9fC6Xbkqw9m1Yw3mKLBsuL2';
    String? nativeCall;
    try {
      if (user?.uid != null &&
          user?.email != null &&
          user?.personalTeamId != null) {
        if (user?.roles != null &&
            user?.roles.toString() != '[]' &&
            user?.roles![0] != null) {
          mRoleId = user != null && user.roles != null && user.roles!.isNotEmpty
              ? user.roles![0].roleId.toString()
              : '';
          mModelId =
              user != null && user.roles != null && user.roles!.isNotEmpty
                  ? user.roles![0].modelId.toString()
                  : '';
          mUserId = user != null && user.roles != null && user.roles!.isNotEmpty
              ? user.roles![0].userId.toString()
              : '';
          if (user?.coachUid != null) {
            mUserCoachUid = user != null ? user.coachUid.toString() : '';
          }
        }
        final Map<String, String?> mParams = {
          'loginId': user?.uid,
          'loginName': user?.displayName,
          'loginEmail': user?.email,
          'teamId': user?.personalTeamId.toString(),
          'teamCoachId': user?.teamCoachId.toString(),
          'roleId': mRoleId,
          'modelId': mModelId,
          'userId': mUserId,
          'coachUID': mUserCoachUid,
        };

        nativeCall = await platform.invokeMethod('NativeMethodCall', mParams);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong'),
        ));
      }
    } catch (e) {
      print(e);
    }
    print(nativeCall);
    return true;
  }
}
