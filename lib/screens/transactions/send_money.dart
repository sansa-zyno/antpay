import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/transactions/send_to_beneficiary.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key}) : super(key: key);

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
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
    return Scaffold(
      backgroundColor: appColor,
      body: Stack(
        children: [
          Positioned(
              top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
          Column(
            children: [
              Container(
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
                        Icon(
                          Icons.arrow_back_ios_new,
                          color: gd2,
                          size: 20,
                        ),
                        Spacer(),
                        CustomText(
                          text: "Send",
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
                    ),
                    Center(
                      child: CustomText(
                        text: "Send money across borders seamlessly",
                        textAlign: TextAlign.center,
                        color: Colors.white,
                      ),
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            changeScreen(context, SendToBeneficiary());
                          },
                          child: Container(
                            height: 100,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xff25D366),
                                      Color(0xff25D366).withOpacity(0.3),
                                      Color(0xffFFFFFF)
                                    ]),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 30,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: appColor,
                                                fontWeight: FontWeight.bold),
                                            children: [
                                          TextSpan(text: "Send to Bank \n"),
                                          TextSpan(text: "Account")
                                        ])),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Image.asset(arrow, width: 32),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                      color: appColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          bottomLeft: Radius.circular(50),
                                          topRight: Radius.circular(8),
                                          bottomRight: Radius.circular(8))),
                                  child: Image.asset(
                                    dollar2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 30,
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                        TextSpan(text: "Send to Virtual \n"),
                                        TextSpan(text: "Account")
                                      ])),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Image.asset(
                                    arrow,
                                    width: 32,
                                    color: gd2,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xff25D366),
                                          Color(0xff25D366),
                                          Color(0xffFFFFFF)
                                        ]),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        bottomLeft: Radius.circular(50),
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                                child: Image.asset(
                                  cards_on_hand2,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
