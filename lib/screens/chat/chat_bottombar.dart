import 'dart:developer';
import 'dart:io';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:cometchat/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

String stickerVal = "";

class ChatBottomBar extends StatefulWidget {
  User me;
  AppEntity conversationWith;
  final String type;
  ChatBottomBar(
      {required this.me, required this.conversationWith, required this.type});

  @override
  _ChatBottomBarState createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  TextEditingController messageTextEdittingController = TextEditingController();
  //PlatformFile? file;
  XFile? image;
  late AppProvider appProvider;
  bool showsticker = false;

  Future addTextMessage() async {
    if (messageTextEdittingController.text != "") {
      TextMessage textMessage = TextMessage(
          text: messageTextEdittingController.text,
          receiverUid: (widget.conversationWith as User).uid,
          receiverType: ConversationType.user,
          type: CometChatMessageType.text);
      CometChat.sendMessage(textMessage, onSuccess: (TextMessage message) {
        debugPrint("Message sent successfully:  $message");
        messageTextEdittingController.text = "";
      }, onError: (CometChatException e) {
        debugPrint("Message sending failed with exception:  ${e.message}");
      });
    }
  }

  Future addTextMessageToGroup() async {
    TextMessage textMessage = TextMessage(
        text: messageTextEdittingController.text,
        receiverUid: (widget.conversationWith as Group).guid,
        receiverType: ConversationType.group,
        type: CometChatMessageType.text);
    if (messageTextEdittingController.text != "") {
      CometChat.sendMessage(textMessage, onSuccess: (TextMessage message) {
        debugPrint("Message sent successfully:  $message");
        messageTextEdittingController.text = "";
      }, onError: (CometChatException e) {
        debugPrint("Message sending failed with exception:  ${e.message}");
      });
    }
  }

