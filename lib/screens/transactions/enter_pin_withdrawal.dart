import 'dart:convert';
import 'dart:developer';

import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/screens/transactions/success_alert.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class WithdrawEnterPin extends StatefulWidget {
  String validationUrl;
  WithdrawEnterPin({required this.validationUrl});
  @override
  State<WithdrawEnterPin> createState() => _WithdrawEnterPinState();
}

class _WithdrawEnterPinState extends State<WithdrawEnterPin> {
  final FocusNode _pinPutFocusNode = FocusNode();
  TextEditingController pinController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(stickers04)),
          //color: Color(0xFF1A0130)
          color: appColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
                top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
            Positioned(
                top: 230,
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
            Column(
              children: [
                SizedBox(
                  height: 30,
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
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    CustomText(
                      text: "Withdraw",
                      color: Colors.white,
                    ),
                    Spacer(),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: CustomText(
                      text: "Enter your 5-digit Antpay PIN ",
                      color: Colors.white,
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
                      length: 4,
                      defaultPinTheme: PinTheme(
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
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 100,
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : GradientButton(
                        title: "Withdraw",
                        textClr: appColor,
                        clrs: [gd2, gd2],
                        onpressed: () async {
                          isLoading = true;
                          setState(() {});
                          Response response = await HttpService.postRequest(
                              widget.validationUrl,
                              {"_pin": pinController.text},
                              bearerToken: true,
                              accessToken: appProvider.token,
                              validationUrl: true);
                          if (response.statusCode == 200) {
                            Map res = jsonDecode(response.body);
                            log(response.statusCode.toString());
                            if (res["status"]) {
                              appProvider.getWallet();
                              changeScreenReplacement(
                                  context, Success("Withdrawal"));
                            } else {
                              isLoading = false;
                              setState(() {});
                              Get.defaultDialog(
                                  title: "Error",
                                  titleStyle: TextStyle(color: Colors.red),
                                  middleText: res["message"]);
                            }
                          } else {
                            isLoading = false;
                            setState(() {});
                            Map res = jsonDecode(response.body);
                            log(response.statusCode.toString());
                            Get.defaultDialog(
                                title: "Error",
                                titleStyle: TextStyle(color: Colors.red),
                                middleText: res["message"]);
                          }
                        }),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
