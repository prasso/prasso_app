import 'package:get_it/get_it.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  if (CupertinoHomeScaffoldViewModel.isDisposed) {
    locator.registerSingleton<CupertinoHomeScaffoldViewModel>(
        CupertinoHomeScaffoldViewModel.initializeFromLocalStorage());
  }
}
