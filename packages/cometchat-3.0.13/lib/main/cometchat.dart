import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cometchat/Builders/app_settings_request.dart';
import 'package:cometchat/Exception/CometChatException.dart';
import 'package:cometchat/handlers/connection_listener.dart';
import 'package:cometchat/handlers/group_listener.dart';
import 'package:cometchat/handlers/login_listener.dart';
import 'package:cometchat/handlers/message_listener.dart';
import 'package:cometchat/handlers/user_listener.dart';
import 'package:cometchat/main/package_constants.dart';
import 'package:cometchat/models/app_entity.dart';
import 'package:cometchat/models/custom_message.dart';
import 'package:cometchat/models/message_receipt.dart';
import 'package:cometchat/models/transient_message.dart';
import 'package:cometchat/models/typing_indicator.dart';
import 'package:cometchat/utils/constants.dart';
import 'package:flutter/material.dart';
import '../handlers/call_listener.dart';
import '../models/call.dart';
import '../models/conversation.dart';
import '../models/group.dart';
import '../models/group_member.dart';
import 'package:flutter/services.dart';
import '../models/base_message.dart';
import '../models/media_message.dart';
import '../models/text_message.dart';
import '../models/user.dart';
import '../models/action.dart' as action_import;

/// Flutter wrapper for using CometChat SDK.
///
/// for more information on how to use wrapper effectively.
class CometChat {
  final String appId;

  /// Use this only for testing purpose
  final String? authKey;
  final String region;

  ///Constructor for creating CometChat object
  /// [appId] refers to your CometChat App ID.
  /// [region] The region where the app was created.
  CometChat(
    this.appId, {
    @deprecated this.authKey,
    this.region = 'us',
  });

  ///This is stream channel to receiver messages

  static late Stream? nativeStream;

  static Map<String, MessageListener> _messageListeners = {};
  static Map<String, UserListener> _userListeners = {};
  static Map<String, GroupListener> _groupListeners = {};
  static Map<String, LoginListener> _loginListeners = {};
  static Map<String, ConnectionListener> _connectionListeners = {};
  static Map<String, CallListener> _callListener = {}; //Call-SDK-changes

  ///For every activity or fragment you wish to receive messages in, you need to register the MessageListener
  ///
  /// [listenerId] unique id for listener
  static addMessageListener(String listenerId, MessageListener listenerClass) {
    _messageListeners[listenerId] = listenerClass;
  }

  ///To remove message listener
  ///
  ///We recommend you remove the listener once the activity or fragment is not in use. Typically, this can be added in the dispose() method.
  static removeMessageListener(String listenerId) {
    _messageListeners.remove(listenerId);
  }

  ///The UserListener class provides you with live events related to users
  /// [listenerId] unique id for listener
  static addUserListener(String listenerId, UserListener listenerClass) {
    _userListeners[listenerId] = listenerClass;
  }

  ///Remove User Listener
  static removeUserListener(String listenerId) {
    _userListeners.remove(listenerId);
  }

  /// The GroupListener class provides you with all the real-time events related to groups
  static addGroupListener(String listenerId, GroupListener listenerClass) {
    _groupListeners[listenerId] = listenerClass;
  }

  ///Remove Group Listener
  static removeGroupListener(String listenerId) {
    _groupListeners.remove(listenerId);
  }

  /// The LoginListener class provides you with all the real-time updates for the login and logout events
  static addloginListener(String listenerId, LoginListener listenerClass) {
    _loginListeners[listenerId] = listenerClass;
  }

  ///Remove Login Listener
  static removeLoginListener(String listenerId) {
    _loginListeners.remove(listenerId);
  }

  /// The ConnectionListener class provides you with all the status of the connection to CometChat web-socket servers
  static addConnectionListener(String listenerId, ConnectionListener listenerClass) {
    _connectionListeners[listenerId] = listenerClass;
  }

  ///Remove Connection Listener
  static removeConnectionListener(String listenerId) {
    _connectionListeners.remove(listenerId);
  }

  //Call-SDK-changes
  static addCallListener(String listenerId, CallListener listenerClass) {
    _callListener[listenerId] = listenerClass;
  }

  //Call-SDK-changes
  static removeCallListener(String listenerId) {
    _callListener.remove(listenerId);
  }

  static initializetestmessageStream() {
    nativeStream = eventStreamChannel.receiveBroadcastStream(1).map((e) {
      debugPrint("inStreams  ${e["methodName"]}");
      switch (e["methodName"]) {
        //Mark -- Message Listeners
        case "onTextMessageReceived":
          BaseMessage receivedMessage = BaseMessage.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onTextMessageReceived(receivedMessage as TextMessage);
          });
          break;

        case "onMediaMessageReceived":
          BaseMessage receivedMessage = BaseMessage.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onMediaMessageReceived(receivedMessage as MediaMessage);
          });
          break;

