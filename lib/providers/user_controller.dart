import 'dart:io';
import 'package:ant_pay/screens/callscreens/pickup/video_pickup_screen.dart';
import 'package:ant_pay/screens/callscreens/pickup/voice_pickup_screen.dart';
import 'package:ant_pay/services/call_history.dart';
import 'package:ant_pay/services/call_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ant_pay/models/user.dart';
import 'package:uuid/uuid.dart';

import '../models/call.dart';

class UserController with ChangeNotifier {
  OurUser _currentUser = OurUser();
  OurUser get getCurrentUser => _currentUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isAvatarUploading = false;
  late File file;
  ImagePicker img = ImagePicker();
  String postId = Uuid().v4();

  CallMethods callMethods = CallMethods();

  UserController() {
    /* if (_currentUser.uid != null) {
      callMethods.callStream(uid: _currentUser.uid!).listen((snapshot) {
        Call call = Call.fromMap(snapshot.data as Map<dynamic, dynamic>);
        if (!call.hasDialled!) {
          if (snapshot["fkey"] != "") {
            CallHistory().updateCall(call: call, fkey: snapshot["fkey"]);
          }
          if (call.type == "video") {
            Get.to(VideoPickupScreen(call: call));
          } else {
            Get.to(VoicePickupScreen(call: call));
          }
        }
      });
    }*/
  }

  Future<bool> updateAvatar(String uid) async {
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

    updatePostInFirestore({String? mediaUrl, String? uid}) async {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "avatarUrl": mediaUrl,
      });
      await getCurrentUserInfo();
      isAvatarUploading = false;
      notifyListeners();
    }

    uploadToStorage(String uid) async {
      String? mediaUrl = await uploadImage(file, uid);
      if (mediaUrl != null) {
        await updatePostInFirestore(mediaUrl: mediaUrl, uid: uid);
      }
    }

    handleChooseFromGallery(String uid) async {
      var getImage =
          await img.getImage(source: ImageSource.gallery, imageQuality: 25);
      File file = File(getImage!.path);
      this.file = file;
      isAvatarUploading = true;
      notifyListeners();
      await uploadToStorage(uid);
    }

    handleChooseFromGallery(uid);

    return true;
  }

  Future<bool> updateDisplay(String name) async {
    try {
      await _firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .update({"displayName": name});
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateBio(String bio) async {
    try {
      await _firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .update({"bio": bio});
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateCountry(String country) async {
    try {
      await _firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .update({"country": country});
    } catch (e) {
      return false;
    }
    return true;
  }

  getCurrentUserInfo() async {
    try {
      if (auth.currentUser != null) {
        DocumentSnapshot _documentSnapshot = await _firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get();
        Map<String, dynamic> snapshotData =
            _documentSnapshot.data()! as Map<String, dynamic>;
        _currentUser.uid = auth.currentUser!.uid;
        _currentUser.phone = snapshotData["phoneNumber"];
        _currentUser.accountCreated = snapshotData["accountCreated"];
        _currentUser.avatarUrl = snapshotData["avatarUrl"];
        _currentUser.bio = snapshotData["bio"];
        _currentUser.displayName = snapshotData["displayName"];
        _currentUser.country = snapshotData["country"];
        _currentUser.lastActive = snapshotData["lastActive"];
        notifyListeners();
      } else {}
    } catch (e) {}
  }

  removeCurrentUser() {
    _currentUser = OurUser();
    notifyListeners();
  }
}
