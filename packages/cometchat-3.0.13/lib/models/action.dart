import 'dart:convert';

import 'app_entity.dart';
import 'base_message.dart';
import 'group.dart';
import 'user.dart';

class Action extends BaseMessage {
  String message;
  String rawData;
  String action;
  String oldScope;
  String newScope;
  AppEntity? actionBy;// -> User
  AppEntity? actionFor;//user  group- > add , Add
  AppEntity? actionOn;//Group, Action Message


  Action({
    required this.message,
    required this.rawData,
    required this.action,
    required this.oldScope,
    required this.newScope,
    required int id,
    required String? muid,
    required User sender,
    required AppEntity receiver,
    required String receiverUid,
    required String type,
    required String receiverType,
    required String category,
    required DateTime sentAt,
    required DateTime deliveredAt,
    required DateTime readAt,
    Map<String, dynamic> metadata = const {},
    required DateTime readByMeAt,
    required DateTime deliveredToMeAt,
    required DateTime deletedAt,
    required DateTime editedAt,
    required String? deletedBy,
    required String? editedBy,
    required DateTime updatedAt,
    required String conversationId,
    required int parentMessageId,
    required replyCount,
    this.actionBy,
    this.actionOn,
    this.actionFor
  }) : super(
          id: id,
          muid: muid ?? '',
          sender: sender,
          receiver: receiver,
          receiverUid: receiverUid,
          type: type,
          receiverType: receiverType,
          category: category,
          sentAt: sentAt,
          deliveredAt: deliveredAt,
          readAt: readAt,
          metadata: metadata,
          readByMeAt: readByMeAt,
          deliveredToMeAt: deliveredToMeAt,
          deletedAt: deletedAt,
          editedAt: editedAt,
          deletedBy: deletedBy,
          editedBy: editedBy,
          updatedAt: updatedAt,
          conversationId: conversationId,
          parentMessageId: parentMessageId,
          replyCount: replyCount,
        );

  factory Action.fromMap(dynamic map) {
    if (map == null) throw ArgumentError('The type of action map is null');

    final appEntity = (map['receiverType'] == 'user')
        ? User.fromMap(map['receiver'])
        : Group.fromMap(map['receiver']);


    AppEntity? getAppEntity(dynamic  map){
      AppEntity? returningEntity;
      if(map==null) return null;
      if(map['uid']!=null){
        returningEntity = User.fromMap(map);
      }else if(map['guid']!=null){
        returningEntity = Group.fromMap(map);
      }else if(map['id']!=null){
        return(BaseMessage.fromMap(map));
      }
      return returningEntity;
    }


    return Action(
      message: map['message'] ?? '',
      rawData: map['rawData'] ?? '{}',
      action: map['action'].toString(),
      oldScope: map['oldScope'].toString(),
      newScope: map['newScope'].toString(),
      id: map['id'],
      muid: map['muid'],
      sender: User.fromMap(map['sender']),
      receiver: appEntity,
      receiverUid: map['receiverUid'],
      type: map['type'],
      receiverType: map['receiverType'],
      category: map['category'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(map['sentAt'] * 1000),
      deliveredAt: DateTime.fromMillisecondsSinceEpoch(map['deliveredAt'] * 1000),
      readAt: DateTime.fromMillisecondsSinceEpoch(map['readAt'] * 1000),
      metadata: Map<String, dynamic>.from(json.decode(map['metadata'] ?? '{}')),
      readByMeAt: DateTime.fromMillisecondsSinceEpoch(map['readByMeAt'] * 1000),
      deliveredToMeAt: DateTime.fromMillisecondsSinceEpoch(map['deliveredToMeAt'] * 1000),
      deletedAt: DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] * 1000),
      editedAt: DateTime.fromMillisecondsSinceEpoch(map['editedAt'] * 1000),
      deletedBy: map['deletedBy'],
      editedBy: map['editedBy'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] * 1000),
      conversationId: map['conversationId'],
      parentMessageId: map['parentMessageId'],
      replyCount: map['replyCount'],
      actionBy: getAppEntity(map['actionBy']),
      actionOn :getAppEntity(map['actionOn']),
      actionFor :getAppEntity(map['actionFor'])
    );
  }

  @override
  String toString() {
    return 'Action{message: $message, rawData: $rawData, action: $action, oldScope: $oldScope, newScope: $newScope}';
  }


}
