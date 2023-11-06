import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/models/user.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/utils/call_utilities.dart';
import 'package:ant_pay/utils/permissions.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:cometchat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactInfo extends StatefulWidget {
  final String type;
  final User me;
  final AppEntity conversationWith;
  ContactInfo(
      {required this.type, required this.me, required this.conversationWith});

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Provider.of<UserController>(context);
    return Scaffold(
      backgroundColor: appColor,
      body: Stack(
        children: [
          Positioned(
              top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
          userController.getOtherUser == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Container(
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
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20,
                                  color: gd2,
                                ),
                              ),
                              Spacer(),
                              /*CustomText(
                          text: "Edit",
                          color: Colors.white,
                        ),*/
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  userController.getOtherUser!.avatarUrl!),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: CustomText(
                              text: userController.getOtherUser!.displayName!,
                              textAlign: TextAlign.center,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: CustomText(
                              text: userController.getOtherUser!.phone!,
                              textAlign: TextAlign.center,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await Permissions
                                          .cameraAndMicrophonePermissionsGranted()
                                      ? CallUtils.dialAudio(
                                          from: widget.me,
                                          to: (widget.conversationWith as User),
                                          context: context)
                                      : {};
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: gd2),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.call,
                                      size: 20,
                                      color: Colors.white,
                                    )),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                onTap: () async {
                                  await Permissions
                                          .cameraAndMicrophonePermissionsGranted()
                                      ? CallUtils.dialVideo(
                                          from: widget.me,
                                          to: (widget.conversationWith as User),
                                          context: context)
                                      : {};
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: gd2),
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.video_call,
                                        color: Colors.white, size: 20)),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              /* Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: gd2),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.photo_camera,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: gd2),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.sticky_note_2_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                              SizedBox(
                                width: 15,
                              ),*/
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: gd2),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.chat,
                                      color: Colors.white,
                                      size: 20,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
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
                            image: DecorationImage(image: AssetImage(stickers)),
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
                              ListTile(
                                title: CustomText(
                                  text: "Shared Files",
                                  weight: FontWeight.bold,
                                  size: 14,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: appColor,
                                ),
                              ),
                              Divider(),
                              ListTile(
                                title: CustomText(
                                  text: "Share Contacts",
                                  weight: FontWeight.bold,
                                  size: 14,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: appColor,
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
