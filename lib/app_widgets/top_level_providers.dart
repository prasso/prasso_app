import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:prasso_app/services/prasso_api_repository.dart';
import 'package:prasso_app/providers/profile_pic_url_state.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';

final sharedPreferencesService =
    Provider<SharedPreferencesService>((ref) => SharedPreferencesService(null));

final cupertinoHomeScaffoldVMProvider =
    Provider<CupertinoHomeScaffoldViewModel>((ref) =>
        CupertinoHomeScaffoldViewModel.initializeFromLocalStorage(
            ref.watch(sharedPreferencesService)));

final profilePicUrlState =
    ChangeNotifierProvider<ProfilePicUrlState>((ref) => ProfilePicUrlState());

final authStateChangesProvider = StreamProvider<ApiUser>(
    (ref) => ref.watch(prassoApiService).authStateChanges());

final databaseProvider = Provider<FirestoreDatabase>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.data?.value?.uid != null) {
    return FirestoreDatabase(uid: auth.data?.value?.uid);
  }
  return null;
});

final prassoApiService = Provider<PrassoApiRepository>((ref) =>
    PrassoApiRepository(ref.watch(sharedPreferencesService),
        ref.watch(cupertinoHomeScaffoldVMProvider)));

final loggerProvider = Provider<Logger>((ref) => Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        printEmojis: false,
      ),
    ));
