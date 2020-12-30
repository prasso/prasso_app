import 'package:get_it/get_it.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/models/api_user.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  if (locator.isRegistered<CupertinoHomeScaffoldViewModel>()) {
    locator.unregister<CupertinoHomeScaffoldViewModel>();
  }
  locator.registerSingleton<CupertinoHomeScaffoldViewModel>(
      CupertinoHomeScaffoldViewModel.initializeFromLocalStorage());
}

void setupLoggedInUser(ApiUser user) {
  if (locator.isRegistered<ApiUser>()) {
    locator.unregister<ApiUser>();
  }
  locator.registerSingleton<ApiUser>(user);
}
