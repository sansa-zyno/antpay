import 'dart:convert';
import 'dart:developer';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IdentityVerification1 extends StatefulWidget {
  const IdentityVerification1({Key? key}) : super(key: key);

  @override
  State<IdentityVerification1> createState() => _IdentityVerification1State();
}

class _IdentityVerification1State extends State<IdentityVerification1> {
  late AppProvider appProvider;
  late UserController userController;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  // TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  bool loading = false;
  String countryUid = "";
  String countryName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getCountries();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    userController = Provider.of<UserController>(context);
    return Container(
      /*onWillPop: () async {
        bool result = false;
        if (loading) {
          result = false;
        } else {
          result = true;
        }
        return result;
      },*/
      child: Scaffold(
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
                      SizedBox(height: titleBarOffset),
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
                                "Fill in the required information to verify your identity",
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
                              text: "First Name",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CurvedTextField(
                              hint: "Enter first name",
                              controller: firstname,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            CustomText(
                              text: "Last Name",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CurvedTextField(
                              hint: "Enter last name",
                              controller: lastname,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            CustomText(
                              text: "Email",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CurvedTextField(
                              hint: "Enter email address",
                              controller: email,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            CustomText(
                              text: "Country Of Origin",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
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
                                /*visualDensity: VisualDensity(
                                    horizontal: 0, vertical: -4),*/
                                title: Text(
                                  countryName.isEmpty
                                      ? "Select Country"
                                      : countryName,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    if (appProvider.countries.isNotEmpty) {
                                      await showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15))),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    text: "Select Country",
                                                    color: appColor,
                                                    size: 16,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      )),
                                                ],
                                              ),
                                              insetPadding: EdgeInsets.all(0),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                    children: List.generate(
                                                        appProvider
                                                            .countries.length,
                                                        (index) => ListTile(
                                                              onTap: () {
                                                                countryUid =
                                                                    appProvider.countries[
                                                                            index]
                                                                        ["uid"];
                                                                countryName =
                                                                    appProvider.countries[
                                                                            index]
                                                                        [
                                                                        "name"];
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              leading:
                                                                  SvgPicture
                                                                      .network(
                                                                appProvider.countries[
                                                                        index]
                                                                    ["flag"],
                                                                placeholderBuilder:
                                                                    (BuildContext
                                                                            context) =>
                                                                        Container(
                                                                  width: 40,
                                                                ),
                                                                width: 40,
                                                              ),
                                                              title: Text(appProvider
                                                                      .countries[
                                                                  index]["name"]),
                                                            ))),
                                              )));
                                    } else {
                                      appProvider.getCountries();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            /* SizedBox(
                              height: 15,
                            ),
                            CustomText(
                              text: "Password",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CurvedTextField(
                              hint: "Enter password",
                              obsecureText: true,
                              controller: password,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CustomText(
                              text: "Confirm Password",
                              color: appColor,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CurvedTextField(
                              hint: "Confirm password",
                              obsecureText: true,
                              controller: cpassword,
                            ),*/
                            SizedBox(
                              height: 100,
                            ),
                            loading
                                ? Center(child: CircularProgressIndicator())
                                : GradientButton(
                                    title: "Submit",
                                    textClr: gd2,
                                    clrs: [appColor, appColor],
                                    onpressed: () {
                                      log(userController.getCurrentUser.phone!);
                                      registerOnAntpay();
                                    },
                                  ),
                            SizedBox(
                              height: 50,
                            ),
                            /*Container(
                                width: 283,
                                alignment: Alignment.center,
                                child: CustomText(
                                  text: "Step 1 of 2",
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
      ),
    );
  }

  registerOnAntpay() async {
    loading = true;
    setState(() {});
    Response response = await HttpService.postRequest(Api.register, {
      "first_name": firstname.text.trim(),
      "last_name": lastname.text.trim(),
      "email": email.text.trim(),
      "phone": userController.getCurrentUser.phone,
      "country_id": countryUid,
      "password":
          "${firstname.text.capitalizeFirst.toString() + "_${userController.getCurrentUser.phone}"}",
      "password_confirmation":
          "${firstname.text.capitalizeFirst.toString() + "_${userController.getCurrentUser.phone}"}"
    });
    Map result = jsonDecode(response.body);
    log(result.toString());
    if (result["status"]) {
      appProvider.setToken(result["data"]["token"]);
      updateDataOnFB(result["data"]["uid"]).then((value) {
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
      });
    } else {
      loading = false;
      setState(() {});
      Get.defaultDialog(title: "Error", middleText: result["message"]);
    }
  }

  Future updateDataOnFB(String userId) async {
    log("${firstname.text.capitalizeFirst.toString() + "_${FirebaseAuth.instance.currentUser!.phoneNumber}"}");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "email": email.text.trim(),
      "firstname": firstname.text.capitalizeFirst.toString(),
      "lastname": lastname.text.capitalizeFirst.toString(),
      "isReadyForTxn": true,
      "userId": userId
    });
    loading = false;
    setState(() {});
  }
}
