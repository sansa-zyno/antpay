import 'dart:convert';
import 'app_entity.dart';

class User extends AppEntity {
  String uid;
  String name;
  String? avatar;
  String? link;
  String? role;
  String? status;
  String? statusMessage;
  DateTime? lastActiveAt;
  List<String>? tags;
  bool? hasBlockedMe;
  bool? blockedByMe;
  Map<String, dynamic>? metadata;

  User({
    this.uid = "",
    required this.name,
    this.avatar,
    this.link,
    this.role,
    this.status,
    this.statusMessage,
    this.lastActiveAt,
    this.tags,
    this.metadata,
    this.hasBlockedMe,
    this.blockedByMe,
  });

  User.fromUID({
    required this.uid,
    required this.name,
    this.avatar = '',
    this.link = '',
    this.role = 'default',
    this.status = 'offline',
    this.statusMessage = '',
    this.lastActiveAt,
    this.tags = const [],
    this.metadata = const {},
    this.hasBlockedMe = false,
    this.blockedByMe = false,
  });

  factory User.fromMap(dynamic map) {
    if (map == null) throw ArgumentError('The type of user map is null');
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'],
      link: map['link'],
      role: map['role'],
      status: map['status'],
      statusMessage: map['statusMessage'],
      lastActiveAt: map['lastActiveAt'] == 0 || map['lastActiveAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastActiveAt'].toInt() * 1000),
      tags: map['tags'] == null ? null : List<String>.from(map['tags']),
      hasBlockedMe: map['hasBlockedMe'],
      blockedByMe: map['blockedByMe'],
      metadata: map['metadata'] == null ? null : Map<String, dynamic>.from(json.decode(map['metadata'])),
    );
  }

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, avatar: $avatar, link: $link, role: $role, status: $status, statusMessage: $statusMessage, lastActiveAt: $lastActiveAt, tags: $tags, hasBlockedMe: $hasBlockedMe, blockedByMe: $blockedByMe, metadata: $metadata}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['name'] = name;
    map['link'] = link;
    map['avatar'] = avatar;
    if (metadata != null) {
      map['metadata'] = metadata;
    }
    map['status'] = status;
    map['role'] = role;
    map['statusMessage'] = statusMessage;
    map['tags'] = tags;
    map['hasBlockedMe'] = hasBlockedMe;
    map['blockedByMe'] = blockedByMe;
    map['lastActiveAt'] = lastActiveAt == null ? 0 : lastActiveAt?.millisecondsSinceEpoch;
    // map['updatedAt'] = updatedAt;
    // map['conversationId'] = conversationId;
    return map;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['name'] = name;
    map['link'] = link;
    map['avatar'] = avatar;
    map['status'] = status;
    map['role'] = role;
    map['lastActiveAt'] = lastActiveAt;
    map['statusMessage'] = statusMessage;
    map['tags'] = tags;
    map['hasBlockedMe'] = hasBlockedMe;
    map['blockedByMe'] = blockedByMe;
    map['metadata'] = metadata;
    return map;
  }
}
