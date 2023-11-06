import 'dart:async';
import 'dart:convert';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/chat/chat_appbar.dart';
import 'package:ant_pay/screens/chat/chat_bottombar.dart';
import 'package:ant_pay/screens/chat/chat_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  User me;
  String type;
  AppEntity conversationWith;
  String conversationId;
  ChatScreen(
      {required this.me,
      required this.type,
      required this.conversationWith,
      required this.conversationId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with MessageListener {
  late AppProvider appProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CometChat.addMessageListener("listenerId", this);
    appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getStickers();
    appProvider.getCustomStickers();
    getUser();
  }

  getUser() async {
    if (widget.type == ConversationType.user) {
      List uids = [];
      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection("users").get();
      for (int i = 0; i < snap.docs.length; i++) {
        uids.add(snap.docs[i]["uid"].toString());
      }
      List res = uids
          .where((element) =>
              element.toString().toLowerCase() ==
              (widget.conversationWith as User).uid)
          .toList();
      String userId = res[0];
      UserController userController =
          Provider.of<UserController>(context, listen: false);
      userController.getUserInfo(userId);
    }
  }

  @override
  void onTextMessageReceived(TextMessage textMessage) {
    debugPrint("Text message received successfully: $textMessage");

    CometChat.markAsDelivered(textMessage, onSuccess: (String unused) {
      debugPrint("markAsDelivered : $unused ");
    }, onError: (CometChatException e) {
      debugPrint("markAsDelivered unsuccessful : ${e.message} ");
    });
    CometChat.markAsRead(textMessage, onSuccess: (String unused) {
      debugPrint("markAsRead : $unused ");
    }, onError: (CometChatException e) {
      debugPrint("markAsRead unsuccessfull : ${e.message} ");
    });
    widget.type == ConversationType.user
        ? appProvider.getChatData(
            textMessage.sender!.uid, ConversationType.user, false)
        : appProvider.getChatData((widget.conversationWith as Group).guid,
            ConversationType.group, false);
  }

  @override
  void onMediaMessageReceived(MediaMessage mediaMessage) {
    debugPrint("Media message received successfully: $mediaMessage");
    CometChat.markAsDelivered(mediaMessage, onSuccess: (String unused) {
      debugPrint("markAsDelivered : $unused ");
    }, onError: (CometChatException e) {
      debugPrint("markAsDelivered unsuccessful : ${e.message} ");
    });
    CometChat.markAsRead(mediaMessage, onSuccess: (String unused) {
      debugPrint("markAsRead : $unused ");
    }, onError: (CometChatException e) {
      debugPrint("markAsRead unsuccessfull : ${e.message} ");
    });
    widget.type == ConversationType.user
        ? appProvider.getChatData(
            mediaMessage.sender!.uid, ConversationType.user, false)
        : appProvider.getChatData((widget.conversationWith as Group).guid,
            ConversationType.group, false);
  }

  @override
  void onCustomMessageReceived(CustomMessage customMessage) {
    debugPrint("Custom message received successfully: $customMessage");
    CometChat.markAsDelivered(customMessage, onSuccess: (String unused) {
      debugPrint("markAsDelivered : $unused ");
    }, onError: (CometChatException e) {
      debugPrint("markAsDelivered unsuccessful : ${e.message} ");
    });
    CometChat.markAsRead(customMessage, onSuccess: (String unused) {
      debugPrint("markAsRead : $unused ");
    }, onError: (CometChatException e) {
      debugPrint("markAsRead unsuccessfull : ${e.message} ");
    });
    widget.type == ConversationType.user
        ? appProvider.getChatData(
            customMessage.sender!.uid, ConversationType.user, false)
        : appProvider.getChatData((widget.conversationWith as Group).guid,
            ConversationType.group, false);
  }

  @override
  void onMessagesDelivered(MessageReceipt messageReceipt) {
    // TODO: implement onMessagesDelivered
    widget.type == ConversationType.user
        ? appProvider.getChatData(
            messageReceipt.sender.uid, ConversationType.user, false)
        : appProvider.getChatData((widget.conversationWith as Group).guid,
            ConversationType.group, false);
  }

  @override
  void onMessagesRead(MessageReceipt messageReceipt) {
    // TODO: implement onMessagesRead
    widget.type == ConversationType.user
        ? appProvider.getChatData(
            messageReceipt.sender.uid, ConversationType.user, false)
        : appProvider.getChatData((widget.conversationWith as Group).guid,
            ConversationType.group, false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    CometChat.removeMessageListener("listenerId");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    appProvider = Provider.of<AppProvider>(context);

    return Container(
      decoration: BoxDecoration(
          //image: DecorationImage(image: AssetImage(stickers3)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6E01CE), Color(0xFF1F0138)],
              stops: [0.0, 1.0]),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 4),
                blurRadius: 4.0)
          ]),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 90),
                appProvider.chatData != null
                    ? Expanded(
                        child: ChatMessages(
                        data: appProvider.chatData!,
                        type: widget.type,
                        me: widget.me,
                        conversationWith: widget.conversationWith,
                      ))
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: CircularProgressIndicator()),
              ],
            ),
            ChatAppBar(
                me: widget.me,
                type: widget.type,
                conversationWith: widget.conversationWith),
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatBottomBar(
                  me: widget.me,
                  conversationWith: widget.conversationWith,
                  type: widget.type),
            ),
          ],
        ),
      ),
    );
  }
}
