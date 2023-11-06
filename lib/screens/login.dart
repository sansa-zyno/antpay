/*import 'dart:developer';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/home.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/curved_textfield.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:cometchat/models/user.dart' as ct;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late AppProvider appProvider;
  late UserController userController;
  TextEditingController email = TextEditingController();
  // TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    userController = Provider.of<UserController>(context);
    return Container(
      /*onWillPop: () async {
        bool result = false;
        if (loading) {
          result = false;
        } else {
          result = true;
        }
        return result;
      },*/
      child: Scaffold(
        backgroundColor: appColor,
        body: Stack(
          children: [
            Positioned(
                top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
            Column(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: titleBarOffset),
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          /*Icon(
                            Icons.arrow_back_ios_new,
                            color: gd2,
                            size: 20,
                          ),*/
                          Spacer(),
                          CustomText(
                            text: "Login",
                            color: Colors.white,
                            size: 16,
                          ),
                          Spacer(),
                          SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "You need to login to continue transacting",
                            size: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //image: DecorationImage(image: AssetImage(stickers)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [appColor, gd2, gd3, gd4, gd5],
                            stops: [0.02, 0.2, 0.6, 0.8, 1.0]),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              CustomText(
                                text: "Email",
                                color: appColor,
                                weight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              CurvedTextField(
                                hint: "Enter email address",
                                controller: email,
                              ),
                              /* SizedBox(
                                height: 15,
                              ),
                              CustomText(
                                text: "Home Address",
                                color: appColor,
                                weight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              CurvedTextField(
                                hint: "Enter Home Address",
                                controller: address,
                              ),*/
                              SizedBox(
                                height: 30,
                              ),
                              CustomText(
                                text: "Password",
                                color: appColor,
                                weight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              CurvedTextField(
                                hint: "Enter password",
                                obsecureText: true,
                                controller: password,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                              ),
                              loading
                                  ? Container(
                                      width: 283,
                                      child: Center(
                                          child: CircularProgressIndicator()))
                                  : GradientButton(
                                      title: "Submit",
                                      textClr: gd2,
                                      clrs: [appColor, appColor],
                                      onpressed: () {
                                        loginOnAntpay();
                                      },
                                    ),
                              SizedBox(
                                height: 50,
                              ),
                              /*Container(
                                  width: 283,
                                  alignment: Alignment.center,
                                  child: CustomText(
                                    text: "Step 1 of 2",
                                    color: appColor,
                                  ))*/
                            ],
                          ),
                        ),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
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
      loading = false;
      setState(() {});
    });

    //if login is successful
    if (_user != null) {
      appProvider.conversationData();
      userController.getCurrentUserInfo();
      loading = false;
      setState(() {});
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

  loginOnAntpay() async {
    loading = true;
    setState(() {});
    Response response = await HttpService.post(Api.login, {
      "email": email.text.trim(),
      "password": password.text.trim(),
    });
    Map result = response.data;
    log(result.toString());
    if (result["status"]) {
      appProvider.setToken(result["data"]["token"]);
      loginUser(FirebaseAuth.instance.currentUser!.uid, context);
    } else {
      Get.defaultDialog(
          title: "Error", middleText: "There was an error login user");
    }
  }
}*/
