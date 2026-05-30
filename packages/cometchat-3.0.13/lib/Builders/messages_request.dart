import 'package:cometchat/Exception/CometChatException.dart';
import 'package:cometchat/models/base_message.dart';
import 'package:cometchat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessagesRequest {
  static final int? maxLimit = 100;
  static final int? defaultLimit = 30;

  final String? uid;
  final String? guid;
  final int? limit;
  final int? messageId;
  final DateTime? timestamp;
  final bool? unread;
  final bool? hideMessagesFromBlockedUsers;
  final String? searchKeyword;
  final DateTime? updatedAfter;
  final bool? updatesOnly;
  final String? category;
  final String? type;
  final int? parentMessageId;
  final bool? hideReplies;
  final bool? hideDeleted;
  final List<String>? categories;
  final List<String>? types;
  final bool? withTags;
  final List<String>? tags;
  String? key;

  MessagesRequest._builder(MessagesRequestBuilder builder)
      : limit = builder.limit ?? maxLimit,
        uid = builder.uid,
        guid = builder.guid,
        messageId = builder.messageId,
        timestamp = builder.timestamp,
        unread = builder.unread,
        hideMessagesFromBlockedUsers = builder.hideMessagesFromBlockedUsers,
        searchKeyword = builder.searchKeyword,
        updatedAfter = builder.updatedAfter,
        updatesOnly = builder.updatesOnly,
        category = builder.category,
        type = builder.type,
        parentMessageId = builder.parentMessageId,
        hideReplies = builder.hideReplies,
        hideDeleted = builder.hideDeleted,
        categories = builder.categories,
        types = builder.types,
        withTags = builder.withTags ?? false,
        tags = builder.tags;

  ///Returns a list of [BaseMessage] object fetched after putting the filters.
  ///
  /// [uid] user with whom the conversation is to be fetched.
  ///
  /// [guid] group for which the conversations are to be fetched.
  ///
  /// [searchTerm] fetch messages that have search term.
  ///
  /// [afterMessageId] provides messages only before the message-id.
  ///
  /// [limit] informs the SDK to fetch the specified number of messages in one iteration.
  ///
  /// The method could throw [PlatformException] with error codes specifying the cause
  ///
  /// See also [Android Documentation](https://www.cometchat.com/docs/android-chat-sdk/groups-create-group) [IOS Documentation](https://www.cometchat.com/docs/ios-chat-sdk/groups-create-a-group)
  Future<List<BaseMessage>> fetchNext({required Function(List<BaseMessage> message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try{
      int? updateAfterLong;
      int? timestampLong;
      if (this.updatedAfter != null) {
        updateAfterLong = this.updatedAfter!.millisecondsSinceEpoch ~/ 1000;
      }
      if (this.timestamp != null) {
        timestampLong = this.timestamp!.millisecondsSinceEpoch ~/ 1000;
      }
      final result = await channel.invokeMethod('fetchNextMessages', {
        'uid': this.uid,
        'guid': this.guid,
        'searchTerm': this.searchKeyword,
        'messageId': this.messageId,
        'limit': this.limit,
        'timestamp': timestampLong,
        'unread': this.unread,
        'hideblockedUsers': this.hideMessagesFromBlockedUsers,
        'updateAfter': updateAfterLong,
        'updatesOnly': this.updatesOnly,
        'categories': this.categories,
        'types': this.types,
        'parentMessageId': this.parentMessageId,
        'hideReplies': this.hideReplies,
        'hideDeletedMessages': this.hideDeleted,
        'withTags': this.withTags,
        'tags': this.tags,
        'key': this.key
      });
      final List<BaseMessage> res = [];
      if (result != null) {
        key = result["key"];
        if (result["list"] != null) {
          for (var _obj in result["list"]) {
            try {
              res.add(BaseMessage.fromMap(_obj));
            } catch (e) {
              if(onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString() , e.toString()));
              return [];
            }
          }
        }
      }
      if(onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if(onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if(onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString() , e.toString()));
    }
    return [];
  }

  ///Returns a list of [BaseMessage] object fetched after putting the filters.
  ///
  /// [uid] user with whom the conversation is to be fetched.
  ///
  /// [guid] group for which the conversations are to be fetched.
  ///
  /// [searchTerm] fetch messages that have search term.
  ///
  /// [afterMessageId] provides messages only before the message-id.
  ///
  /// [limit] informs the SDK to fetch the specified number of messages in one iteration.
  ///
  /// The method could throw [PlatformException] with error codes specifying the cause
  ///
  /// See also [Android Documentation](https://www.cometchat.com/docs/android-chat-sdk/groups-create-group) [IOS Documentation](https://www.cometchat.com/docs/ios-chat-sdk/groups-create-a-group)
  Future<List<BaseMessage>> fetchPrevious({required Function(List<BaseMessage> message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try{
      int? updateAfterLong;
      int? timestampLong;
      if (this.updatedAfter != null) {
        updateAfterLong = this.updatedAfter!.millisecondsSinceEpoch ~/ 1000;
      }
      if (this.timestamp != null) {
        timestampLong = this.timestamp!.millisecondsSinceEpoch ~/ 1000;
      }
      final result = await channel.invokeMethod('fetchPreviousMessages', {
        'uid': this.uid,
        'guid': this.guid,
        'searchTerm': this.searchKeyword,
        'messageId': this.messageId,
        'limit': this.limit,
        'timestamp': timestampLong,
        'unread': this.unread,
        'hideblockedUsers': this.hideMessagesFromBlockedUsers,
        'updateAfter': updateAfterLong,
        'updatesOnly': this.updatesOnly,
        'categories': this.categories,
        'types': this.types,
        'parentMessageId': this.parentMessageId,
        'hideReplies': this.hideReplies,
        'hideDeletedMessages': this.hideDeleted,
        'withTags': this.withTags,
        'tags': this.tags,
        'key': this.key
      });
      final List<BaseMessage> res = [];
      if (result != null) {
        key = result["key"];
        debugPrint("key in SDK $key");
        if (result["list"] != null) {
          for (var _obj in result["list"]) {
            try {
              res.add(BaseMessage.fromMap(_obj));
            } catch (e) {
              if(onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString() , e.toString()));
              return [];
            }
          }
        }
      }
      if(onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if(onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      if(onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString() , e.toString()));
    }
    return [];
  }
}

class MessagesRequestBuilder {
  String? uid;
  String? guid;
  int? limit;
  int? messageId;
  DateTime? timestamp;
  bool? unread;
  bool? hideMessagesFromBlockedUsers;
  String? searchKeyword;
  DateTime? updatedAfter;
  bool? updatesOnly;
  String? category;
  String? type;
  int? parentMessageId;
  bool? hideReplies;
  bool? hideDeleted;
  List<String>? categories;
  List<String>? types;
  bool? withTags;
  List<String>? tags;

  MessagesRequestBuilder();

  MessagesRequest build() {
    return MessagesRequest._builder(this);
  }
}
