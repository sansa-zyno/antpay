import 'dart:convert';
import 'dart:developer';
import 'package:achievement_view/achievement_view.dart';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class SetPin extends StatefulWidget {
  const SetPin({Key? key}) : super(key: key);

  @override
  State<SetPin> createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  final FocusNode _pinPutFocusNode = FocusNode();
  TextEditingController pinController = TextEditingController();
  late UserController userController;
  late AppProvider appProvider;
  bool isLoading = false;
  bool activateButton = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userController = Provider.of<UserController>(context);
    appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
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
                    SizedBox(
                      height: titleBarOffset,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: gd2,
                            size: 20,
                          ),
                        ),
                        Spacer(),
                        CustomText(
                          text: "Set Transaction Pin",
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
                      height: 15,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15),
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          setpin_padlock,
                          height: 100,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomText(
                          text:
                              "Choose a secure 4-digit PIN.\n Don’t share this Pin with anyone!",
                          size: 12,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          child: Pinput(
                            onChanged: (x) {
                              activateButton = pinController.text.length == 4;
                              setState(() {});
                            },
                            length: 4,
                            defaultPinTheme: PinTheme(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8))),
                            onSubmitted: (String pin) => {},
                            focusNode: _pinPutFocusNode,
                            controller: pinController,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : GradientButton(
                                title: "Save",
                                textClr: Colors.white,
                                clrs: activateButton
                                    ? [appColor, appColor]
                                    : [Colors.grey[300]!, Colors.grey[300]!],
                                onpressed: () {
                                  activateButton ? setPin() : {};
                                },
                              ),
                      ],
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

  setPin() async {
    isLoading = true;
    setState(() {});
    Response response = await HttpService.postRequest(
        Api.setPin,
        {
          "current_pin": userController.getCurrentUser.antpayPin,
          "pin": pinController.text,
          "pin_confirmation": pinController.text
        },
        bearerToken: true,
        accessToken: appProvider.token);

    if (response.statusCode == 200) {
      Map res = jsonDecode(response.body);
      log(res.toString());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userController.getCurrentUser.uid)
          .update({"antpayPin": pinController.text});
      isLoading = false;
      setState(() {});
      AchievementView(
        color: Colors.green,
        icon: Icon(
          FontAwesomeIcons.check,
          color: Colors.white,
        ),
        title: "Successfull !",
        elevation: 20,
        subTitle: res["status"],
        isCircle: true,
      ).show(context);
      userController.getCurrentUserInfo();
      Navigator.pop(context);
    } else {
      isLoading = false;
      setState(() {});
      Map res = jsonDecode(response.body);
      log(res.toString());
      Get.defaultDialog(
        title: "Error",
        titleStyle: TextStyle(color: Colors.red),
        middleText: res["message"],
      );
    }
  }
}
