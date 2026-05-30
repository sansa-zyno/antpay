import 'package:cometchat/Exception/CometChatException.dart';
import 'package:cometchat/models/user.dart';
import 'package:cometchat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlockedUsersRequest {
  static final String directionBlockedByMe = "blockedByMe";
  static final String directionHasBlockedMe = "hasBlockedMe";
  static final String directionBoth = "both";

  static final int maxLimit = 100;
  static final int defaultLimit = 30;

  final int? limit;
  final int? token;
  final String? searchKeyword;
  final String? direction;
  String? key;

  BlockedUsersRequest._builder(BlockedUsersRequestBuilder builder)
      : limit = builder.limit,
        token = builder.token,
        searchKeyword = builder.searchKeyword,
        direction = builder.direction;

  ///fetch the list of Users that logged-in user have blocked.
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  ///
  /// See also [Android Documentation](https://www.cometchat.com/docs/android-chat-sdk/users-block-users) [IOS Documentation](https://www.cometchat.com/docs/ios-chat-sdk/users-block-users)
  Future<List<User>> fetchNext({required Function(List<User> userList)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('fetchBlockedUsers', {
        'limit': this.limit,
        'searchKeyword': this.searchKeyword,
        'direction': this.direction,
        'key': this.key
      });
      final List<User> res = [];
      if (result != null) {
        key = result["key"];
        if (result["list"] != null) {
          for (var _obj in result["list"]) {
            try {
              res.add(User.fromMap(_obj));
            } catch (e) {
              if(onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString() , e.toString()));
              return [];
            }
          }
        }
      }
      debugPrint("key is $key");
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
}

class BlockedUsersRequestBuilder {
  int? limit;
  int? token;
  String? searchKeyword;
  String? direction;

  BlockedUsersRequestBuilder();

  BlockedUsersRequest build() {
    return BlockedUsersRequest._builder(this);
  }
}
