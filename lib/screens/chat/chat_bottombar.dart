import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/models/user.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/custom_stickers.dart';
import 'package:ant_pay/screens/transactions/enter_pin_pay.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

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
  PlatformFile? file;
  XFile? image;
  late AppProvider appProvider;
  bool showsticker = false;
  bool typing = false;

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

  Future addImageMessage({required ImageSource source}) async {
    image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      MediaMessage mediaMessage = MediaMessage(
          receiverType: ConversationType.user,
          type: CometChatMessageType.image,
          receiverUid: (widget.conversationWith as User).uid,
          file: image!.path);

      await CometChat.sendMediaMessage(mediaMessage,
          onSuccess: (MediaMessage message) {
        debugPrint("Media message sent successfully:${mediaMessage.metadata}");
      }, onError: (e) {
        debugPrint("Media message sending failed with exception: ${e.message}");
      });
    }
  }

  Future addImageMessageToGroup({required ImageSource source}) async {
    image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      MediaMessage mediaMessage = MediaMessage(
          receiverType: ConversationType.group,
          type: CometChatMessageType.image,
          receiverUid: (widget.conversationWith as Group).guid,
          file: image!.path);

      await CometChat.sendMediaMessage(mediaMessage,
          onSuccess: (MediaMessage message) {
        debugPrint("Media message sent successfully:${mediaMessage.metadata}");
      }, onError: (e) {
        debugPrint("Media message sending failed with exception: ${e.message}");
      });
    }
  }

  Future addDocMessage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = result.files.single;
      MediaMessage mediaMessage = MediaMessage(
          receiverType: ConversationType.user,
          type: CometChatMessageType.image,
          receiverUid: (widget.conversationWith as User).uid,
          file: file!.path);

      await CometChat.sendMediaMessage(mediaMessage,
          onSuccess: (MediaMessage message) {
        debugPrint("Media message sent successfully:${mediaMessage.metadata}");
      }, onError: (e) {
        debugPrint("Media message sending failed with exception: ${e.message}");
      });
    }
  }

  Future addDocMessageToGroup() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = result.files.single;
      MediaMessage mediaMessage = MediaMessage(
          receiverType: ConversationType.group,
          type: CometChatMessageType.image,
          receiverUid: (widget.conversationWith as Group).guid,
          file: file!.path);

      await CometChat.sendMediaMessage(mediaMessage,
          onSuccess: (MediaMessage message) {
        debugPrint("Media message sent successfully:${mediaMessage.metadata}");
      }, onError: (e) {
        debugPrint("Media message sending failed with exception: ${e.message}");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageTextEdittingController.addListener(() {
      if (messageTextEdittingController.text.isNotEmpty) {
        typing = true;
        setState(() {});
      } else {
        typing = false;
        setState(() {});
      }
    });
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
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => buildsheet(),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            isDismissible: false,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15))));
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
                          onPressed: () {},
                          icon: InkWell(
                            onTap: () {
                              showsticker = !showsticker;
                              setState(() {});
                            },
                            child: Icon(
                              Icons.sticky_note_2_rounded,
                              color: showsticker ? appColor : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  !typing
                      ? Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  widget.type == ConversationType.user
                                      ? addImageMessage(
                                              source: ImageSource.camera)
                                          .then((value) {
                                          appProvider.getChatData(
                                              (widget.conversationWith as User)
                                                  .uid,
                                              ConversationType.user,
                                              false);
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            appProvider.conversationData();
                                          });
                                        })
                                      : addImageMessageToGroup(
                                              source: ImageSource.camera)
                                          .then((value) {
                                          appProvider.getChatData(
                                              (widget.conversationWith as Group)
                                                  .guid,
                                              ConversationType.group,
                                              false);
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            appProvider.conversationData();
                                          });
                                        });
                                  appProvider.updateVal("", "", false, "", "");
                                },
                                child: Icon(Icons.photo_camera,
                                    color: showsticker
                                        ? appColor
                                        : Color(0xffADFFE1))),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(Icons.mic,
                                color:
                                    showsticker ? appColor : Color(0xffADFFE1)),
                          ],
                        )
                      : InkWell(
                          onTap: () {
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
                                        (widget.conversationWith as Group).guid,
                                        ConversationType.group,
                                        false);
                                    Future.delayed(Duration(seconds: 1), () {
                                      appProvider.conversationData();
                                    });
                                  });
                            appProvider.updateVal("", "", false, "", "");
                          },
                          child: Icon(Icons.send, color: Color(0xffADFFE1))),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Visibility(
                visible: showsticker,
                child: StickerWidget(
                  conversationWith: widget.conversationWith,
                  type: widget.type,
                ))
          ],
        ),
      ),
    );
  }

  Widget buildsheet() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            margin: EdgeInsets.only(right: 15, left: 3),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    widget.type == ConversationType.user
                        ? addImageMessage(source: ImageSource.camera)
                            .then((value) {
                            appProvider.getChatData(
                                (widget.conversationWith as User).uid,
                                ConversationType.user,
                                false);
                            Future.delayed(Duration(seconds: 1), () {
                              appProvider.conversationData();
                            });
                          })
                        : addImageMessageToGroup(source: ImageSource.camera)
                            .then((value) {
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
                  leading: Icon(
                    Icons.photo_camera,
                    color: appColor,
                  ),
                  title: CustomText(
                    text: "Camera",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    widget.type == ConversationType.user
                        ? addImageMessage(source: ImageSource.gallery)
                            .then((value) {
                            appProvider.getChatData(
                                (widget.conversationWith as User).uid,
                                ConversationType.user,
                                false);
                            Future.delayed(Duration(seconds: 1), () {
                              appProvider.conversationData();
                            });
                          })
                        : addImageMessageToGroup(source: ImageSource.gallery)
                            .then((value) {
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
                  leading: Icon(
                    Icons.image,
                    color: appColor,
                  ),
                  title: CustomText(
                    text: "Photo & Video Libary",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    widget.type == ConversationType.user
                        ? addDocMessage().then((value) {
                            appProvider.getChatData(
                                (widget.conversationWith as User).uid,
                                ConversationType.user,
                                false);
                            Future.delayed(Duration(seconds: 1), () {
                              appProvider.conversationData();
                            });
                          })
                        : addDocMessageToGroup().then((value) {
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
                  leading: Icon(
                    Icons.file_open_rounded,
                    color: appColor,
                  ),
                  title: CustomText(
                    text: "Document",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: appColor,
                  ),
                  title: CustomText(
                    text: "Location",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.person_3_rounded,
                    color: appColor,
                  ),
                  title: CustomText(
                    text: "Contact",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                ),
                /*Divider(),
                ListTile(
                  leading: Icon(
                    Icons.bar_chart,
                    color: appColor,
                  ),
                  title: CustomText(
                    text: "Poll",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                ),*/
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(right: 15, left: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Cancel",
                      color: appColor,
                      size: 16,
                      weight: FontWeight.bold,
                    )
                  ],
                )),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      );
}

class StickerWidget extends StatefulWidget {
  final AppEntity conversationWith;
  final String type;
  const StickerWidget(
      {Key? key, required this.conversationWith, required this.type})
      : super(key: key);

  @override
  State<StickerWidget> createState() => _StickerWidgetState();
}

class _StickerWidgetState extends State<StickerWidget>
    with SingleTickerProviderStateMixin {
  int idx = -1;
  late TabController controller;
  dynamic selectedSticker = "";
  TextEditingController amountController = TextEditingController();
  // WidgetsToImageController to access widget
  WidgetsToImageController imageController = WidgetsToImageController();
  // to save image bytes of widget
  Uint8List? bytes;

  Future sendStickerToUser() async {
    if (selectedSticker != "") {
      MediaMessage mediaMessage = MediaMessage(
          receiverType: ConversationType.user,
          type: CometChatMessageType.image,
          receiverUid: (widget.conversationWith as User).uid,
          file: null);
      if (selectedSticker.runtimeType == String) {
        String fileUrl = selectedSticker;
        String fileName = "test";
        String fileExtension = "png";
        String fileMimeType = "image/png";

        Attachment attach =
            Attachment(fileUrl, fileName, fileExtension, fileMimeType, null);
        mediaMessage.attachment = attach;
      } else {
        mediaMessage.file = (selectedSticker as File).path;
      }
      await CometChat.sendMediaMessage(mediaMessage,
          onSuccess: (MediaMessage message) {
        debugPrint("Media message sent successfully:${mediaMessage.metadata}");
      }, onError: (e) {
        debugPrint("Media message sending failed with exception: ${e.message}");
      });
    }
  }

  Future sendStickerToGroup() async {
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(vsync: this, length: 7);
    controller.animateTo(2);
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    UserController userController = Provider.of<UserController>(context);
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
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:
                          controller.index == 5 ? appColor : Color(0xffADFFE1)),
                  child: CustomText(
                      text: "Airtime",
                      size: 12,
                      color:
                          controller.index == 5 ? Colors.white : Colors.black)),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                  height: 30,
                  padding: EdgeInsets.only(
                    left: 3,
                  ),
                  decoration: BoxDecoration(border: Border.all()),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 12),
                        border: InputBorder.none,
                        prefix: Text(controller.index == 1
                            ? "\u20a6"
                            : controller.index == 2
                                ? "\$"
                                : "")),
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Text(
                  "Select Sticker",
                  style: TextStyle(fontSize: 14),
                  overflow: appProvider.customSticker.isNotEmpty
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                ),
                trailing: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => CustomSticker()));
                    },
                    child: Icon(Icons.arrow_drop_down)),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            amountController.text != "" && appProvider.customSticker != ""
                ? WidgetsToImage(
                    controller: imageController,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Stack(children: [
                        Image.network(appProvider.customSticker),
                        Positioned(
                          bottom: 0,
                          left: 10,
                          right: 5,
                          child: CustomText(
                            text:
                                "${controller.index == 1 ? "\u20a6" : controller.index == 2 ? "\$" : ""}${amountController.text}",
                            size: 12,
                            color: Colors.white,
                          ),
                        )
                      ]),
                    ),
                  )
                : Image.asset(
                    noImage,
                    width: 30,
                  ),
            //if (bytes != null) Image.memory(bytes!),
            SizedBox(
              width: 30,
            ),
            amountController.text != "" && appProvider.customSticker != ""
                ? InkWell(
                    onTap: () async {
                      final bytes = await imageController.capture();
                      final tempDir = await getTemporaryDirectory();
                      File file =
                          await File('${tempDir.path}/image.png').create();
                      if (bytes != null) {
                        file.writeAsBytesSync(bytes);
                        selectedSticker = file;
                      }

                      //idx = index;
                      if (widget.type == ConversationType.user) {
                        /*sendStickerToUser().then((value) {
                                      appProvider.getChatData(
                                          (widget.conversationWith as User).uid,
                                          ConversationType.user,
                                          false);
                                      Future.delayed(Duration(seconds: 1), () {
                                        appProvider.conversationData();
                                      });
                                    });*/
                        List Username = appProvider.contacts!.where((e) {
                          return e["doc"]["uid"].toString().toLowerCase() ==
                              (widget.conversationWith as User).uid;
                        }).toList();
                        if (userController.getOtherUser != null) {
                          log(userController.getOtherUser!.userId!);
                          Response response = await HttpService.postRequest(
                              Api.transfer,
                              {
                                "user_id": userController.getOtherUser!.userId!,
                                "amount": amountController.text
                              },
                              bearerToken: true,
                              accessToken: appProvider.token);
                          Map res = jsonDecode(response.body);
                          if (res["status"] == "Success") {
                            changeScreen(
                                context,
                                PayEnterPin(
                                    name: Username.isNotEmpty
                                        ? Username[0]["name"]
                                        : (widget.conversationWith as User)
                                            .name,
                                    validationUrl: res["data"]["url"],
                                    amount: amountController.text,
                                    sendSticker: sendStickerToUser,
                                    conversationWith: widget.conversationWith));
                          }
                        } else {}
                      } else {
                        sendStickerToGroup().then((value) {
                          appProvider.getChatData(
                              (widget.conversationWith as Group).guid,
                              ConversationType.group,
                              false);
                          Future.delayed(Duration(seconds: 1), () {
                            appProvider.conversationData();
                          });
                        });
                      }
                      appProvider.updateVal("", "", false, "", "");
                    },
                    child: Icon(
                      Icons.send,
                      color: appColor,
                    ))
                : Container(),
            SizedBox(
              width: 10,
            )
          ],
        ),
        SizedBox(
          height: 8,
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
                                onTap: () async {
                                  selectedSticker =
                                      appProvider.stickers![index]["img"];
                                  //idx = index;
                                  if (widget.type == ConversationType.user) {
                                    /*sendStickerToUser().then((value) {
                                      appProvider.getChatData(
                                          (widget.conversationWith as User).uid,
                                          ConversationType.user,
                                          false);
                                      Future.delayed(Duration(seconds: 1), () {
                                        appProvider.conversationData();
                                      });
                                    });*/
                                    List Username =
                                        appProvider.contacts!.where((e) {
                                      return e["doc"]["uid"]
                                              .toString()
                                              .toLowerCase() ==
                                          (widget.conversationWith as User).uid;
                                    }).toList();
                                    if (userController.getOtherUser != null) {
                                      log(userController.getOtherUser!.userId!);
                                      Response response =
                                          await HttpService.postRequest(
                                              Api.transfer,
                                              {
                                                "user_id": userController
                                                    .getOtherUser!.userId!,
                                                "amount": appProvider
                                                    .stickers![index]["value"]
                                              },
                                              bearerToken: true,
                                              accessToken: appProvider.token);
                                      log(response.body);
                                      Map res = jsonDecode(response.body);
                                      if (res["status"] == "Success") {
                                        changeScreen(
                                            context,
                                            PayEnterPin(
                                              name: Username.isNotEmpty
                                                  ? Username[0]["name"]
                                                  : (widget.conversationWith
                                                          as User)
                                                      .name,
                                              validationUrl: res["data"]["url"],
                                              amount: appProvider
                                                  .stickers![index]["value"],
                                              sendSticker: sendStickerToUser,
                                              conversationWith:
                                                  widget.conversationWith,
                                            ));
                                      }
                                    } else {}
                                  } else {
                                    sendStickerToGroup().then((value) {
                                      appProvider.getChatData(
                                          (widget.conversationWith as Group)
                                              .guid,
                                          ConversationType.group,
                                          false);
                                      Future.delayed(Duration(seconds: 1), () {
                                        appProvider.conversationData();
                                      });
                                    });
                                  }
                                  appProvider.updateVal("", "", false, "", "");
                                },
                                child: Stack(
                                  children: [
                                    Image.network(
                                      appProvider.stickers![index]["img"],
                                    ),
                                    /*Visibility(
                                      visible: index == idx,
                                      child: Positioned(
                                          top: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.check),
                                          )),
                                    )*/
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
