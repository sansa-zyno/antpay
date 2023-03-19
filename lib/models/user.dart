import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser {
  String? uid;
  String? phone;
  String? displayName;
  String? country;
  String? avatarUrl;
  String? bio;
  Timestamp? accountCreated;
  String? lastActive;

  OurUser(
      {this.accountCreated,
      this.phone,
      this.uid,
      this.avatarUrl,
      this.country,
      this.displayName,
      this.bio,
      this.lastActive});

  /*factory OurUser.fromFireStore(DocumentSnapshot _data) {
    return OurUser(
      uid: _data["uid"],
      phone: _data["phoneNumber"] ?? "",
      displayName: _data["displayName"] ?? "",
      country: _data["country"] ?? "",
      avatarUrl: _data["avatarUrl"] ?? "",
      accountCreated: _data["accountCreated"],
      bio: _data["bio"] ?? "",
      lastActive: _data["lastActive"] ?? "",
    );
  }*/
}
