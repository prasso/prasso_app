import 'package:flutter/foundation.dart';
import 'package:prasso_app/app_widgets/sign_in/sign_in_page.dart';
import 'package:prasso_app/providers/profile_pic_url_state.dart';
import 'package:prasso_app/services/firebase_auth_service/auth_widget_builder.dart';
import 'package:prasso_app/services/prasso_api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:prasso_app/app_widgets/home/home_page.dart';
import 'package:prasso_app/routing/router.dart' as _rtr;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:prasso_app/models/api_user.dart';
import 'service_locator.dart';
import 'services/firestore_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();
  setupLocator();

  runApp(PrassoCore(
    databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
    apiBuilder: (_) => PrassoApiService(),
  ));
}

class PrassoCore extends StatelessWidget {
  const PrassoCore({Key key, this.databaseBuilder, this.apiBuilder})
      : super(key: key);

  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;
  final PrassoApiService Function(BuildContext context) apiBuilder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfilePicUrlState>(
            create: (context) => ProfilePicUrlState()),
        Provider<PrassoApiService>(
          create: apiBuilder,
        ),
        Provider<Logger>(
          create: (_) => Logger(
            printer: PrettyPrinter(
              methodCount: 1,
              printEmojis: false,
            ),
          ),
        )
      ],
      child: AuthWidgetBuilder(
        userProvidersBuilder: (_, dynamic user) => [
          Provider<ApiUser>.value(value: user),
          Provider<FirestoreDatabase>(
            create: (_) => FirestoreDatabase(uid: user.uid),
          ),
        ],
        builder: (context, userSnapshot) {
          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.orange),
            debugShowCheckedModeBanner: false,
            home: AuthWidget(
              userSnapshot: userSnapshot,
              nonSignedInBuilder: (_) => SignInPageBuilder(),
              signedInBuilder: (_) => HomePage(),
            ),
            onGenerateRoute: _rtr.Router.onGenerateRoute,
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<
            FirestoreDatabase Function(BuildContext context, String uid)>(
        'databaseBuilder', databaseBuilder));
    properties.add(
        DiagnosticsProperty<PrassoApiService Function(BuildContext context)>(
            'apiBuilder', apiBuilder));
  }
}
