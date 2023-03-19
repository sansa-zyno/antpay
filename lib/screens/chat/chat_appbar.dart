import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/utils/call_utilities.dart';
import 'package:ant_pay/utils/permissions.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  //final OurUser recipient;
  final String type;
  final User me;
  final AppEntity conversationWith;

  ChatAppBar(
      {
      //required this.recipient,
      required this.me,
      required this.type,
      required this.conversationWith});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return Container(
      height: 100,
      width: double.infinity,
      padding: EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
          color: Color(0xFF6E01CE),
          border: Border(bottom: BorderSide(width: 1.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15,
          ),
          InkWell(
            child: Icon(Icons.arrow_back_ios, color: Color(0xffADFFE1)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  type == ConversationType.user
                      ? (conversationWith as User).avatar != null &&
                              (conversationWith as User).avatar != ""
                          ? Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  shape: BoxShape.circle),
                              child: CircularProfileAvatar(
                                (conversationWith as User).avatar.toString(),
                                radius: 25,
                                borderColor: appColor,
                                borderWidth: 3.0,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  shape: BoxShape.circle),
                              child: CircularProfileAvatar(
                                "",
                                radius: 25,
                                borderColor: appColor,
                                borderWidth: 3.0,
                                child: Image.asset(user),
                              ),
                            )
                      : (conversationWith as Group).icon != null &&
                              (conversationWith as Group).icon != ""
                          ? Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  shape: BoxShape.circle),
                              child: CircularProfileAvatar(
                                (conversationWith as Group).icon.toString(),
                                radius: 25,
                                borderColor: appColor,
                                borderWidth: 3.0,
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(0xff6E01CE), width: 3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text((conversationWith as Group)
                                      .name
                                      .substring(0, 2)
                                      .toUpperCase()),
                                ),
                              ),
                            ),
                  SizedBox(width: w * 3.6),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: w * 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: type == ConversationType.user
                              ? Text(
                                  (conversationWith as User).name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 4.8,
                                  ),
                                )
                              : Text(
                                  (conversationWith as Group).name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 4.8,
                                  ),
                                ),
                        ),

                        /*Flexible(
                          child: Text(
                            "Online",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 4.8,
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          type == ConversationType.user
              ? InkWell(
                  onTap: () async {
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? CallUtils.dialAudio(
                            from: me,
                            to: (conversationWith as User),
                            context: context)
                        : {};
                  },
                  child: Icon(Icons.call, color: Color(0xffADFFE1)))
              : Container(),
          SizedBox(
            width: 15,
          ),
          type == ConversationType.user
              ? InkWell(
                  onTap: () async {
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? CallUtils.dialVideo(
                            from: me,
                            to: (conversationWith as User),
                            context: context)
                        : {};
                  },
                  child: Icon(Icons.video_call, color: Color(0xffADFFE1)))
              : Container(),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
