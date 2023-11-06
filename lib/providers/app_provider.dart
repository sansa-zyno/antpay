import 'dart:convert';
import 'package:ant_pay/constants/api.dart';
import 'package:ant_pay/services/local_storage.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import '../services/http.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

class AppProvider extends ChangeNotifier {
  String type = "";
  bool reply = false;
  String senderReplied = "";
  String chatid = "";
  String msgreplied = "";

  List? forumData;
  List? notifications;
  List<Conversation>? listConversation;
  List<BaseMessage>? chatData;
  String imageUrl = "";

  List<Map>? contacts;
  List? stickers;
  List? customStickers;

  String dialcode = "+234";
  String countrySelected = "Nigeria";

  String token = "";
  Map? wallet;
  List countries = [];
  List banks = [];

  String customSticker = "";

  AppProvider() {
    listConversation = null;
    chatData = null;
    getContacts();
  }

  getContacts() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus status = await Permission.contacts.request();
      if (status == PermissionStatus.granted) {
        try {
          List<Contact> foundContacts =
              await ContactsService.getContacts(withThumbnails: false);
          log("done loading contacts" + foundContacts.length.toString());
          final list = foundContacts.toList();
          list.sort((a, b) => a.displayName!.compareTo(b.displayName!));
          contacts = [];
          for (int i = 0; i < list.length; i++) {
            if (list[i].phones!.isNotEmpty) {
              QuerySnapshot snap = await FirebaseFirestore.instance
                  .collection("users")
                  .where("phoneNumber",
                      isEqualTo: list[i].phones![0].value!.replaceAll(" ", ""))
                  .get();
              if (snap.docs.isNotEmpty) {
                contacts!
                    .add({"name": list[i].displayName, "doc": snap.docs[0]});
                notifyListeners();
              }
            }
          }
          log(contacts.toString());
        } catch (e) {
          log(e.toString());
        }
      }
    } else {
      try {
        List<Contact> foundContacts =
            await ContactsService.getContacts(withThumbnails: false);
        debugPrint("done loading contacts" + foundContacts.length.toString());
        final list = foundContacts.toList();
        list.sort((a, b) => a.displayName!.compareTo(b.displayName!));
        contacts = [];
        for (int i = 0; i < list.length; i++) {
          if (list[i].phones!.isNotEmpty) {
            QuerySnapshot snap = await FirebaseFirestore.instance
                .collection("users")
                .where("phoneNumber",
                    isEqualTo: list[i].phones![0].value!.replaceAll(" ", ""))
                .get();
            if (snap.docs.isNotEmpty) {
              contacts!.add({"name": list[i].displayName, "doc": snap.docs[0]});
              notifyListeners();
            }
          }
        }
        log(contacts.toString());
      } catch (e) {
        log(e.toString());
      }
    }
  }

  getStickers() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection("stickers").get();
    stickers = snap.docs[0]["stickers"];
    notifyListeners();
  }

  getCustomStickers() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection("customStickers").get();
    customStickers = snap.docs[0]["stickers"];
    notifyListeners();
  }

  setDialCode(String dialCode) {
    dialcode = dialCode;
    notifyListeners();
  }

  setCountrySelected(String countrySel) {
    countrySelected = countrySel;
    notifyListeners();
  }

  Future<String> getUsername() async {
    String username = await LocalStorage().getString("username");
    return username;
  }

  updateVal(String msg, String typ, bool rep, String sender, String chatId) {
    msgreplied = msg;
    type = typ;
    reply = rep;
    senderReplied = sender;
    chatid = chatId;
    notifyListeners();
  }

  /* getForumData() async {
    Response response = await HttpService.post("", {});
    forumData = jsonDecode(response.data);
    notifyListeners();
    // log(forumData.toString());
  }*/

//get one to one or one to group message history(all messages)
  getChatData(String conversationWithUid, String type, bool newPerson) async {
    newPerson ? chatData = null : chatData = chatData;
    notifyListeners();
    if (type == ConversationType.user) {
      MessagesRequest messageRequest =
          (MessagesRequestBuilder()..uid = conversationWithUid).build();
      messageRequest.fetchPrevious(onSuccess: (List<BaseMessage> list) {
        chatData = list;
        notifyListeners();
      }, onError: (CometChatException e) {
        debugPrint("Message fetching failed with exception: ${e.message}");
        //chatData = [];
        // notifyListeners();
      });
    } else {
      MessagesRequest messageRequest =
          (MessagesRequestBuilder()..guid = conversationWithUid).build();
      messageRequest.fetchPrevious(onSuccess: (List<BaseMessage> list) {
        chatData = list;
        notifyListeners();
      }, onError: (CometChatException e) {
        debugPrint("Message fetching failed with exception: ${e.message}");
        //chatData = [];
        //notifyListeners();
      });
    }
  }

  /*addToChatData(BaseMessage message) {
    chatData!.add(message);
    notifyListeners();
  }*/

//get persons the user has chatted with
  conversationData() async {
    // log("called");
    ConversationsRequest conversationRequest =
        (ConversationsRequestBuilder()).build();

    conversationRequest.fetchNext(
        onSuccess: (List<Conversation> conversations) {
      listConversation = conversations;
      notifyListeners();
      for (Conversation chat in listConversation!) {}
    }, onError: (CometChatException e) {
      //listConversation = [];
      //notifyListeners();
    });
  }

  /* Future getNotifications() async {
    Response response = await HttpService.post("", {});
    notifications = jsonDecode(response.data);
    notifyListeners();
    // log(notifications.toString());
  }*/

  /* getImage(String username) async {
    try {
      Response res = await HttpService.post("", {"username": username});
      imageUrl = res.data;
    } catch (e) {
      imageUrl = "";
    }
    notifyListeners();
  }*/

  setToken(String token) {
    this.token = token;
    notifyListeners();
  }

  getWallet() async {
    Response response = await HttpService.getRequest(Api.wallet,
        bearerToken: true, accessToken: this.token);
    log(this.token);
    Map result = jsonDecode(response.body);
    log(result.toString());
    if (result["status"]) {
      wallet = result["data"];
      notifyListeners();
    } else {
      Get.defaultDialog(
          title: "Error",
          middleText: "There was an error getting user wallet details");
    }
  }

  getCountries() async {
    Response response = await HttpService.getRequest(Api.countries);
    Map result = jsonDecode(response.body);
    if (result["status"]) {
      countries = result["data"]["data"];
      notifyListeners();
    }
  }

  getBanks() async {
    Response response = await HttpService.getRequest(Api.banks);
    Map result = jsonDecode(response.body);
    if (result["status"]) {
      banks = result["data"]["data"];
      notifyListeners();
    }
  }

  setCustomSticker(String sticker) {
    customSticker = sticker;
    notifyListeners();
  }
}
