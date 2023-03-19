import 'dart:developer';
import 'dart:io';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/home.dart';
import 'package:ant_pay/widgets/GradientButton/GradientButton.dart';
import 'package:ant_pay/widgets/curved_textfield.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cometchat/models/user.dart' as ct;
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ProfileSetup extends StatefulWidget {
  String uid;
  ProfileSetup({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  late AppProvider _app;
  late UserController _userController;
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  bool isAvatarUploading = false;
  late File file;
  ImagePicker img = ImagePicker();
  String avatarUrl = "";
  //String postId = Uuid().v4();
  bool a = false;
  bool b = false;
  bool c = false;
  bool d = false;
  bool e = false;
  bool f = false;
  bool g = false;
  bool h = false;
  bool i = false;
  bool j = false;
  bool k = false;

  String status = "Select a status";
  bool expanded = false;

  Future<bool> getImageUrl(String uid) async {
    Future<String?> uploadImage(File imageFile, String uid) async {
      String? downloadUrl;
      Reference reference =
          FirebaseStorage.instance.ref().child("profilePictures/$uid.jpg");
      UploadTask uploadTask = reference.putData(imageFile.readAsBytesSync());

      await uploadTask.whenComplete(() async {
        downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
      });

      return downloadUrl;
    }

    uploadToStorage(String uid) async {
      isAvatarUploading = true;
      setState(() {});
      String? mediaUrl = await uploadImage(file, uid);
      if (mediaUrl != null) {
        avatarUrl = mediaUrl;
        isAvatarUploading = false;
        setState(() {});
      } else {
        avatarUrl = "";
        isAvatarUploading = false;
        setState(() {});
      }
    }

    handleChooseFromGallery(String uid) async {
      var getImage =
          await img.pickImage(source: ImageSource.gallery, imageQuality: 25);
      File file = File(getImage!.path);
      this.file = file;
      await uploadToStorage(uid);
    }

    handleChooseFromGallery(uid);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    _app = Provider.of<AppProvider>(context);
    _userController = Provider.of<UserController>(context, listen: false);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(stickers)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gd1, gd2, gd3, gd4, gd5],
              stops: [0.02, 0.2, 0.6, 0.8, 1.0]),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(heart_red, width: 50),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    sun,
                    width: 100,
                  ),
                ),
                Positioned(
                    top: 120,
                    left: 0,
                    child: Image.asset(
                      cards_on_hand,
                      width: 100,
                    )),
                Positioned(
                    top: 90,
                    right: 0,
                    child: Image.asset(
                      dollar,
                      width: 50,
                    )),
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: Image.asset(
                      car,
                      width: 70,
                    )),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      money_and_gold,
                      width: 70,
                    )),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 90,
                      ),
                      CustomText(
                        text: "Set up your profile",
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          getImageUrl(widget.uid);
                        },
                        child: CircleAvatar(
                            radius: 70,
                            backgroundColor: appColor.withOpacity(0.6),
                            child: isAvatarUploading
                                ? CircularProgressIndicator()
                                : avatarUrl.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: 50,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(90),
                                        child: Image.network(
                                          avatarUrl,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ))),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: CurvedTextField(
                          hint: "Enter Name",
                          controller: name,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: CurvedTextField(
                          hint: "Description",
                          controller: bio,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: expanded ? null : 58,
                        width: 283,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(2, 2))
                            ]),
                        child: ExpansionTile(
                          expandedAlignment: Alignment.centerLeft,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          onExpansionChanged: (x) {
                            expanded = x;
                            setState(() {});
                          },
                          title:
                              Text(status, style: TextStyle(color: appColor)),
                          trailing:
                              Icon(Icons.arrow_drop_down, color: appColor),
                          children: [
                            InkWell(
                                onTap: () {
                                  a = true;
                                  b = false;
                                  c = false;
                                  d = false;
                                  e = false;
                                  f = false;
                                  g = false;
                                  h = false;
                                  i = false;
                                  j = false;
                                  k = false;
                                  status = "Available";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            a ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("Available",
                                            style: TextStyle(
                                                color: a
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = true;
                                  c = false;
                                  d = false;
                                  e = false;
                                  f = false;
                                  g = false;
                                  h = false;
                                  i = false;
                                  j = false;
                                  k = false;
                                  status = "Busy";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            b ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("Busy",
                                            style: TextStyle(
                                                color: b
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = false;
                                  c = true;
                                  d = false;
                                  e = false;
                                  f = false;
                                  g = false;
                                  h = false;
                                  i = false;
                                  j = false;
                                  k = false;
                                  status = "At School";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            c ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("At School",
                                            style: TextStyle(
                                                color: c
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = false;
                                  c = false;
                                  d = true;
                                  e = false;
                                  f = false;
                                  g = false;
                                  h = false;
                                  i = false;
                                  j = false;
                                  k = false;
                                  status = "At the movies";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            d ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("At the movies",
                                            style: TextStyle(
                                                color: d
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = false;
                                  c = false;
                                  d = false;
                                  e = true;
                                  f = false;
                                  g = false;
                                  h = false;
                                  i = false;
                                  j = false;
                                  k = false;
                                  status = "At work";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            e ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("At work",
                                            style: TextStyle(
                                                color: e
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = false;
                                  c = false;
                                  d = false;
                                  e = false;
                                  f = true;
                                  g = false;
                                  h = false;
                                  i = false;
                                  j = false;
                                  k = false;
                                  status = "Battery about to die";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            f ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("Battery about to die",
                                            style: TextStyle(
                                                color: f
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = false;
                                  c = false;
                                  d = false;
                                  e = false;
                                  f = false;
                                  g = true;
                                  h = false;
                                  i = false;
                                  j = false;
                                  k = false;
                                  status = "Cant talk, chat only";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            g ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("Cant talk, chat only",
                                            style: TextStyle(
                                                color: g
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = false;
                                  c = false;
                                  d = false;
                                  e = false;
                                  f = false;
                                  g = false;
                                  h = true;
                                  i = false;
                                  j = false;
                                  k = false;
                                  status = "In a meeting";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            h ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("In a meeting",
                                            style: TextStyle(
                                                color: h
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = false;
                                  c = false;
                                  d = false;
                                  e = false;
                                  f = false;
                                  g = false;
                                  h = false;
                                  i = true;
                                  j = false;
                                  k = false;
                                  status = "At the gym";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            i ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("At the gym",
                                            style: TextStyle(
                                                color: i
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = false;
                                  c = false;
                                  d = false;
                                  e = false;
                                  f = false;
                                  g = false;
                                  h = false;
                                  i = false;
                                  j = true;
                                  k = false;
                                  status = "Sleeping";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            j ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Row(
                                      children: [
                                        Text("Sleeping",
                                            style: TextStyle(
                                                color: j
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    ))),
                            InkWell(
                                onTap: () {
                                  a = false;
                                  b = false;
                                  c = false;
                                  d = false;
                                  e = false;
                                  f = false;
                                  g = false;
                                  h = false;
                                  i = false;
                                  j = false;
                                  k = true;
                                  status = "Urgent calls only";
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            k ? appColor : Colors.transparent),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Row(
                                      children: [
                                        Text("Urgent calls only",
                                            style: TextStyle(
                                                color: k
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ],
                                    )))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      GradientButton(
                        title: "Finish",
                        textClr: Colors.white,
                        clrs: [appColor, appColor],
                        onpressed: () {
                          ToastContext().init(context);
                          if (avatarUrl.isNotEmpty) {
                            if (name.text != "") {
                              setDataToDb().then((value) =>
                                  registerUserAndLogin(
                                      widget.uid, name.text, context));
                            } else {
                              Toast.show("Name cannot be empty",
                                  duration: Toast.lengthShort,
                                  gravity: Toast.bottom);
                              log("Name cannot be empty");
                            }
                          } else {
                            Toast.show("Please upload an image",
                                duration: Toast.lengthShort,
                                gravity: Toast.bottom);
                            log("Please upload an image");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  //Method to register new user
  registerUserAndLogin(String uid, String name, BuildContext context) async {
    String authKey = cometchatAuthKey; //Replace with the auth key of app
    ct.User user = ct.User(uid: uid, name: name, avatar: avatarUrl);
    await CometChat.createUser(user, authKey, onSuccess: (ct.User user) {
      debugPrint("User Created Successfully");
      loginUser(uid, context);
    }, onError: (CometChatException e) {
      debugPrint("User not created");
    });
  }

  //Login User function must pass userid and authkey should be used only while developing
  loginUser(String userId, BuildContext context) async {
    ct.User? _user = await CometChat.getLoggedInUser();
    try {
      if (_user != null) {
        await CometChat.logout(onSuccess: (_) {}, onError: (_) {});
      }
    } catch (_) {}

    await CometChat.login(userId, cometchatAuthKey,
        onSuccess: (ct.User loggedInUser) {
      debugPrint("Login Successful : $loggedInUser");
      _user = loggedInUser;
    }, onError: (CometChatException e) {
      debugPrint("Login failed with exception:  ${e.message}");
    });

    //if login is successful
    if (_user != null) {
      _userController.getCurrentUserInfo();
      _app.conversationData();
      //USERID = _user!.uid;
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          child: Home(),
        ),
      );
    }
  }

  Future setDataToDb() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "phoneNumber": _app.dialcode == "+234"
          ? "${FirebaseAuth.instance.currentUser!.phoneNumber!.replaceFirst("+234", "0")}"
          : FirebaseAuth.instance.currentUser!.phoneNumber,
      "displayName": name.text,
      "country": _app.countrySelected,
      "avatarUrl": avatarUrl,
      "accountCreated": Timestamp.now(),
      "bio": bio.text,
      "status": status,
      "lastActive": ""
    });
  }
}
