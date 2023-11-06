import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late UserController userController;
  int idx = -1;
  bool accept = false;
  bool decline = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userController = Provider.of<UserController>(context);
    return Scaffold(
      backgroundColor: appColor,
      body: Stack(
        children: [
          Positioned(
              top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
          Column(
            children: [
              Container(
                height: 90,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    SizedBox(
                      height: 15,
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
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Spacer(),
                        CustomText(
                          text: "Notifications",
                          color: Colors.white,
                          size: 16,
                        ),
                        Spacer(),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    Spacer()
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
                    child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        physics: BouncingScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (ctx, index) {
                          bool isSameDate = true;
                          DateTime dt = DateTime.parse("1970-12-0$index");
                          if (index == 0) {
                            isSameDate = false;
                          } else {
                            DateTime dte = DateTime.parse(
                                "1970-12-0${index - 1}"); //date of prev item
                            isSameDate = dt.compareTo(dte) == 0
                                ? true
                                : false; //compare dates
                          }
                          if (index == 0 || !(isSameDate)) {
                            DateTime dt = DateTime.parse("1970-12-0$index");
                            DateTime dateNow = DateTime.parse(
                                DateTime.now().toString().substring(0, 10));
                            DateTime dtTime = DateTime.parse("1970-12-0$index");
                            String time =
                                formatDate(dtTime, [hh, ':', nn, ' ', am]);

                            String date = dt.compareTo(dateNow) == 0
                                ? "Today"
                                : "${dt.year} ${dt.month} ${dt.day}" ==
                                        "${dateNow.year} ${dateNow.month} ${(dateNow.day) - 1}"
                                    ? "Yesterday"
                                    : formatDate(dt, [M, ' ', dd, ', ', yyyy]);
                            return Column(
                              children: [
                                SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff6E01CE),
                                                width: 3),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(male),
                                                fit: BoxFit.cover)),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                text: TextSpan(
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    children: [
                                                  TextSpan(
                                                      text:
                                                          "John Doe requested payment of "),
                                                  TextSpan(
                                                      style: TextStyle(
                                                          color: appColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      text: "\$200")
                                                ])),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    idx = index;
                                                    accept = true;
                                                    decline = false;
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: idx == index &&
                                                                accept
                                                            ? appColor
                                                            : Colors
                                                                .transparent,
                                                        border: Border.all(
                                                            color: appColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    padding: EdgeInsets.all(8),
                                                    child: CustomText(
                                                      text: "Accept",
                                                      color:
                                                          idx == index && accept
                                                              ? Colors.white
                                                              : null,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    idx = index;
                                                    accept = false;
                                                    decline = true;
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: idx == index &&
                                                                decline
                                                            ? appColor
                                                            : Colors
                                                                .transparent,
                                                        border: Border.all(
                                                            color: appColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    padding: EdgeInsets.all(8),
                                                    child: CustomText(
                                                      text: "Decline",
                                                      color: idx == index &&
                                                              decline
                                                          ? Colors.white
                                                          : null,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomText(
                                        text: time,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            DateTime dtTime = DateTime.parse("1970-12-0$index");
                            String time =
                                formatDate(dtTime, [hh, ':', nn, ' ', am]);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xff6E01CE), width: 3),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(male),
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                              TextSpan(
                                                  text:
                                                      "John Doe requested payment of "),
                                              TextSpan(
                                                  style: TextStyle(
                                                      color: appColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  text: "\$200")
                                            ])),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                idx = index;
                                                accept = true;
                                                decline = false;
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: idx == index &&
                                                            accept
                                                        ? appColor
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                        color: appColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding: EdgeInsets.all(8),
                                                child: CustomText(
                                                  text: "Accept",
                                                  color: idx == index && accept
                                                      ? Colors.white
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                idx = index;
                                                accept = false;
                                                decline = true;
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: idx == index &&
                                                            decline
                                                        ? appColor
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                        color: appColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding: EdgeInsets.all(8),
                                                child: CustomText(
                                                  text: "Decline",
                                                  color: idx == index && decline
                                                      ? Colors.white
                                                      : null,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomText(
                                    text: time,
                                  ),
                                ],
                              ),
                            );
                          }
                        })),
              )
            ],
          ),
        ],
      ),
    );
  }
}
