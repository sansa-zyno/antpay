import 'dart:developer';
import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/widgets/curved_textfield.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late UserController userController;
  late TextEditingController name;

  bool isAvatarUploading = false;
  late File file;
  ImagePicker img = ImagePicker();
  String avatarUrl = "";

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
  void initState() {
    // TODO: implement initState
    super.initState();
    userController = Provider.of<UserController>(context, listen: false);
    name =
        TextEditingController(text: userController.getCurrentUser.displayName!);
    status = userController.getCurrentUser.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(stickers)),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [appColor, gd2, gd3, gd4, gd5],
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
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: appColor,
                          ),
                        ),
                        Spacer(),
                        CustomText(
                          text: "Edit Profile",
                          size: 16,
                          weight: FontWeight.bold,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(userController.getCurrentUser.uid!)
                                .update({
                              "displayName": name.text,
                              "status": status,
                              "avatarUrl": avatarUrl.isNotEmpty
                                  ? avatarUrl
                                  : userController.getCurrentUser.avatarUrl!
                            }).then(
                              (value) {
                                userController.getCurrentUserInfo();
                                CometChat.updateCurrentUserDetails(
                                    User(
                                        uid: userController.getCurrentUser.uid!
                                            .toLowerCase(),
                                        name: name.text,
                                        avatar: avatarUrl.isNotEmpty
                                            ? avatarUrl
                                            : userController
                                                .getCurrentUser.avatarUrl!),
                                    onSuccess: (user) {
                                  AchievementView(
                                    color: Colors.green,
                                    icon: Icon(
                                      FontAwesomeIcons.check,
                                      color: Colors.white,
                                    ),
                                    title: "Successfull !",
                                    elevation: 20,
                                    subTitle:
                                        "User details updated successfully",
                                    isCircle: true,
                                  ).show(context);
                                  Navigator.pop(context);
                                }, onError: (error) {
                                  log("cannot update user");
                                });
                              },
                            );
                          },
                          child: CustomText(
                            text: "Save",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          getImageUrl(userController.getCurrentUser.uid!);
                        },
                        child: isAvatarUploading
                            ? CircleAvatar(
                                radius: 50,
                                child:
                                    Center(child: CircularProgressIndicator()),
                                backgroundColor: Colors.white,
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: avatarUrl.isEmpty
                                    ? NetworkImage(
                                        userController
                                            .getCurrentUser.avatarUrl!,
                                      )
                                    : NetworkImage(avatarUrl),
                                backgroundColor: Colors.white,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: appColor),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      child: CurvedTextField(
                        controller: name,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: appColor),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(2, 2))
                            ]),
                        child: CustomText(
                          text: FirebaseAuth.instance.currentUser!.phoneNumber!,
                          color: Colors.grey,
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: expanded ? null : 58,
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
                        title: Text(status, style: TextStyle(color: appColor)),
                        trailing: Icon(Icons.arrow_drop_down, color: appColor),
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
                                      color: a ? appColor : Colors.transparent),
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
                                      color: b ? appColor : Colors.transparent),
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
                                      color: c ? appColor : Colors.transparent),
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
                                      color: d ? appColor : Colors.transparent),
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
                                      color: e ? appColor : Colors.transparent),
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
                                      color: f ? appColor : Colors.transparent),
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
                                      color: g ? appColor : Colors.transparent),
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
                                      color: h ? appColor : Colors.transparent),
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
                                      color: i ? appColor : Colors.transparent),
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
                                      color: j ? appColor : Colors.transparent),
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
                                      color: k ? appColor : Colors.transparent),
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
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 180,
                left: 0,
                child: Image.asset(
                  cards_on_hand,
                  width: 100,
                )),
          ],
        ),
      ),
    );
  }
}
