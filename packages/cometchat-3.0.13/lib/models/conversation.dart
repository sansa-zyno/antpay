import 'app_entity.dart';
import 'base_message.dart';
import 'group.dart';
import 'user.dart';

class Conversation {
  String? conversationId;
  String conversationType;
  AppEntity conversationWith;
  BaseMessage? lastMessage;
  DateTime? updatedAt;
  int? unreadMessageCount;
  List<String>? tags;

  Conversation({
    this.conversationId,
    required this.conversationType,
    required this.conversationWith,
    this.lastMessage,
    this.updatedAt,
    this.unreadMessageCount = 0,
    this.tags
  });

  factory Conversation.fromMap(dynamic map) {
    if (map == null)
      throw ArgumentError('The type of conversation map is null');

    final appEntity = (map['conversationType'] == 'user')
        ? User.fromMap(map['conversationWith'])
        : Group.fromMap(map['conversationWith']);

    return Conversation(
      conversationId: map['conversationId'],
      conversationType: map['conversationType'],
      conversationWith: appEntity,
      lastMessage: map['lastMessage'] == null || map['lastMessage'].isEmpty
          ? null
          : BaseMessage.fromMap(map['lastMessage']),
      updatedAt:map['updatedAt']==0|| map['updatedAt']==null?null:
      DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] * 1000),
      unreadMessageCount: map['unreadMessageCount'],
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  @override
  String toString() {
    return 'Conversation{conversationId: $conversationId, conversationType: $conversationType, conversationWith: $conversationWith, lastMessage: $lastMessage, updatedAt: $updatedAt, unreadMessageCount: $unreadMessageCount, tags: $tags}';
  }
}
