// Flutter imports:

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// Project imports:
import 'package:prasso_app/app_widgets/auth_widget.dart';
import 'package:prasso_app/app_widgets/home/home_page.dart';
import 'package:prasso_app/app_widgets/onboarding/intro_page.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/routing/router.dart' as _rtr;
import 'package:prasso_app/services/shared_preferences_service.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_widgets/onboarding/intro_viewmodel.dart';
import 'app_widgets/onboarding/onboarding_page.dart';
import 'app_widgets/onboarding/onboarding_viewmodel.dart';
import 'app_widgets/sign_in/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyD-dA6WeTVXsxsGJYXro9EUqHf1LHcL7J8',
        appId: '1:535566369970:web:f39cb9e1b6dc4cd8fcb5ab',
        messagingSenderId: '535566369970',
        projectId: 'prasso-app',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesService.overrideWithValue(
        SharedPreferencesService(sharedPreferences),
      ),
    ],
    child: PrassoCore(),
  ));
}

class PrassoCore extends StatefulWidget {
  @override
  _PrassoCoreState createState() => _PrassoCoreState();
}

class _PrassoCoreState extends State<PrassoCore> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    //FirebaseCrashlytics.instance.crash();

    return MaterialApp(
        theme: prassoThemeData,
        debugShowCheckedModeBanner: false,
        home: AuthWidget(
          nonSignedInBuilder: (_) => Consumer(
            builder: (context, ref, _) {
              final bool didCompleteOnboarding =
                  ref.watch(onboardingViewModelProvider).state;
              return didCompleteOnboarding ? SignInPage() : OnboardingPage();
            },
          ),

          /// Signed In Builder will show intro pages ( video and profile editor ) if the user is newly registered
          signedInBuilder: (_) => Consumer(
            builder: (context, ref, _) {
              final bool didCompleteProfile =
                  ref.watch(introViewModelProvider).state;
              return didCompleteProfile ? const HomePage() : IntroPage();
            },
          ),
        ),
        onGenerateRoute: _rtr.Router.onGenerateRoute);
  }

  Future<void> getFCMToken() async {
    final String? token = await _firebaseMessaging.getToken();
    print('FCM Token:$token');
  }

  Future<void> selectNotification(String? payload) async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  void initState() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    super.initState();

    FirebaseMessaging.onMessage.listen((message) async {
      print('onMessage: $message');

      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Prasso',
        'Prasso Android',
        channelDescription: 'Prasso Android Channel',
        importance: Importance.max,
        priority: Priority.high,
      ); // Android

      const iOSPlatformChannelSpecifics = IOSNotificationDetails(); // IOS

      const platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(0, message.data['title'],
          message.data['body'], platformChannelSpecifics);
    });

    if (!kIsWeb) getFCMToken();
  }
}
