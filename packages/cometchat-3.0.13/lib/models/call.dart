import 'dart:convert';

import 'package:cometchat/models/app_entity.dart';
import 'package:cometchat/models/base_message.dart';
import 'package:cometchat/models/group.dart';
import 'package:cometchat/models/user.dart';

class Call extends BaseMessage {
  String? sessionId;
  String? callStatus;
  String? action;
  String? rawData;
  DateTime? initiatedAt;
  DateTime? joinedAt;
  AppEntity? callInitiator;
  AppEntity? callReceiver;

  Call({
    this.sessionId,
    this.callStatus,
    this.action,
    this.rawData,
    this.initiatedAt,
    this.joinedAt,
    this.callInitiator,
    this.callReceiver,
    int? id,
    String? muid,
    User? sender,
    AppEntity? receiver,
    required String receiverUid,
    required String type,
    required String receiverType,
    String? category,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    Map<String, dynamic>? metadata,
    DateTime? readByMeAt,
    DateTime? deliveredToMeAt,
    DateTime? deletedAt,
    DateTime? editedAt,
    String? deletedBy,
    String? editedBy,
    DateTime? updatedAt,
    String? conversationId,
    int? parentMessageId,
    int? replyCount,
  }) : super(
          id: id ?? 0,
          muid: muid ?? '',
          sender: sender,
          receiver: receiver,
          receiverUid: receiverUid,
          type: type,
          receiverType: receiverType,
          category: category ?? '',
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
          parentMessageId: parentMessageId ?? 0,
          replyCount: replyCount ?? 0,
        );

  factory Call.fromMap(dynamic map, {AppEntity? receiver}) {
    if (map == null) throw ArgumentError('The type of mediamessage map is null');

    final appEntity = (map['receiver'] == null)
        ? receiver
        : (map['receiverType'] == 'user')
            ? User.fromMap(map['receiver'])
            : Group.fromMap(map['receiver']);

    final conversationId = map['conversationId'].isEmpty
        ? map['receiverType'] == 'user'
            ? '${map['sender']['uid']}_user_${(appEntity as User).uid}'
            : 'group_${map['receiver']['guid']}'
        : map['conversationId'];

    final callReceiver = (map['callReceiver'] == null)
        ? receiver
        : (map['callReceiver']['guid'] == null ||
                map['callReceiver']['guid'] == 'null')
            ? User.fromMap(map['callReceiver'])
            : Group.fromMap(map['callReceiver']);

    final callInitiator = (map['callInitiator'] == null)
        ? receiver
        : (map['callInitiator']['guid'] == null ||
                map['callInitiator']['guid'] == 'null')
            ? User.fromMap(map['callInitiator'])
            : Group.fromMap(map['callInitiator']);

    return Call(
      sessionId: map['sessionId'],
      callStatus: map['callStatus'],
      action: map['action'],
      callReceiver: callReceiver,
      callInitiator: callInitiator,
      initiatedAt: map['initiatedAt'] == 0 || map['initiatedAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['initiatedAt'] * 1000),
      joinedAt: map['joinedAt'] == 0 || map['joinedAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['joinedAt'] * 1000),
      id: map['id'],
      muid: map['muid'],
      sender: map['sender'] == null ? null : User.fromMap(map['sender']),
      receiver: appEntity,
      receiverUid: map['receiverUid'],
      type: map['type'],
      receiverType: map['receiverType'],
      category: map['category'],
      sentAt: map['sentAt'] == 0 || map['sentAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['sentAt'] * 1000),
      deliveredAt: map['deliveredAt'] == 0 || map['deliveredAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['deliveredAt'] * 1000),
      readAt: map['readAt'] == 0 || map['readAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['readAt'] * 1000),
      metadata: Map<String, dynamic>.from(json.decode(map['metadata'] ?? '{}')),
      readByMeAt: map['readByMeAt'] == 0 || map['readByMeAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['readByMeAt'] * 1000),
      deliveredToMeAt: map['deliveredToMeAt'] == 0 ||
              map['deliveredToMeAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['deliveredToMeAt'] * 1000),
      deletedAt: map['deletedAt'] == 0 || map['deletedAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] * 1000),
      editedAt: map['editedAt'] == 0 || map['editedAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['editedAt'] * 1000),
      deletedBy: map['deletedBy'],
      editedBy: map['editedBy'],
      updatedAt: map['updatedAt'] == 0 || map['updatedAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] * 1000),
      conversationId: conversationId,
      parentMessageId: map['parentMessageId'],
      replyCount: map['replyCount'],
    );
  }
}
