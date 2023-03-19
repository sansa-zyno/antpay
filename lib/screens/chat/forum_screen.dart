/*import 'dart:convert';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/screens/chat/chat_bottombar.dart';
import 'package:ant_pay/screens/chat/chat_messages.dart';
import 'package:cometchat/models/group.dart';
import 'package:cometchat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForumScreen extends StatefulWidget {
  User me;
  Group conversationWith;
  String type;
  ForumScreen(
      {required this.me, required this.type, required this.conversationWith});
  //final OurUser recipient;
  //final String chatRoomid;
  //ForumScreen(this.recipient, this.chatRoomid);
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SizedBox(height: h * 13.7),
              appProvider.forumData != null
                  ? Expanded(
                      child: ChatMessages(
                          //forum: true,
                          data: appProvider.chatData!,
                          type: widget.type,
                          me: widget.me,
                          conversationWith: widget.conversationWith))
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator()),
            ],
          ),
          /*ChatAppBar(
            icon: Icons.arrow_back,
          ),*/
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatBottomBar(
              me: widget.me,
              conversationWith: widget.conversationWith,
              forum: true,
            ),
          ),
        ],
      ),
    );
  }
}*/
