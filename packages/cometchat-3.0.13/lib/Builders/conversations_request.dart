import 'package:cometchat/models/conversation.dart';
import 'package:cometchat/Exception/CometChatException.dart';
import 'package:cometchat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConversationsRequest {
  static const int maxLimit = 50;
  static const int defaultLimit = 30;

  final int? limit;
  final String? conversationType;
  bool? init;
  final bool? withUserAndGroupTags;
  final bool? withTags;
  final List<String>? tags;
  String? key;

  ConversationsRequest._builder(ConversationsRequestBuilder builder)
      : limit = builder.limit,
        conversationType = builder.conversationType,
        withUserAndGroupTags = builder.withUserAndGroupTags,
        withTags = builder.withTags ?? false,
        tags = builder.tags,
        init = true;

  ///Returns a list of [Conversation] object fetched after putting the filters.
  ///
  /// [Conversation] provide the last messages for every one-on-one and group
  /// conversation the logged-in user is a part of. This makes it easy for you to build a Recent Chats list.
  ///
  /// [limit] the number of conversations that should be fetched in a single iteration.
  ///
  /// [conversationType] used to fetch user or group conversations specifically.
  ///
  /// The method could throw [PlatformException] with error codes specifying the cause
  ///
  /// See also [Android Documentation](https://www.cometchat.com/docs/android-chat-sdk/messaging-retrieve-conversations) [IOS Documentation](https://www.cometchat.com/docs/ios-chat-sdk/messaging-conversations)
  Future<List<Conversation>> fetchNext({required Function(List<Conversation> message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('fetchNextConversations', {
        'limit': this.limit,
        'type': this.conversationType,
        'init': this.init,
        'withUserAndGroupTags': withUserAndGroupTags,
        'withTags': this.withTags,
        'tags': this.tags,
        'key': this.key
      });
      final List<Conversation> res = [];
      if (result != null) {
        key = result["key"];
        debugPrint("key is $key");
        if (result["list"] != null) {
          for (var _obj in result["list"]) {
            try {
              res.add(Conversation.fromMap(_obj));
            } catch (e) {
              if(onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString() , e.toString()));
              return [];
            }
          }
        }
      }
      if(onSuccess != null) onSuccess(res);
      this.init = false;
      return res;
    } on PlatformException catch (platformException) {
      if(onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if(onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString() , e.toString()));
    }
    return [];
  }
}

class ConversationsRequestBuilder {
  int? limit;
  String? conversationType;
  bool? withUserAndGroupTags;
  bool? withTags;
  List<String>? tags;

  ConversationsRequestBuilder();

  ConversationsRequest build() {
    return ConversationsRequest._builder(this);
  }
}
