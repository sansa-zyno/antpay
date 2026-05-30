import '../models/call.dart';
import 'message_listener.dart';

class CallListener implements EventHandler{
  void onIncomingCallReceived(Call call) {}
  void onOutgoingCallAccepted(Call call) {}
  void onOutgoingCallRejected(Call call) {}
  void onIncomingCallCancelled(Call call) {}
  void onCallEndedMessageReceived(Call call) {}
}