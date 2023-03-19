import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/screens/profile_setup.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  TextEditingController otp;
  Function() onpressed;
  Function resendOtp;
  String number;

  Verification(
      {required this.otp,
      required this.onpressed,
      required this.number,
      required this.resendOtp});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final FocusNode _pinPutFocusNode = FocusNode();
  double _times = 60;
  CountdownTimerController? controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

  void onEnd() {
    setState(() {
      _times = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(stickers)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gd1, gd2, gd3, gd4, gd5],
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
                  top: 120,
                  left: 0,
                  child: Image.asset(
                    cards_on_hand,
                    width: 100,
                  )),
              Positioned(
                  top: 90,
                  right: 0,
                  child: Image.asset(
                    dollar,
                    width: 50,
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    car,
                    width: 70,
                  )),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    money_and_gold,
                    width: 70,
                  )),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    CustomText(
                      text: "Phone Number Confirmation",
                      textAlign: TextAlign.center,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: CustomText(
                          text:
                              "Enter the 6-digit code we just sent to ${widget.number == "" ? "you" : "${appProvider.dialcode + widget.number}"}",
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Container(
                        width: 283,
                        child: Pinput(
                          length: 6,
                          defaultPinTheme: PinTheme(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8))),
                          onSubmitted: (String pin) => {},
                          focusNode: _pinPutFocusNode,
                          controller: widget.otp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    _times != 0
                        ? GradientButton(
                            title: "Continue",
                            textClr: Colors.white,
                            clrs: [appColor, appColor],
                            onpressed: widget.onpressed)
                        : GradientButton(
                            title: "Resend Code",
                            textClr: Colors.white,
                            clrs: [appColor, appColor],
                            onpressed: () {
                              endTime = DateTime.now().millisecondsSinceEpoch +
                                  1000 * 60;
                              _times = 60;
                              controller = CountdownTimerController(
                                  endTime: endTime, onEnd: onEnd);
                              setState(() {});
                              widget.resendOtp(appProvider.countrySelected,
                                  appProvider.dialcode);
                            },
                          ),
                    const SizedBox(height: 50),
                    CountdownTimer(
                        controller: controller,
                        onEnd: () {},
                        endTime: endTime,
                        widgetBuilder: (_, time) {
                          if (time == null) {
                            return Container();
                          }
                          return CustomText(
                              text:
                                  "Re-Send Code In 0:${time.sec!.floor() < 10 ? "0" : ""}${time.sec!.floor()} ");
                        }),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
