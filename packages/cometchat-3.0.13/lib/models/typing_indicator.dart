import 'package:cometchat/models/user.dart';

class TypingIndicator{
   User sender;
   String receiverId;
   String receiverType;
   Map<String,String>? metadata;
   DateTime lastTimestamp;

   TypingIndicator({
      required this.sender,
      required this.receiverId,
      required this.receiverType,
      this.metadata,
      required this.lastTimestamp,
   });

   factory TypingIndicator.fromMap(dynamic map){
      return TypingIndicator(
         sender: User.fromMap(map['sender']),
         receiverId: map['receiverId'],
         receiverType: map['receiverType'],
         metadata: map['metadata'],
         lastTimestamp:
         DateTime.fromMillisecondsSinceEpoch(map['lastTimestamp']??0 * 1000),
      );
   }

   @override
  String toString() {
    return 'TypingIndicator{sender: $sender, receiverId: $receiverId, receiverType: $receiverType, metadata: $metadata, lastTimestamp: $lastTimestamp}';
  }
}