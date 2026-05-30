import 'package:cometchat/cometchat_sdk.dart';

class BaseMessage extends AppEntity{
  int id;
  String muid;
  User? sender;
  AppEntity? receiver;
  String receiverUid;
  String type;
  String receiverType;
  String category;
  DateTime? sentAt;
  DateTime? deliveredAt;
  DateTime? readAt;
  Map<String, dynamic>? metadata;
  DateTime? readByMeAt;
  DateTime? deliveredToMeAt;
  DateTime? deletedAt;
  DateTime? editedAt;
  String? deletedBy;
  String? editedBy;
  DateTime? updatedAt;
  String? conversationId;
  int parentMessageId;
  int replyCount;

  BaseMessage({
    this.id = 0,
    this.muid = '',
    this.sender,
    this.receiver,
    required this.receiverUid,
    required this.type,
    required this.receiverType,
    this.category = '',
    this.sentAt,
    this.deliveredAt,
    required this.readAt,
    this.metadata,
    this.readByMeAt,
    this.deliveredToMeAt,
    this.deletedAt,
    this.editedAt,
    this.deletedBy,
    this.editedBy,
    this.updatedAt,
    this.conversationId,
    this.parentMessageId = 0,
    this.replyCount = 0,
  });

  factory BaseMessage.fromMap(dynamic map) {
    if (map == null) throw ArgumentError('The type of basemessage map is null');

    final String category = map['category'] ?? '';

    if (category.isEmpty) {
      throw Exception('Category is missing in JSON');
    }
    if (category == 'message') {
      if (map['type'] == 'text') {
        return TextMessage.fromMap(map);
      } else if (map['type'] == CometChatMessageType.file ||
          map['type'] == CometChatMessageType.image ||
          map['type'] == CometChatMessageType.video ||
          map['type'] == CometChatMessageType.audio) {
        return MediaMessage.fromMap(map);
      } else {
        // Custom message
        throw UnimplementedError();
      }
    } else if (category == 'action') {
      return Action.fromMap(map);
    } else if (category == 'call') {
      return Call.fromMap(map);
    } else if (category == 'custom') {
      return CustomMessage.fromMap(map);
    } else {
      throw ArgumentError();
    }
  }

  Map<String, dynamic> toJson() {
    User? userObj = sender;
    late Map receiverMap;
    if (receiverType == CometChatReceiverType.group) {
      Group grp = receiver as Group;
      receiverMap = grp.toJson();
    } else {
      User usr = receiver as User;
      receiverMap = usr.toJson();
    }

    final map = <String, dynamic>{};
    map['metadata'] = metadata;
    if (receiver != null) {
      map['receiver'] = receiverMap;
    }
    map['editedBy'] = editedBy;
    map['conversationId'] = conversationId;
    map['sentAt'] = sentAt == null ? 0 : sentAt?.millisecondsSinceEpoch;
    map['receiverUid'] = receiverUid;
    map['type'] = type;
    map['readAt'] = readAt == null ? 0 : readAt?.millisecondsSinceEpoch;
    map['deletedBy'] = deletedBy;
    map['deliveredAt'] = deliveredAt == null ? 0 : deliveredAt?.millisecondsSinceEpoch;
    map['muid'] = muid;
    map['deletedAt'] = deletedAt == null ? 0 : deletedAt?.millisecondsSinceEpoch;
    map['replyCount'] = replyCount;
    if (sender != null) {
      map['sender'] = userObj!.toJson();
    }
    map['receiverType'] = receiverType;
    map['editedAt'] = editedAt == null ? 0 : editedAt?.millisecondsSinceEpoch;
    map['parentMessageId'] = parentMessageId;
    map['readByMeAt'] = readByMeAt == null ? 0 : readByMeAt?.millisecondsSinceEpoch;
    map['id'] = id;
    map['category'] = category;
    map['deliveredToMeAt'] = deliveredToMeAt == null ? 0 : deliveredToMeAt?.millisecondsSinceEpoch;
    map['updatedAt'] = updatedAt != null ? updatedAt?.millisecondsSinceEpoch : 0;
    return map;
  }
}
