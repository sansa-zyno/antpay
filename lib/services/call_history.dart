import 'dart:developer';

import 'package:ant_pay/services/call_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/call.dart';

class CallHistory {
  final CollectionReference callhistory =
      FirebaseFirestore.instance.collection("callhistorys");
  static final CallMethods callMethods = CallMethods();
//by dialler
  Future<bool> saveCall({required Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);
      hasDialledMap.addAll({"status": "0", "date": Timestamp.now()});
      callhistory.doc(call.callerId).set({"r": "r"});
      DocumentReference ref = await callhistory
          .doc(call.callerId)
          .collection("callhistory")
          .add(hasDialledMap);
      callMethods.callCollection.doc(call.callerId).update({"ref": ref.id});
      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);
      hasNotDialledMap
          .addAll({"status": "0", "date": Timestamp.now(), "fkey": ref.id});
      callhistory.doc(call.receiverId).set({"r": "r"});
      callhistory
          .doc(call.receiverId)
          .collection("callerhistory")
          .doc(ref.id)
          .set(hasNotDialledMap);
      callMethods.callCollection.doc(call.receiverId).update({"ref": ref.id});
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

//by receiver
  updateCall({required Call call, required String fkey}) async {
    callhistory
        .doc(call.callerId)
        .collection("callhistory")
        .doc(fkey)
        .update({"status": "1"});
    callhistory
        .doc(call.receiverId)
        .collection("callhistory")
        .doc(fkey)
        .update({"status": "1"});
  }

//clear for one party
  clearHistory({required String userId}) async {}
}
