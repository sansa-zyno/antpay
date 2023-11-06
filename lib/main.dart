import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/home.dart';
import 'package:ant_pay/screens/splash.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:cometchat/models/user.dart' as ct;

AppSettings appSettings = (AppSettingsBuilder()
      ..subscriptionType = CometChatSubscriptionType.allUsers
      ..region = cometchatRegion
      ..autoEstablishSocketConnection = true)
    .build();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /*await FirebaseAppCheck.instance.activate(
      //webRecaptchaSiteKey: 'recaptcha-v3-site-key',
      webRecaptchaSiteKey: '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8',
      // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. debug provider
      // 2. safety net provider
      // 3. play integrity provider
      androidDebugProvider: false);*/
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
          home: Wrapper()),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late AppProvider appProvider;
  late UserController userController;
  //int timeCounter = 0;
  //double percentage = 0;
  //Timer? periodicTimer;
  checkConnectionAndLogin() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      //await loginOnAntpay();
      loginUser(FirebaseAuth.instance.currentUser!.uid, context);
    } else {
      //Get.defaultDialog(title: "Eroor", middleText: "No data connection");
      checkConnectionAndLogin();
    }
  }

  Future loginOnAntpay() async {
    log("log called");
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc["isReadyForTxn"]) {
      Response response = await HttpService.postRequest(Api.login, {
        "email": doc["email"],
        "password": "${doc["firstname"] + "_${doc["phoneNumber"]}"}",
      });
      Map result = jsonDecode(response.body);
      log(result.toString());
      if (result["status"]) {
        appProvider.setToken(result["data"]["token"]);
      } else {
        Get.defaultDialog(
            title: "Error", middleText: "There was an error login user");
      }
    }
  }

  //Login User function must pass userid and authkey should be used only while developing
  loginUser(String userId, BuildContext context) async {
    ct.User? _user = await CometChat.getLoggedInUser();
    try {
      if (_user != null) {
        await CometChat.logout(onSuccess: (_) {}, onError: (_) {});
      }
    } catch (_) {}

    await CometChat.login(userId, cometchatAuthKey,
        onSuccess: (ct.User loggedInUser) {
      debugPrint("Login Successful : $loggedInUser");
      _user = loggedInUser;
    }, onError: (CometChatException e) {
      log("Login failed with exception:  ${e.message}");
    });

    //if login is successful
    if (_user != null) {
      appProvider.conversationData();
      userController.getCurrentUserInfo();
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
            child: Home()),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    userController = Provider.of<UserController>(context, listen: false);
    if (FirebaseAuth.instance.currentUser != null) {
      checkConnectionAndLogin();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        /*periodicTimer = Timer.periodic(Duration(seconds: 1), (time) {
          timeCounter = timeCounter + 1;
          percentage = timeCounter / 3;
          // print("====== GOOOO $timeCounter");
          if (timeCounter == 3) {
            timeCounter = 0;
            percentage = 0;
            changeScreenReplacement(context, Splash());
            time.cancel();
          }
          //notifyListeners();
        });*/
        changeScreenReplacement(context, Splash());
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    /* if (periodicTimer != null) {
      periodicTimer!.cancel();
      periodicTimer = null;
    }*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(stickers)),
          color: Color(0xff3F007B)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/splash_ant_native.png",
                width: 150,
              ),
            ),
            /* SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: LinearPercentIndicator(
                lineHeight: 15,
                barRadius: Radius.circular(15),
                animation: true,
                animationDuration: 3000,
                percent: 1,
                backgroundColor: Colors.grey.withOpacity(0.2),
                progressColor: gd2,
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
