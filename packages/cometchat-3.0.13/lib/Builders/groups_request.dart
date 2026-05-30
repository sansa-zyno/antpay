import 'package:cometchat/models/group.dart';
import 'package:cometchat/Exception/CometChatException.dart';
import 'package:cometchat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupsRequest {
  static final int maxLimit = 100;
  static const int defaultLimit = 30;

  final int? limit;
  final String? searchKeyword;
  final bool? joinedOnly;
  final List<String>? tags;
  final bool? withTags;
  String? key;

  GroupsRequest._builder(GroupsRequestBuilder builder)
      : limit = builder.limit ?? maxLimit,
        searchKeyword = builder.searchKeyword,
        joinedOnly = builder.joinedOnly,
        tags = builder.tags,
        withTags = builder.withTags;

  ///Returns list of  [Group] object fetched after putting the filters.
  ///
  /// [limit] limit the number of groups retreaved.
  ///
  /// [searchTerm] term for group retreavel.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  ///
  /// See also [Android Documentation](https://www.cometchat.com/docs/android-chat-sdk/groups-retrieve-groups) [IOS Documentation](https://www.cometchat.com/docs/ios-chat-sdk/groups-retrieve-groups)
  Future<List<Group>> fetchNext({required Function(List<Group> groupList)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('fetchNextGroups', {
        'searchTerm': this.searchKeyword,
        'limit': this.limit,
        'joinedOnly': this.joinedOnly,
        'tags': this.tags,
        'withTags': this.withTags,
        'key': this.key
      });
      final List<Group> res = [];
      if (result != null) {
        key = result["key"];
        if (result["list"] != null) {
          for (var _obj in result["list"]) {
            try {
              res.add(Group.fromMap(_obj));
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

class GroupsRequestBuilder {
  int? limit;
  String? searchKeyword;
  bool? joinedOnly = false;
  List<String>? tags;
  bool? withTags = false;

  GroupsRequestBuilder();

  GroupsRequest build() {
    return GroupsRequest._builder(this);
  }
}
