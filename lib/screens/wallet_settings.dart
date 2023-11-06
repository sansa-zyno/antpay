import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/double_auth.dart';
import 'package:ant_pay/screens/identity_verification1.dart';
import 'package:ant_pay/screens/identity_verification2.dart';
import 'package:ant_pay/screens/transactions/set_pin.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletSettings extends StatefulWidget {
  const WalletSettings({Key? key}) : super(key: key);

  @override
  State<WalletSettings> createState() => _WalletSettingsState();
}

class _WalletSettingsState extends State<WalletSettings> {
  late UserController userController;

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
                          text: "Wallet Settings",
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.person,
                            color: appColor,
                          ),
                          title: CustomText(
                            text: "Identity Verification",
                            color: appColor,
                          ),
                          subtitle: CustomText(
                            text:
                                "Verify your account with your valid documents ",
                            size: 10,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: appColor,
                          ),
                          onTap: () {
                            /*userController.getCurrentUser.isReadyForTxn!
                                ? changeScreen(context, IdentityVerification2())
                                : changeScreen(
                                    context, IdentityVerification1());*/
                            changeScreen(context, IdentityVerification2());
                          },
                        ),
                        /* ListTile(
                          leading: Icon(
                            Icons.fingerprint,
                            color: appColor,
                          ),
                          title: CustomText(
                            text: "Use FingerPrint",
                            color: appColor,
                          ),
                          trailing: Switch(
                              activeColor: Colors.white,
                              activeTrackColor: appColor,
                              value: true,
                              onChanged: (x) {}),
                        ),*/
                        ListTile(
                          leading: Icon(
                            Icons.wallet,
                            color: appColor,
                          ),
                          title: CustomText(
                            text: "Show Wallet Balance",
                            color: appColor,
                          ),
                          trailing: Switch(
                              activeColor: Colors.white,
                              activeTrackColor: appColor,
                              value: true,
                              onChanged: (x) {}),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.verified_user,
                            color: appColor,
                          ),
                          title: CustomText(
                            text: "Double Authentication",
                            color: appColor,
                          ),
                          trailing: Switch(
                              activeColor: Colors.white,
                              activeTrackColor: appColor,
                              value: true,
                              onChanged: (x) {}),
                          onTap: () {
                            changeScreen(context, DoubleAuth());
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.lock,
                            color: appColor,
                          ),
                          title: CustomText(
                            text: "Set Transaction Pin",
                            color: appColor,
                          ),
                          subtitle: CustomText(
                            text: "Set up your 5-digit transaction pin",
                            size: 10,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: appColor,
                          ),
                          onTap: () {
                            changeScreen(context, SetPin());
                          },
                        ),
                        /*ListTile(
                            leading: Icon(
                              Icons.cake,
                              color: appColor,
                            ),
                            title: CustomText(
                              text: "Stick 'n' Earn ",
                              color: appColor,
                            ),
                            subtitle: CustomText(
                              text:
                                  "Invite your friends with stickers and get \$1 per referral. ",
                              size: 10,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: appColor,
                            )),*/
                        ListTile(
                            leading: Icon(
                              Icons.headphones,
                              color: appColor,
                            ),
                            title: CustomText(
                              text: "Support",
                              color: appColor,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: appColor,
                            ))
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
