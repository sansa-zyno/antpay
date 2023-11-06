import 'dart:convert';
import 'dart:developer';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/transactions/enter_pin_send.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/curved_textfield.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class SendToAccount extends StatefulWidget {
  const SendToAccount({Key? key}) : super(key: key);

  @override
  State<SendToAccount> createState() => _SendToAccountState();
}

class _SendToAccountState extends State<SendToAccount> {
  late UserController userController;
  late AppProvider appProvider;
  bool expanded = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController narrationController = TextEditingController();
  TextEditingController recipientAccountNo = TextEditingController();
  String bankId = "";
  String countryId = "";
  String bankName = "";
  bool loading = false;
  bool isloading = false;
  bool addToBeneficiary = false;
  bool confirmRecipient = false;
  String recipientName = "";
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
                height: 150,
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
                          text: "Send To Bank Account",
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
                      child: Container(
                        height: 40,
                        width: 240,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 100,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Color(0xffADFFE1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: CustomText(
                                  text: "Local",
                                  color: appColor,
                                  size: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(),
                                child: CustomText(
                                  text: "International",
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            )
                          ],
                        ),
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
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            /*CustomText(
                              text: "Sending From",
                              color: appColor,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                height: expanded ? null : 58,
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
                                    expanded = x;
                                    setState(() {});
                                  },
                                  title: Text("Select account",
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
                              text: "Recipient's Bank",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                height: expanded ? null : 58,
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
                                        log(appProvider.banks.toString());
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
                              text: "Recipient's Account Number",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CurvedTextField(
                              hint: "",
                              controller: recipientAccountNo,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CustomText(
                              text:
                                  "Confirm recipient’s name before tapping proceed",
                              size: 12,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Visibility(
                              visible: !confirmRecipient,
                              child: isloading
                                  ? Center(child: CircularProgressIndicator())
                                  : InkWell(
                                      onTap: () async {
                                        isloading = true;
                                        setState(() {});
                                        log(bankId);
                                        log(recipientAccountNo.text);
                                        Response response =
                                            await HttpService.postRequest(
                                                Api.nameEnquiry,
                                                {
                                                  "account_number":
                                                      recipientAccountNo.text,
                                                  "bank_id": bankId
                                                },
                                                bearerToken: true,
                                                accessToken: appProvider.token);
                                        Map res = jsonDecode(response.body);
                                        if (res["status"]) {
                                          confirmRecipient = true;
                                          recipientName =
                                              res["data"]["accountName"];
                                          isloading = false;
                                          setState(() {});
                                        } else {
                                          isloading = false;
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    blurRadius: 10,
                                                    offset: Offset(2, 2))
                                              ]),
                                          child: Center(
                                              child: CustomText(
                                            text: "Confirm Recipient",
                                            color: Colors.white,
                                          ))),
                                    ),
                            ),
                            Visibility(
                              visible: confirmRecipient,
                              child: Stack(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: Offset(2, 2))
                                          ]),
                                      child: CustomText(
                                        text: recipientName,
                                        color: appColor,
                                      )),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: InkWell(
                                        onTap: () {
                                          confirmRecipient = false;
                                          recipientName = "";
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        )),
                                  )
                                ],
                              ),
                            ),
                            confirmRecipient
                                ? SizedBox(
                                    height: 15,
                                  )
                                : SizedBox(height: 50),
                            Visibility(
                              visible: confirmRecipient,
                              child: Column(
                                children: [
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
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomText(
                                          text: "Add to beneficiary list"),
                                      Switch(
                                          activeColor: Colors.white,
                                          activeTrackColor: appColor,
                                          value: addToBeneficiary,
                                          onChanged: (x) {
                                            addToBeneficiary = x;
                                            setState(() {});
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            loading
                                ? Center(child: CircularProgressIndicator())
                                : GradientButton(
                                    title: "Proceed",
                                    textClr: Colors.white,
                                    clrs: confirmRecipient
                                        ? [appColor, appColor]
                                        : [gd5, gd5],
                                    onpressed: confirmRecipient
                                        ? () async {
                                            loading = true;
                                            setState(() {});
                                            dio.Response response =
                                                await HttpService.postFromDio(
                                                    Api.withdraw,
                                                    {
                                                      "account_number":
                                                          recipientAccountNo
                                                              .text,
                                                      "bank_id": bankId,
                                                      "country_id": countryId,
                                                      "narration":
                                                          narrationController
                                                              .text,
                                                      "amount": int.parse(
                                                          amountController
                                                              .text),
                                                      "save_beneficiary":
                                                          addToBeneficiary
                                                    },
                                                    accessToken:
                                                        appProvider.token);
                                            log(response.data.toString());
                                            Map result = response.data;
                                            if (result["status"] == "Success") {
                                              loading = false;
                                              setState(() {});
                                              changeScreenReplacement(
                                                  context,
                                                  SendEnterPin(
                                                    validationUrl:
                                                        result["data"]["url"],
                                                  ));
                                            } else {}
                                          }
                                        : () {},
                                  ),
                          ],
                        ),
                      ),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
