import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/screens/auth/authMain.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2CA580),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(stickers3), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Image.asset(splash_ant, height: 155, width: 155),
              Image.asset(splash_img, height: 292, width: 292),
              SizedBox(
                height: 15,
              ),
              CustomText(text: "Welcome to Convenience"),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GradientButton(
                  title: "Sign Up",
                  textClr: Colors.white,
                  clrs: [appColor, appColor],
                  onpressed: () {
                    changeScreen(context, AuthMain());
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: CustomText(
                  text:
                      "By tapping Sign Up you agree to our Terms of service and privacy policy ",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
