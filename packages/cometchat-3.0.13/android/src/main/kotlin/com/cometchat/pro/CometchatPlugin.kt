package com.cometchat.pro
import android.content.Context
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import com.cometchat.pro.core.*
import com.cometchat.pro.core.CometChat.CallbackListener
import com.cometchat.pro.exceptions.CometChatException
import com.cometchat.pro.models.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import java.io.File
import com.cometchat.pro.models.BaseMessage
import com.cometchat.pro.core.CometChat

import com.cometchat.pro.models.MessageReceipt

import com.cometchat.pro.models.TransientMessage
import java.lang.Exception
import com.cometchat.pro.models.User
import com.cometchat.pro.constants.CometChatConstants
import org.json.JSONArray
import java.io.Serializable
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap


/** CometchatPlugin */
class CometchatPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private val TAG = javaClass.simpleName
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var messageStream: EventChannel
    private lateinit var typingStream : EventChannel
    val messageRequestMap: MutableMap<String, MessagesRequest> = mutableMapOf<String, MessagesRequest>()
    val conversationRequestMap: MutableMap<String, ConversationsRequest> = mutableMapOf<String, ConversationsRequest>()
    val userRequestMap: MutableMap<String, UsersRequest> = mutableMapOf<String, UsersRequest>()
    val groupMemberRequestMap: MutableMap<String, GroupMembersRequest> = mutableMapOf<String, GroupMembersRequest>()
    val groupRequestMap: MutableMap<String, GroupsRequest> = mutableMapOf<String, GroupsRequest>()
    val bannedGroupMemberRequestMap: MutableMap<String, BannedGroupMembersRequest> = mutableMapOf<String, BannedGroupMembersRequest>()
    val blockedUsersRequestMap: MutableMap<String, BlockedUsersRequest> = mutableMapOf<String, BlockedUsersRequest>()


    var counter:Int = 0

    private  var messageStreamSink : EventChannel.EventSink? = null
    private  var typingStreamSink : EventChannel.EventSink? = null
    private lateinit var context: Context

    private val listenerID:String = "CALL_LISTENER_ID" //Call-SDK-Changes

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "cometchat")
        channel.setMethodCallHandler(this)

        messageStream = EventChannel(flutterPluginBinding.binaryMessenger, "cometchat_message_stream")
        messageStream.setStreamHandler(this)

        typingStream = EventChannel(flutterPluginBinding.binaryMessenger, "cometchat_typing_stream")
        typingStream.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "init" -> initializeCometChat(call, result)
            "createUser" -> createUser(call, result)
            "loginWithApiKey" -> loginWithApiKey(call, result)
            "loginWithAuthToken" -> loginWithAuthToken(call, result)
            "logout" -> logout(result)
            "getLoggedInUser" -> getLoggedInUser(result)
            "getUser" -> getUser(call, result)
            "sendMessage" -> sendMessage(call, result)
            "sendMediaMessage" -> sendMediaMessage(call, result)
            "sendCustomMessage" -> sendCustomMessage(call, result)
            "fetchPreviousMessages" -> fetchPreviousMessages(call, result)
            "fetchNextConversations" -> fetchNextConversations(call, result)
            "getConversation" -> getConversation(call, result)
            //"getConversationFromMessage" -> getConversationFromMessage(call, result)
            "deleteMessage" -> deleteMessage(call, result)
            "createGroup" -> createGroup(call, result)
            "joinGroup" -> joinGroup(call, result)
            "leaveGroup" -> leaveGroup(call, result)
            "deleteGroup" -> deleteGroup(call, result)
            "fetchNextGroupMembers" -> fetchNextGroupMembers(call, result)
            "fetchNextGroups" -> fetchNextGroups(call, result)
            "registerTokenForPushNotification" -> registerTokenForPushNotification(call, result)
            "getUnreadMessageCount" -> getUnreadMessageCount(result)
            "markAsRead" -> markAsRead(call, result)
            "callExtension" -> callExtension(call, result)
            "blockUsers" -> blockUsers(call, result)
            "unblockUsers" -> unblockUsers(call, result)
            "fetchBlockedUsers" -> fetchBlockedUsers(call, result)
            "fetchUsers" -> fetchUsers(call, result)
            "startTyping" -> startTyping(call, result)
            "endTyping" -> endTyping(call, result)
            "fetchNextMessages" -> fetchNextMessages(call, result)
            "getUnreadMessageCountForGroup"->getUnreadMessageCountForGroup(call,result)
            "getUnreadMessageCountForAllUsers"->getUnreadMessageCountForAllUsers(call,result)
            "getUnreadMessageCountForAllGroups"->getUnreadMessageCountForAllGroups(call,result)
            "markAsDelivered"->markAsDelivered(call,result)
            "getMessageReceipts"->getMessageReceipts(call,result)
            "editMessage"->editMessage(call,result)
            "deleteConversation"->deleteConversation(call,result)
            "sendTransientMessage"->sendTransientMessage(call,result)
            "getOnlineUserCount"->getOnlineUserCount(result)
            "updateUser"->updateUser(call,result)
            "updateCurrentUserDetails"->updateCurrentUserDetails(call,result)
            "getGroup"->getGroup(call,result)
            "getOnlineGroupMemberCount"->getOnlineGroupMemberCount(call,result)
            "updateGroup"->updateGroup(call,result)
            "addMembersToGroup"->addMembersToGroup(call,result)
            "kickGroupMember"->kickGroupMember(call,result)
            "banGroupMember"->banGroupMember(call,result)
            "unbanGroupMember"->unbanGroupMember(call,result)
            "updateGroupMemberScope"->updateGroupMemberScope(call,result)
            "transferGroupOwnership"->transferGroupOwnership(call,result)
            "fetchBlockedGroupMembers"->fetchBlockedGroupMembers(call,result)
            "tagConversation"->tagConversation(call,result)
            "connect"->connect(result)
            "disconnect"->disconnect(result)
            "getLastDeliveredMessageId"->getLastDeliveredMessageId(call ,result)
            "getConnectionStatus"->getConnectionStatus(result)
            "getUserAuthToken"->getUserAuthToken(result)
            "initiateCall"->initiateCall(call, result)
            "acceptCall"->acceptCall(call, result)
            "rejectCall"->rejectCall(call, result)
            "endCall"->endCall(call, result)
            "getActiveCall"->getActiveCall(result)
            "isExtensionEnabled"->isExtensionEnabled(call, result)
            "setSource"->setSource(call, result)
            "setPlatformParams"->setPlatformParams(call, result)

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        if(arguments != null){
            if(arguments as Int == 1){
                messageStreamSink = events
            }else if(arguments as Int == 2){
                typingStreamSink  = events
            }
        }

        addMessageListener()
        addUserListener()
        addGroupListener()
        addLoginListener()
        addConnectionListener()
        addCallListener() //Call-SDK-Changes
    }

    override fun onCancel(arguments: Any?) {
        Log.e("onCancel", "event onCancel called")
        if(arguments != null){
            if(arguments as Int == 1){
                messageStreamSink = null
            }else if(arguments as Int == 2){
                typingStreamSink  = null
            }
        }
    }

    private fun getUser(call: MethodCall, result: Result) {
        val uid: String = call.argument<String>("uid").toString()

        CometChat.getUser(uid, object : CallbackListener<User?>() {
            override fun onSuccess(user: User?) {
                result.success(user?.let { getUserMap(user) })
            }

            override fun onError(e: CometChatException) {
                result.error(e.code,e.message,e.details)
            }
        })
    }

    // CometChat functions
    private fun initializeCometChat(call: MethodCall, result: Result) {
        val appID: String = call.argument("appId") ?: ""
        val region: String = call.argument("region") ?: ""
        val adminHost: String = call.argument("adminHost") ?: ""
        val clientHost: String = call.argument("clientHost") ?: ""
        val subscriptionType: String = call.argument("subscriptionType") ?: "allUsers"
        val roles: List<String> = call.argument("roles")?: emptyList()
        val autoEstablishSocketConnection: Boolean = call.argument("autoEstablishSocketConnection") ?: true
        val platform: String = call.argument("platform") ?: ""
        val sdkVersion: String = call.argument("sdkVersion") ?: ""

        var appBuilder: AppSettings.AppSettingsBuilder =  AppSettings.AppSettingsBuilder()

        if (region.isNotEmpty()) appBuilder = appBuilder.setRegion(region)
        if (adminHost.isNotEmpty()) appBuilder = appBuilder.overrideAdminHost(adminHost)
        if (clientHost.isNotEmpty()) appBuilder = appBuilder.overrideClientHost(clientHost)

        when (subscriptionType) {
            "none" -> Log.i(TAG, "NONE")
            "allUsers" -> {
                appBuilder = appBuilder.subscribePresenceForAllUsers()}
            "roles" -> {
                appBuilder = appBuilder.subcribePresenceForRoles(roles)
            }
            "friends" ->{
                appBuilder = appBuilder.subscribePresenceForFriends()
            }
            else -> { // Note the block
                appBuilder = appBuilder.subscribePresenceForAllUsers()
            }
        }
        appBuilder = appBuilder.autoEstablishSocketConnection(autoEstablishSocketConnection)

        val appSetting = appBuilder.build()

        CometChat.init(context, appID, appSetting, object : CometChat.CallbackListener<String>() {
            override fun onSuccess(successString: String?) {
                Log.d("initializeCometChat", "Initialization completed successfully")
                CometChat.setPlatformParams(platform, sdkVersion)
                result.success(successString)
            }

            override fun onError(e: CometChatException) {
                Log.d("initializeCometChat", "Initialization failed with exception: " + e.message)
                result.error(e.code, e.message, e.details)
            }
        })
    }



    private fun createUser(call: MethodCall, result: Result) {
        val apiKey: String = call.argument("apiKey") ?: ""
        val uid: String = call.argument("uid") ?: ""
        val name: String = call.argument("name") ?: ""
        val avatar: String? = call.argument("avatar")
        val tags: List<String>? = call.argument("tags")
        val link: String? = call.argument("link")
        val metadata: String? = call.argument("metadata")
        val statusMessage: String? = call.argument("statusMessage")
        val role: String? = call.argument("role")
        val blockedByMe: Boolean? = call.argument("blockedByMe")
        val hasBlockedMe: Boolean? = call.argument("hasBlockedMe")
        val lastActiveAt: Long? = call.argument("lastActiveAt")
        val status: String? = call.argument("status")

        val user = User()
        if(uid.isNotEmpty())user.uid = uid
        if(name.isNotEmpty())user.name = name
        if(avatar!=null)user.avatar = avatar
        if(link!=null)user.link = link
        if(metadata!=null) user.metadata = JSONObject(metadata)
        if(tags!=null) user.tags = tags
        if(statusMessage!=null)user.statusMessage = statusMessage
        if(role!=null)user.role = role
        if(blockedByMe!=null)user.isBlockedByMe = blockedByMe
        if(hasBlockedMe!=null)user.isHasBlockedMe = hasBlockedMe
        if(lastActiveAt!=null)user.lastActiveAt = lastActiveAt
        if (status!=null) {
            if(status.equals("online" ,ignoreCase = true)){
                user.status = CometChatConstants.USER_STATUS_ONLINE;
            }else{
                user.status = CometChatConstants.USER_STATUS_OFFLINE
            }

        }

        CometChat.createUser(user, apiKey, object : CometChat.CallbackListener<User>() {
            override fun onSuccess(user: User) {
                Log.d("createUser", user.toString())
                result.success(getUserMap(user))
            }

            override fun onError(e: CometChatException) {
                Log.e("createUser", e.message ?: "Messed up")
                result.error(e.code, e.message, e.details)
            }
        })
    }

    private fun loginWithApiKey(call: MethodCall, result: Result) {
        val uid: String = call.argument("uid") ?: ""
        val apiKey: String = call.argument("apiKey") ?: ""

        CometChat.login(uid, apiKey, object : CometChat.CallbackListener<User>() {
            override fun onSuccess(user: User) {
                Log.d("login", "Login Successful : $user")
                result.success(getUserMap(user))
            }

            override fun onError(e: CometChatException) {
                Log.e("login", "Login failed with exception: " + e.message)
                result.error(e.code, e.message, e.details)
            }
        })
    }

    private fun loginWithAuthToken(call: MethodCall, result: Result) {
        val authToken: String = call.argument("authToken") ?: ""

        CometChat.login(authToken, object : CometChat.CallbackListener<User>() {
            override fun onSuccess(user: User) {
                Log.d("login", "Login Successful : $user")
                result.success(getUserMap(user))
            }

            override fun onError(e: CometChatException) {
                Log.e("login", "Login failed with exception: " + e.message)
                result.error(e.code, e.message, e.details)
            }
        })
    }

    private fun logout(result: Result) {
        CometChat.logout(object : CometChat.CallbackListener<String>() {
            override fun onSuccess(m: String?) {
                Log.d("logout", "Logout completed successfully$m")
                result.success("User logout successfully")
            }

            override fun onError(e: CometChatException) {
                Log.e("logout", "Logout failed with exception: " + e.message)
                result.error(e.code, e.message, e.details)
            }
        })
    }

    private fun getLoggedInUser(result: Result) {
        val user: User? = CometChat.getLoggedInUser()
        result.success(user?.let { getUserMap(it) })
    }

    private fun sendMessage(call: MethodCall, result: Result) {
        val receiverID: String = call.argument("receiverId") ?: ""
        val messageText: String = call.argument("messageText") ?: ""
        val muid: String = call.argument("muid") ?: ""
        val receiverType: String = call.argument("receiverType") ?: ""
        val parentMessageId: Int = call.argument("parentMessageId") ?: -1
        val tags: List<String> = call.argument("tags") ?: emptyList()
        //val metadata: Map<String , Any > = call.argument("metadata") ?: mapOf()
        val metadata: String = call.argument("metadata") ?: ""
        Log.d("Android", "receaved metadat = ${metadata}")

        val textMessage = TextMessage(receiverID, messageText, receiverType)

        if(metadata.isNotEmpty()){
            textMessage.metadata = JSONObject(metadata)
        }

        if(muid.isNotEmpty()) {
            textMessage.muid = muid
        }

        if (parentMessageId > 0) textMessage.parentMessageId = parentMessageId

        if(tags.isNotEmpty()) textMessage.tags =  tags



        CometChat.sendMessage(textMessage, object : CometChat.CallbackListener<TextMessage>() {
            override fun onSuccess(message: TextMessage) {
                Log.d("sendMessage", "Message sent metadata=->  ${message.metadata}")
                result.success(getMessageMap(message))
            }

            override fun onError(e: CometChatException) {
                Log.e("sendMessage", "Message sending failed with exception: " + e.message)
                result.error(e.code, e.message, e.details)
            }
        })
    }

    private fun getMetaDataRecursively(metadata : Map<String , Any > ): JSONObject{
        val customData=JSONObject()
        for ((k, v) in metadata) {
            var value:Any;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if(v!=null){
                    Log.d("getMetaDataRecursively", "$k with $v datatype ${v::class.java.typeName}")
                }
                else{
                    Log.d("getMetaDataRecursively", "$k with $v datatype $v")
                }

            }else{
                Log.d("getMetaDataRecursively", "version issue")
            }
            if(v!=null &&  (v is Map<*, *> )){
                value =   getMetaDataRecursively(v as Map<String,Any >);
            }else{
                value = v;
            }
            customData.put(k,v)
        }
        return  customData;
    }

    private fun getMessageMap(message: BaseMessage?, methodName : String = ""): HashMap<String, Any?>? {
        if (message == null) return null
        val metaData: String? = if(message.metadata != null){
            message.metadata.toString()
        }else{
            null
        }

        val map: HashMap<String, Any?> = hashMapOf(
            "flutterMap" to "BaseMessage",
            "id" to message.id,
            "muid" to message.muid,
            "sender" to getUserMap(message.sender),
            "receiver" to when (message.receiver) {
                is User -> getUserMap(message.receiver as User)
                is Group -> getGroupMap(message.receiver as Group)
                else -> null
            },
            "receiverUid" to message.receiverUid,
            "type" to message.type,
            "receiverType" to message.receiverType,
            "category" to message.category,
            "sentAt" to message.sentAt,
            "deliveredAt" to message.deliveredAt,
            "readAt" to message.readAt,
            "metadata" to metaData ,
            "readByMeAt" to message.readByMeAt,
            "deliveredToMeAt" to message.deliveredToMeAt,
            "deletedAt" to message.deletedAt,
            "editedAt" to message.editedAt,
            "deletedBy" to message.deletedBy,
            "editedBy" to message.editedBy,
            "updatedAt" to message.updatedAt,
            "conversationId" to message.conversationId,
            "parentMessageId" to message.parentMessageId,
            "replyCount" to message.replyCount,
            "methodName" to methodName
        )

        when (message) {
            is TextMessage ->map.putAll(
                hashMapOf(
                    "text" to message.text,
                    "tags" to message.tags
                )
            )
            is MediaMessage -> map.putAll(
                hashMapOf(
                    "caption" to message.caption,
                    "attachment" to getAttachmentMap(message.attachment),
                    "tags" to message.tags
                )
            )
            is CustomMessage -> map.putAll(
                hashMapOf(
                    "subType" to message.subType,
                    "customData" to  message.customData?.toString(),
                    "tags" to message.tags
                )
            )
            is Action -> map.putAll(
                hashMapOf(
                    "message" to message.message,
                    "rawData" to message.rawData,
                    "action" to message.action,
                    "oldScope" to message.oldScope,
                    "newScope" to message.newScope,
                    "actionOn" to when (message.actionOn) {
                        null -> null
                        is User -> getUserMap(message.actionOn as User)
                        is Group -> getGroupMap(message.actionOn as Group)
                        is BaseMessage -> getMessageMap(message.actionOn as BaseMessage)
                        else -> null
                    },
                    "actionFor" to when (message.actionFor) {
                        null -> null
                        is User -> getUserMap(message.actionFor as User)
                        is Group -> getGroupMap(message.actionFor as Group)
                        is BaseMessage -> getMessageMap(message.actionFor as BaseMessage)
                        else -> null
                    },
                    "actionBy" to when (message.actionBy) {
                        null -> null
                        is User -> getUserMap(message.actionBy as User)
                        is Group -> getGroupMap(message.actionBy as Group)
                        is BaseMessage -> getMessageMap(message.actionBy as BaseMessage)
                        else -> null
                    }

                )
            )

            is Call-> map.putAll(
                hashMapOf(
                    "sessionId" to message.sessionId,
                    "callStatus" to message.callStatus,
                    "action" to message.action,
                    "rawData" to message.rawData,
                    "initiatedAt" to message.initiatedAt,
                    "joinedAt" to message.joinedAt,
                    "callInitiator" to when (message.callInitiator) {
                        is User -> getUserMap(message.callInitiator as User)
                        is Group -> getGroupMap(message.callInitiator as Group)
                        else -> null
                    },
                    "callReceiver" to when (message.callReceiver) {
                        is User -> getUserMap(message.callReceiver as User)
                        is Group -> getGroupMap(message.callReceiver as Group)
                        else -> null
                    }
                )
            )
        }
        return map
    }

    private fun getMapFromJsonObject(jsonObj: JSONObject?): HashMap<String, Any?>?{
        if(jsonObj==null)return null;
        val data:HashMap<String, Any?>  = HashMap()
        for( keys in jsonObj.keys()){

            if(jsonObj.get(keys) is JSONObject){

                data[keys] = getMapFromJsonObject(jsonObj.get(keys) as JSONObject)
            }else if(jsonObj.get(keys) is JSONArray){

                data[keys] = {}
            }
            else{
                data[keys] = jsonObj.get(keys)
            }

        }

        return data
    }


    private fun getTypingIndicatorMap(typingIndicator: TypingIndicator? , methodName : String = ""): HashMap<String, Any?>? {
        if (typingIndicator == null) return null
        val map: HashMap<String, Any?> = hashMapOf(
            "receiverId" to typingIndicator.receiverId,
            "receiverType" to typingIndicator.receiverType,
            "metadata" to typingIndicator.metadata,
            //"sender" to getUserMap(typingIndicator.sender),
            "sender" to when (typingIndicator.sender) {
                is User -> getUserMap(typingIndicator.sender as User)
                is Group -> getGroupMap(typingIndicator.sender as Group)
                else -> null
            },
            "methodName" to methodName
        )
        return map
    }



    private fun getTransientMessageMap(transientMessage: TransientMessage? , methodName : String = ""): HashMap<String, Any?>? {
        if (transientMessage == null) return null


        var data:HashMap<String, Any?>  = HashMap() ;
        for( keys in transientMessage.data.keys()){
            data[keys] = transientMessage.data.get(keys)
        }

        val map: HashMap<String, Any?> = hashMapOf(
            "receiverId" to transientMessage.receiverId,
            "receiverType" to transientMessage.receiverType,
            //"sender" to getUserMap(typingIndicator.sender),
            "sender" to when (transientMessage.sender) {
                is User -> getUserMap(transientMessage.sender as User)
                is Group -> getGroupMap(transientMessage.sender as Group)
                else -> null
            },
            "methodName" to methodName,
            "data" to data

        )
        return map
    }


    private fun getAttachmentMap(attachment: Attachment?): HashMap<String, Any?>? {
        if (attachment == null) return null
        return hashMapOf(
            "className" to "Attachment",
            "fileName" to attachment.fileName,
            "fileExtension" to attachment.fileExtension,
            "fileSize" to attachment.fileSize,
            "fileMimeType" to attachment.fileMimeType,
            "fileUrl" to attachment.fileUrl
        )
    }

    private fun getConversationMap(conversation: Conversation, methodName : String = ""): HashMap<String, Any?> {
        return hashMapOf(
            "conversationId" to conversation.conversationId,
            "conversationType" to conversation.conversationType,
            "conversationWith" to when (conversation.conversationWith) {
                is User -> getUserMap(conversation.conversationWith as User)
                is Group -> getGroupMap(conversation.conversationWith as Group)
                else -> null
            },
            "lastMessage" to getMessageMap(conversation.lastMessage),
            "unreadMessageCount" to conversation.unreadMessageCount,
            "updatedAt" to conversation.updatedAt,
            "tags" to conversation.tags,
            "methodName" to methodName

        )
    }

    private fun getGroupMap(group: Group ,methodName : String = ""): HashMap<String, Any?> {
        val groupMap = group.toMap()
        return hashMapOf(
            "guid" to group.guid,
            "name" to group.name,
            "type" to groupMap["type"],
            "password" to group.password,
            "icon" to group.icon,
            "description" to group.description,
            "owner" to group.owner,
            "metadata" to group.metadata?.toString(),
            "createdAt" to group.createdAt,
            "updatedAt" to group.updatedAt,
            "hasJoined" to (groupMap["hasJoined"]?.toInt() == 1),
            "joinedAt" to group.joinedAt,
            "scope" to group.scope,
            "membersCount" to group.membersCount,
            "tags" to group.tags,
            "methodName" to methodName
        )
    }

    private fun getUserMap(user: User,methodName : String = ""): HashMap<String, Any?> {
        return hashMapOf(
            "uid" to user.uid,
            "name" to user.name,
            "avatar" to user.avatar,
            "link" to user.link,
            "role" to user.role,
            "metadata" to user.metadata?.toString(),
            "status" to user.status,
            "statusMessage" to user.statusMessage,
            "lastActiveAt" to user.lastActiveAt,
            "tags" to user.tags,
            "blockedByMe" to user.isBlockedByMe,
            "hasBlockedMe" to user.isHasBlockedMe,
            "methodName" to methodName
        )
    }

    private fun getGroupMemberMap(groupMember: GroupMember,methodName : String = ""): HashMap<String, Any?> {
        val map: HashMap<String, Any?> = getUserMap(groupMember)
        map.putAll(
            hashMapOf(
                "scope" to groupMember.scope,
                "joinedAt" to groupMember.joinedAt,
                "methodName" to methodName
            )
        )
        return map
    }

    private fun getMessageReceiptMap(messageReceipt:  MessageReceipt?,methodName : String = ""): HashMap<String, Any?>? {
        if (messageReceipt == null) return null
        return  hashMapOf(
            "messageId" to messageReceipt.messageId,
            "sender" to  getUserMap(messageReceipt.sender),
            "receivertype" to messageReceipt.receivertype,
            "receiverId" to messageReceipt.receiverId,
            "timestamp" to messageReceipt.timestamp,
            "receiptType" to messageReceipt.receiptType,
            "deliveredAt" to messageReceipt.deliveredAt,
            "readAt" to messageReceipt.readAt,
            "messageSender" to messageReceipt.messageSender,
            "methodName" to methodName
        );
    }

    private fun getCometChatExceptionMap(exception: CometChatException,methodName : String = ""): HashMap<String, Any?> {
        return hashMapOf(
            "code" to exception.code,
            "details" to exception.details,
            "message" to exception.message,
            "methodName" to methodName
        )
    }

    private fun sendMediaMessage(call: MethodCall, result: Result) {
        val receiverID: String = call.argument("receiverId") ?: ""
        val receiverType: String = call.argument("receiverType") ?: ""
        val messageType: String = call.argument("messageType") ?: ""
        val filePath: String = call.argument("filePath") ?: ""
        val caption: String = call.argument("caption") ?: ""
        val parentMessageId: Int = call.argument("parentMessageId") ?: -1
        val tags: List<String> = call.argument("tags") ?: emptyList()

        val hasAttachment: Boolean = call.argument("hasAttachment") ?: false
        val attachmentFileName: String = call.argument("attachmentFileName") ?: ""
        val attchemntFileExtension: String = call.argument("attchemntFileExtension") ?: ""
        val attachmentFileUrl: String = call.argument("attachmentFileUrl") ?: ""
        val attachmentMimeType: String = call.argument("attachmentMimeType") ?: ""
        val metadata: String = call.argument("metadata") ?: ""
        val muid: String = call.argument("muid") ?: ""
        //val metadata: Map<String,String> = call.argument("metadata") ?: mapOf()
        Log.d("Android", "receaved metadat = ${metadata}")


        var mediaMessage: MediaMessage;
        if(hasAttachment){
            mediaMessage = MediaMessage(receiverID,  messageType, receiverType)


            val attachment = Attachment();
            attachment.fileName = attachmentFileName
            attachment.fileExtension = attchemntFileExtension
            attachment.fileUrl = attachmentFileUrl
            attachment.fileMimeType = attachmentMimeType

            mediaMessage.attachments = Arrays.asList(attachment)


        }else{
            mediaMessage = MediaMessage(receiverID, File(filePath), messageType, receiverType)
        }
        if(muid!=null&& !muid.isEmpty() ){
            mediaMessage.muid = muid;
        }



        if (caption.isNotEmpty()) mediaMessage.caption = caption

        if (parentMessageId > 0) mediaMessage.parentMessageId = parentMessageId

        if(tags.isNotEmpty()) mediaMessage.tags = tags

        if(metadata.isNotEmpty()){
            mediaMessage.metadata = JSONObject(metadata)
            //Log.d("Meta data in android", "before sending meta data = ${mediaMessage.metadata}")
        }

//        if(metadata.isNotEmpty()){
//            val customData=JSONObject()
//            for ((k, v) in metadata) {
//                customData.put(k,v)
//            }
//            mediaMessage.metadata = customData;
//        }



        CometChat.sendMediaMessage(
            mediaMessage,
            object : CometChat.CallbackListener<MediaMessage>() {
                override fun onSuccess(message: MediaMessage) {
                    Log.d("sendMediaMessage", "Media message sent successfully: $message")
                    result.success(getMessageMap(message))
                }

                override fun onError(e: CometChatException) {
                    Log.e("sendMediaMessage", "Message sending failed with exception: " + e.message)
                    result.error(e.code!!, e.message, e.details)
                }
            })
    }

    private fun sendCustomMessage(call: MethodCall, result: Result) {
        val receiverId: String = call.argument("receiverId") ?: ""
        val receiverType: String = call.argument("receiverType") ?: ""
        val customType: String = call.argument("customType") ?: ""
        val customDataPassed: Map<String,String> = call.argument("customData") ?: mapOf()
        val tags: List<String> = call.argument("tags") ?: emptyList()
        val muid: String = call.argument("muid") ?: ""
        val parentMessageId: Int = call.argument("parentMessageId") ?: -1
        val metadata: String = call.argument("metadata") ?: ""

        val customData=JSONObject()
        for ((k, v) in customDataPassed) {
            customData.put(k,v)
        }
        val customMessage = CustomMessage(receiverId, receiverType,customType, customData)
        if(muid!=null && muid.isNotEmpty())
            customMessage.muid  = muid;


        if(tags.isNotEmpty()) customMessage.tags = tags

        if (parentMessageId > 0) customMessage.parentMessageId = parentMessageId

        if(metadata.isNotEmpty()){
            customMessage.metadata = JSONObject(metadata)
        }

        CometChat.sendCustomMessage(customMessage, object :CometChat.CallbackListener<CustomMessage>() {
            override fun onSuccess(customMessage: CustomMessage) {
                Log.d("TAG", customMessage.toString())
                result.success(getMessageMap(customMessage))
            }
            override fun onError(e: CometChatException) {
                //Log.d("TAG", e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun addMessageListener() {
        CometChat.addMessageListener(
            "cometchat.message",
            object : CometChat.MessageListener() {
                override fun onTextMessageReceived(message: TextMessage) {
                    Log.d("receiveMessage", "Message received successfully: ${message.text} sender: ${message.sender?.uid} receiver: ${message.receiverUid}")
                    messageStreamSink?.success(getMessageMap(message,"onTextMessageReceived"))
                }

                override fun onMediaMessageReceived(message: MediaMessage) {
                    message.caption
                    Log.d("receiveMessage", "Message received successfully: ${message.attachment.fileUrl} sender: ${message.sender?.uid} receiver: ${message.receiverUid}")
                    messageStreamSink?.success(getMessageMap(message,"onMediaMessageReceived"))
                }

                override fun onMessageDeleted(message: BaseMessage) {
                    Log.d("deleteMessage", "Message deleted successfully")
                    messageStreamSink?.success(getMessageMap(message,"onMessageDeleted"))
                }
                override fun onMessageEdited(message: BaseMessage?) {
                    Log.d("TAG", "Message Edited")
                    messageStreamSink?.success(getMessageMap(message,"onMessageEdited"))
                }

                override fun onTransientMessageReceived(transientMessage: TransientMessage?) {
                    Log.d("TAG", "Transient Message Receaved")
                    messageStreamSink?.success(getTransientMessageMap(transientMessage,"onTransientMessageReceived"))
                }

                override fun onTypingStarted(typingMessage: TypingIndicator?) {
                    Log.d("TAG", "Typing Started Native")
                    messageStreamSink?.success(getTypingIndicatorMap(typingMessage, "onTypingStarted"))
                }

                override fun onTypingEnded(typingMessage: TypingIndicator?) {
                    Log.d("TAG", "Typing Ended Native")
                    messageStreamSink?.success(getTypingIndicatorMap(typingMessage,"onTypingEnded"))
                }

                override fun onMessagesRead(messageReceipt: MessageReceipt?) {
                    Log.d("TAG", "onMessagesRead Native")
                    messageStreamSink?.success(getMessageReceiptMap(messageReceipt,"onMessagesRead"))
                }

                override fun onMessagesDelivered(messageReceipt: MessageReceipt?) {
                    Log.d("TAG", "onMessagesDelivered Native")
                    messageStreamSink?.success(getMessageReceiptMap(messageReceipt,"onMessagesDelivered"))
                }

                override fun onCustomMessageReceived(customMessage: CustomMessage?) {
                    Log.d("TAG", "onMessagesDelivered Native")
                    messageStreamSink?.success(getMessageMap(customMessage,"onCustomMessageReceived"))
                }
            })
    }

    private fun addUserListener(){
        CometChat.addUserListener(
            "cometchat.user",
            object : CometChat.UserListener() {

                override fun onUserOnline(user: User?) {
                    Log.d("TAG", "onUserOnline Native ${user?.status}")
                    if(user!=null)
                        messageStreamSink?.success(getUserMap(user,"onUserOnline"))
                }

                override fun onUserOffline(user: User?) {
                    Log.d("TAG", "onUserOffline Native ${user?.status}")
                    if(user !=null)
                        messageStreamSink?.success(getUserMap(user,"onUserOffline"))
                }
            })
    }

    private fun addGroupListener(){
        CometChat.addGroupListener(
            "cometchat.group",
            object : CometChat.GroupListener() {

                override fun onGroupMemberJoined(action: Action?, user: User?, group: Group?) {
                    val responseMap :HashMap<String,Any?> = HashMap()

                    responseMap["action"] = getMessageMap(action)
                    if(user!=null) responseMap["joinedUser"]  = getUserMap(user)
                    if(group!=null) responseMap["joinedGroup"] = getGroupMap(group)
                    responseMap["methodName"] = "onGroupMemberJoined"

                    messageStreamSink?.success(responseMap)

                }

                override fun onGroupMemberLeft(action: Action?, user: User?, group: Group?) {
                    val responseMap :HashMap<String,Any?> = HashMap()

                    responseMap["action"] = getMessageMap(action)
                    if(user!=null) responseMap["leftUser"]  = getUserMap(user)
                    if(group!=null) responseMap["leftGroup"] = getGroupMap(group)
                    responseMap["methodName"] = "onGroupMemberLeft"

                    messageStreamSink?.success(responseMap)
                }

                override fun onGroupMemberKicked(action: Action?, kickedUser: User?, kickedBy: User?, kickedFrom: Group?) {
                    val responseMap :HashMap<String,Any?> = HashMap()

                    responseMap["action"] = getMessageMap(action)
                    if(kickedUser!=null) responseMap["kickedUser"]  = getUserMap(kickedUser)
                    if(kickedBy!=null) responseMap["kickedBy"]  = getUserMap(kickedBy)
                    if(kickedFrom!=null) responseMap["kickedFrom"] = getGroupMap(kickedFrom)
                    responseMap["methodName"] = "onGroupMemberKicked"

                    messageStreamSink?.success(responseMap)
                }

                override fun onGroupMemberBanned(action: Action?, bannedUser: User?, bannedBy: User?, bannedFrom: Group?) {
                    val responseMap :HashMap<String,Any?> = HashMap()

                    responseMap["action"] = getMessageMap(action)
                    if(bannedUser!=null) responseMap["bannedUser"]  = getUserMap(bannedUser)
                    if(bannedBy!=null) responseMap["bannedBy"]  = getUserMap(bannedBy)
                    if(bannedFrom!=null) responseMap["bannedFrom"] = getGroupMap(bannedFrom)
                    responseMap["methodName"] = "onGroupMemberBanned"

                    messageStreamSink?.success(responseMap)
                }

                override fun onGroupMemberUnbanned(action: Action?, unbannedUser: User?, unbannedBy: User?, unbannedFrom: Group?) {
                    val responseMap :HashMap<String,Any?> = HashMap()

                    responseMap["action"] = getMessageMap(action)
                    if(unbannedUser!=null) responseMap["unbannedUser"]  = getUserMap(unbannedUser)
                    if(unbannedBy!=null) responseMap["unbannedBy"]  = getUserMap(unbannedBy)
                    if(unbannedFrom!=null) responseMap["unbannedFrom"] = getGroupMap(unbannedFrom)
                    responseMap["methodName"] = "onGroupMemberUnbanned"

                    messageStreamSink?.success(responseMap)
                }

                override fun onGroupMemberScopeChanged(
                    action: Action?,
                    updatedBy: User?,
                    updatedUser: User?,
                    scopeChangedTo: String?,
                    scopeChangedFrom: String?,
                    group: Group?
                ) {
                    val responseMap :HashMap<String,Any?> = HashMap()

                    responseMap["action"] = getMessageMap(action)
                    if(updatedBy!=null) responseMap["updatedBy"]  = getUserMap(updatedBy)
                    if(updatedUser!=null) responseMap["updatedUser"]  = getUserMap(updatedUser)
                    responseMap["scopeChangedTo"] = scopeChangedTo
                    responseMap["scopeChangedFrom"] = scopeChangedFrom
                    if(group!=null) responseMap["group"] = getGroupMap(group)
                    responseMap["methodName"] = "onGroupMemberScopeChanged"

                    messageStreamSink?.success(responseMap)
                }

                override fun onMemberAddedToGroup(action: Action?, addedby: User?, userAdded: User?, addedTo: Group?) {
                    val responseMap :HashMap<String,Any?> = HashMap()

                    responseMap["action"] = getMessageMap(action)
                    if(addedby!=null) responseMap["addedby"]  = getUserMap(addedby)
                    if(userAdded!=null) responseMap["userAdded"]  = getUserMap(userAdded)
                    if(addedTo!=null) responseMap["addedTo"] = getGroupMap(addedTo)
                    responseMap["methodName"] = "onMemberAddedToGroup"

                    messageStreamSink?.success(responseMap)
                }
            })


    }


    private fun addLoginListener(){
        CometChat.addLoginListener(
            "cometchat.login",
            object : CometChat.LoginListener() {
                override fun loginSuccess(user: User?) {
                    Log.d("TAG", "loginSuccess Native")
                    if(user!=null) messageStreamSink?.success(getUserMap(user,"loginSuccess"))
                }

                override fun loginFailure(exception: CometChatException?) {
                    Log.d("TAG", "loginFailure Native")
                    if(exception!=null)messageStreamSink?.success(getCometChatExceptionMap(exception,"loginFailure"))
                }

                override fun logoutSuccess() {
                    Log.d("TAG", "logoutSuccess Native")
                    val responseMap :HashMap<String,Any?> = HashMap()
                    responseMap["methodName"] = "logoutSuccess"
                    messageStreamSink?.success(responseMap)
                }

                override fun logoutFailure(exception: CometChatException?) {
                    Log.d("TAG", "logoutFailure Native")
                    if(exception!=null)messageStreamSink?.success(getCometChatExceptionMap(exception,"logoutFailure"))
                }
            })

    }


    private fun addConnectionListener(){
        CometChat.addConnectionListener(
            "cometchat.connection",
            object : CometChat.ConnectionListener {
                override fun onConnected() {
                    Log.d("TAG", "onConnected Native")
                    val responseMap :HashMap<String,Any?> = HashMap()
                    responseMap["methodName"] = "onConnected"
                    messageStreamSink?.success(responseMap)
                }

                override fun onConnecting() {
                    Log.d("TAG", "onConnecting Native")
                    val responseMap :HashMap<String,Any?> = HashMap()
                    responseMap["methodName"] = "onConnecting"
                    messageStreamSink?.success(responseMap)
                }

                override fun onDisconnected() {
                    Log.d("TAG", "onDisconnected Native")
                    val responseMap :HashMap<String,Any?> = HashMap()
                    responseMap["methodName"] = "onDisconnected"
                    messageStreamSink?.success(responseMap)
                }

                override fun onFeatureThrottled() {
                    Log.d("TAG", "onFeatureThrottled Native")
                    val responseMap :HashMap<String,Any?> = HashMap()
                    responseMap["methodName"] = "onFeatureThrottled"
                    messageStreamSink?.success(responseMap)
                }
            })
    }

    private fun fetchPreviousMessages(call: MethodCall, result: Result) {
        val limit: Int = call.argument("limit") ?: -1
        val uid: String = call.argument("uid") ?: ""
        val guid: String = call.argument("guid") ?: ""
        val searchTerm: String = call.argument("searchTerm") ?: ""
        val messageId: Int = call.argument("messageId") ?: -1

        val timestamp: Long = (call.argument("timestamp") ?: 0).toLong()
        val unread: Boolean = call.argument("unread") ?: false
        val hideblockedUsers: Boolean = call.argument("hideblockedUsers") ?: false
        val updateAfter: Long = (call.argument("updateAfter")  ?: 0).toLong()
        val updatesOnly: Boolean = call.argument("updatesOnly") ?: false
        val categories: List<String> = call.argument("categories")?: emptyList()
        val types: List<String> = call.argument("types") ?: emptyList()
        val parentMessageId: Int = call.argument("parentMessageId") ?: -1
        val hideReplies: Boolean = call.argument("hideReplies") ?: false
        val hideDeletedMessages: Boolean = call.argument("hideDeletedMessages") ?: false
        val withTags: Boolean = call.argument("withTags") ?: false
        val tags: List<String> = call.argument("tags") ?: emptyList()
        var key: String? = call.argument("key")
        lateinit var  messagesRequest: MessagesRequest


        if( key==null || !messageRequestMap.contains(key) || ((messageRequestMap.get(key))==null) ){
            var builder: MessagesRequest.MessagesRequestBuilder =
                MessagesRequest.MessagesRequestBuilder()

            if (limit > 0) builder = builder.setLimit(limit)

            if (uid.isNotEmpty()) {
                builder = builder.setUID(uid)
            } else if (guid.isNotEmpty()) {
                builder = builder.setGUID(guid)
            }


            if (searchTerm.isNotEmpty()) builder = builder.setSearchKeyword(searchTerm)

            if (messageId > 0) builder = builder.setMessageId(messageId)

            if (timestamp > 0) builder = builder.setTimestamp(timestamp)

            if (unread) {
                builder = builder.setUnread(unread)

            }
            if (hideblockedUsers) builder = builder.hideMessagesFromBlockedUsers(hideblockedUsers)

            if (updateAfter>0) builder = builder.setUpdatedAfter(updateAfter)

            if (updatesOnly) builder = builder.updatesOnly(updatesOnly)

            if (categories.isNotEmpty()) builder = builder.setCategories(categories)

            if (types.isNotEmpty()) builder = builder.setTypes(types)

            if (parentMessageId > 0) builder = builder.setParentMessageId(parentMessageId)

            if (hideReplies) builder = builder.hideReplies(hideReplies)

            if (hideDeletedMessages) builder = builder.hideDeletedMessages(hideDeletedMessages)

            if(withTags) builder  = builder.withTags(withTags)

            if(tags.isNotEmpty()) builder = builder.setTags(tags)

            messagesRequest= builder.build()

            if(key==null){
                counter++
                key = counter.toString()

            }
            messageRequestMap[key] = messagesRequest


        }else{
            messagesRequest =   messageRequestMap[key]!!

        }

        messagesRequest.fetchPrevious(object : CometChat.CallbackListener<List<BaseMessage>>() {
            override fun onSuccess(messages: List<BaseMessage>) {
//                Log.d("fetchPreviousMessages", "Fetch messages successful: ${messages.size}")
                val list = messages.map { e -> getMessageMap(e) }
                val resultMap = mutableMapOf<String, Any?>()
                resultMap["key"] = key
                resultMap["list"] = list
                result.success(resultMap)
            }

            override fun onError(e: CometChatException) {
                Log.d(
                    "fetchPreviousMessages",
                    "Message fetching failed with exception: " + e.message
                )
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun fetchNextConversations(call: MethodCall, result: Result) {
        val limit: Int = call.argument("limit") ?: -1
        val type: String? = call.argument("type")
        val init: Boolean = call.argument("init") ?: true
        val withUserAndGroupTags: Boolean = call.argument("withUserAndGroupTags") ?: false
        val withTags: Boolean = call.argument("withTags") ?: false
        val tags: List<String> = call.argument("tags") ?: emptyList()
        var key: String? = call.argument("key")

        lateinit var  conversationRequest: ConversationsRequest

        if( key==null || !conversationRequestMap.contains(key) || ((conversationRequestMap.get(key))==null) ){
            var builder: ConversationsRequest.ConversationsRequestBuilder =
                ConversationsRequest.ConversationsRequestBuilder()

            if (limit > 0) builder = builder.setLimit(limit)

            if (type != null) builder = builder.setConversationType(type)


            if(withUserAndGroupTags) builder = builder.withUserAndGroupTags(withUserAndGroupTags)

            if(withTags) builder  = builder.withTags(withTags)

            if(tags.isNotEmpty()) builder = builder.setTags(tags)

            conversationRequest = builder.build()

            if(key==null){
                counter++
                key = counter.toString()

            }
            conversationRequestMap[key] = conversationRequest

        }else{
            conversationRequest =   conversationRequestMap[key]!!

        }


        conversationRequest.fetchNext(object : CometChat.CallbackListener<List<Conversation>>() {
            override fun onSuccess(conversations: List<Conversation>) {

                conversations.map { e -> Log.d("tags from native","${e.tags}") }
                val list = conversations.map { e -> getConversationMap(e) }

                Log.d(
                    "list size",
                    "Fetch conversations successful: ${list.size}"
                )

                val resultMap = mutableMapOf<String, Any?>()
                resultMap["key"] = key
                resultMap["list"] = list
                result.success(resultMap)
            }

            override fun onError(e: CometChatException) {
                Log.e("fetchNextConversations", "Failed to fetch conversations: " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun getConversation(call: MethodCall, result: Result) {
        val conversationWith: String = call.argument("conversationWith") ?: ""
        val conversationType: String = call.argument("conversationType") ?: ""

        CometChat.getConversation(conversationWith, conversationType, object: CometChat.CallbackListener<Conversation>(){
            override fun onSuccess(conversation: Conversation) {
                result.success(getConversationMap(conversation))
            }
            override fun onError(e: CometChatException) {
                Log.e("getConversation", "Failed to fetch conversation: " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

//    private fun getConversationFromMessage(call: MethodCall, result: Result) {
//        CometChatHelper.getConversationFromMessage(toBaseMessage(call.t));
//    }

    private fun deleteMessage(call: MethodCall, result: Result) {
        val messageId: Int = call.argument("messageId") ?: -1
        Log.d("ReceavedID", "receaved id : ${messageId}")

        CometChat.deleteMessage(messageId, object : CometChat.CallbackListener<BaseMessage>() {
            override fun onSuccess(message: BaseMessage) {
                Log.d("deleteMessage", "deleteMessage onSuccess : " +"${message.id} ${message.type}" + message.category +" "+ message.deletedAt)
                result.success(getMessageMap(message));
            }

            override fun onError(e: CometChatException) {
                Log.d("deleteMessage", "deleteMessage onError : " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun createGroup(call: MethodCall, result: Result) {
        val guid: String = call.argument("guid") ?: ""
        val owner: String = call.argument("owner") ?: ""
        val name: String = call.argument("name") ?: ""
        val icon: String = call.argument("icon") ?: ""
        val description: String = call.argument("description") ?: ""
        val membersCount: Int = call.argument("membersCount")?: 0
        val createdAt: Long? = call.argument("createdAt")
        val joinedAt: Long? = call.argument("joinedAt")
        val updatedAt: Long? = call.argument("updatedAt")
        val tags: List<String>? = call.argument("tags")
        val type: String = call.argument("type") ?: ""
        val password: String = call.argument("password") ?: ""
        val scope: String = call.argument("scope") ?: ""
        val metadata: String? = call.argument("metadata")

        val group = Group()
        if(guid.isNotEmpty())group.guid = guid
        if(owner.isNotEmpty())group.owner = owner
        if(name.isNotEmpty())group.name = name
        if(icon.isNotEmpty())group.icon = icon
        if(description.isNotEmpty())group.description = description
        if(metadata!=null&& metadata.isNotEmpty()){
            group.metadata = JSONObject(metadata)
        }
        if(membersCount!=0) group.membersCount = membersCount
        if(createdAt!=null)group.createdAt = createdAt
        if(joinedAt!=null)group.joinedAt = joinedAt
        if(updatedAt!=null)group.updatedAt = updatedAt
        if(tags!=null) group.tags = tags
        if(type.isNotEmpty())group.groupType = type
        if(password.isNotEmpty())group.password = password
        if(scope.isNotEmpty())group.scope = scope

        CometChat.createGroup(group, object : CometChat.CallbackListener<Group>() {
            override fun onSuccess(group: Group) {
                Log.d("createGroup", "Group created successfully: $group")
                result.success(getGroupMap(group))
            }

            override fun onError(e: CometChatException) {
                Log.d("createGroup", "Group creation failed with exception: " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun joinGroup(call: MethodCall, result: Result) {
        val guid: String = call.argument("guid") ?: ""
        val groupType: String = call.argument("groupType") ?: ""
        val password: String = call.argument("password") ?: ""

        CometChat.joinGroup(
            guid,
            groupType,
            password,
            object : CometChat.CallbackListener<Group>() {
                override fun onSuccess(group: Group) {
                    Log.d("joinGroup", "Group joined successfully: $group")
                    result.success(getGroupMap(group))
                }

                override fun onError(e: CometChatException) {
                    Log.d("joinGroup", "Group creation failed with exception: " + e.message)
                    result.error(e.code!!, e.message, e.details)
                }
            })
    }

    private fun leaveGroup(call: MethodCall, result: Result) {
        val guid: String = call.argument("guid") ?: ""

        CometChat.leaveGroup(guid, object : CometChat.CallbackListener<String>() {
            override fun onSuccess(m: String) {
                Log.d("leaveGroup", "Group left successfully: $m")
                result.success(m)
            }

            override fun onError(e: CometChatException) {
                Log.d("leaveGroup", "Group leaving failed with exception: " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun deleteGroup(call: MethodCall, result: Result) {
        val guid: String = call.argument("guid") ?: ""

        CometChat.deleteGroup(guid, object : CometChat.CallbackListener<String>() {
            override fun onSuccess(m: String) {
                Log.d("deleteGroup", "Group deleted successfully: $m")
                result.success(m)
            }

            override fun onError(e: CometChatException) {
                Log.d("deleteGroup", "Group delete failed with exception: " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun fetchNextGroupMembers(call: MethodCall, result: Result) {
        val guid: String = call.argument("guid") ?: ""
        val limit: Int = call.argument("limit") ?: -1
        val keyword: String = call.argument("keyword") ?: ""
        val init: Boolean = call.argument("init") ?: true
        val scopes: List<String> = call.argument("scopes")?: emptyList()
        var key: String? = call.argument("key")
        lateinit var  groupMembersRequest : GroupMembersRequest

        if( key==null || !groupMemberRequestMap.contains(key) || ((groupMemberRequestMap.get(key))==null) ){
            var builder: GroupMembersRequest.GroupMembersRequestBuilder =
                GroupMembersRequest.GroupMembersRequestBuilder(guid)

            if (limit > 0) builder = builder.setLimit(limit)

            if (keyword.isNotEmpty()) builder = builder.setSearchKeyword(keyword)

            if (scopes.isNotEmpty()) builder = builder.setScopes(scopes)

            groupMembersRequest = builder.build()
            if(key==null){
                counter++
                key = counter.toString()

            }
            groupMemberRequestMap[key] = groupMembersRequest


        }else{
            groupMembersRequest =   groupMemberRequestMap[key]!!

        }


        groupMembersRequest.fetchNext(object : CometChat.CallbackListener<List<GroupMember>>() {
            override fun onSuccess(members: List<GroupMember>) {
                Log.d(
                    "fetchNextGroupMembers",
                    "Group Member list fetched successfully: " + members.size
                )
                val list = members.map { e -> getGroupMemberMap(e) }
                val resultMap = mutableMapOf<String, Any?>()
                resultMap["key"] = key
                resultMap["list"] = list
                result.success(resultMap)
            }

            override fun onError(e: CometChatException) {
                Log.d(
                    "fetchNextGroupMembers",
                    "Group Member list fetching failed with exception: " + e.message
                )
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun fetchNextGroups(call: MethodCall, result: Result) {
        val limit: Int = call.argument("limit") ?: -1
        val searchTerm: String = call.argument("searchTerm") ?: ""
        val init: Boolean = call.argument("init") ?: true
        val joinedOnly: Boolean = call.argument("joinedOnly") ?: false
        val tags: List<String> = call.argument("tags") ?: emptyList()
        val withTags: Boolean = call.argument("withTags") ?: false

        var key: String? = call.argument("key")
        lateinit var  groupsRequest: GroupsRequest


        if( key==null || !groupRequestMap.contains(key) || ((groupRequestMap.get(key))==null) ){
            var builder: GroupsRequest.GroupsRequestBuilder = GroupsRequest.GroupsRequestBuilder()
            if (limit > 0) builder = builder.setLimit(limit)
            if (searchTerm.isNotEmpty()) builder.setSearchKeyWord(searchTerm)
            if (joinedOnly) builder = builder.joinedOnly(joinedOnly)
            if (tags.isNotEmpty()) builder = builder.setTags(tags)
            if (withTags) builder = builder.withTags(withTags)
            groupsRequest = builder.build()
            if(key==null){
                counter++
                key = counter.toString()

            }
            groupRequestMap[key] = groupsRequest


        }else {
            groupsRequest = groupRequestMap[key]!!
        }


        groupsRequest.fetchNext(object : CometChat.CallbackListener<List<Group>>() {
            override fun onSuccess(groups: List<Group>) {
                Log.d("fetchNextGroups", "Groups list fetched successfully: " + groups.size)
                val list = groups.map { e -> getGroupMap(e) }
                val resultMap = mutableMapOf<String, Any?>()
                resultMap["key"] = key
                resultMap["list"] = list
                result.success(resultMap)
            }

            override fun onError(e: CometChatException) {
                Log.d("fetchNextGroups", "Groups list fetching failed with exception: " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun registerTokenForPushNotification(call: MethodCall, result: Result) {
        val token: String = call.argument("token") ?: ""
        CometChat.registerTokenForPushNotification(
            token,
            object : CometChat.CallbackListener<String?>() {
                override fun onSuccess(s: String?) {
                    Log.e("onSuccessPN: ", s ?: "Done")
                    result.success(s)
                }

                override fun onError(e: CometChatException) {
                    Log.e("onErrorPN: ", "Token save failed: " + e.message)
                    result.error(e.code!!, e.message, e.details)
                }
            })
    }

    private fun getUnreadMessageCount(result: Result) {
        CometChat.getUnreadMessageCount(object :
            CometChat.CallbackListener<HashMap<String, HashMap<String, Int>>>() {
            override fun onSuccess(counts: HashMap<String, HashMap<String, Int>>?) {
                Log.d("getUnreadMessageCount", "onSuccess: $counts")
                result.success(counts)
            }

            override fun onError(e: CometChatException) {
                Log.d("getUnreadMessageCount", "onError: ${e.message}")
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun markAsRead(call: MethodCall, result: Result) {
        //val baseMessage :BaseMessage? = call.argument("baseMessage") ?: null
        val baseMessage: HashMap<String, Any?> = call.argument("baseMessage") ?: HashMap()



        var baseMessageObj:BaseMessage = toBaseMessage(baseMessage);

        CometChat.markAsRead(baseMessageObj, object : CallbackListener<Void?>() {
            override fun onSuccess(unused: Void?) {
                Log.d("markAsRead", "markAsRead : " + "success")
                result.success("Success")
            }

            override fun onError(e: CometChatException) {
                Log.e("error", "markAsRead : " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })

        //result.success(null)
    }

    private fun callExtension(call: MethodCall, result: Result) {
        val slug: String = call.argument("slug") ?: ""
        val requestType: String = call.argument("requestType") ?: ""
        var endPoint: String = call.argument("endPoint") ?: ""

        val body: JSONObject = JSONObject(call.argument("body") ?: emptyMap<String, Any>())

        if (endPoint.isNotEmpty() && !endPoint.startsWith("/")) {
            endPoint = "/$endPoint";
        }

        CometChat.callExtension(
            slug,
            requestType,
            endPoint,
            body,
            object : CometChat.CallbackListener<JSONObject>() {
                override fun onSuccess(response: JSONObject) {
                    Log.d("callExtension", "onSuccess: ${response.toString()}")
                    result.success(response.toString())
                }

                override fun onError(e: CometChatException) {
                    Log.d("callExtension", "onError: ${e.message}")
                    result.error(e.code!!, e.message, e.details)
                }
            })
    }

    private fun blockUsers(call: MethodCall, result: Result) {
        val uids: List<String> = call.argument("uids")!!
        CometChat.blockUsers(uids, object : CometChat.CallbackListener<HashMap<String, String>>() {

            override fun onSuccess(resultMap: HashMap<String, String>) {
                result.success(resultMap)
            }

            override fun onError(e: CometChatException) {
                Log.d("blockUser", "onError: ${e.message}")
                result.error(e.code!!, e.message, e.details)
            }
        })


    }

    private fun unblockUsers(call: MethodCall, result: Result) {
        val uids: List<String> = call.argument("uids")!!
        CometChat.unblockUsers(
            uids,
            object : CometChat.CallbackListener<HashMap<String, String>>() {

                override fun onSuccess(resultMap: HashMap<String, String>) {
                    result.success(resultMap)
                }

                override fun onError(e: CometChatException) {
                    Log.d("blockUser", "onError: ${e.message}")
                    result.error(e.code!!, e.message, e.details)
                }
            })


    }

    private fun fetchBlockedUsers(call: MethodCall, result: Result) {

        val searchTerm: String = call.argument("searchKeyword") ?: ""
        val direction: String = call.argument("direction") ?: ""
        val limit: Int = call.argument("limit") ?: -1
        var key: String? = call.argument("key")

        lateinit var  blockedUsersRequest : BlockedUsersRequest


        if( key==null || !blockedUsersRequestMap.contains(key) || ((blockedUsersRequestMap.get(key))==null) ){
            var builder: BlockedUsersRequest.BlockedUsersRequestBuilder  =  BlockedUsersRequest.BlockedUsersRequestBuilder()

            if (limit > 0) builder = builder.setLimit(limit)
            if (searchTerm.isNotEmpty()) builder = builder.setSearchKeyword(searchTerm)
            if (direction.isNotEmpty()) {
                if(direction.equals("blockedByMe" ,ignoreCase = true)){
                    builder = builder.setDirection(BlockedUsersRequest.DIRECTION_BLOCKED_BY_ME)
                }else if(direction.equals("hasBlockedMe" ,ignoreCase = true)){
                    builder = builder.setDirection(BlockedUsersRequest.DIRECTION_HAS_BLOCKED_ME)
                }else{
                    builder = builder.setDirection(BlockedUsersRequest.DIRECTION_BOTH)
                }
            }
            blockedUsersRequest= builder.build()
            if(key==null){
                counter++
                key = counter.toString()

            }
            blockedUsersRequestMap[key] = blockedUsersRequest
        }else{
            blockedUsersRequest =   blockedUsersRequestMap[key]!!

        }

        blockedUsersRequest.fetchNext(object : CometChat.CallbackListener<List<User>>() {
            override fun onSuccess(users: List<User>) {
                Log.d(
                    "fetchBlockedUsers",
                    "Blocked users list fetched successfully: " + users.size
                )
                val list = users.map { e -> getUserMap(e) }
                val resultMap = mutableMapOf<String, Any?>()
                resultMap["key"] = key
                resultMap["list"] = list
                result.success(resultMap)
            }

            override fun onError(e: CometChatException) {
                Log.d(
                    "fetchBlockedUsers",
                    "Blocked users list fetching failed with exception: " + e.message
                )
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun fetchUsers(call: MethodCall, result: Result) {
        val searchTerm: String = call.argument("searchTerm") ?: ""
        val limit: Int = call.argument("limit") ?: -1
        val hidebloackedUsers: Boolean = call.argument("hidebloackedUsers") ?: false
        val userRoles: List<String> = call.argument("userRoles")?: emptyList()
        val friendsOnly: Boolean = call.argument("friendsOnly") ?: false
        val tags: List<String> = call.argument("tags") ?: emptyList()
        val uids: List<String> = call.argument("uids") ?: emptyList()
        val withTags: Boolean = call.argument("withTags") ?: false
        val userStatus: String = call.argument("userStatus") ?: ""


        var key: String? = call.argument("key")
        lateinit var  usersRequest: UsersRequest


        if( key==null || !userRequestMap.contains(key) || ((userRequestMap.get(key))==null) ){
            var builder: UsersRequest.UsersRequestBuilder  =  UsersRequest.UsersRequestBuilder()

            if (limit > 0) builder = builder.setLimit(limit)
            if (searchTerm.isNotEmpty()) builder = builder.setSearchKeyword(searchTerm)
            if (hidebloackedUsers) builder = builder.hideBlockedUsers(hidebloackedUsers)
            if (userRoles.isNotEmpty()) builder = builder.setRoles(userRoles)
            if (friendsOnly) builder = builder.friendsOnly(friendsOnly)
            if (tags.isNotEmpty()) builder = builder.setTags(tags)
            if (uids.isNotEmpty()) builder = builder.setUIDs(uids)
            if (withTags) builder = builder.withTags(withTags)
            if (userStatus.isNotEmpty()) {
                if(userStatus.equals("online" ,ignoreCase = true)){
                    Log.d("Native UserStatus", "${UsersRequest.USER_STATUS_ONLINE}")
                    builder = builder.setUserStatus(UsersRequest.USER_STATUS_ONLINE)
                }else{
                    Log.d("Native UserStatus", "${UsersRequest.USER_STATUS_OFFLINE}")
                    builder = builder.setUserStatus(UsersRequest.USER_STATUS_OFFLINE)
                }

            }


            usersRequest = builder.build()

            if(key==null){
                counter++
                key = counter.toString()

            }
            userRequestMap[key] = usersRequest


        }else{
            usersRequest =   userRequestMap[key]!!

        }


        usersRequest.fetchNext(object : CometChat.CallbackListener<List<User>>() {
            override fun onSuccess(members: List<User>) {
                Log.d(
                    "fetchUsers",
                    "user Member list fetched successfully: " + members.size
                )
                val list = members.map { e -> getUserMap(e) }
                val resultMap = mutableMapOf<String, Any?>()
                resultMap["key"] = key
                resultMap["list"] = list
                result.success(resultMap)
            }

            override fun onError(e: CometChatException) {
                Log.d(
                    "fetchUsers",
                    "User Member list fetching failed with exception: " + e.message
                )
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun startTyping(call: MethodCall, result: Result) {
        val uid: String = call.argument("uid") ?: ""
        val receiverType: String = call.argument("receiverType") ?: ""
        val typingIndicator =TypingIndicator(uid,receiverType)
        CometChat.startTyping(typingIndicator)
    }
    private fun endTyping(call: MethodCall, result: Result) {
        val uid: String = call.argument("uid") ?: ""
        val receiverType: String = call.argument("receiverType") ?: ""
        val typingIndicator =TypingIndicator(uid,receiverType)
        CometChat.endTyping(typingIndicator)
    }


    private fun fetchNextMessages(call: MethodCall, result: Result) {
        val limit: Int = call.argument("limit") ?: -1
        val uid: String = call.argument("uid") ?: ""
        val guid: String = call.argument("guid") ?: ""
        val searchTerm: String = call.argument("searchTerm") ?: ""
        val messageId: Int = call.argument("messageId") ?: -1

        val timestamp: Long = (call.argument("timestamp") ?: 0).toLong()
        val unread: Boolean = call.argument("unread") ?: false
        val hideblockedUsers: Boolean = call.argument("hideblockedUsers") ?: false
        val updateAfter: Long = (call.argument("updateAfter")  ?: 0).toLong()
        val updatesOnly: Boolean = call.argument("updatesOnly") ?: false
        val categories: List<String> = call.argument("categories")?: emptyList()
        val types: List<String> = call.argument("types") ?: emptyList()
        val parentMessageId: Int = call.argument("parentMessageId") ?: -1
        val hideReplies: Boolean = call.argument("hideReplies") ?: false
        val hideDeletedMessages: Boolean = call.argument("hideDeletedMessages") ?: false
        val withTags: Boolean = call.argument("withTags") ?: false
        val tags: List<String> = call.argument("tags") ?: emptyList()
        var key: String? = call.argument("key")

        lateinit var  messagesRequest: MessagesRequest


        if( key==null || !messageRequestMap.contains(key) || ((messageRequestMap.get(key))==null) ){
            var builder: MessagesRequest.MessagesRequestBuilder =
                MessagesRequest.MessagesRequestBuilder()

            if (limit > 0) builder = builder.setLimit(limit)

            if (uid.isNotEmpty()) {
                builder = builder.setUID(uid)
            } else if (guid.isNotEmpty()) {
                builder = builder.setGUID(guid)
            }


            if (searchTerm.isNotEmpty()) builder = builder.setSearchKeyword(searchTerm)

            if (messageId > 0) builder = builder.setMessageId(messageId)

            if (timestamp > 0) builder = builder.setTimestamp(timestamp as Long)

            if (unread) {
                builder = builder.setUnread(unread)

            }
            if (hideblockedUsers) builder = builder.hideMessagesFromBlockedUsers(hideblockedUsers)

            if (updateAfter>0) builder = builder.setUpdatedAfter(updateAfter)

            if (updatesOnly) builder = builder.updatesOnly(updatesOnly)

            if (categories.isNotEmpty()) builder = builder.setCategories(categories)

            if (types.isNotEmpty()) builder = builder.setTypes(types)

            if (parentMessageId > 0) builder = builder.setParentMessageId(parentMessageId)

            if (hideReplies) builder = builder.hideReplies(hideReplies)

            if (hideDeletedMessages) builder = builder.hideDeletedMessages(hideDeletedMessages)

            if(withTags) builder  =  builder.withTags(withTags)

            if(tags.isNotEmpty()) builder = builder.setTags(tags)

            messagesRequest= builder.build()

            if(key==null){
                counter++
                key = counter.toString()

            }
            messageRequestMap[key] = messagesRequest


        }else{
            messagesRequest =   messageRequestMap[key]!!

        }

        messagesRequest.fetchNext(object : CometChat.CallbackListener<List<BaseMessage>>() {
            override fun onSuccess(messages: List<BaseMessage>) {
//                Log.d("fetchPreviousMessages", "Fetch messages successful: ${messages.size}")
                val list = messages.map { e -> getMessageMap(e) }
                val resultMap = mutableMapOf<String, Any?>()
                resultMap["key"] = key
                resultMap["list"] = list
                result.success(resultMap)
            }

            override fun onError(e: CometChatException) {
                Log.d(
                    "fetchPreviousMessages",
                    "Message fetching failed with exception: " + e.message
                )
                result.error(e.code!!, e.message, e.details)
            }
        })
    }


    private fun getUnreadMessageCountForGroup(call: MethodCall, result: Result) {

        val guid: String = call.argument("guid") ?: ""
        val hideMessagesFromBlockedUsers: Boolean = call.argument("hideMessagesFromBlockedUsers") ?: false

        CometChat.getUnreadMessageCountForGroup( guid, hideMessagesFromBlockedUsers , object :
            CometChat.CallbackListener<HashMap<String, Int>>() {
            override fun onSuccess(counts: HashMap<String,  Int>?) {
                Log.d("getUnreadMessageCount", "onSuccess: $counts")
                result.success(counts)
            }

            override fun onError(e: CometChatException) {
                Log.d("getUnreadMessageCount", "onError: ${e.message}")
                result.error(e.code!!, e.message, e.details)
            }
        })
    }


    private fun getUnreadMessageCountForAllUsers(call: MethodCall, result: Result) {

        val hideMessagesFromBlockedUsers: Boolean = call.argument("hideMessagesFromBlockedUsers") ?: false

        CometChat.getUnreadMessageCountForAllUsers(hideMessagesFromBlockedUsers , object :
            CometChat.CallbackListener<HashMap<String, Int>>() {
            override fun onSuccess(counts: HashMap<String,  Int>?) {
                Log.d("getUnreadMessageCount", "onSuccess: $counts")
                result.success(counts)
            }

            override fun onError(e: CometChatException) {
                Log.d("getUnreadMessageCount", "onError: ${e.message}")
                result.error(e.code!!, e.message, e.details)
            }
        })
    }


    private fun getUnreadMessageCountForAllGroups(call: MethodCall, result: Result) {

        val hideMessagesFromBlockedUsers: Boolean = call.argument("hideMessagesFromBlockedUsers") ?: false

        CometChat.getUnreadMessageCountForAllGroups(hideMessagesFromBlockedUsers , object :
            CometChat.CallbackListener<HashMap<String, Int>>() {
            override fun onSuccess(counts: HashMap<String,  Int>?) {
                Log.d("getUnreadMessageCount", "onSuccess: $counts")
                result.success(counts)
            }

            override fun onError(e: CometChatException) {
                Log.d("getUnreadMessageCount", "onError: ${e.message}")
                result.error(e.code!!, e.message, e.details)
            }
        })
    }



    private fun markAsDelivered(call: MethodCall, result: Result) {
        val baseMessageMap: HashMap<String, Any?> = call.argument("baseMessage") ?: HashMap()

        var baseMessageObj:BaseMessage = toBaseMessage(baseMessageMap);
        Log.d("markAsDelivered", "Marking delivered : " + "success")
        CometChat.markAsDelivered(baseMessageObj, object : CallbackListener<Void?>() {
            override fun onSuccess(unused: Void?) {
                Log.d("markAsDelivered", "markAsDelivered : " + "success")
                result.success("Success")
            }

            override fun onError(e: CometChatException) {
                Log.e("error", "markAsRead : " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })

        //result.success(null)
    }

    private fun getMessageReceipts(call: MethodCall, result: Result) {
        val messageId: Int = call.argument("id") ?: -1
        CometChat.getMessageReceipts(
            messageId,
            object : CallbackListener<List<MessageReceipt?>?>() {
                override fun onSuccess(messageReceipts: List<MessageReceipt?>?) {
                    val list = messageReceipts?.map { e -> getMessageReceiptMap(e) }
                    result.success(list)
                }
                override fun onError(e: CometChatException) {
                    result.error(e.code!!, e.message, e.details)
                }
            }
        )
    }

    private fun editMessage(call: MethodCall, result: Result) {
        val baseMessageMap: HashMap<String, Any?> = call.argument("baseMessage") ?: HashMap()


        var updatedMessage:BaseMessage
        if(baseMessageMap["type"]=="text"){
            updatedMessage = toTextMessage(baseMessageMap)
        }else if(baseMessageMap["category"]=="custom"){
            updatedMessage = toCustomMessage(baseMessageMap)
        }else {
            updatedMessage = toBaseMessage(baseMessageMap)
        }


        CometChat.editMessage(updatedMessage, object : CallbackListener<BaseMessage>() {
            override fun onSuccess(message: BaseMessage) {
                Log.d("TAG", "Message Edited successfully: $message")
                result.success(getMessageMap(message))
            }

            override fun onError(e: CometChatException) {
                result.error(e.code!!, e.message, e.details)
            }
        })


    }

    private fun deleteConversation(call: MethodCall, result: Result) {
        val conversationWith: String = call.argument("conversationWith") ?: ""
        val conversationType: String = call.argument("conversationType") ?: ""

        CometChat.deleteConversation(
            conversationWith,
            conversationType,
            object : CallbackListener<String?>() {
                override fun onSuccess(s: String?) {
                    Log.d("TAG", "Message Edited successfully: $s")
                    result.success(s)
                }

                override fun onError(e: CometChatException) {
                    result.error(e.code!!, e.message, e.details)
                }
            })


    }

    private fun sendTransientMessage(call: MethodCall, result: Result) {
        val receiverId: String = call.argument("receiverId") ?: ""
        val receiverType: String = call.argument("receiverType") ?: ""
        val passedData : HashMap<String, Any> = call.argument("data") ?: HashMap()

        val data = JSONObject()
        for(items in passedData){
            data.put(items.key,items.value)
        }

        try {
            val transientMessage =
                TransientMessage(receiverId, receiverType, data)
            CometChat.sendTransientMessage(transientMessage)
            result.success("Message Sent ")

        }catch (e: Exception) {
            result.error("ERR", e.message, e.message)

        }

    }

    private fun getOnlineUserCount( result: Result) {

        CometChat.getOnlineUserCount(object : CallbackListener<Int>() {
            override fun onSuccess(count: Int) {
                Log.d("TAG", "Online users : $count")
                result.success(count)
            }

            override fun onError(e: CometChatException) {
                Log.d("TAG", "Error : " + e.message)
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }

    private fun updateUser(call: MethodCall, result: Result) {
        val uid: String = call.argument("uid") ?: ""
        val name: String = call.argument("name") ?: ""
        val avatar: String? = call.argument("avatar")
        val tags: List<String>? = call.argument("tags")
        val link: String? = call.argument("link")
        val metadata: String? = call.argument("metadata")
        val statusMessage: String? = call.argument("statusMessage")
        val apiKey: String = call.argument("apiKey") ?: ""
        val role: String? = call.argument("role")
        val blockedByMe: Boolean? = call.argument("blockedByMe")
        val hasBlockedMe: Boolean? = call.argument("hasBlockedMe")
        val lastActiveAt: Long? = call.argument("lastActiveAt")
        val status: String? = call.argument("status")

        val user = User();
        user.uid = uid
        if(name.isNotEmpty())user.name = name
        if(avatar!=null)user.avatar = avatar
        if(link!=null)user.link = link
        if(metadata!=null) user.metadata = JSONObject(metadata)
        if(tags!=null) user.tags = tags
        if(statusMessage!=null)user.statusMessage = statusMessage
        if(role!=null)user.role = role
        if(blockedByMe!=null)user.isBlockedByMe = blockedByMe
        if(hasBlockedMe!=null)user.isHasBlockedMe = hasBlockedMe
        if(lastActiveAt!=null)user.lastActiveAt = lastActiveAt

        if (status!=null) {
            if(status.equals("online" ,ignoreCase = true)){
                user.status = CometChatConstants.USER_STATUS_ONLINE;
            }else{
                user.status = CometChatConstants.USER_STATUS_OFFLINE
            }

        }




        CometChat.updateUser(user, apiKey, object : CallbackListener<User>() {
            override fun onSuccess(user: User) {
                Log.d("updateUser", user.toString())
                result.success(getUserMap(user) )
            }

            override fun onError(e: CometChatException) {
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }


    private fun updateCurrentUserDetails(call: MethodCall, result: Result) {
        val name: String = call.argument("name") ?: ""
        val avatar: String? = call.argument("avatar")
        val tags: List<String>? = call.argument("tags")
        val link: String? = call.argument("link")
        val metadata: String? = call.argument("metadata")
        val statusMessage: String? = call.argument("statusMessage")
        val role: String? = call.argument("role")
        val blockedByMe: Boolean? = call.argument("blockedByMe")
        val hasBlockedMe: Boolean? = call.argument("hasBlockedMe")
        val lastActiveAt: Long? = call.argument("lastActiveAt")
        val status: String? = call.argument("status")



        val user = User()
        if(name.isNotEmpty())user.name = name
        if(avatar!=null)user.avatar = avatar
        if(link!=null)user.link = link
        if(metadata!=null) user.metadata = JSONObject(metadata)
        if(tags!=null) user.tags = tags
        if(statusMessage!=null)user.statusMessage = statusMessage
        if(role!=null)user.role = role
        if(blockedByMe!=null)user.isBlockedByMe = blockedByMe
        if(hasBlockedMe!=null)user.isHasBlockedMe = hasBlockedMe
        if(lastActiveAt!=null)user.lastActiveAt = lastActiveAt
        if (status!=null) {
            if(status.equals("online" ,ignoreCase = true)){
                user.status = CometChatConstants.USER_STATUS_ONLINE;
            }else{
                user.status = CometChatConstants.USER_STATUS_OFFLINE
            }

        }


        CometChat.updateCurrentUserDetails(user,  object : CallbackListener<User>() {
            override fun onSuccess(user: User) {
                Log.d("Update Current User", user.toString())
                result.success(getUserMap(user) )
            }

            override fun onError(e: CometChatException) {
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }


    private fun getGroup(call: MethodCall, result: Result) {
        val GUID: String = call.argument("guid") ?: ""
        CometChat.getGroup(GUID, object : CallbackListener<Group>() {
            override fun onSuccess(group: Group) {
                Log.d("TAG", "Group details fetched successfully: $group")
                result.success(getGroupMap(group))
            }

            override fun onError(e: CometChatException) {
                Log.d("TAG", "Group details fetching failed with exception: " + e.message)
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }

    private fun getOnlineGroupMemberCount(call: MethodCall, result: Result) {
        val GUIDS: List<String> = call.argument("guids")?: emptyList()
        CometChat.getOnlineGroupMemberCount(
            GUIDS,
            object : CallbackListener<HashMap<String, Int>>() {
                override fun onSuccess(stringIntegerHashMap: HashMap<String, Int>) {
                    Log.d("TAG", "Group details fetched successfully: $stringIntegerHashMap")
                    result.success(stringIntegerHashMap)
                }

                override fun onError(e: CometChatException) {
                    Log.d("TAG", "Group details fetching failed with exception: " + e.message)
                    result.error(e.message!!, e.message, e.toString())
                }
            }
        )
    }

    private fun updateGroup(call: MethodCall, result: Result) {
        val guid: String = call.argument("guid") ?: ""
        val owner: String = call.argument("owner") ?: ""
        val name: String = call.argument("name") ?: ""
        val icon: String = call.argument("icon") ?: ""
        val description: String = call.argument("description") ?: ""
        val membersCount: Int = call.argument("membersCount")?: 0
        val createdAt: Long? = call.argument("createdAt")
        val joinedAt: Long? = call.argument("joinedAt")
        val updatedAt: Long? = call.argument("updatedAt")
        val tags: List<String>? = call.argument("tags")
        val type: String = call.argument("type") ?: ""
        val password: String = call.argument("password") ?: ""
        val scope: String = call.argument("scope") ?: ""
        val metadata: String? = call.argument("metadata")

        val group = Group()
        if(guid.isNotEmpty())group.guid = guid
        if(owner.isNotEmpty())group.owner = owner
        if(name.isNotEmpty())group.name = name
        if(icon.isNotEmpty())group.icon = icon
        if(description.isNotEmpty())group.description = description
        if(metadata!=null&& metadata.isNotEmpty()){
            group.metadata = JSONObject(metadata)
        }
        if(membersCount!=0) group.membersCount = membersCount
        if(createdAt!=null)group.createdAt = createdAt
        if(joinedAt!=null)group.joinedAt = joinedAt
        if(updatedAt!=null)group.updatedAt = updatedAt
        if(tags!=null) group.tags = tags
        if(type.isNotEmpty())group.groupType = type
        if(password.isNotEmpty())group.password = password
        if(scope.isNotEmpty())group.scope = scope

        CometChat.updateGroup(group, object : CallbackListener<Group>() {
            override fun onSuccess(group: Group) {
                Log.d("TAG", "Groups details updated successfully: $group")
                result.success(getGroupMap(group))
            }

            override fun onError(e: CometChatException) {
                Log.d("TAG", "Group details update failed with exception: " + e.message)
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }

    private fun addMembersToGroup(call: MethodCall, result: Result) {
        val GUID: String = call.argument("guid") ?: ""

        val groupMembers: List<HashMap<String,Any?>> = call.argument("groupMembers")?: emptyList()

        val members: MutableList<GroupMember>  = ArrayList()
        for (item in groupMembers){
            members.add(toGroupMember(item))
        }
        CometChat.addMembersToGroup(
            GUID,
            members,
            null,
            object : CallbackListener<HashMap<String?, String?>?>() {
                override fun onSuccess(successMap: HashMap<String?, String?>?) {
                    Log.d("CometChatActivity", "$successMap")
                    result.success(successMap)
                }

                override fun onError(e: CometChatException) {
                    result.error(e.message!!, e.message, e.toString())
                }
            })

    }



    private fun kickGroupMember(call: MethodCall, result: Result) {
        val GUID: String = call.argument("guid") ?: ""
        val UID: String = call.argument("uid") ?: ""

        CometChat.kickGroupMember(UID, GUID, object : CallbackListener<String?>() {
            override fun onSuccess(successMessage: String?) {
                Log.d("TAG", "Group member kicked successfully")
                result.success(successMessage)
            }
            override fun onError(e: CometChatException) {
                Log.d("TAG", "Group member kicking failed with exception: " + e.message)
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }

    private fun banGroupMember(call: MethodCall, result: Result) {
        val GUID: String = call.argument("guid") ?: ""
        val UID: String = call.argument("uid") ?: ""

        CometChat.banGroupMember(UID, GUID, object : CallbackListener<String?>() {
            override fun onSuccess(successMessage: String?) {
                Log.d("TAG", "Group member banned successfully")
                result.success(successMessage)
            }
            override fun onError(e: CometChatException) {
                Log.d("TAG", "Group member ban failed with exception: " + e.message)
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }


    private fun unbanGroupMember(call: MethodCall, result: Result) {
        val GUID: String = call.argument("guid") ?: ""
        val UID: String = call.argument("uid") ?: ""

        CometChat.unbanGroupMember(UID, GUID, object : CallbackListener<String?>() {
            override fun onSuccess(successMessage: String?) {
                Log.d("TAG", "Group member Unbanned successfully")
                result.success(successMessage)
            }
            override fun onError(e: CometChatException) {
                Log.d("TAG", "Group member unban failed with exception: " + e.message)
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }

    private fun updateGroupMemberScope(call: MethodCall, result: Result) {
        val GUID: String = call.argument("guid") ?: ""
        val UID: String = call.argument("uid") ?: ""
        val passedScope: String = call.argument("scope") ?: ""
        var scope:String = CometChatConstants.SCOPE_PARTICIPANT
        if(passedScope=="admin")scope = CometChatConstants.SCOPE_ADMIN
        else if(passedScope=="moderator")scope = CometChatConstants.SCOPE_MODERATOR

        CometChat.updateGroupMemberScope(UID, GUID, scope, object : CallbackListener<String?>() {
            override fun onSuccess(successMessage: String?) {
                Log.d("TAG", "User scope updated successfully")
                result.success(successMessage)
            }

            override fun onError(e: CometChatException) {
                Log.d("TAG", "User scope update failed with exception: " + e.message)
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }

    private fun transferGroupOwnership(call: MethodCall, result: Result) {
        val GUID: String = call.argument("guid") ?: ""
        val UID: String = call.argument("uid") ?: ""

        CometChat.transferGroupOwnership(GUID, UID, object : CallbackListener<String?>() {
            override fun onSuccess(successMessage: String?) {
                Log.e("TAG", "Transfer group ownership successful")
                result.success(successMessage)
            }

            override fun onError(e: CometChatException) {
                Log.e("TAG", "Transfer group ownership failed : " + e.message)
                result.error(e.message!!, e.message, e.toString())
            }
        })

    }

    private fun fetchBlockedGroupMembers(call: MethodCall, result: Result) {
        val searchTerm: String = call.argument("searchKeyword") ?: ""
        val limit: Int = call.argument("limit") ?: -1
        val guid: String = call.argument("guid") ?: ""
        var key: String? = call.argument("key")

        lateinit var  bannedGroupMembersRequest: BannedGroupMembersRequest


        if( key==null || !bannedGroupMemberRequestMap.contains(key) || ((bannedGroupMemberRequestMap.get(key))==null) ){
            var builder: BannedGroupMembersRequest.BannedGroupMembersRequestBuilder  =  BannedGroupMembersRequest.BannedGroupMembersRequestBuilder(guid)

            if (limit > 0) builder = builder.setLimit(limit)
            if (searchTerm.isNotEmpty()) builder = builder.setSearchKeyword(searchTerm)


            bannedGroupMembersRequest= builder.build()

            if(key==null){
                counter++
                key = counter.toString()

            }
            bannedGroupMemberRequestMap[key] = bannedGroupMembersRequest


        }else{
            bannedGroupMembersRequest =   bannedGroupMemberRequestMap[key]!!

        }



        bannedGroupMembersRequest.fetchNext(object : CometChat.CallbackListener<List<GroupMember>>() {
            override fun onSuccess(members: List<GroupMember>) {
                Log.d(
                    "fetchUsers",
                    "user Member list fetched successfully: " + members.size
                )
                val list = members.map { e -> getGroupMemberMap(e) }
                val resultMap = mutableMapOf<String, Any?>()
                resultMap["key"] = key
                resultMap["list"] = list
                result.success(resultMap)
            }

            override fun onError(e: CometChatException) {
                Log.d(
                    "fetchUsers",
                    "User Member list fetching failed with exception: " + e.message
                )
                result.error(e.code!!, e.message, e.details)
            }
        })
    }


    private fun tagConversation(call: MethodCall, result: Result) {
        val conversationWith: String = call.argument("conversationWith") ?: ""
        val conversationType: String = call.argument("conversationType") ?: ""
        val tags: List<String> = call.argument("tags") ?: emptyList()


        CometChat.tagConversation(conversationWith, conversationType, tags,object: CometChat.CallbackListener<Conversation>(){
            override fun onSuccess(conversation: Conversation) {
                Log.d("Edit Tag", "${conversation.tags}")
                result.success(getConversationMap(conversation))
            }
            override fun onError(e: CometChatException) {
                Log.e("getConversation", "Failed to fetch conversation: " + e.message)
                result.error(e.code!!, e.message, e.details)
            }
        })
    }

    private fun connect( result: Result) {
        CometChat.connect();
    }

    private fun disconnect( result: Result) {
        CometChat.disconnect();
    }


    private fun getConnectionStatus( result: Result) {

        val connectionStatus : String =  CometChat.getConnectionStatus()
        result.success(connectionStatus)

    }



    private fun toBaseMessage(map : HashMap<String, Any?>):BaseMessage{

        val baseMesssageObject:BaseMessage  = BaseMessage();
        baseMesssageObject.id = map["id"] as Int
        baseMesssageObject.receiverUid = map["receiverUid"] as String
        baseMesssageObject.type = map["type"] as String
        baseMesssageObject.receiverType = map["receiverType"] as String
        baseMesssageObject.parentMessageId = map["parentMessageId"] as Int
        baseMesssageObject.category = map["category"] as String
        baseMesssageObject.sender = toUser(map["sender"] as HashMap<String, Any?>) as User
        if(baseMesssageObject.receiverType=="group"){
            baseMesssageObject.receiver = toGroup(map["receiver"] as HashMap<String, Any?>) as Group
        }else{
            baseMesssageObject.receiver = toUser(map["receiver"] as HashMap<String, Any?>) as User
        }

        return baseMesssageObject;
    }

    private fun toTextMessage(map : HashMap<String, Any?>):TextMessage{
        val textMessage  = TextMessage(map["receiverUid"] as String ,map["type"] as String,map["receiverType"] as String  );
        textMessage.id = map["id"] as Int
        textMessage.text = map["text"] as String
        textMessage.receiverUid = map["receiverUid"] as String
        textMessage.type = map["type"] as String
        textMessage.receiverType = map["receiverType"] as String
        textMessage.parentMessageId = map["parentMessageId"] as Int
        textMessage.category = map["category"] as String
        textMessage.sender = toUser(map["sender"] as HashMap<String, Any?>) as User
        if(textMessage.receiverType=="group"){
            textMessage.receiver = toGroup(map["receiver"] as HashMap<String, Any?>) as Group
        }else{
            textMessage.receiver = toUser(map["receiver"] as HashMap<String, Any?>) as User
        }
        if(map["tags"]==null)textMessage.tags = emptyList()
        else  textMessage.tags = map["tags"]as MutableList<String>

        val metadata = map["metadata"] as HashMap<String, Any?>?;
        if(metadata!=null&& metadata.isNotEmpty()){
            textMessage.metadata = JSONObject(metadata)
            //Log.d("Meta data in android", "before sending meta data = ${textMessage.metadata}")
        }
        return textMessage;
    }



    private fun toCustomMessage(map : HashMap<String, Any?>):CustomMessage{

        val customMessageJson: JSONObject;
        val customData = map["customData"] as HashMap<String, Any?>?;

        customMessageJson = if(customData!=null&& customData.isNotEmpty()){
            JSONObject(customData)
        }else{
            JSONObject("""{}""")
        }

        val custom  = CustomMessage(map["receiverUid"] as String ,map["type"] as String,map["receiverType"] as String ,customMessageJson );
        custom.id = map["id"] as Int
        custom.receiverUid = map["receiverUid"] as String
        custom.type = map["type"] as String
        custom.receiverType = map["receiverType"] as String
        custom.parentMessageId = map["parentMessageId"] as Int
        custom.category = map["category"] as String
        custom.sender = toUser(map["sender"] as HashMap<String, Any?>) as User
        if(custom.receiverType=="group"){
            custom.receiver = toGroup(map["receiver"] as HashMap<String, Any?>) as Group
        }else{
            custom.receiver = toUser(map["receiver"] as HashMap<String, Any?>) as User
        }
        if(map["tags"]==null)custom.tags = emptyList()
        else  custom.tags = map["tags"]as MutableList<String>

        val metadata = map["metadata"] as HashMap<String, Any?>?;
        if(metadata!=null&& metadata.isNotEmpty()){
            custom.metadata = JSONObject(metadata)
        }
        return custom;
    }

    private fun toUser(map : HashMap<String, Any?>):User{
        val userObj:User  = User();
        userObj.uid = map["uid"] as String
        userObj.name = map["name"] as String
        userObj.status = map["status"] as String?
        return userObj;
    }

    private fun toGroup(map : HashMap<String, Any?>):Group{
        val groupObj:Group  = Group()
        groupObj.guid = map["guid"] as String
        groupObj.name = map["name"] as String
        return groupObj
    }

    private fun toGroupMember(map : HashMap<String, Any?>):GroupMember{

        val groupMember:GroupMember

        if(map["scope"] as String == "admin") groupMember  = GroupMember(map["uid"] as String,CometChatConstants.SCOPE_ADMIN)

        else if(map["scope"] as String == "moderator") groupMember  = GroupMember(map["uid"] as String,CometChatConstants.SCOPE_MODERATOR)

        else groupMember  = GroupMember(map["uid"] as String,CometChatConstants.SCOPE_PARTICIPANT);

        return groupMember
    }


    private fun getLastDeliveredMessageId(call: MethodCall, result: Result) {

        val lasteDeliveredMessageId:Int = CometChat.getLastDeliveredMessageId();
        result.success(lasteDeliveredMessageId);
    }

    //Call-SDK-changes
    private fun getUserAuthToken(result: Result) {
        val token: String? = CometChat.getUserAuthToken()
        if (token.isNullOrBlank()){
            result.error("ERROR", "User auth token is null", "User is not logged in.")
        }else{
            result.success(token)
        }
    }

    private fun initiateCall(args: MethodCall, result: Result) {
        val receiverUid = args.argument<String>("receiverUid")
        val receiverType = args.argument<String>("receiverType")
        val callType = args.argument<String>("callType")
        val call = Call(receiverUid!!, receiverType, callType)
        CometChat.initiateCall(call, object : CallbackListener<Call>() {
            override fun onSuccess(call: Call) {
                result.success(callToMap(call))
            }

            override fun onError(e: CometChatException) {
                result.error(e.code, e.message, e.details)
            }
        })
    }

    private fun acceptCall(args: MethodCall, result: Result) {
        val sessionID = args.argument<String>("sessionID")
        CometChat.acceptCall(sessionID!!, object : CallbackListener<Call>() {
            override fun onSuccess(call: Call) {
                result.success(callToMap(call))
            }

            override fun onError(e: CometChatException) {
                result.error(e.code, e.message, e.details)
            }
        })
    }

    private fun rejectCall(args: MethodCall, result: Result) {
        val sessionID = args.argument<String>("sessionID")
        val status = args.argument<String>("status")
        CometChat.rejectCall(sessionID!!, status!!, object : CallbackListener<Call>() {
            override fun onSuccess(call: Call) {
                result.success(callToMap(call))
            }

            override fun onError(e: CometChatException) {
                result.error(e.code, e.message, e.details)
            }
        })
    }
    private fun endCall(args: MethodCall, result: Result) {
        val sessionID = args.argument<String>("sessionID")
        CometChat.endCall(sessionID!!, object : CallbackListener<Call>() {
            override fun onSuccess(call: Call) {
                result.success(callToMap(call))
            }

            override fun onError(e: CometChatException) {
                result.error(e.code, e.message, e.details)
            }
        })
    }

    private fun getActiveCall(result: Result){
        try {
            val activeCallObj = CometChat.getActiveCall()
            if(activeCallObj != null){
                result.success(callToMap(activeCallObj))
            }else{
                result.success(null)
            }
        }catch (e: Exception){
            result.error("ERROR", e.message, e.toString())
        }
    }

    private fun addCallListener(){
        CometChat.addCallListener(listenerID, object :CometChat.CallListener(){
            override fun onOutgoingCallAccepted(p0: Call?) {
                val responseMap :HashMap<String,Any?> = HashMap()
                responseMap["call"] = callToMap(p0!!)
                responseMap["methodName"] = "onOutgoingCallAccepted"
                messageStreamSink?.success(responseMap)
            }
            override fun onIncomingCallReceived(p0: Call?) {
                val responseMap :HashMap<String,Any?> = HashMap()
                responseMap["call"] = callToMap(p0!!)
                responseMap["methodName"] = "onIncomingCallReceived"
                messageStreamSink?.success(responseMap)
            }
            override fun onIncomingCallCancelled(p0: Call?) {
                val responseMap :HashMap<String,Any?> = HashMap()
                responseMap["call"] = callToMap(p0!!)
                responseMap["methodName"] = "onIncomingCallCancelled"
                messageStreamSink?.success(responseMap)
            }
            override fun onOutgoingCallRejected(p0: Call?) {
                val responseMap :HashMap<String,Any?> = HashMap()
                responseMap["call"] = callToMap(p0!!)
                responseMap["methodName"] = "onOutgoingCallRejected"
                messageStreamSink?.success(responseMap)
            }
            override fun onCallEndedMessageReceived(p0: Call?) {
                val responseMap :HashMap<String,Any?> = HashMap()
                responseMap["call"] = callToMap(p0!!)
                responseMap["methodName"] = "onCallEndedMessageReceived"
                messageStreamSink?.success(responseMap)
            }
        })
    }

    private fun callToMap(call: Call): HashMap<String, Serializable?> {
        val metaData: String? = if(call.metadata != null){
            call.metadata.toString()
        }else{
            null
        }
        return hashMapOf(
            "sessionId" to call.sessionId,
            "callStatus" to call.callStatus,
            "action" to call.action,
            "rawData" to call.rawData,
            "initiatedAt" to call.initiatedAt,
            "joinedAt" to call.joinedAt,
            "callInitiator" to when (call.callInitiator) {
                is User -> getUserMap(call.callInitiator as User)
                is Group -> getGroupMap(call.callInitiator as Group)
                else -> null
            },
            "callReceiver" to when (call.callReceiver) {
                is User -> getUserMap(call.callReceiver as User)
                is Group -> getGroupMap(call.callReceiver as Group)
                else -> null
            },
            "id" to call.id,
            "muid" to call.muid,
            "sender" to when (call.sender) {
                is User -> getUserMap(call.sender as User)
                is Group -> getGroupMap(call.sender as Group)
                else -> null
            },
            "receiver" to when (call.receiver) {
                is User -> getUserMap(call.receiver as User)
                is Group -> getGroupMap(call.receiver as Group)
                else -> null
            },
            "receiverUid" to call.receiverUid,
            "type" to call.type,
            "receiverType" to call.receiverType,
            "category" to call.category,
            "sentAt" to call.sentAt,
            "deliveredAt" to call.deliveredAt,
            "readAt" to call.readAt,
            "metadata" to metaData,
            "readByMeAt" to call.readByMeAt,
            "deliveredToMeAt" to call.deliveredToMeAt,
            "deletedAt" to call.deletedAt,
            "editedAt" to call.editedAt,
            "deletedBy" to call.deletedBy,
            "editedBy" to call.editedBy,
            "updatedAt" to call.updatedAt,
            "conversationId" to call.conversationId,
            "parentMessageId" to call.parentMessageId,
            "replyCount" to call.replyCount
        )
    }


    private fun isExtensionEnabled(args: MethodCall,result: Result){
        val extensionId = args.argument<String>("extensionId")
        CometChat.isExtensionEnabled(extensionId!!,
            object : CallbackListener<Boolean>() {
            override fun onSuccess(res: Boolean) {
                result.success(res)
            }

            override fun onError(e: CometChatException) {
                result.error(e.code, e.message, e.details)
            }
        })
    }

    private fun setSource(args: MethodCall, result: Result){
        val resource = args.argument<String>("resource")
        val platform = args.argument<String>("platform")
        val language = args.argument<String>("language")
        CometChat.setSource(resource!!,platform!!,language!!)
        result.success(true)
    }

    private fun setPlatformParams(args: MethodCall, result: Result){
        val platform: String =  args.argument("platform") ?: ""
        val sdkVersion: String =  args.argument("sdkVersion") ?: ""
        CometChat.setPlatformParams(platform, sdkVersion)
        result.success(true)
    }
}

