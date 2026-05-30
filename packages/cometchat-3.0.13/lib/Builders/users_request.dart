import 'package:cometchat/Exception/CometChatException.dart';
import 'package:cometchat/models/user.dart';
import 'package:cometchat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsersRequest {
  final int? limit;
  final int? token;
  final String? searchKeyword;
  final bool? hideBlockedUsers;
  final String? role;
  final bool? friendsOnly;
  final List<String>? roles;
  final List<String>? tags;
  final bool? withTags;
  final String? userStatus;
  final int? nextPage;
  final int? totalPages;
  final int? currentPage;
  final bool? inProgress;
  final List<String>? uids;
  String? key;

  UsersRequest._builder(UsersRequestBuilder builder)
      : limit = builder.limit,
        token = builder.token,
        searchKeyword = builder.searchKeyword,
        hideBlockedUsers = builder.hideBlockedUsers,
        role = builder.role,
        friendsOnly = builder.friendsOnly,
        roles = builder.roles,
        tags = builder.tags,
        withTags = builder.withTags,
        userStatus = builder.userStatus,
        nextPage = builder.nextPage,
        totalPages = builder.totalPages,
        currentPage = builder.currentPage,
        inProgress = builder.inProgress,
        uids = builder.uids;

  Future<List<User>> fetchNext({required Function(List<User> userList)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('fetchUsers', {
        'searchTerm': this.searchKeyword,
        'limit': this.limit,
        'hidebloackedUsers': this.hideBlockedUsers,
        'userRoles': this.roles,
        'friendsOnly': this.friendsOnly,
        'tags': this.tags,
        'withTags': this.withTags,
        'userStatus': this.userStatus,
        'uids': this.uids,
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

class UsersRequestBuilder {
  int? limit;
  int? token;
  String? searchKeyword;
  bool? hideBlockedUsers;
  String? role;
  bool? friendsOnly;
  List<String>? roles;
  List<String>? tags;
  bool? withTags;
  String? userStatus;
  int? nextPage;
  int? totalPages;
  int? currentPage;
  bool? inProgress;
  List<String>? uids;

  UsersRequestBuilder();

  UsersRequest build() {
    return UsersRequest._builder(this);
  }
}
