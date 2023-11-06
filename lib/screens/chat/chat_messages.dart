import 'dart:developer';
import 'dart:io';

import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/scheduler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatefulWidget {
  List<BaseMessage> data;
  User me;
  String type;
  AppEntity conversationWith;

  ChatMessages({
    required this.data,
    required this.me,
    required this.type,
    required this.conversationWith,
  });

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  int idx = -1;
  ScrollController? scrollController;
  late AppProvider appProvider;

  Widget chatMessageTile(TextMessage textMessage, String time, h, w) {
    log(textMessage.sender!.uid);
    log(widget.me.uid);
    return textMessage.sender!.uid == widget.me.uid.toLowerCase()
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFD4A3FF),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /* Flexible(
                                  child: reply != ""
                                      ? reply.contains("uploads/images/")
                                          ? Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff4B0973),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Image.network(
                                                "https://pboforum.com/office/$reply",
                                                height: 40,
                                                width: 40,
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff4B0973),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Text(
                                                reply,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Nunito",
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            )
                                      : Container(
                                          width: 3,
                                        ),
                                ),*/
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              textMessage.text,
                              style: TextStyle(
                                  fontSize: 16.0, fontFamily: "Helvetica"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              time,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            textMessage.readAt != null
                                ? Stack(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: gd2,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Icon(
                                          Icons.check,
                                          color: gd2,
                                        ),
                                      ),
                                    ],
                                  )
                                : textMessage.deliveredAt != null
                                    ? Stack(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: Colors.grey,
                                      ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      widget.type != ConversationType.user
                          ? Text(
                              (widget.me.name),
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFFD4A3FF)),
                            )
                          : Container()
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                widget.type != ConversationType.user
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                            height: 40,
                            width: 40,
                            imageUrl: widget.me.avatar ?? "",
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                          value: progress.progress),
                                    )))
                    : Container()
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.type != ConversationType.user
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                            height: 40,
                            width: 40,
                            imageUrl: widget.type == ConversationType.user
                                ? (widget.conversationWith as User).avatar ?? ""
                                : textMessage.sender!.avatar ?? "",
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                          value: progress.progress),
                                    )))
                    : Container(),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        constraints: BoxConstraints(maxWidth: 200),
                        decoration: BoxDecoration(
                          color: Color(0xffADFFE1),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /*reply != ""
                                    ? reply.contains("uploads/images/")
                                        ? Flexible(
                                            child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 197, 207, 243),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Image.network(
                                                  "https://pboforum.com/office/$reply",
                                                  height: 40,
                                                  width: 40,
                                                )),
                                          )
                                        : Flexible(
                                            child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 197, 207, 243),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Text(
                                                  reply,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: "Nunito"),
                                                )),
                                          )
                                    : Container(
                                        width: 3,
                                      ),*/
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              textMessage.text,
                              style: TextStyle(
                                  fontSize: 16.0, fontFamily: "Helvetica"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        time,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      widget.type != ConversationType.user
                          ? Text(
                              widget.type == ConversationType.user
                                  ? (widget.conversationWith as User).name
                                  : textMessage.sender!.name,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xffADFFE1)),
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget imageMessageTile(MediaMessage mediaMessage, String time) {
    List imageExtensions = ["jpg", "png", "jpeg"];
    //log(mediaMessage.attachment!.fileExtension);
    return mediaMessage.attachment != null
        ? mediaMessage.sender!.uid == widget.me.uid.toLowerCase()
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Icon(Icons.phone,color: const Color(0xff7672c9),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            final url = mediaMessage.attachment!.fileUrl;
                            final filename = mediaMessage.attachment!.fileUrl
                                .split("/")
                                .last;
                            var request =
                                await HttpClient().getUrl(Uri.parse(url));
                            var response = await request.close();
                            var bytes =
                                await consolidateHttpClientResponseBytes(
                                    response);
                            var dir = await getApplicationDocumentsDirectory();
                            File file = File("${dir.path}/$filename");
                            await file.writeAsBytes(bytes, flush: true);
                            OpenFilex.open(file.path);
                          },
                          child: Column(
                            children: [
                              /*reply != ""
                                  ? reply.contains("uploads/images/")
                                      ? Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color(0xff4B0973),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Image.network(
                                            "https://pboforum.com/office/$reply",
                                            height: 40,
                                            width: 40,
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color(0xff4B0973),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Text(
                                            reply,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Nunito",
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        )
                                  : Container(),*/
                              SizedBox(
                                height: 8,
                              ),
                              mediaMessage.attachment != null &&
                                      mediaMessage.attachment!.fileUrl != ""
                                  ? imageExtensions.contains(mediaMessage
                                          .attachment!.fileExtension)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          child: Image.network(
                                            mediaMessage.attachment!.fileUrl,
                                            height: 90,
                                          ),
                                        )
                                      : Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 200),
                                          child: Text(
                                            mediaMessage.attachment!.fileUrl
                                                .split("/")
                                                .last,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFFD4A3FF),
                                                decoration:
                                                    TextDecoration.underline,
                                                fontFamily: "Helvetica"),
                                          ),
                                        )
                                  : Container(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                time,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              mediaMessage.readAt != null
                                  ? Stack(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: gd2,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.check,
                                            color: gd2,
                                          ),
                                        ),
                                      ],
                                    )
                                  : mediaMessage.deliveredAt != null
                                      ? Stack(
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: Colors.grey,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Icon(
                                          Icons.check,
                                          color: Colors.grey,
                                        ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        widget.type != ConversationType.user
                            ? Text(
                                widget.me.name,
                                style: TextStyle(color: Color(0xFFD4A3FF)),
                              )
                            : Container()
                      ],
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    widget.type != ConversationType.user
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                                height: 40,
                                width: 40,
                                imageUrl: widget.me.avatar ?? "",
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                          child: CircularProgressIndicator(
                                              value: progress.progress),
                                        )))
                        : Container()
                  ],
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Icon(Icons.phone,color: const Color(0xff7672c9),),

                    widget.type != ConversationType.user
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                                height: 40,
                                width: 40,
                                imageUrl: widget.type == ConversationType.user
                                    ? (widget.conversationWith as User)
                                            .avatar ??
                                        ""
                                    : mediaMessage.sender!.avatar ?? "",
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                          child: CircularProgressIndicator(
                                              value: progress.progress),
                                        )))
                        : Container(),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            final url = mediaMessage.attachment!.fileUrl;
                            final filename = mediaMessage.attachment!.fileUrl
                                .split("/")
                                .last;
                            var request =
                                await HttpClient().getUrl(Uri.parse(url));
                            var response = await request.close();
                            var bytes =
                                await consolidateHttpClientResponseBytes(
                                    response);
                            var dir = await getApplicationDocumentsDirectory();
                            File file = File("${dir.path}/$filename");
                            await file.writeAsBytes(bytes, flush: true);
                            OpenFilex.open(file.path);
                          },
                          child: Column(
                            children: [
                              /*reply != ""
                                  ? reply.contains("uploads/images/")
                                      ? Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 197, 207, 243),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Image.network(
                                            "https://pboforum.com/office/$reply",
                                            height: 40,
                                            width: 40,
                                          ))
                                      : Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 197, 207, 243),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Text(
                                            reply,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: "Nunito"),
                                          ))
                                  : Container(),*/
                              SizedBox(
                                height: 8,
                              ),
                              mediaMessage.attachment != null &&
                                      mediaMessage.attachment!.fileUrl != ""
                                  ? imageExtensions.contains(mediaMessage
                                          .attachment!.fileExtension)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          child: Image.network(
                                            mediaMessage.attachment!.fileUrl,
                                            height: 90,
                                          ),
                                        )
                                      : Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 200),
                                          child: Text(
                                            mediaMessage.attachment!.fileUrl
                                                .split("/")
                                                .last,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xffADFFE1),
                                                decoration:
                                                    TextDecoration.underline,
                                                fontFamily: "Helvetica"),
                                          ),
                                        )
                                  : Container(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          time,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        widget.type != ConversationType.user
                            ? Text(
                                widget.type == ConversationType.user
                                    ? (widget.conversationWith as User).name
                                    : mediaMessage.sender!.name,
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xffADFFE1)),
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
              )
        : Container();
  }

  Widget chatMessages(h, w, BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (scrollController!.hasClients) {
        scrollController!.animateTo(
          scrollController!.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    });

    return widget.data.isNotEmpty
        ? ListView.builder(
            itemCount: (widget.data.length + 1),
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.all(0),
            controller: scrollController,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == widget.data.length) {
                return Container(
                  height: 100,
                );
              }
              bool isSameDate = true;
              DateTime dt = widget.data[index].sentAt != null
                  ? DateTime.parse(
                      widget.data[index].sentAt.toString().substring(0, 10))
                  : DateTime.parse("1970-12-02");
              if (index == 0) {
                isSameDate = false;
              } else {
                DateTime dte = widget.data[index - 1].sentAt != null
                    ? DateTime.parse(widget.data[index - 1].sentAt
                        .toString()
                        .substring(0, 10))
                    : DateTime.parse("1970-12-02"); //date of prev item
                isSameDate =
                    dt.compareTo(dte) == 0 ? true : false; //compare dates
              }
//index == 0 || !(isSameDate)
              if (index == 0 || !(isSameDate)) {
                DateTime dt = widget.data[index].sentAt != null
                    ? DateTime.parse(
                        widget.data[index].sentAt.toString().substring(0, 10))
                    : DateTime.parse("1970-12-02");
                DateTime dateNow =
                    DateTime.parse(DateTime.now().toString().substring(0, 10));
                DateTime dtTime = widget.data[index].sentAt != null
                    ? DateTime.parse(widget.data[index].sentAt.toString())
                    : DateTime.parse("1970-12-02");
                String time = formatDate(dtTime, [hh, ':', nn, ' ', am]);

                String date = dt.compareTo(dateNow) == 0
                    ? "Today"
                    : "${dt.year} ${dt.month} ${dt.day}" ==
                            "${dateNow.year} ${dateNow.month} ${(dateNow.day) - 1}"
                        ? "Yesterday"
                        : formatDate(dt, [M, ' ', dd, ', ', yyyy]);
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: widget.data[index].sender!.uid ==
                            widget.me.uid.toLowerCase()
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          date,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 8),
                      //ListTile(title: Text('item $index'))
                      widget.data[index] is TextMessage
                          ? InkWell(
                              onTap: () {
                                appProvider.updateVal("", "", false, "", "");
                              },
                              onLongPress: () {
                                idx = index;
                                setState(() {});
                                if (index == idx) {
                                  /*appProvider.updateVal(
                                      widget.data[index]["Message"],
                                      "text",
                                      true,
                                      widget.data[index]["Sender"],
                                      widget.data[index]["Chat Id"]);*/
                                }
                              },
                              child: Container(
                                color: index == idx
                                    ? appProvider.reply
                                        ? Colors.blue[100]
                                        : Colors.transparent
                                    : Colors.transparent,
                                child: chatMessageTile(
                                  widget.data[index] as TextMessage,
                                  time,
                                  h,
                                  w,
                                ),
                              ),
                            )
                          : widget.data[index] is MediaMessage
                              ? InkWell(
                                  onTap: () {
                                    appProvider.updateVal(
                                        "", "", false, "", "");
                                  },
                                  onLongPress: () {
                                    idx = index;
                                    setState(() {});
                                    if (index == idx) {
                                      /*appProvider.updateVal(
                                      widget.data[index]["Message"],
                                      "image",
                                      true,
                                      widget.data[index]["Sender"],
                                      widget.data[index]["Chat Id"]);*/
                                    }
                                  },
                                  child: Container(
                                    color: index == idx
                                        ? appProvider.reply
                                            ? Colors.blue[100]
                                            : Colors.transparent
                                        : Colors.transparent,
                                    child: imageMessageTile(
                                        widget.data[index] as MediaMessage,
                                        time),
                                  ),
                                )
                              /* : widget.data[index] is Action
                                  ? Builder(builder: (context) {
                                      Action? action =
                                          widget.data[index] as Action?;
                                      return action != null &&
                                              action.message != ""
                                          ? Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                child: Text(
                                                  action.message,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : Container();
                                    })*/
                              : Container()
                    ]);
              } else {
                DateTime dtTime = widget.data[index].sentAt != null
                    ? DateTime.parse(widget.data[index].sentAt.toString())
                    : DateTime.parse("1970-12-02");
                String time = formatDate(dtTime, [hh, ':', nn, ' ', am]);
                return widget.data[index] is TextMessage
                    ? InkWell(
                        onTap: () {
                          appProvider.updateVal("", "", false, "", "");
                        },
                        onLongPress: () {
                          idx = index;
                          setState(() {});
                          if (index == idx) {
                            /*appProvider.updateVal(
                                      widget.data[index]["Message"],
                                      "text",
                                      true,
                                      widget.data[index]["Sender"],
                                      widget.data[index]["Chat Id"]);*/
                          }
                        },
                        child: Container(
                          color: index == idx
                              ? appProvider.reply
                                  ? Colors.blue[100]
                                  : Colors.transparent
                              : Colors.transparent,
                          child: chatMessageTile(
                            widget.data[index] as TextMessage,
                            time,
                            h,
                            w,
                          ),
                        ),
                      )
                    : widget.data[index] is MediaMessage
                        ? InkWell(
                            onTap: () {
                              appProvider.updateVal("", "", false, "", "");
                            },
                            onLongPress: () {
                              idx = index;
                              setState(() {});
                              if (index == idx) {
                                /*appProvider.updateVal(
                                      widget.data[index]["Message"],
                                      "image",
                                      true,
                                      widget.data[index]["Sender"],
                                      widget.data[index]["Chat Id"]);*/
                              }
                            },
                            child: Container(
                              color: index == idx
                                  ? appProvider.reply
                                      ? Colors.blue[100]
                                      : Colors.transparent
                                  : Colors.transparent,
                              child: imageMessageTile(
                                  widget.data[index] as MediaMessage, time),
                            ),
                          )
                        /*: widget.data[index] is Action
                            ? Builder(builder: (context) {
                                Action? action = widget.data[index] as Action?;
                                return action != null && action.message != ""
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            action.message,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : Container();
                              })*/
                        : Container();
              }
            }, // optional // optional
          )
        : Center(
            child: Text(
            "Start a new chat",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    appProvider = Provider.of<AppProvider>(context);
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(stickers3)),
      ),
      child: Column(
        children: [
          Expanded(
            child: chatMessages(h, w, context),
          ),
          SizedBox(
            height: 88.2,
          )
        ],
      ),
    ));
  }
}

/*const String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}*/
