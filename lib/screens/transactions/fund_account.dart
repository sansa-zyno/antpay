import 'dart:convert';
import 'dart:developer';

import 'package:achievement_view/achievement_view.dart';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/transactions/enter_pin_fund.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/curved_textfield.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class FundAccount extends StatefulWidget {
  const FundAccount({Key? key}) : super(key: key);

  @override
  State<FundAccount> createState() => _FundAccountState();
}

class _FundAccountState extends State<FundAccount> {
  bool expanded1 = false;
  bool expanded2 = false;
  late UserController userController;
  late AppProvider appProvider;
  TextEditingController amountController = TextEditingController();
  bool loading = false;

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
                            text: "Fund",
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            CustomText(
                              text: "Deposit From",
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
                            ),
                            CustomText(
                              text: "Deposit To",
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
                              height: 100,
                            ),
                            loading
                                ? Center(child: CircularProgressIndicator())
                                : GradientButton(
                                    title: "Fund Wallet",
                                    clrs: [appColor, appColor],
                                    onpressed: () async {
                                      await fund();
                                    },
                                  )
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 70, left: 30),
                  child: Image.asset(
                    hand_holding_dollar,
                    height: 200,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  fund() async {
    loading = true;
    setState(() {});
    Response response = await HttpService.postRequest(
        Api.fund, {"amount": amountController.text},
        bearerToken: true, accessToken: appProvider.token);
    Map result = jsonDecode(response.body);
    log(result.toString());
    if (result["status"] == "Success") {
      amountController.text = "";
      changeScreenReplacement(
          context,
          FundEnterPin(
            validationUrl: result["data"]["url"],
          ));
      loading = false;
      setState(() {});
    } else {
      loading = false;
      setState(() {});
      AchievementView(
        color: Colors.red,
        icon: Icon(
          FontAwesomeIcons.bug,
          color: Colors.white,
        ),
        title: "Error",
        elevation: 20,
        subTitle: "Wallet not funded",
        isCircle: true,
      ).show(context);
    }
  }
}
