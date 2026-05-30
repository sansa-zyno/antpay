import 'package:cometchat/models/base_message.dart';
import 'package:cometchat/models/custom_message.dart';
import 'package:cometchat/models/media_message.dart';
import 'package:cometchat/models/message_receipt.dart';
import 'package:cometchat/models/text_message.dart';
import 'package:cometchat/models/transient_message.dart';
import 'package:cometchat/models/typing_indicator.dart';

class MessageListener implements EventHandler {
  void onTextMessageReceived(TextMessage textMessage) {}
  void onMediaMessageReceived(MediaMessage mediaMessage) {}
  void onCustomMessageReceived(CustomMessage customMessage) {}
  void onTypingStarted(TypingIndicator typingIndicator) {}
  void onTypingEnded(TypingIndicator typingIndicator) {}
  void onMessagesDelivered(MessageReceipt messageReceipt) {}
  void onMessagesRead(MessageReceipt messageReceipt) {}
  void onMessageEdited(BaseMessage message) {}
  void onMessageDeleted(BaseMessage message) {}
  void onTransientMessageReceived(TransientMessage message) {}
}

abstract class EventHandler {}
