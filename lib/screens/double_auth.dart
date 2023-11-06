import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class DoubleAuth extends StatefulWidget {
  @override
  State<DoubleAuth> createState() => _DoubleAuthState();
}

class _DoubleAuthState extends State<DoubleAuth> {
  final FocusNode _pinPutFocusNode1 = FocusNode();
  final FocusNode _pinPutFocusNode2 = FocusNode();
  TextEditingController pinController = TextEditingController();
  TextEditingController confirmPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(stickers)),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [appColor, gd2, gd3, gd4, gd5],
            stops: [0.02, 0.2, 0.6, 0.8, 1.0]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(heart_red, width: 50),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                sun,
                width: 100,
              ),
            ),
            Positioned(
                top: 90,
                right: 0,
                child: Image.asset(
                  dollar,
                  width: 50,
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  money_and_gold,
                  width: 70,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: CustomText(
                      text: "Double Authentication",
                      textAlign: TextAlign.center,
                      weight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: CustomText(
                        text:
                            "Set up a 5-digit Double authentication PIN,\n We’ll ask you for it from time to time",
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: CustomText(
                      text: "Enter Pin",
                      color: appColor,
                      weight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    child: Pinput(
                      length: 5,
                      pinContentAlignment: Alignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      defaultPinTheme: PinTheme(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8))),
                      onSubmitted: (String pin) => {},
                      focusNode: _pinPutFocusNode1,
                      controller: pinController,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: CustomText(
                      text: "Confirm Pin",
                      color: appColor,
                      weight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    child: Pinput(
                      length: 5,
                      defaultPinTheme: PinTheme(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8))),
                      onSubmitted: (String pin) => {},
                      focusNode: _pinPutFocusNode2,
                      controller: confirmPinController,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  GradientButton(
                      title: "Done",
                      textClr: Colors.white,
                      clrs: [appColor, appColor],
                      onpressed: () {}),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  padlock,
                  width: 250,
                )),
          ],
        ),
      ),
    );
  }
}
