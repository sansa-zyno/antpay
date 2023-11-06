import 'dart:convert';
import 'dart:developer';

import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/transactions/enter_pin_withdrawal.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/curved_textfield.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:provider/provider.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({Key? key}) : super(key: key);

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  bool expanded1 = false;
  bool expanded2 = false;
  late UserController userController;
  late AppProvider appProvider;
  TextEditingController amountController = TextEditingController();
  TextEditingController narrationController = TextEditingController();
  TextEditingController withdrawToAccountNo = TextEditingController();
  String bankId = "";
  String countryId = "";
  String bankName = "";
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appProvider = Provider.of(context, listen: false);
    appProvider.getBanks();
  }

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
          Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  height: 270,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
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
                            text: "Withdraw",
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
                Positioned(
                  top: 250,
                  left: 0,
                  right: 0,
                  bottom: 0,
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
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            /*Container(
                                width: 283,
                                child: CustomText(
                                  text: "Withdraw From",
                                  color: appColor,
                                  weight: FontWeight.bold,
                                )),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                                height: expanded1 ? null : 58,
                                width: 283,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: Offset(2, 2))
                                    ]),
                                child: ExpansionTile(
                                  expandedAlignment: Alignment.centerLeft,
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  onExpansionChanged: (x) {
                                    expanded1 = x;
                                    setState(() {});
                                  },
                                  title: Text("Select Account",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                  trailing: Icon(Icons.arrow_drop_down,
                                      color: appColor),
                                  children: [],
                                )),
                            SizedBox(
                              height: 15,
                            ),*/
                            CustomText(
                              text: "Withdraw To",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CurvedTextField(
                              hint: "",
                              controller: withdrawToAccountNo,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CustomText(
                              text: "Bank",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                                height: expanded1 ? null : 58,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: Offset(2, 2))
                                    ]),
                                child: ListTile(
                                  title: Text(
                                      bankName.isEmpty
                                          ? "Select Bank"
                                          : bankName,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      if (appProvider.banks.isNotEmpty) {
                                        await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomText(
                                                      text: "Select Bank",
                                                      color: appColor,
                                                      size: 16,
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        )),
                                                  ],
                                                ),
                                                insetPadding: EdgeInsets.all(0),
                                                content: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                        children: List.generate(
                                                            appProvider
                                                                .banks.length,
                                                            (index) => ListTile(
                                                                  onTap: () {
                                                                    bankId = appProvider
                                                                            .banks[index]
                                                                        ["uid"];
                                                                    countryId = appProvider.banks[index]
                                                                            [
                                                                            "country"]
                                                                        ["uid"];
                                                                    bankName = appProvider
                                                                            .banks[index]
                                                                        [
                                                                        "bank_name"];
                                                                    setState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  leading: Text(
                                                                      "${index + 1}"),
                                                                  title: Text(appProvider
                                                                              .banks[
                                                                          index]
                                                                      [
                                                                      "bank_name"]),
                                                                ))),
                                                  ),
                                                )));
                                      } else {
                                        appProvider.getBanks();
                                      }
                                    },
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: appColor),
                                  ),
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            CustomText(
                              text: "Amount",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CurvedTextField(
                              hint: "",
                              controller: amountController,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CustomText(
                              text: "Narration",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CurvedTextField(
                              hint: "",
                              controller: narrationController,
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            loading
                                ? Center(child: CircularProgressIndicator())
                                : GradientButton(
                                    title: "Withdraw",
                                    clrs: [appColor, appColor],
                                    onpressed: () async {
                                      loading = true;
                                      setState(() {});
                                      dio.Response response =
                                          await HttpService.postFromDio(
                                              Api.withdraw,
                                              {
                                                "account_number":
                                                    withdrawToAccountNo.text,
                                                "bank_id": bankId,
                                                "country_id": countryId,
                                                "narration":
                                                    narrationController.text,
                                                "amount": int.parse(
                                                    amountController.text),
                                                "save_beneficiary": false
                                              },
                                              accessToken: appProvider.token);
                                      Map result = response.data;
                                      if (result["status"] == "Success") {
                                        loading = false;
                                        setState(() {});
                                        changeScreenReplacement(
                                            context,
                                            WithdrawEnterPin(
                                              validationUrl: result["data"]
                                                  ["url"],
                                            ));
                                      }
                                    })
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 30),
                  child: Image.asset(
                    tgn_14,
                    height: 300,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
