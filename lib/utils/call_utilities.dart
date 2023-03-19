import 'dart:math';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/screens/callscreens/video_call_screen.dart';
import 'package:ant_pay/services/call_history.dart';
import 'package:cometchat/cometchat_sdk.dart' hide Call;
import 'package:flutter/material.dart';
import 'package:ant_pay/models/call.dart';
import 'package:ant_pay/services/call_methods.dart';
import 'package:ant_pay/screens/callscreens/voice_call_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static getAgoraToken(String channelId) async {
    var response = await http.get(
        Uri.parse("$agoraTokenServerUrl/access_token?channelName=$channelId"));
    String token = jsonDecode(response.body)["token"];
    return token;
  }

  static dialVideo({required User from, required User to, context}) async {
    String channelId = Random().nextInt(1000).toString();
    String token = await getAgoraToken(channelId);
    print(token);
    Call call = Call(
        callerId: from.uid,
        callerName: from.name,
        callerPic: from.avatar,
        receiverId: to.uid,
        receiverName: to.name,
        receiverPic: to.avatar,
        channelId: channelId,
        token: token,
        type: 'video');

    bool callMade = await callMethods.makeCall(call: call);
    bool historyMade = await CallHistory().saveCall(call: call);

    call.hasDialled = true;

    if (callMade && historyMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallScreen(call: call),
          ));
    }
  }

  static dialAudio({required User from, required User to, context}) async {
    String channelId = Random().nextInt(1000).toString();
    String token = await getAgoraToken(channelId);
    print(token);
    Call call = Call(
        callerId: from.uid,
        callerName: from.name,
        callerPic: from.avatar,
        receiverId: to.uid,
        receiverName: to.name,
        receiverPic: to.avatar,
        channelId: channelId,
        token: token,
        type: 'call');

    bool callMade = await callMethods.makeCall(call: call);
    bool historyMade = await CallHistory().saveCall(call: call);

    call.hasDialled = true;

    if (callMade && historyMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallScreen(call: call),
          ));
    }
  }
}
