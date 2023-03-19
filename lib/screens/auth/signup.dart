import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  TextEditingController? phone;
  final Function? onpressed;

  SignUp({this.onpressed, this.phone});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String isoCode = "";
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
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 90,
                      ),
                      CustomText(
                        text: "Continue with Phone Number",
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 90,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: CustomText(
                          text:
                              "Please confirm your country code and enter your phone number ",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 90,
                      ),
                      Container(
                        height: 54,
                        width: 283,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        child: ListTile(
                          leading: CustomText(
                            text: appProvider.countrySelected,
                            color: appColor,
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                showCountryPicker(
                                  context: context,
                                  showSearch: false,
                                  showPhoneCode:
                                      false, // optional. Shows phone code before the country name.
                                  onSelect: (Country country) {
                                    print(
                                        'Select country: ${country.displayName}');
                                    appProvider.setCountrySelected(
                                        country.displayName);
                                    appProvider
                                        .setDialCode("+${country.phoneCode}");
                                  },
                                );
                              },
                              color: appColor),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Container(
                          width: 283,
                          height: 54,
                          child: Row(
                            children: [
                              Container(
                                  height: 54,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right:
                                              BorderSide(color: Colors.grey))),
                                  child: Center(
                                    child: CustomText(
                                      text: appProvider.dialcode,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: widget.phone,
                                            decoration: InputDecoration(
                                                hintText: "Phone number",
                                                border: InputBorder.none),
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      GradientButton(
                          title: "Continue",
                          textClr: Colors.white,
                          clrs: [appColor, appColor],
                          onpressed: () {
                            widget.onpressed!(appProvider.countrySelected,
                                appProvider.dialcode);
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildButton(CountryCode isoCode) {
    return Row(
      children: <Widget>[
        Text(
          '$isoCode',
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