  Future addImageMessage(bool sticker) async {
    if (!sticker) {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        MediaMessage mediaMessage = MediaMessage(
            receiverType: ConversationType.user,
            type: CometChatMessageType.image,
            receiverUid: (widget.conversationWith as User).uid,
            file: image!.path);

        await CometChat.sendMediaMessage(mediaMessage,
            onSuccess: (MediaMessage message) {
          debugPrint(
              "Media message sent successfully:${mediaMessage.metadata}");
        }, onError: (e) {
          debugPrint(
              "Media message sending failed with exception: ${e.message}");
        });
      }
    } else {
      if (stickerVal != "") {
        MediaMessage mediaMessage = MediaMessage(
            receiverType: ConversationType.user,
            type: CometChatMessageType.image,
            receiverUid: (widget.conversationWith as User).uid,
            file: null);

        String fileUrl = stickerVal;
        String fileName = "test";
        String fileExtension = "png";
        String fileMimeType = "image/png";

        Attachment attach =
            Attachment(fileUrl, fileName, fileExtension, fileMimeType, null);
        mediaMessage.attachment = attach;

        await CometChat.sendMediaMessage(mediaMessage,
            onSuccess: (MediaMessage message) {
          debugPrint(
              "Media message sent successfully:${mediaMessage.metadata}");
        }, onError: (e) {
          debugPrint(
              "Media message sending failed with exception: ${e.message}");
        });
      }
    }
  }

  Future addImageMessageToGroup(bool sticker) async {
    if (!sticker) {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        MediaMessage mediaMessage = MediaMessage(
            receiverType: ConversationType.group,
            type: CometChatMessageType.image,
            receiverUid: (widget.conversationWith as Group).guid,
            file: image!.path);

        await CometChat.sendMediaMessage(mediaMessage,
            onSuccess: (MediaMessage message) {
          debugPrint(
              "Media message sent successfully:${mediaMessage.metadata}");
        }, onError: (e) {
          debugPrint(
              "Media message sending failed with exception: ${e.message}");
        });
      }
    } else {
      showsticker = false;
      setState(() {});
      /* MediaMessage mediaMessage = MediaMessage(
            receiverType: ConversationType.group,
            type: CometChatMessageType.image,
            receiverUid: (widget.conversationWith as Group).guid,
            file: stickerVal);

        await CometChat.sendMediaMessage(mediaMessage,
            onSuccess: (MediaMessage message) {
          debugPrint(
              "Media message sent successfully:${mediaMessage.metadata}");
        }, onError: (e) {
          debugPrint(
              "Media message sending failed with exception: ${e.message}");
        });*/
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    appProvider = Provider.of<AppProvider>(context);
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
            color: showsticker ? Colors.white : Colors.transparent),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            appProvider.type == ""
                ? Container()
                : appProvider.type == "text"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appProvider.senderReplied == widget.me.uid
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "You",
                                      style:
                                          TextStyle(color: Color(0xff4B0973)),
                                    ),
                                    InkWell(
                                      child: Icon(Icons.cancel,
                                          color: Color(0xff4B0973)),
                                      onTap: () {
                                        appProvider.updateVal(
                                            "", "", false, "", "");
                                      },
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      appProvider.senderReplied,
                                      style:
                                          TextStyle(color: Color(0xff4B0973)),
                                    ),
                                    InkWell(
                                      child: Icon(Icons.cancel,
                                          color: Color(0xff4B0973)),
                                      onTap: () {
                                        appProvider.updateVal(
                                            "", "", false, "", "");
                                      },
                                    )
                                  ],
                                ),
                          Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xff4B0973),
                                      width: 10,
                                    ),
                                  )),
                              child: Row(
                                children: [
                                  Flexible(child: Text(appProvider.msgreplied)),
                                ],
                              )),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appProvider.senderReplied == widget.me.uid
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "You",
                                      style:
                                          TextStyle(color: Color(0xff4B0973)),
                                    ),
                                    InkWell(
                                      child: Icon(Icons.cancel,
                                          color: Color(0xff4B0973)),
                                      onTap: () {
                                        appProvider.updateVal(
                                            "", "", false, "", "");
                                      },
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      appProvider.senderReplied,
                                      style:
                                          TextStyle(color: Color(0xff4B0973)),
                                    ),
                                    InkWell(
                                      child: Icon(Icons.cancel,
                                          color: Color(0xff4B0973)),
                                      onTap: () {
                                        appProvider.updateVal(
                                            "", "", false, "", "");
                                      },
                                    )
                                  ],
                                ),
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border(
                                  left: BorderSide(
                                    color: Color(0xff4B0973),
                                    width: 10,
                                  ),
                                )),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Image.network(
                                    appProvider.msgreplied,
                                    height: 90,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        showsticker = !showsticker;
                        setState(() {});
                        /*showModalBottomSheet(
                            context: context,
                            builder: (context) => StickerWidget(),
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15))));*/
                      },
                      child: Icon(Icons.add,
                          color: showsticker ? appColor : Color(0xffADFFE1))),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageTextEdittingController,
                      readOnly: showsticker ? true : false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefix: Text("   "),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          // borderSide: BorderSide(color: mycolor, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        hintText: showsticker
                            ? "Choose a sticker..."
                            : 'Type a message...',
                        suffixIcon: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            if (!showsticker) {
                              widget.type == ConversationType.user
                                  ? addTextMessage().then((value) {
                                      appProvider.getChatData(
                                          (widget.conversationWith as User).uid,
                                          ConversationType.user,
                                          false);
                                      Future.delayed(Duration(seconds: 1), () {
                                        appProvider.conversationData();
                                      });
                                    })
                                  : addTextMessageToGroup().then((value) {
                                      appProvider.getChatData(
                                          (widget.conversationWith as Group)
                                              .guid,
                                          ConversationType.group,
                                          false);
                                      Future.delayed(Duration(seconds: 1), () {
                                        appProvider.conversationData();
                                      });
                                    });
                              appProvider.updateVal("", "", false, "", "");
                            } else {
                              widget.type == ConversationType.user
                                  ? addImageMessage(true).then((value) {
                                      appProvider.getChatData(
                                          (widget.conversationWith as User).uid,
                                          ConversationType.user,
                                          false);
                                      Future.delayed(Duration(seconds: 1), () {
                                        appProvider.conversationData();
                                      });
                                    })
                                  : addImageMessageToGroup(true).then((value) {
                                      appProvider.getChatData(
                                          (widget.conversationWith as Group)
                                              .guid,
                                          ConversationType.group,
                                          false);
                                      Future.delayed(Duration(seconds: 1), () {
                                        appProvider.conversationData();
                                      });
                                    });
                              appProvider.updateVal("", "", false, "", "");
                            }
                          },
                          icon: Icon(
                            //Icons.file_open_rounded,
                            Icons.send,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        widget.type == ConversationType.user
                            ? addImageMessage(false).then((value) {
                                appProvider.getChatData(
                                    (widget.conversationWith as User).uid,
                                    ConversationType.user,
                                    false);
                                Future.delayed(Duration(seconds: 1), () {
                                  appProvider.conversationData();
                                });
                              })
                            : addImageMessageToGroup(false).then((value) {
                                appProvider.getChatData(
                                    (widget.conversationWith as Group).guid,
                                    ConversationType.group,
                                    false);
                                Future.delayed(Duration(seconds: 1), () {
                                  appProvider.conversationData();
                                });
                              });
                        appProvider.updateVal("", "", false, "", "");
                      },
                      child: Icon(Icons.photo_camera,
                          color: showsticker ? appColor : Color(0xffADFFE1))),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(Icons.mic,
                      color: showsticker ? appColor : Color(0xffADFFE1)),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Visibility(visible: showsticker, child: StickerWidget())
          ],
        ),
      ),
    );
  }
}

