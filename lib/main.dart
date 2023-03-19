import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/splash.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

AppSettings appSettings = (AppSettingsBuilder()
      ..subscriptionType = CometChatSubscriptionType.allUsers
      ..region = cometchatRegion
      ..autoEstablishSocketConnection = true)
    .build();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
      //webRecaptchaSiteKey: 'recaptcha-v3-site-key',
      // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. debug provider
      // 2. safety net provider
      // 3. play integrity provider
      androidDebugProvider: true);
  FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  CometChat.init(cometchatAppId, appSettings,
      onSuccess: (String successMessage) {
    debugPrint("Initialization completed successfully  $successMessage");
  }, onError: (CometChatException excep) {
    debugPrint("Initialization failed with exception: ${excep.message}");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (context) => AppProvider())
      ],
      child: GetMaterialApp(
          title: 'Ant Pay',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: Splash()),
    );
  }
}
