import 'dart:convert';
import 'dart:developer';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/auth/signup.dart';
import 'package:ant_pay/screens/auth/verification.dart';
import 'package:ant_pay/screens/home.dart';
import 'package:ant_pay/screens/profile_setup.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cometchat/models/user.dart' as ct;

class AuthMain extends StatefulWidget {
  @override
  _AuthMainState createState() => _AuthMainState();
}

class _AuthMainState extends State<AuthMain> {
  final TextEditingController _otp = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  bool isLoggedIn = false;
  bool otpSent = false;
  String? uid;
  late String _verificationId;

  void _verifyOTP() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _otp.text);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      log("firebase user: ${userCredential.user}");

      if (FirebaseAuth.instance.currentUser != null) {
        setState(() {
          isLoggedIn = true;
          uid = FirebaseAuth.instance.currentUser!.uid;
        });
      } else {
        AchievementView(
          color: Colors.red,
          icon: const Icon(
            FontAwesomeIcons.bug,
            color: Colors.white,
          ),
          title: "Wrong Code !",
          elevation: 20,
          subTitle: "Your Entered OTP is Incorrect",
          isCircle: true,
        ).show(context);
      }
    } catch (e) {
      log("Following error was thrown while trying to authenticate the OTP : ${e.toString()}.");
      Get.defaultDialog(
          title: "Error!",
          middleText:
              "Following error was thrown while trying to authenticate the OTP : ${e.toString()}");
    }

    if (uid != null) {
      try {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .get();
        if (snap.docs.isNotEmpty) {
          //await loginOnAntpay(context);
          loginUser(uid!, context);
        } else {
          changeScreen(context, ProfileSetup(uid: uid!));
        }
      } catch (e) {
        log("Error in fetching user data. ${e.toString()}");
      }
    }
  }

  void _sendOTP(String countrySel, String dialCode) async {
    log(countrySel);
    log(dialCode);
    log("${dialCode + _phoneNumber.text}");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${dialCode + _phoneNumber.text}",
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: Duration(seconds: 60));
    setState(() {
      otpSent = true;
    });

    AchievementView(
      color: Colors.green,
      icon: Icon(
        FontAwesomeIcons.check,
        color: Colors.white,
      ),
      title: "OTP Generation Successfull !",
      elevation: 20,
      subTitle: "Type in your OTP",
      isCircle: true,
    ).show(context);
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });
  }

  void codeSent(String verificationId, [int? a]) {
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });
  }

  void verificationFailed(FirebaseAuthException exception) {
    AchievementView(
      color: Colors.red,
      icon: Icon(
        FontAwesomeIcons.bug,
        color: Colors.white,
      ),
      title: "Verification failed",
      elevation: 20,
      subTitle: "There is an issue verifying this number: ${exception.message}",
      isCircle: true,
    ).show(context);
    setState(() {
      isLoggedIn = false;
      otpSent = false;
    });
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    /* log("verification completed callback called now");
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      log("userCredential.user: ${userCredential.user}");
      if (FirebaseAuth.instance.currentUser != null) {
        log("inside the user not null");
        setState(() {
          isLoggedIn = true;
          uid = FirebaseAuth.instance.currentUser!.uid;
          log("userid: $uid");
        });
      } else {
        AchievementView(
          context,
          color: Colors.red,
          icon: const Icon(
            FontAwesomeIcons.bug,
            color: Colors.white,
          ),
          title: "Something went wrong!",
          elevation: 20,
          subTitle: "Could not fetch the OTP",
          isCircle: true,
        ).show();
      }
    } catch (e) {
      log("Following error was thrown while trying to authenticate the OTP : ${e.toString()}.");
      Get.defaultDialog(
          title: "Error!",
          middleText:
              "Following error was thrown while trying to authenticate the OTP : ${e.toString()}.");
    }
    if (uid != null) {
      try {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .get();
        if (snap.docs.isNotEmpty) {
          UserController _currentUser =
              Provider.of<UserController>(context, listen: false);
          _currentUser.getCurrentUserInfo();
          //setStatusOnline();
          loginUser(uid!, context);
        } else {
          changeScreen(context, ProfileSetup(uid: uid!));
        }
      } catch (e) {
        log("Error in fetching user data. ${e.toString()}");
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return otpSent
        ? Verification(
            number: _phoneNumber.text,
            otp: _otp,
            onpressed: _verifyOTP,
            resendOtp: _sendOTP,
          )
        : SignUp(
            onpressed: _sendOTP,
            phone: _phoneNumber,
          );
  }

  Future loginOnAntpay(BuildContext context) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
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
      debugPrint("Login failed with exception:  ${e.message}");
    });

    //if login is successful
    if (_user != null) {
      AppProvider _app = Provider.of<AppProvider>(context, listen: false);
      _app.conversationData();
      UserController _currentUser =
          Provider.of<UserController>(context, listen: false);
      _currentUser.getCurrentUserInfo();
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
}