class StickerWidget extends StatefulWidget {
  const StickerWidget({Key? key}) : super(key: key);

  @override
  State<StickerWidget> createState() => _StickerWidgetState();
}

class _StickerWidgetState extends State<StickerWidget>
    with SingleTickerProviderStateMixin {
  int idx = -1;
  late TabController controller;
  /*List usdStickers = [
    sticker1,
    sticker2,
    sticker03,
    sticker4,
    sticker5,
    sticker6,
    sticker7,
    sticker8,
    sticker9
  ];*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(vsync: this, length: 6);
    controller.animateTo(2);
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: controller,
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 5),
          onTap: (index) {
            controller.index = index;
            setState(() {});
          },
          tabs: [
            Tab(
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 15,
                        color: Colors.black,
                      ),
                      SizedBox(width: 3),
                      CustomText(text: "Search", size: 12),
                    ],
                  )),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:
                          controller.index == 1 ? appColor : Color(0xffADFFE1)),
                  child: CustomText(
                      text: "NGN",
                      size: 12,
                      color:
                          controller.index == 1 ? Colors.white : Colors.black)),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:
                          controller.index == 2 ? appColor : Color(0xffADFFE1)),
                  child: CustomText(
                      text: "USD",
                      size: 12,
                      color:
                          controller.index == 2 ? Colors.white : Colors.black)),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:
                          controller.index == 3 ? appColor : Color(0xffADFFE1)),
                  child: CustomText(
                      text: "Pounds",
                      size: 12,
                      color:
                          controller.index == 3 ? Colors.white : Colors.black)),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:
                          controller.index == 4 ? appColor : Color(0xffADFFE1)),
                  child: CustomText(
                      text: "GHC",
                      size: 12,
                      color:
                          controller.index == 4 ? Colors.white : Colors.black)),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CustomText(
                    text: "See all",
                    size: 12,
                  )),
            )
          ],
        ),
        Container(
          height: 180,
          child: TabBarView(controller: controller, children: [
            Container(
              height: 15,
            ),
            Container(
              height: 15,
            ),
            appProvider.stickers != null
                ? appProvider.stickers!.isNotEmpty
                    ? GridView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: appProvider.stickers!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) =>
                            InkWell(
                                onTap: () {
                                  stickerVal = appProvider.stickers![index];
                                  idx = index;
                                  setState(() {});
                                },
                                child: Stack(
                                  children: [
                                    Image.network(
                                      appProvider.stickers![index],
                                    ),
                                    Visibility(
                                      visible: index == idx,
                                      child: Positioned(
                                          top: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.check),
                                          )),
                                    )
                                  ],
                                )),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, childAspectRatio: 1))
                    : Center(child: Text("No stickers to show"))
                : Center(child: Text("Loading stickers...")),
            Container(
              height: 15,
            ),
            Container(
              height: 15,
            ),
            Container(
              height: 15,
            )
          ]),
        )
      ],
    );
  }
}
