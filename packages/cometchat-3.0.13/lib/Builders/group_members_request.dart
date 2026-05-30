import 'package:cometchat/models/group_member.dart';
import 'package:cometchat/Exception/CometChatException.dart';
import 'package:cometchat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupMembersRequest {
  static final int maxLimit = 100;
  static const int defaultLimit = 30;

  final String guid;
  final int limit;
  final String? searchKeyword;
  final List<String>? scopes;
  String? key;

  GroupMembersRequest._builder(GroupMembersRequestBuilder builder)
      : limit = builder.limit ?? maxLimit,
        guid = builder.guid,
        searchKeyword = builder.searchKeyword,
        scopes = builder.scopes;

  ///fetch the list of groups members for a group , returns List of [GroupMember].
  ///
  /// [guid] of the group for which the members are to be fetched.
  ///
  /// [limit] : the number of members that should be fetched in a single iteration.
  ///
  /// [keyword] : set the search string based on which the group members are to be fetched.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  ///
  /// See also [Android Documentation](https://www.cometchat.com/docs/android-chat-sdk/groups-retrieve-group-members) [IOS Documentation](https://www.cometchat.com/docs/ios-chat-sdk/groups-retrieve-group-members)
  Future<List<GroupMember>> fetchNext({required Function(List<GroupMember> groupMemberList)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('fetchNextGroupMembers', {
        'guid': this.guid,
        'limit': this.limit,
        'keyword': this.searchKeyword,
        'scopes': this.scopes,
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

class GroupMembersRequestBuilder {
  String guid;
  int? limit;
  String? searchKeyword;
  List<String>? scopes;

  GroupMembersRequestBuilder(this.guid);

  GroupMembersRequest build() {
    return GroupMembersRequest._builder(this);
  }
}
