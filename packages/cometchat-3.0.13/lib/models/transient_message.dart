import 'package:cometchat/models/user.dart';

class TransientMessage {
  String receiverId;
  String receiverType;
  Map<String, dynamic> data;
  User? sender;

  TransientMessage({
    required this.receiverId,
    required this.receiverType,
    required this.data,
    this.sender,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['receiverId'] = receiverId;
    map['receiverType'] = receiverType;
    map['data'] = data;
    if (sender != null) {
      map['sender'] = sender!.toJson();
    }
    return map;
  }

  factory TransientMessage.fromMap(dynamic map) {
    return TransientMessage(
      receiverId: map['receiverId'],
      receiverType: map['receiverType'],
      data: Map<String, dynamic>.from(map['data'] ?? '{}'),
      sender: map['sender'] == null ? null : User.fromMap(map['sender']),
    );
  }

  @override
  String toString() {
    return 'TransientMessage{receiverId: $receiverId, receiverType: $receiverType, data: $data , sender $sender}';
  }
}
