import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BannedGroupMembersRequest {
  static final String directionBlockedByMe = "blockedByMe";
  static final String directionHasBlockedMe = "hasBlockedMe";
  static final String directionBoth = "both";

  static final int maxLimit = 100;
  static final int defaultLimit = 30;

  final String guid;
  final int limit;
  final String? searchKeyword;
  String? key;

  BannedGroupMembersRequest._builder(BannedGroupMembersRequestBuilder builder)
      : limit = builder.limit ?? defaultLimit,
        guid = builder.guid,
        searchKeyword = builder.searchKeyword;

  ///fetch the list of Users that logged-in user have blocked.
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  ///
  /// See also [Android Documentation](https://www.cometchat.com/docs/android-chat-sdk/users-block-users) [IOS Documentation](https://www.cometchat.com/docs/ios-chat-sdk/users-block-users)
  Future<List<GroupMember>> fetchNext({required Function(List<GroupMember> groupList)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('fetchBlockedGroupMembers', {
        'limit': this.limit,
        'searchKeyword': this.searchKeyword,
        'guid': this.guid,
        'key': this.key
      });
      final List<GroupMember> res = [];
      if (result != null) {
        key = result["key"];
        if (result["list"] != null) {
          for (var _obj in result["list"]) {
            try {
              res.add(GroupMember.fromMap(_obj));
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

class BannedGroupMembersRequestBuilder {
  String guid;
  int? limit;
  String? searchKeyword;

  BannedGroupMembersRequestBuilder({required this.guid});

  BannedGroupMembersRequest build() {
    return BannedGroupMembersRequest._builder(this);
  }
}
