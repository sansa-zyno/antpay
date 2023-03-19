import 'dart:developer';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/screens/chat/chat_screen.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:provider/provider.dart';
import 'package:ant_pay/constants/app_images.dart' as img;

class Messages extends StatefulWidget {
  String username;
  Messages({Key? key, required this.username}) : super(key: key);
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  User? me;
  getCurrentUser() async {
    me = await CometChat.getLoggedInUser();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return appProvider.listConversation != null && me != null
        ? appProvider.listConversation!.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: ListView.separated(
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: appProvider.listConversation!.length,
                      itemBuilder: (cxt, index) {
                        return ChatRoomListTile(
                            id: appProvider
                                .listConversation![index].conversationId!,
                            me: me!,
                            conversationType: appProvider
                                .listConversation![index].conversationType,
                            lastMessage: appProvider
                                .listConversation![index].lastMessage,
                            conversationWith: appProvider
                                .listConversation![index].conversationWith,
                            unreadMessageCount: appProvider
                                .listConversation![index].unreadMessageCount!);
                      },
                      separatorBuilder: (ctx, index) => Divider(),
                    ),
                  )
                ],
              )
            : Center(child: Text("No recent messages to show"))
        : Center(child: CircularProgressIndicator());
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String id;
  final String conversationType;
  final BaseMessage? lastMessage;
  final User me;
  final AppEntity conversationWith;
  final int unreadMessageCount;
  ChatRoomListTile(
      {required this.conversationType,
      required this.conversationWith,
      required this.me,
      required this.id,
      required this.lastMessage,
      required this.unreadMessageCount});
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String timesAgo = "";

  /*String calcTimesAgo(DateTime dt) {
    Duration dur = DateTime.now().difference(dt);
    print(dur.inHours);
    if (dur.inSeconds < 60) {
      return dur.inSeconds == 1
          ? "${dur.inSeconds} sec ago"
          : "${dur.inSeconds} sec ago";
    }
    if (dur.inMinutes >= 1 && dur.inMinutes < 60) {
      return dur.inMinutes == 1
          ? "${dur.inMinutes} min ago"
          : "${dur.inMinutes} mins ago";
    }
    if (dur.inHours >= 1 && dur.inHours < 60) {
      return dur.inHours == 1
          ? "${dur.inHours} hour ago"
          : "${dur.inHours} hours ago";
    }
    if (dur.inHours > 60) {
      DateTime dateNow =
          DateTime.parse(DateTime.now().toString().substring(0, 10));
      DateTime dte = DateTime.parse(dt.toString().substring(0, 10));
      String date = dateNow.compareTo(dte) == 0
          ? "Today"
          : "${dte.year} ${dte.month} ${dte.day}" ==
                  "${dateNow.year} ${dateNow.month} ${(dateNow.day) - 1}"
              ? "Yesterday"
              : formatDate(dte, [M, ' ', dd, ', ', yyyy]);
      return date;
    }
    return "";
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //timesAgo = calcTimesAgo(DateTime.parse(widget.dateString));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return Builder(builder: (context) {
      late User user;
      late Group group;
      if (widget.conversationType == ConversationType.user) {
        user = widget.conversationWith as User;
      } else {
        group = widget.conversationWith as Group;
      }

      return InkWell(
        onTap: () {
          /* await HttpService.post("", {
              "username": widget.receiverName,
              "messageid": widget.chatId,
              "message": widget.lastMessage
            });*/
          widget.conversationType == ConversationType.user
              ? appProvider.getChatData(user.uid, ConversationType.user, true)
              : appProvider.getChatData(
                  group.guid, ConversationType.group, true);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ChatScreen(
                        me: widget.me,
                        type: widget.conversationType,
                        conversationWith: widget.conversationWith,
                        conversationId: widget.id,
                      )));
          //appProvider.RecentChatData(widget.receiverName);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8.0),
          child: Row(
            children: [
              Stack(
                children: [
                  widget.conversationType == ConversationType.user
                      ? user.avatar != null && user.avatar != ""
                          ? Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff6E01CE), width: 3),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(user.avatar!),
                                      fit: BoxFit.cover)),
                            )
                          : Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff6E01CE), width: 3),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(img.user),
                                      fit: BoxFit.cover)),
                            )
                      : group.icon != null && group.icon != ""
                          ? Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff6E01CE), width: 3),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(group.icon!),
                                      fit: BoxFit.cover)),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0xff6E01CE), width: 3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                    group.name.substring(0, 2).toUpperCase()),
                              ),
                            )

                  /* Positioned(
                        top: 0,
                        right: 2,
                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red),
                            child: Center(
                                child: Text('5',
                                    style: TextStyle(color: Colors.white)))))*/
                ],
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversationType == ConversationType.user
                        ? user.name
                        : group.name,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff4B0973),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  widget.lastMessage is TextMessage
                      ? Builder(builder: (context) {
                          TextMessage message =
                              widget.lastMessage as TextMessage;
                          return Container(
                            width: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    message.text,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      : widget.lastMessage is CustomMessage
                          ? Builder(builder: (context) {
                              return Container();
                              /* CustomMessage message =
                                  widget.lastMessage as CustomMessage;
                              return Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: message.customData != null
                                            ? Image.network(
                                                message.customData![
                                                        "sticker_url"] ??
                                                    "",
                                                height: 60,
                                                width: 60,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  ],
                                ),
                              );*/
                            })
                          : widget.lastMessage is MediaMessage
                              ? Builder(builder: (context) {
                                  MediaMessage mediaMessage =
                                      widget.lastMessage as MediaMessage;
                                  log(mediaMessage.attachment.toString());
                                  return Container(
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Opacity(
                                          opacity: 1,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: mediaMessage.attachment !=
                                                        null &&
                                                    mediaMessage.attachment!
                                                            .fileUrl !=
                                                        ""
                                                ? Image.network(
                                                    mediaMessage
                                                        .attachment!.fileUrl
                                                        .toString(),
                                                    height: 60,
                                                    width: 60,
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              : Builder(builder: (context) {
                                  Action? action =
                                      widget.lastMessage as Action?;
                                  log(action.toString());
                                  return Container(
                                    width: 200,
                                    child: action != null
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  action.message,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  );
                                })
                ],
              ),
              Expanded(
                  child: Text(
                timesAgo,
                // style: TextStyle(color: mycolor),
              ))
            ],
          ),
        ),
      );
    });
  }
}