        case "onTypingStarted":
          TypingIndicator typingIndicator = TypingIndicator.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onTypingStarted(typingIndicator);
          });
          break;

        case "onTypingEnded":
          TypingIndicator typingIndicator = TypingIndicator.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onTypingEnded(typingIndicator);
          });
          break;

        case "onMessagesDelivered":
          MessageReceipt messageReceipt = MessageReceipt.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onMessagesDelivered(messageReceipt);
          });
          break;

        case "onMessagesRead":
          MessageReceipt messageReceipt = MessageReceipt.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onMessagesRead(messageReceipt);
          });
          break;

        case "onMessageEdited":
          BaseMessage receivedMessage = BaseMessage.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onMessageEdited(receivedMessage);
          });
          break;

        case "onMessageDeleted":
          BaseMessage receivedMessage = BaseMessage.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onMessageDeleted(receivedMessage);
          });
          break;

        case "onTransientMessageReceived":
          TransientMessage receivedMessage = TransientMessage.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onTransientMessageReceived(receivedMessage);
          });
          break;

        case "onCustomMessageReceived":
          CustomMessage receivedMessage = CustomMessage.fromMap(e);
          _messageListeners.values.forEach((element) {
            element.onCustomMessageReceived(receivedMessage);
          });
          break;

        //Mark -- User Listeners
        case "onUserOnline":
          User user = User.fromMap(e);
          _userListeners.values.forEach((element) {
            element.onUserOnline(user);
          });
          break;

        case "onUserOffline":
          User user = User.fromMap(e);
          _userListeners.values.forEach((element) {
            element.onUserOffline(user);
          });
          break;

        //Mark -- Group Listeners
        case "onGroupMemberJoined":
          action_import.Action action = action_import.Action.fromMap(e["action"]);
          User joinedUser = User.fromMap(e["joinedUser"]);
          Group joinedGroup = Group.fromMap(e["joinedGroup"]);
          _groupListeners.values.forEach((element) {
            element.onGroupMemberJoined(action, joinedUser, joinedGroup);
          });
          break;

        case "onGroupMemberLeft":
          action_import.Action action = action_import.Action.fromMap(e["action"]);
          User leftUser = User.fromMap(e["leftUser"]);
          Group leftGroup = Group.fromMap(e["leftGroup"]);
          _groupListeners.values.forEach((element) {
            element.onGroupMemberLeft(action, leftUser, leftGroup);
          });
          break;

        case "onGroupMemberKicked":
          action_import.Action action = action_import.Action.fromMap(e["action"]);
          User kickedUser = User.fromMap(e["kickedUser"]);
          User kickedBy = User.fromMap(e["kickedBy"]);
          Group kickedFrom = Group.fromMap(e["kickedFrom"]);
          _groupListeners.values.forEach((element) {
            element.onGroupMemberKicked(action, kickedUser, kickedBy, kickedFrom);
          });
          break;

        case "onGroupMemberBanned":
          action_import.Action action = action_import.Action.fromMap(e["action"]);
          User bannedUser = User.fromMap(e["bannedUser"]);
          User bannedBy = User.fromMap(e["bannedBy"]);
          Group bannedFrom = Group.fromMap(e["bannedFrom"]);
          _groupListeners.values.forEach((element) {
            element.onGroupMemberBanned(action, bannedUser, bannedBy, bannedFrom);
          });
          break;

        case "onGroupMemberUnbanned":
          action_import.Action action = action_import.Action.fromMap(e["action"]);
          User unbannedUser = User.fromMap(e["unbannedUser"]);
          User unbannedBy = User.fromMap(e["unbannedBy"]);
          Group unbannedFrom = Group.fromMap(e["unbannedFrom"]);
          _groupListeners.values.forEach((element) {
            element.onGroupMemberUnbanned(action, unbannedUser, unbannedBy, unbannedFrom);
          });
          break;

        case "onGroupMemberScopeChanged":
          action_import.Action action = action_import.Action.fromMap(e["action"]);
          User updatedBy = User.fromMap(e["updatedBy"]);
          User updatedUser = User.fromMap(e["updatedUser"]);
          String scopeChangedTo = e["scopeChangedTo"];
          String scopeChangedFrom = e["scopeChangedFrom"];
          Group group = Group.fromMap(e["group"]);
          _groupListeners.values.forEach((element) {
            element.onGroupMemberScopeChanged(action, updatedBy, updatedUser, scopeChangedTo, scopeChangedFrom, group);
          });
          break;

        case "onMemberAddedToGroup":
          action_import.Action action = action_import.Action.fromMap(e["action"]);
          User addedby = User.fromMap(e["addedby"]);
          User userAdded = User.fromMap(e["userAdded"]);
          Group addedTo = Group.fromMap(e["addedTo"]);
          _groupListeners.values.forEach((element) {
            element.onMemberAddedToGroup(action, addedby, userAdded, addedTo);
          });
          break;

        //Mark -- Login Listeners
        case "loginSuccess":
          User user = User.fromMap(e);
          _loginListeners.values.forEach((element) {
            element.loginSuccess(user);
          });
          break;

        case "loginFailure":
          CometChatException excep = CometChatException.fromMap(e);
          _loginListeners.values.forEach((element) {
            element.loginFailure(excep);
          });
          break;

        case "logoutSuccess":
          _loginListeners.values.forEach((element) {
            element.logoutSuccess();
          });
          break;

        case "logoutFailure":
          CometChatException excep = CometChatException.fromMap(e);
          _loginListeners.values.forEach((element) {
            element.loginFailure(excep);
          });
          break;

        //Mark -- Connection Listeners
        case "onConnected":
          _connectionListeners.values.forEach((element) {
            element.onConnected();
          });
          break;

        case "onConnecting":
          _connectionListeners.values.forEach((element) {
            element.onConnecting();
          });
          break;

        case "onDisconnected":
          _connectionListeners.values.forEach((element) {
            element.onDisconnected();
          });
          break;

        case "onFeatureThrottled":
          _connectionListeners.values.forEach((element) {
            element.onFeatureThrottled();
          });
          break;

        //Call-SDK-changes
        case "onIncomingCallReceived":
          _callListener.values.forEach((element) {
            Call call = Call.fromMap(e["call"]);
            element.onIncomingCallReceived(call);
          });
          break;

        case "onOutgoingCallAccepted":
          _callListener.values.forEach((element) {
            Call call = Call.fromMap(e["call"]);
            element.onOutgoingCallAccepted(call);
          });
          break;

        case "onOutgoingCallRejected":
          _callListener.values.forEach((element) {
            Call call = Call.fromMap(e["call"]);
            element.onOutgoingCallRejected(call);
          });
          break;

        case "onIncomingCallCancelled":
          _callListener.values.forEach((element) {
            Call call = Call.fromMap(e["call"]);
            element.onIncomingCallCancelled(call);
          });
          break;

        case "onCallEndedMessageReceived":
          _callListener.values.forEach((element) {
            Call call = Call.fromMap(e["call"]);
            element.onCallEndedMessageReceived(call);
          });
          break;
      }
    });
  }

  static Future<String> loadPubspecYaml() async {
    String yamlString = await rootBundle.loadString('pubspec.yaml');
    return yamlString;
  }

  /// method initializes the settings required for CometChat
  ///
  /// We suggest you call the init() method on app startup
  ///
  /// [appId] refers to your CometChat App ID.
  /// [region] The region where the app was created.
  static Future<void> init(String appId, AppSettings appSettings,
      {required Function(String successMessage)? onSuccess, required Function(CometChatException e)? onError}) async {
    try {
      final arguments = {
        'appId': appId,
        'roles': appSettings.roles,
        'region': appSettings.region,
        'adminHost': appSettings.adminHost,
        'clientHost': appSettings.clientHost,
        'subscriptionType': appSettings.subscriptionType,
        'autoEstablishSocketConnection': appSettings.autoEstablishSocketConnection,
        'sdkVersion': PackageConstants.version,
        'platform': PackageConstants.platform
      };
      final result = await channel.invokeMethod('init', arguments);
      initializetestmessageStream();
      nativeStream?.listen((event) {});
      //connectionReceiveStreamController = StreamController<BaseMessage>.broadcast();
      if (onSuccess != null) onSuccess(result);
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  ///Method returns user after creation in cometchat environment
  ///
  /// Ideally, user creation should take place at your backend
  ///
  /// [uid] specified on user creation. Not editable after that.
  ///
  /// [name] Display name of the user.
  ///
  /// [avatar] URL to profile picture of the user.
  static Future<User?> createUser(User user, String authKey,
      {required Function(User user)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('createUser', {
        'apiKey': authKey,
        'uid': user.uid,
        'name': user.name,
        'link': user.link,
        'tags': user.tags,
        'avatar': user.avatar,
        'statusMessage': user.statusMessage,
        'metadata': user.metadata == null ? null : json.encode(user.metadata),
        'role': user.role,
        'lastActiveAt': user.lastActiveAt == null ? null : user.lastActiveAt!.millisecondsSinceEpoch,
        'hasBlockedMe': user.hasBlockedMe,
        'blockedByMe': user.blockedByMe,
        'status': user.status
      });
      final User res = User.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  /// Use this function only for testing purpose. For production, use [loginWithAuthToken]
  @deprecated
  static Future<User?> login(String uid, String authKey,
      {required Function(User user)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('loginWithApiKey', {
        'uid': uid,
        'apiKey': authKey,
      });
      final User res = User.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Returns a  [User] object after login in CometChat API.
  ///
  /// The CometChat SDK maintains the session of the logged in user within the SDK.
  /// Thus you do not need to call the login method for every session. You can use the
  /// CometChat.getLoggedInUser() method to check if there is any existing session in the SDK.
  /// This method should return the details of the logged-in user.
  ///
  /// [Create an Auth Token](https://www.cometchat.com/docs/chat-apis/ref#createauthtoken) via the CometChat API
  /// for the new user every time the user logs in to your app
  ///
  /// check of getLoggedInUser() function in your app where you check App's user login status.
  /// In case it returns nil then you need to call the Login method inside it.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<User?> loginWithAuthToken(String authToken,
      {required Function(User user)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('loginWithAuthToken', {
        'authToken': authToken,
      });
      final User res = User.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Method to log out the user from CometChat
  static Future<void> logout({required Function(String message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('logout');
      if (onSuccess != null) onSuccess(result);
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      if (onError != null) onError(CometChatException("Error", e.toString(), e.toString()));
    }
  }

  ///Retrieve Particular [User] Details
  ///
  /// [uid] : The UID of the user for whom the details are to be fetched
  static Future<User?> getUser(String uid, {required Function(User user)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('getUser', {'uid': uid});
      final User res = User.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Returns logged in [User] Object
  ///
  /// check of getLoggedInUser() function in your app where you check App's user login status.
  /// In case it returns nil then you need to call the Login method inside it.
  static Future<User?> getLoggedInUser({Function(User)? onSuccess, Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('getLoggedInUser');
      if (result == null) return null;
      final User res = User.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
      return null;
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
      return null;
    }
  }

  ///To send a text message to a single user or group.
  ///returns the [TextMessage] with message id
  ///
  /// [receiver] The UID or GUID of the recipient
  ///
  /// [messageText] The text to be sent
  ///
  /// [receiverType] The type of the receiver to whom the message is to be sent i.e user or group
  ///
  /// The method could throw [PlatformException] with error codes specifying the cause
  static Future<TextMessage?> sendMessage(TextMessage message,
      {required Function(TextMessage message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('sendMessage', {
        'receiverId': message.receiverUid,
        'receiverType': message.receiverType,
        'messageText': message.text,
        'parentMessageId': message.parentMessageId,
        'metadata': json.encode(message.metadata ?? {}),
        'tags': message.tags,
        'muid': message.muid,
      });
      final TextMessage res = TextMessage.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///send a media message like photos, videos & files.
  ///
  /// [filePath] The file path object to be sent,  need to prefix the path with 'file://' for IOS.
  ///
  /// [messageType] type of the message that needs to be sent `image,video,audio,file`
  ///
  /// [receiver] Group or User class from which UID and GUID will be fetched according to need.
  ///
  /// [receiverType] ype of the receiver to whom the message is to be sent `user,group`.
  ///
  /// On success, you will receive an object of the MediaMessage class containing all the information related to the sent media message.
  ///
  /// The method could throw [PlatformException] with error codes specifying the cause
  static Future<MediaMessage?> sendMediaMessage(MediaMessage mediaMessage,
      {required Function(MediaMessage message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      bool hasAttachment = false;
      String? attachmentFileName;
      String? attchemntFileExtension;
      String? attachmentFileUrl;
      String? attachmentMimeType;
      if (mediaMessage.attachment != null) {
        hasAttachment = true;
        attachmentFileName = mediaMessage.attachment?.fileName;
        attchemntFileExtension = mediaMessage.attachment?.fileExtension;
        attachmentFileUrl = mediaMessage.attachment?.fileUrl;
        attachmentMimeType = mediaMessage.attachment?.fileMimeType;
      }
      final result = await channel.invokeMethod('sendMediaMessage', {
        'receiverId': mediaMessage.receiverUid,
        'receiverType': mediaMessage.receiverType,
        'filePath': Platform.isIOS ? '${mediaMessage.file}' : mediaMessage.file,
        'messageType': mediaMessage.type,
        'caption': mediaMessage.caption,
        'metadata': json.encode(mediaMessage.metadata ?? {}),
        'hasAttachment': hasAttachment,
        'attachmentFileName': attachmentFileName,
        'attchemntFileExtension': attchemntFileExtension,
        'attachmentFileUrl': attachmentFileUrl,
        "attachmentMimeType": attachmentMimeType,
        'muid': mediaMessage.muid,
        'parentMessageId': mediaMessage.parentMessageId,
      });
      final res = MediaMessage.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///send custom messages which are neither text nor media messages.
  ///
  /// [receiverId] Unique id of the user or group to which the message is to be sent.
  ///
  /// [receiverType] Type of the receiver i.e user or group
  ///
  /// [customType] custom message type that you need to set.
  ///
  /// [customData] The data to be passed as the message in the form of a JSONObject.
  ///
  /// The method could throw [PlatformException] with error codes specifying the cause
  static Future<CustomMessage?> sendCustomMessage(CustomMessage message,
      {required Function(CustomMessage message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('sendCustomMessage', {
        'receiverId': message.receiverUid,
        'receiverType': message.receiverType,
        'customType': message.type,
        'customData': message.customData,
        'subType': message.subType,
        'muid': message.muid,
        'parentMessageId': message.parentMessageId,
        'metadata': json.encode(message.metadata ?? {}),
      });
      final res = CustomMessage.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  static Stream<String> onTypingIndicator() {
    return typingStream.receiveBroadcastStream(2).map<String>((e) => e);
  }

  ///In order to fetch a specific conversation
  ///
  /// [conversationWith] : UID/GUID of the user/group whose conversation you want to fetch.
  ///
  /// [conversationType] : user or group.
  ///
  /// The method could throw [PlatformException] with error codes specifying the cause
  static Future<Conversation?> getConversation(String conversationWith, String conversationType,
      {required Function(Conversation conversation)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('getConversation', {
        'conversationWith': conversationWith,
        'conversationType': conversationType,
      });
      final res = Conversation.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Deletes the message with specified [messageId].
  ///
  ///  you get an object of the BaseMessage class, with the deletedAt field set with the timestamp of the time the message was deleted.
  ///  Also, the deletedBy field is set.
  ///  These two fields can be used to identify if the message is deleted while iterating through a list of messages.
  ///
  /// Messages can be deleted only when logged-in user is the sender.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<void> deleteMessage(int messageId,
      {required Function(BaseMessage message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final res = await channel.invokeMethod('deleteMessage', {
        'messageId': messageId,
      });
      BaseMessage message = BaseMessage.fromMap(res);
      if (onSuccess != null) onSuccess(message);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  ///Returns a  [Group] object after creating in CometChat API.
  ///
  /// [guid] A unique identifier for a group. Can be alphanumeric with underscore and hyphens only.
  ///
  /// [groupName] name of group.
  ///
  /// [groupType] needs to be either of the below 3 values public, private, password.
  ///
  /// [password] Mandatory in case group is password only.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<Group?> createGroup(
      {required Group group, required Function(Group group)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('createGroup', {
        'guid': group.guid,
        'name': group.name,
        'icon': group.icon,
        'description': group.description,
        'membersCount': group.membersCount,
        'metadata': group.metadata == null || group.metadata!.isEmpty ? null : json.encode(group.metadata),
        'joinedAt': group.joinedAt == null ? null : group.joinedAt!.millisecondsSinceEpoch,
        'hasJoined': group.hasJoined,
        'createdAt': group.createdAt == null ? null : group.createdAt!.millisecondsSinceEpoch,
        'owner': group.owner,
        'updatedAt': group.updatedAt == null ? null : group.updatedAt!.millisecondsSinceEpoch,
        'tags': group.tags,
        'type': group.type,
        'scope': group.scope,
        'password': group.password,
      });
      final res = Group.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Returns a  [Group] object after joining the logged in user to specified group.
  ///In order to start participating in group conversations, you will have to join a group
  ///
  /// [guid] A unique identifier for a group that logged in user wants to join.
  ///
  /// [groupType] needs to be either of the below 3 values public, private, password.
  ///
  /// [password] Mandatory in case group type  is password only.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<Group?> joinGroup(String guid, String groupType,
      {String password = '', required Function(Group group)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('joinGroup', {
        'guid': guid,
        'groupType': groupType,
        'password': password,
      });
      final res = Group.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///In order to stop receiving updates and messages for any particular joined group.
  ///
  ///Owner  cannot leave the group , transfer the ownership before leaving the group
  ///
  /// [guid] A unique identifier for a group that logged in user wants to leave.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<void> leaveGroup(String guid,
      {required Function(String returnResponse)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      var result = await channel.invokeMethod('leaveGroup', {
        'guid': guid,
      });
      if (onSuccess != null) onSuccess(result);
      return result;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  ///In order to delete a group.
  ///
  ///The user must be an Admin of the group they are trying to delete.
  ///
  /// [guid] A unique identifier for a group that logged in user wants to delete.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<void> deleteGroup(String guid,
      {required Function(String message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      var result = await channel.invokeMethod('deleteGroup', {
        'guid': guid,
      });
      if (onSuccess != null) onSuccess(result);
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  ///Registers the obtained FCM Token which will be used by the CometChat server to send message via push notification.
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  static Future<void> registerTokenForPushNotification(String token,
      {required Function(String response)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('registerTokenForPushNotification', {
        'token': token,
      });
      if (onSuccess != null) onSuccess(result);
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  ///Gives count of unread messages for every one-on-one and group conversation.
  ///
  /// on Success will return 2 keys:
  /// 1) user - The value for this key holds another map that holds the UIDs of users and their corresponding unread message counts.
  /// 2) group - The value for this key holds another map that holds the GUIDs of groups and their corresponding unread message counts.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<Map<String, int>?> getUnreadMessageCountForGroup(
      {required String guid,
      bool? hideMessagesFromBlockedUsers,
      Function(Map<String, int> message)? onSuccess,
      Function(CometChatException excep)? onError}) async {
    try {
      final count =
          await channel.invokeMethod('getUnreadMessageCountForGroup', {'guid': guid, 'hideMessagesFromBlockedUsers': hideMessagesFromBlockedUsers});
      final res = Map<String, int>.from(count);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
      return null;
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
      return null;
    }
  }

  ///Gives count of unread messages for every one-on-one and group conversation.
  ///
  /// on Success will return 2 keys:
  /// 1) user - The value for this key holds another map that holds the UIDs of users and their corresponding unread message counts.
  /// 2) group - The value for this key holds another map that holds the GUIDs of groups and their corresponding unread message counts.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<Map<String, Map<String, int>>?> getUnreadMessageCount(
      {bool? hideMessagesFromBlockedUsers,
      Function(Map<String, Map<String, int>> message)? onSuccess,
      Function(CometChatException excep)? onError}) async {
    try {
      final count = await channel.invokeMethod('getUnreadMessageCount');
      final countMap = Map<String, dynamic>.from(count);
      final res = countMap.map((k, v) => MapEntry(k, Map<String, int>.from(v)));
      if (!res.containsKey('group')) res['group'] = {};
      if (!res.containsKey('user')) res['user'] = {};
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
      return null;
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
      return null;
    }
  }

  ///Gives count of unread messages for every one-on-one and group conversation.
  ///
  /// on Success will return 2 keys:
  /// 1) user - The value for this key holds another map that holds the UIDs of users and their corresponding unread message counts.
  /// 2) group - The value for this key holds another map that holds the GUIDs of groups and their corresponding unread message counts.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<Map<String, int>?> getUnreadMessageCountForAllUsers(
      {bool? hideMessagesFromBlockedUsers, Function(Map<String, int> message)? onSuccess, Function(CometChatException excep)? onError}) async {
    try {
      final count = await channel.invokeMethod('getUnreadMessageCountForAllUsers', {'hideMessagesFromBlockedUsers': hideMessagesFromBlockedUsers});
      final res = Map<String, int>.from(count);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
      return null;
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
      return null;
    }
  }

  ///Gives count of unread messages for every one-on-one and group conversation.
  ///
  /// on Success will return 2 keys:
  /// 1) user - The value for this key holds another map that holds the UIDs of users and their corresponding unread message counts.
  /// 2) group - The value for this key holds another map that holds the GUIDs of groups and their corresponding unread message counts.
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<Map<String, int>?> getUnreadMessageCountForAllGroups(
      {bool? hideMessagesFromBlockedUsers, Function(Map<String, int> message)? onSuccess, Function(CometChatException excep)? onError}) async {
    try {
      final count = await channel.invokeMethod('getUnreadMessageCountForAllGroups', {'hideMessagesFromBlockedUsers': hideMessagesFromBlockedUsers});
      final res = Map<String, int>.from(count);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
      return null;
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
      return null;
    }
  }

  ///Messages for both user and group conversations can be marked as read using this method.
  ///
  /// Ideally, you should mark all the messages as read for any conversation when the user opens the chat window.
  ///
  /// [messageId] The ID of the message above which all messages for a particular conversation are to be marked as read.
  ///
  /// [receiverId] In case of one to one conversation message's sender UID will be the receipt's receiver Id.In case of group conversation message's receiver Id will be the receipt's receiver Id
  ///
  /// [senderId] The UID of the sender of the message
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<void> markAsRead(BaseMessage baseMessage,
      {required Function(String)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      Map<String, dynamic> map = baseMessage.toJson();
      final result = await channel.invokeMethod('markAsRead', {'baseMessage': map});
      if (onSuccess != null) onSuccess(result);
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  /// can call any extension
  ///
  /// can be used in extensions like Pin message, Save message,Tiny Url, Bitly etc
  ///
  ///
  ///  method could throw [PlatformException] with error codes specifying the cause
  static Future<Map<String, dynamic>?> callExtension(String slug, String requestType, String endPoint, Map<String, dynamic>? body,
      {required Function(Map<String, dynamic> map)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      if (Platform.isIOS && endPoint.isNotEmpty && endPoint[0] == '/') endPoint = endPoint.substring(1);
      final result = await channel.invokeMethod('callExtension', {
        'slug': slug,
        'requestType': requestType,
        'endPoint': endPoint,
        'body': body,
      });
      var res;
      if (Platform.isIOS) {
        final _map = json.decode(result);
        res = {'data': _map};
      } else {
        final map = json.decode(result);
        res = Map<String, dynamic>.from(map);
      }
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Block a user from sending logged-in user any  messages.
  ///
  /// [uids] list of UID of users to be blocked
  ///
  /// receive a map which contains UIDs as the keys and "success" or "fail"
  /// as the value based on if the block operation for the UID was successful or not
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  static Future<Map<String, dynamic>?> blockUser(List<String>? uids,
      {required Function(Map<String, dynamic> map)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('blockUsers', {'uids': uids});
      final res = Map<String, dynamic>.from(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Un-block a user from sending logged-in user any  messages.
  ///
  /// [uids] list of UID of users to be un-blocked
  ///
  /// receive a map which contains UIDs as the keys and "success" or "fail"
  /// as the value based on if the un-block operation for the UID was successful or not
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  static Future<Map<String, dynamic>?> unblockUser(List<String>? uids,
      {required Function(Map<String, dynamic> map)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('unblockUsers', {'uids': uids});
      final res = Map<String, dynamic>.from(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///method to inform the receiver that the logged in user has started typing.
  ///
  /// receive this information in the onTypingStarted() method of the MessageListener class
  static startTyping({String? receaverUid, String? receiverType}) async {
    try {
      await channel.invokeMethod('startTyping', {'uid': receaverUid, 'receiverType': receiverType});
    } catch (e) {
      throw e;
    }
  }

  ///method to inform the receiver that the logged in user has ended typing.
  ///
  /// receive this information in the onTypingStarted() method of the MessageListener class
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  static endTyping({String? receaverUid, String? receiverType}) async {
    try {
      await channel.invokeMethod('endTyping', {'uid': receaverUid, 'receiverType': receiverType});
    } catch (e) {
      throw e;
    }
  }

  ///Mark the messages for a particular conversation as delivered .
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  static markAsDelivered(BaseMessage message,
      {required Function(String message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      Map<String, dynamic> messageMap = message.toJson();
      final result = await channel.invokeMethod('markAsDelivered', {'baseMessage': messageMap});
      if (onSuccess != null) onSuccess(result);
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  ///Method to get message receipts.
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  static Future<List<MessageReceipt>?> getMessageReceipts(int messageId,
      {required Function(List<MessageReceipt> messageReceipt)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      List<MessageReceipt> receiptList = [];
      final result = await channel.invokeMethod('getMessageReceipts', {'id': messageId});
      for (var _obj in result) {
        try {
          receiptList.add(MessageReceipt.fromMap(_obj));
        } catch (e) {
          if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
          return [];
        }
      }
      if (onSuccess != null) onSuccess(receiptList);
      return receiptList;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///edit a message, you can use the editMessage() method
  ///
  /// only allowed to edit TextMessage and CustomMessage
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static editMessage(BaseMessage message,
      {required Function(BaseMessage retMessage)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      late Map<String, dynamic> messageMap;
      if (message is TextMessage) {
        messageMap = message.toJson();
      } else if (message is CustomMessage) {
        messageMap = message.toJson();
      } else {
        messageMap = message.toJson();
      }
      final result = await channel.invokeMethod('editMessage', {'baseMessage': messageMap});
      late BaseMessage resultMessage;
      switch (message.type) {
        case CometChatMessageType.text:
          resultMessage = TextMessage.fromMap(result);
          break;
        case CometChatMessageType.custom:
          resultMessage = CustomMessage.fromMap(result);
          break;
        default:
          resultMessage = BaseMessage.fromMap(result);
          break;
      }
      if (onSuccess != null) onSuccess(resultMessage);
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  ///Method deletes the conversation only for the logged-in user.
  ///
  /// [conversationWith] The ID of the message above which all messages for a particular conversation are to be marked as read.
  ///
  /// [conversationType] The type of conversation you want to delete . It can be either user or group
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static deleteConversation(String conversationWith, String conversationType,
      {required Function(String message)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('deleteConversation', {'conversationWith': conversationWith, 'conversationType': conversationType});
      if (onSuccess != null) onSuccess(result);
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  ///Transient messages are messages that are sent in real-time only
  ///
  /// method send transient message
  ///
  /// [data] A JSONObject to provide data.
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static sendTransientMessage(TransientMessage message,
      {required Function()? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      await channel.invokeMethod('sendTransientMessage', {
        'receiverId': message.receiverId,
        'receiverType': message.receiverType,
        'data': message.data,
      });
      if (onSuccess != null) onSuccess();
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
  }

  ///get the total count of online users for your app
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<int?> getOnlineUserCount({required Function(int count)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('getOnlineUserCount', {});
      if (onSuccess != null) onSuccess(result);
      return result;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Updating a user similar to creating a user should ideally be achieved at your backend using the Restful APIs
  ///
  /// [user] a user object which user needs to be updated.
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<User?> updateUser(User user, String apiKey,
      {required Function(User retUser)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      debugPrint("Status is ${user.status}");
      final result = await channel.invokeMethod('updateUser', {
        'uid': user.uid,
        'name': user.name,
        'link': user.link,
        'tags': user.tags,
        'avatar': user.avatar,
        'statusMessage': user.statusMessage,
        'metadata': user.metadata == null ? null : json.encode(user.metadata),
        'apiKey': apiKey,
        'role': user.role,
        'lastActiveAt': user.lastActiveAt == null ? null : user.lastActiveAt!.millisecondsSinceEpoch,
        'hasBlockedMe': user.hasBlockedMe,
        'blockedByMe': user.blockedByMe,
        'status': user.status
      });
      final User res = User.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return user;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Updating a logged-in user is similar to updating a user
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  static Future<User?> updateCurrentUserDetails(User user,
      {required Function(User retUser)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('updateCurrentUserDetails', {
        'name': user.name,
        'link': user.link,
        'tags': user.tags,
        'avatar': user.avatar,
        'statusMessage': user.statusMessage,
        'metadata': user.metadata == null ? null : json.encode(user.metadata),
        'role': user.role,
        'lastActiveAt': user.lastActiveAt == null ? null : user.lastActiveAt!.millisecondsSinceEpoch,
        'hasBlockedMe': user.hasBlockedMe,
        'blockedByMe': user.blockedByMe,
        'status': user.status
      });
      final User res = User.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Retrieve information for a specific group
  ///
  /// [guid] guid of group
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<Group?> getGroup(String guid,
      {required Function(Group retGrou)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('getGroup', {
        'guid': guid,
      });
      final Group res = Group.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///get the total count of online users in particular groups
  ///
  /// [guids] list of group ids
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<Map<String, int>?> getOnlineGroupMemberCount(List<String> guids,
      {required Function(Map<String, int> result)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('getOnlineGroupMemberCount', {
        'guids': guids,
      });
      final Map<String, int> res = Map<String, int>.from(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///update the group details
  ///
  /// [guid] an instance of class Group
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<Group?> updateGroup(
      {required Group group, required Function(Group group)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('updateGroup', {
        'guid': group.guid,
        'name': group.name,
        'icon': group.icon,
        'description': group.description,
        'membersCount': group.membersCount,
        'metadata': group.metadata == null || group.metadata!.isEmpty ? null : json.encode(group.metadata),
        'joinedAt': group.joinedAt == null ? null : group.joinedAt!.millisecondsSinceEpoch,
        'hasJoined': group.hasJoined,
        'createdAt': group.createdAt == null ? null : group.createdAt!.millisecondsSinceEpoch,
        'owner': group.owner,
        'updatedAt': group.updatedAt == null ? null : group.updatedAt!.millisecondsSinceEpoch,
        'tags': group.tags,
        'type': group.type,
        'scope': group.scope,
        'password': group.password,
      });
      final Group res = Group.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Add members to the group
  ///
  /// [guid] id of group in which members should be added
  ///
  /// [groupMembers] list of GroupMember instance members to be added
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<Map<String?, String?>?> addMembersToGroup(
      {required String guid,
      required List<GroupMember> groupMembers,
      required Function(Map<String?, String?> result)? onSuccess,
      required Function(CometChatException excep)? onError}) async {
    List<Map<String, dynamic>> groupMemberMapList = [];
    for (var member in groupMembers) {
      groupMemberMapList.add(member.toJson());
    }
    try {
      final result = await channel.invokeMethod('addMembersToGroup', {
        'guid': guid,
        'groupMembers': groupMemberMapList,
      });
      final Map<String?, String?> res = Map<String?, String?>.from(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Admin or Moderator of a group can kick a member out of the group
  ///
  /// [guid] The GUID of the group from which user is to be kicked
  ///
  /// [uid] The UID of the user to be kicked
  ///
  /// Kicked user can rejoin the group.
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<String?> kickGroupMember(
      {required String guid,
      required String uid,
      required Function(String result)? onSuccess,
      required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('kickGroupMember', {
        'guid': guid,
        'uid': uid,
      });
      if (onSuccess != null) onSuccess(result);
      return result;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Admin or Moderator of a group can ban a member of the group
  ///
  /// [guid] The GUID of the group from which user is to be banned
  ///
  /// [uid] The UID of the user to be banned
  ///
  /// Banned user cannot rejoin the group.
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<String?> banGroupMember(
      {required String guid,
      required String uid,
      required Function(String result)? onSuccess,
      required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('banGroupMember', {
        'guid': guid,
        'uid': uid,
      });
      if (onSuccess != null) onSuccess(result);
      return result;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Only Admin or Moderators of the group can unban a previously banned member from the group
  ///
  /// [guid] The UID of the group from which user is to be unbanned
  ///
  /// [uid] The UID of the user to be unbanned
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<String?> unbanGroupMember(
      {required String guid,
      required String uid,
      required Function(String result)? onSuccess,
      required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('unbanGroupMember', {
        'guid': guid,
        'uid': uid,
      });
      if (onSuccess != null) onSuccess(result);
      return result;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///In order to change the scope of a group member
  ///
  /// [guid] The GUID of the group for which the member's scope needs to be changed
  ///
  /// [uid] The UID of the member whose scope you would like to change
  ///
  /// the updated scope of the member. can be [CometChatMemberScope.admin] , [CometChatMemberScope.participant], [CometChatMemberScope.moderator]
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<String?> updateGroupMemberScope(
      {required String guid,
      required String uid,
      required String scope,
      required Function(String result)? onSuccess,
      required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('updateGroupMemberScope', {
        'guid': guid,
        'uid': uid,
        'scope': scope,
      });
      if (onSuccess != null) onSuccess(result);
      return result;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Transfer the ownership of any group if logged-in user is the owner of the group
  ///
  /// [guid] The GUID of the group for which the ownership needs to be changed
  ///
  /// [uid] The UID of the member who should be the new owner
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<String?> transferGroupOwnership(
      {required String guid,
      required String uid,
      required Function(String result)? onSuccess,
      required Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('transferGroupOwnership', {
        'guid': guid,
        'uid': uid,
      });
      if (onSuccess != null) onSuccess(result);
      return result;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///Tag a conversation
  ///
  /// [conversationWith] The id of conversation
  ///
  /// [conversationType] The user or group
  ///
  /// method could throw [PlatformException] with error codes specifying the cause
  static Future<Conversation?> tagConversation(String conversationWith, String conversationType, List<String> tags,
      {required Function(Conversation conversation)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      final result =
          await channel.invokeMethod('tagConversation', {'conversationWith': conversationWith, 'conversationType': conversationType, 'tags': tags});
      final res = Conversation.fromMap(result);
      if (onSuccess != null) onSuccess(res);
      return res;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  ///will establish the Web-socket connections manually
  ///
  /// While calling the init() function on the app startup,  need to inform the SDK that you will be managing the web socket connect from autoEstablishSocketConnection.
  ///
  /// Once the connection is established, you will start receiving all the real-time events for the logged in user
  static Future<Null> connect() async {
    try {
      await channel.invokeMethod('connect', {});
    } on PlatformException catch (_) {
    } catch (e) {
      throw e;
    }
  }

  ///will disable the Web-socket connections manually
  ///
  /// While calling the init() function on the app startup,  need to inform the SDK that you will be managing the web socket connect from autoEstablishSocketConnection.
  ///
  /// Once the connection is disables , you will stop receiving all the real-time events for the logged in user
  static Future<Null> disconnect() async {
    try {
      await channel.invokeMethod('disconnect', {});
    } on PlatformException catch (_) {
    } catch (e) {
      throw e;
    }
  }

  static Future<int?> getLastDeliveredMessageId({Function(int lastMessageId)? onSuccess}) async {
    try {
      var result = await channel.invokeMethod('getLastDeliveredMessageId', {});
      if (onSuccess != null) onSuccess(result);
      return result;
    } on PlatformException catch (e) {
      debugPrint("Error: $e");
      return null;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  static Future<String> getConnectionStatus() async {
    try {
      final result = await channel.invokeMethod('getConnectionStatus', {});

      return result;
    } catch (e) {
      throw e;
    }
  }

  ///get the conversation object from message object.
  ///
  ///method could throw [PlatformException] with error codes specifying the cause
  static Future<Conversation?> getConversationFromMessage(BaseMessage message,
      {required Function(Conversation conversation)? onSuccess, required Function(CometChatException excep)? onError}) async {
    try {
      String conversationType = message.receiverType;
      User? loggedInUser = await getLoggedInUser();
      String? conversationId = message.conversationId;
      if (loggedInUser != null) {
        AppEntity appEntity = AppEntity();
        if (conversationType == CometChatReceiverType.user) {
          if (loggedInUser.uid == message.sender!.uid) {
            appEntity = message.receiver!;
          } else {
            appEntity = message.sender!;
          }
        } else {
          appEntity = message.receiver!;
        }
        Conversation conversation = Conversation(
            conversationId: conversationId,
            conversationType: conversationType,
            conversationWith: appEntity,
            lastMessage: message,
            updatedAt: message.updatedAt);
        if (onSuccess != null) onSuccess(conversation);
        return conversation;
      } else {
        if (onError != null) onError(CometChatException(ErrorCode.errorUserNotLoggedIn, "User not logged in", "User not logged in"));
        return null;
      }
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return null;
  }

  //Call-SDK-changes
  static Future<String?> getUserAuthToken() async {
    try {
      User? loggedInUser = await getLoggedInUser();
      if (loggedInUser != null) {
        var result = await channel.invokeMethod('getUserAuthToken', {});
        return result;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      debugPrint("Error: $e");
      return null;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  static void initiateCall(Call call, {required Function(Call call)? onSuccess, required Function(CometChatException excep) onError}) async {
    try {
      if (call.receiverUid.isEmpty) {
        onError(CometChatException("Error", "User auth toke is null", "User is not logged in"));
      } else if (call.receiverType.isEmpty) {
        onError(CometChatException("Error", "User auth toke is null", "User is not logged in"));
      } else if (call.type.isEmpty) {
        onError(CometChatException("Error", "User auth toke is null", "User is not logged in"));
      } else {
        var result = await channel.invokeMethod('initiateCall', {
          "receiverUid": call.receiverUid,
          "receiverType": call.receiverType,
          "callType": call.type,
        });
        if (onSuccess != null) onSuccess(Call.fromMap(result));
      }
    } on PlatformException catch (exception) {
      onError(CometChatException(exception.code, exception.message, exception.details));
    } catch (e) {
      onError(CometChatException("Error", "Something went wrong", e.toString()));
    }
  }

  static void acceptCall(String sessionID, {required Function(Call call)? onSuccess, required Function(CometChatException excep) onError}) async {
    try {
      if (sessionID.isEmpty) {
        onError(CometChatException("Error", "Session ID is null", "Session ID is null"));
      } else {
        var result = await channel.invokeMethod('acceptCall', {"sessionID": sessionID});
        if (onSuccess != null) onSuccess(Call.fromMap(result));
      }
    } on PlatformException catch (exception) {
      onError(CometChatException(exception.code, exception.message, exception.details));
    } catch (e) {
      onError(CometChatException("Error", "Something went wrong", e.toString()));
    }
  }

  static void rejectCall(String sessionID, String status,
      {required Function(Call call)? onSuccess, required Function(CometChatException excep) onError}) async {
    try {
      if (sessionID.isEmpty) {
        onError(CometChatException("Error", "Session ID is null", "Session ID is null"));
      } else if (status.isEmpty) {
        onError(CometChatException("Error", "Call status is null", "Call status is null"));
      } else {
        var result = await channel.invokeMethod('rejectCall', {"sessionID": sessionID, "status": status});
        if (onSuccess != null) onSuccess(Call.fromMap(result));
      }
    } on PlatformException catch (exception) {
      onError(CometChatException(exception.code, exception.message, exception.details));
    } catch (e) {
      onError(CometChatException("Error", "Something went wrong", e.toString()));
    }
  }

  static void endCall(String sessionID, {required Function(Call call)? onSuccess, required Function(CometChatException excep) onError}) async {
    try {
      if (sessionID.isEmpty) {
        onError(CometChatException("Error", "Session ID is null", "Session ID is null"));
      } else {
        var result = await channel.invokeMethod('endCall', {"sessionID": sessionID});
        if (onSuccess != null) onSuccess(Call.fromMap(result));
      }
    } on PlatformException catch (exception) {
      onError(CometChatException(exception.code, exception.message, exception.details));
    } catch (e) {
      onError(CometChatException("Error", "Something went wrong", e.toString()));
    }
  }

  static Future<Call?> getActiveCall() async {
    try {
      final result = await channel.invokeMethod('getActiveCall', {});
      if (result != null) {
        return Call.fromMap(result);
      } else {
        return null;
      }
    } on PlatformException catch (exception) {
      debugPrint("Error PlatformException: ${exception.toString()}");
      return null;
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return null;
    }
  }

  static Future<bool> isExtensionEnabled(String extensionId, {Function(bool)? onSuccess, Function(CometChatException excep)? onError}) async {
    try {
      final result = await channel.invokeMethod('isExtensionEnabled', {"extensionId": extensionId});
      if (onSuccess != null) onSuccess(result as bool);
      return result as bool;
    } on PlatformException catch (platformException) {
      if (onError != null) onError(CometChatException(platformException.code, platformException.details, platformException.message));
      return false;
    } catch (e) {
      debugPrint("Error: $e");
      if (onError != null) onError(CometChatException(ErrorCode.errorUnhandledException, e.toString(), e.toString()));
    }
    return false;
  }

  static Future<void> setSource(String resource, String platform, String language) async {
    try {
      final arguments = {"resource": resource, "platform": platform, "language": language};
      final result = await channel.invokeMethod('setSource', arguments);
      debugPrint("result is $result");
    } on PlatformException catch (e) {
      debugPrint("Error: $e");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  static Future<void> setPlatformParams(String platform, String sdkVersion) async {
    try {
      final arguments = {"platform": platform, "sdkVersion": sdkVersion};
      final result = await channel.invokeMethod('setPlatformParams', arguments);
      debugPrint("result is $result");
    } on PlatformException catch (e) {
      debugPrint("Error: $e");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}
