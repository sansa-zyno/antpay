import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/curved_textfield.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as dio;

class IdentityVerification2 extends StatefulWidget {
  const IdentityVerification2({Key? key}) : super(key: key);

  @override
  State<IdentityVerification2> createState() => _IdentityVerification2State();
}

class _IdentityVerification2State extends State<IdentityVerification2> {
  //TextEditingController idController = TextEditingController();
  TextEditingController bvnSsnController = TextEditingController();
  PlatformFile? file;
  bool expanded = false;
  String issuedDate = "";
  String expiryDate = "";

  bool a = false;
  bool b = false;
  bool c = false;
  String docType = "Select Document Type";

  List items = ["BVN", "SSN"];
  String val = "BVN";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    UserController userController = Provider.of<UserController>(context);
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
                          text: "Identity Verification",
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Spacer(),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text:
                              "Fill in the requied details as appeared on your valid ID ",
                          size: 12,
                          color: Colors.white,
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          CustomText(
                            text: "Document Type",
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
                              child: ExpansionTile(
                                expandedAlignment: Alignment.centerLeft,
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                onExpansionChanged: (x) {
                                  expanded = x;
                                  setState(() {});
                                },
                                title: Text(docType,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                                trailing: Icon(Icons.arrow_drop_down,
                                    color: appColor),
                                children: [
                                  InkWell(
                                      onTap: () {
                                        a = true;
                                        b = false;
                                        c = false;
                                        docType = "National Id";
                                        setState(() {});
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: a
                                                  ? appColor
                                                  : Colors.transparent),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          child: Row(
                                            children: [
                                              Text("National Id",
                                                  style: TextStyle(
                                                      color: a
                                                          ? Colors.white
                                                          : Colors.black)),
                                            ],
                                          ))),
                                  InkWell(
                                      onTap: () {
                                        a = false;
                                        b = true;
                                        c = false;
                                        docType = "International Passport";
                                        setState(() {});
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: b
                                                  ? appColor
                                                  : Colors.transparent),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          child: Row(
                                            children: [
                                              Text("International Passport",
                                                  style: TextStyle(
                                                      color: b
                                                          ? Colors.white
                                                          : Colors.black)),
                                            ],
                                          ))),
                                  InkWell(
                                      onTap: () {
                                        a = false;
                                        b = false;
                                        c = true;
                                        docType = "Driver's License";
                                        setState(() {});
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: c
                                                  ? appColor
                                                  : Colors.transparent),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          child: Row(
                                            children: [
                                              Text("Driver's License",
                                                  style: TextStyle(
                                                      color: c
                                                          ? Colors.white
                                                          : Colors.black)),
                                            ],
                                          ))),
                                ],
                              )),
                          /* SizedBox(
                            height: 15,
                          ),
                          CustomText(
                            text: "ID Number",
                            color: appColor,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CurvedTextField(
                            hint: "",
                            controller: idController,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 283,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Date Issued",
                                      color: appColor,
                                      weight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        DateTime? date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime.now());
                                        if (date != null) {
                                          issuedDate =
                                              "${date.year}-${date.month}-${date.day}";
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 130,
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
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(Icons.date_range),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            CustomText(text: issuedDate)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Expiry Date",
                                      color: appColor,
                                      weight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        DateTime? date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime.now());
                                        if (date != null) {
                                          expiryDate =
                                              "${date.year}-${date.month}-${date.day}";
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 130,
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
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(Icons.date_range),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            CustomText(text: expiryDate)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),*/
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButton<String>(
                              value: val,
                              icon: Container(),
                              underline: Container(),
                              style: TextStyle(color: Colors.black),
                              items: items
                                  .map<DropdownMenuItem<String>>(
                                      (value) => DropdownMenuItem(
                                          value: value,
                                          child: CustomText(
                                            text: "$value",
                                            color: appColor,
                                            weight: FontWeight.bold,
                                          )))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  val = value!;
                                });
                              }),
                          CurvedTextField(
                            hint: "",
                            controller: bvnSsnController,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          file == null
                              ? InkWell(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles();
                                    if (result != null) {
                                      file = result.files.single;
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.upload,
                                          color: appColor,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        CustomText(
                                          text: "Upload Document",
                                          color: appColor,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 25),
                                      child: Text(
                                        file!.name,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 0,
                                        child: InkWell(
                                            onTap: () {
                                              file = null;
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )))
                                  ],
                                ),
                          SizedBox(
                            height: 100,
                          ),
                          loading
                              ? Center(child: CircularProgressIndicator())
                              : GradientButton(
                                  title: "Verify",
                                  textClr: gd2,
                                  clrs: [appColor, appColor],
                                  onpressed: () async {
                                    loading = true;
                                    setState(() {});
                                    Response response =
                                        await HttpService.postRequest(
                                            Api.kyc,
                                            {
                                              "name": val.toLowerCase(),
                                              "id_number": bvnSsnController.text
                                            },
                                            bearerToken: true,
                                            accessToken: appProvider.token);
                                    Map result = jsonDecode(response.body);
                                    log(result.toString());
                                    if (result["status"]) {
                                      if (file != null) {
                                        try {
                                          dio.Response response =
                                              await HttpService.postWithFiles(
                                                  Api.docVerification, {
                                            "attachment":
                                                dio.MultipartFile.fromBytes(
                                                    File(file!.path!)
                                                        .readAsBytesSync(),
                                                    filename: file!.name),
                                            "name": file!.name
                                          });
                                          log(response.data.toString());
                                        } catch (e) {
                                          log("Error verifying documents");
                                        }
                                      }

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "isKycDone": true,
                                      });
                                      loading = false;
                                      setState(() {});
                                      userController.getCurrentUserInfo();
                                      AchievementView(
                                        color: Colors.green,
                                        icon: Icon(
                                          FontAwesomeIcons.check,
                                          color: Colors.white,
                                        ),
                                        title: "Successfull !",
                                        elevation: 20,
                                        subTitle: result["message"],
                                        isCircle: true,
                                      ).show(context);
                                      Navigator.pop(context);
                                    } else {
                                      loading = false;
                                      setState(() {});
                                      Get.defaultDialog(
                                          title: "Error",
                                          middleText: result["message"]);
                                    }
                                  },
                                ),
                          /*SizedBox(
                            height: 8,
                          ),
                          Container(
                              width: 283,
                              alignment: Alignment.center,
                              child: CustomText(
                                text: "Step 2 of 2",
                                color: appColor,
                              ))*/
                        ],
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
