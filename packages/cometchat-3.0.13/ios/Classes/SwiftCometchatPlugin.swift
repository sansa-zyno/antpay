import Flutter
import UIKit
import CometChatPro

public class SwiftCometchatPlugin: NSObject, FlutterPlugin {
    
    var sink: FlutterEventSink?
    //Initialize over here in order to get callback from Cometchat
    //var messagesRequest = MessagesRequest.MessageRequestBuilder().set(limit: 50).build(); // for messages obj
    
    //var messagesRequest : MessagesRequest? = nil
    
    //var convRequest : ConversationRequest?=nil //for conversation obj
    
    var groupInstance = Group(guid: "", name: "", groupType: .public, password: "");
    
    //var groupMembersRequest:GroupMembersRequest?=nil
    
    //var groupsRequest  : GroupsRequest?=nil
    
    var mediaMessage = MediaMessage(receiverUid: "", fileurl:"", messageType: .image, receiverType: .user);
    
    //var blockedUserRequest = BlockedUserRequest.BlockedUserRequestBuilder().build();
    
    //var usersRequest : UsersRequest?=nil
    
    //var bannedGroupMembersRequest  : BannedGroupMembersRequest?=nil
    
    var messageRequestDict: [String: MessagesRequest] = [:]
    var conversationRequestDict: [String: ConversationRequest] = [:]
    var groupMemberRequestDict: [String: GroupMembersRequest] = [:]
    var groupRequestDict: [String: GroupsRequest] = [:]
    var blockedUserRequestDict: [String: BlockedUserRequest] = [:]
    var bannedGroupMemberRequestDict: [String: BannedGroupMembersRequest] = [:]
    var userRequestDict: [String: UsersRequest] = [:]
    
    var counter : Int = 0
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftCometchatPlugin()
        
        let channel = FlutterMethodChannel(name: "cometchat", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let channelName = "cometchat_message_stream"
        let eventChannel = FlutterEventChannel(name: channelName, binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        
        CometChat.messagedelegate = instance
        CometChat.userdelegate = instance
        CometChat.groupdelegate  = instance
        CometChat.logindelegate = instance
        CometChat.connectiondelegate = instance
        CometChat.calldelegate = instance //calling-changes
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //    result("iOS " + UIDevice.current.systemVersion)
        
        DispatchQueue.main.async { [weak self] in
            let args = call.arguments as? [String: Any] ?? [String: Any]();
            switch call.method {
            case "init":
                self?.initializeCometChat(args: args, result:result)
            case "createUser":
                self?.createUser(args: args, result:result)
            case "loginWithApiKey":
                self?.loginWithApiKey(args: args, result:result)
            case "loginWithAuthToken":
                self?.loginWithAuthToken(args: args, result:result)
            case "logout":
                self?.logout(result:result)
            case "getLoggedInUser":
                self?.getLoggedInUser(result: result)
            case "getUser":
                self?.getUser(args: args, result: result)
            case "sendMessage":
                self?.sendMessage(args: args, result:result)
            case "sendMediaMessage":
                self?.sendMediaMessage(args: args, result:result)
//            case "fetchPreviousMessages":
//                self?.fetchPreviousMessages(args: args, result:result)
            case "fetchPreviousMessages":
                self?.fetchPreviousMessages(args: args, result:result)
            case "fetchNextConversations":
                self?.fetchNextConversations(args: args, result:result)
            case "deleteMessage":
                self?.deleteMessage(args: args, result:result)
            case "createGroup":
                self?.createGroup(args: args, result:result)
            case "joinGroup":
                self?.joinGroup(args: args, result:result)
            case "leaveGroup":
                self?.leaveGroup(args: args, result:result)
            case "deleteGroup":
                self?.deleteGroup(args: args, result:result)
            case "fetchNextGroupMembers":
                self?.fetchNextGroupMembers(args: args, result:result)
            case "fetchNextGroups":
                self?.fetchNextGroups(args: args, result:result)
            case "registerTokenForPushNotification":
                self?.registerTokenForPushNotification(args: args, result:result)
            case "getUnreadMessageCount":
                self?.getUnreadMessageCount(result:result)
            case "markAsRead":
                self?.markAsRead(args: args, result:result)
            case "callExtension":
                self?.callExtension(args: args, result:result)
            case "blockUsers":
                self?.blockUsers(args: args, result:result)
            case "unblockUsers":
                self?.unblockUsers(args: args, result:result)
            case "fetchBlockedUsers":
                self?.fetchBlockedUsers(args: args,result:result)
            case "fetchUsers":
                self?.fetchUsers(args: args, result:result)
            case "startTyping":
                self?.startTyping(args: args, result:result)
            case "endTyping":
                self?.endTyping(args: args, result:result)
            case "getConversation":
                self?.getConversation(args: args, result:result)
            case "fetchNextMessages":
                self?.fetchNextMessages(args: args, result:result)
            case "getUnreadMessageCountForGroup":
                self?.getUnreadMessageCountForGroup(args: args, result:result)
            case "getUnreadMessageCountForAllUsers":
                self?.getUnreadMessageCountForAllUsers(args: args, result:result)
            case "getUnreadMessageCountForAllGroups":
                self?.getUnreadMessageCountForAllGroups(args: args, result:result)
            case "markAsDelivered":
                self?.markAsDelivered(args: args, result:result)
            case "getMessageReceipts":
                self?.getMessageReceipts(args: args, result:result)
            case "editMessage":
                self?.editMessage(args: args, result:result)
            case "deleteConversation":
                self?.deleteConversation(args: args, result:result)
            case "sendTransientMessage":
                self?.sendTransientMessage(args: args, result:result)
            case "getOnlineUserCount":
                self?.getOnlineUserCount(args: args, result:result)
            case "updateUser":
                self?.updateUser(args: args, result:result)
            case "updateCurrentUserDetails":
                self?.updateCurrentUserDetails(args: args, result:result)
            case "getGroup":
                self?.getGroup(args: args, result:result)
            case "getOnlineGroupMemberCount":
                self?.getOnlineGroupMemberCount(args: args, result:result)
            case "updateGroup":
                self?.updateGroup(args: args, result:result)
            case "addMembersToGroup":
                self?.addMembersToGroup(args: args, result:result)
            case "kickGroupMember":
                self?.kickGroupMember(args: args, result:result)
            case "banGroupMember":
                self?.banGroupMember(args: args, result:result)
            case "unbanGroupMember":
                self?.unbanGroupMember(args: args, result:result)
            case "updateGroupMemberScope":
                self?.updateGroupMemberScope(args: args, result:result)
            case "transferGroupOwnership":
                self?.transferGroupOwnership(args: args, result:result)
            case "fetchBlockedGroupMembers":
                self?.fetchBlockedGroupMembers(args: args, result:result)
            case "tagConversation":
                self?.tagConversation(args: args, result:result)
            case "connect":
                self?.connect(result:result)
            case "disconnect":
                self?.disconnect(result:result)
            case "getLastDeliveredMessageId":
                self?.getLastDeliveredMessageId(args: args,result:result)
            case "getConnectionStatus":
                self?.getConnectionStatus(result:result)
            case "sendCustomMessage":
                self?.sendCustomMessage(args: args, result:result)
            case "getUserAuthToken":
                self?.getUserAuthToken(result: result)
            case "initiateCall":
                self?.initiateCall(args: args, result: result)
            case "acceptCall":
                self?.acceptCall(args: args, result: result)
            case "rejectCall":
                self?.rejectCall(args: args, result: result)
            case "endCall":
                self?.endCall(args: args, result: result)
            case "getActiveCall":
                self?.getActiveCall(result: result)
            case "isExtensionEnabled":
                self?.isExtensionEnabled(args: args, result: result)
            case "setSource":
                  self?.setSource(args: args, result: result)
            case "setPlatformParams":
                  self?.setPlatformParams(args: args, result: result)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    
    private func initializeCometChat(args: [String: Any], result: @escaping FlutterResult){
        let appId = args["appId"] as! String
        let region = args["region"] as! String
        let subscriptionType = args["subscriptionType"] as! String ?? "allUsers"
        let roles = args["roles"] as? [String] ?? []
        let autoEstablishSocketConnection = args["autoEstablishSocketConnection"] as? Bool ?? true
        let platform = args["platform"] as! String ?? "flutter"
        let sdkVersion = args["sdkVersion"] as! String ?? ""
        let adminHost = args["adminHost"] as? String ?? ""
        let clientHost = args["clientHost"] as? String ?? ""
        
        var builder = AppSettings.AppSettingsBuilder()
        if (subscriptionType != nil) {
            switch(subscriptionType) {
               case "none"  :
                print("none")
                break;
               case "allUsers"  :
                print("allUsers")
                builder = builder.subscribePresenceForAllUsers()
                break;
               case "roles"  :
                print("allUsers")
                builder = builder.subcribePresenceForRoles(roles: roles)
                break;
               case "roles"  :
                 builder = builder.subcribePresenceForRoles(roles: roles)
                 break;
               default :
                builder = builder.subscribePresenceForAllUsers()
            }
        }
        
        builder = builder.setRegion(region: region)
        builder = builder.autoEstablishSocketConnection(autoEstablishSocketConnection)
        if clientHost != "" {
            builder = builder.overrideClientHost(clientHost)
        }
        if adminHost != "" {
            builder = builder.overrideAdminHost(adminHost)
        }
        
        var initializationNeeded : Bool = true
        
        //let mySettings = AppSettings.AppSettingsBuilder().subscribePresenceForAllUsers().setRegion(region: region).build()
        print("CometChat Pro SDK tried")
        let mySettings = builder.build()
        CometChat.init(appId: appId ,appSettings: mySettings,onSuccess: { (isSuccess: Bool) in
            print("CometChat Pro SDK initialize successfully. \(isSuccess)")
            initializationNeeded = false
            CometChat.setPlatformParams(platform: platform, sdkVersion: sdkVersion)
            result(String(isSuccess))
        }) { (error) in
            print("CometChat Pro SDK failed initialize with error: \(error.errorDescription)")
            initializationNeeded = false
            result(FlutterError(code: error.errorCode, message: error.errorDescription, details: error.debugDescription))
        }
    }
    
    private func createUser(args: [String: Any], result: @escaping FlutterResult){
        let apiKey = args["apiKey"] as! String
        let uid = args["uid"] as? String ?? ""
        let name = args["name"] as? String ?? ""
        let avatar = args["avatar"] as? String
        let link = args["link"] as? String
        let tags = args["tags"] as? [String]
        let metadata = args["metadata"] as? String
        let statusMessage = args["statusMessage"] as? String
        let role = args["role"] as? String
        let blockedByMe = args["blockedByMe"] as? Bool
        let deactivatedAt = args["deactivatedAt"] as? Double
        let hasBlockedMe = args["hasBlockedMe"] as? Bool
        let lastActiveAt = args["lastActiveAt"] as? Double
        let status = args["status"] as? String
        
        let newUser : User = User(uid: uid, name: name)
        
        if let avatar = avatar {
            newUser.avatar = avatar
        }
        
        if let link = link {
            newUser.link = link
        }
        
        if let metadata = metadata {
            newUser.metadata = convertToDictionary(text: metadata)
        }
        
        if let tags = tags {
            newUser.tags = tags
        }
        
        if let statusMessage = statusMessage {
            newUser.statusMessage = statusMessage
        }
        
        if let role = role {
            newUser.role = role
        }
        
        if let blockedByMe = blockedByMe {
            newUser.blockedByMe = blockedByMe
        }
        if let hasBlockedMe = hasBlockedMe {
            newUser.hasBlockedMe = hasBlockedMe
        }
        if let lastActiveAt = lastActiveAt {
            newUser.lastActiveAt = lastActiveAt
        }
        if let status = status {
            switch status {
            case "online":
                newUser.status = CometChat.UserStatus.online
            case "offline":
                newUser.status = CometChat.UserStatus.offline
            default:
                newUser.status = CometChat.UserStatus.offline
            }
        }
        
        
        CometChat.createUser(user: newUser, apiKey: apiKey, onSuccess: { (user) in
            print("User created successfully. \(user.stringValue())")
            result(self.getUserMap(user: user))
        }) { (error) in
            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "",
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func loginWithApiKey(args: [String: Any], result: @escaping FlutterResult){
        let uid = args["uid"] as! String
        let apiKey = args["apiKey"] as! String
        
        CometChat.login(UID: uid, apiKey: apiKey) { (user) in
            print("User logged in successfully. \(user.stringValue())")
            result(self.getUserMap(user: user))
        } onError: { (error) in
            print("The error is \(String(describing: error.description))")
            result(FlutterError(code: error.errorCode,
                                message: error.errorDescription, details: error.debugDescription))
        }
    }
    
    private func loginWithAuthToken(args: [String: Any], result: @escaping FlutterResult){
        let authToken = args["authToken"] as! String
        
        CometChat.login(authToken: authToken) { (user) in
            print("User logged in successfully. \(user.stringValue())")
            result(self.getUserMap(user: user))
        } onError: { (error) in
            print("The error is \(String(describing: error.description))")
            result(FlutterError(code: error.errorCode,
                                message: error.errorDescription, details: error.debugDescription))
        }
    }
    
    private func logout(result: @escaping FlutterResult){
        CometChat.logout { (message) in
            result(String(message))
        } onError: { (error) in
            result(FlutterError(code: error.errorCode, message: error.errorDescription, details: error.debugDescription))
        }
    }
    
    private func getLoggedInUser(result: @escaping FlutterResult){
        let user = CometChat.getLoggedInUser()
        print("Current User. \(user?.stringValue() ?? "Null")")
        result(getUserMap(user: user))
    }
    
    private func getUser(args: [String: Any], result: @escaping FlutterResult){
        let uid = args["uid"] as? String ?? ""
        
        CometChat.getUser(UID: uid) { (user) in
            result(self.getUserMap(user: user));
        } onError: { (error) in
            print("Error getting user." )
            result(FlutterError(code: error?.errorCode ?? "",
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    private func sendMessage(args: [String: Any], result: @escaping FlutterResult){
        let receiverID = args["receiverId"] as? String ?? ""
        let messageText = args["messageText"] as? String ?? ""
        let receiver = args["receiverType"] as? String ?? ""
        let parentMessageId = args["parentMessageId"] as? Int ?? 0
        let tags = args["tags"] as? [String] ?? []
        //let metadata = args["metadata"] as? Dictionary<String,Any> ?? [:]
        let metadata = args["metadata"] as? String ?? ""
        let muid = args["muid"] as? String ?? ""
    
        
                
        let receiverType : CometChat.ReceiverType
        switch receiver {
        case "user":
            receiverType =  CometChat.ReceiverType.user
        default:
            receiverType =   CometChat.ReceiverType.group
        }
        
        let textMessage = TextMessage(receiverUid: receiverID , text: messageText, receiverType: receiverType)
        
        textMessage.muid = muid

        if parentMessageId > 0 {
            textMessage.parentMessageId = parentMessageId
        }
        
        if (!tags.isEmpty){
            textMessage.tags = tags
        }
        
        if (!metadata.isEmpty){
            textMessage.metaData = convertToDictionary(text: metadata)
        }
        
        CometChat.sendTextMessage(message: textMessage, onSuccess: { (message) in
            print("TextMessage sent successfully. \(message.metaData)}")
            let user = CometChat.getLoggedInUser();
            message.sender = user
            result(self.getMessageMap(message: message))
        }) { (error) in
            print("TextMessage sending failed with error: " + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "",
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    

    
    private func sendMediaMessage(args: [String: Any], result: @escaping FlutterResult){
    
        let receiverid = args["receiverId"] as? String ?? ""
        let receiver = args["receiverType"] as? String ?? ""
        let msgType = args["messageType"] as? String ?? ""
        
        var filePath:String? = args["filePath"] as? String ?? ""
        let caption = args["caption"] as? String ?? ""
        let parentMessageId = args["parentMessageId"] as? Int ?? 0
        let tags = args["tags"] as? [String] ?? []
       
        let hasAttachment = args["hasAttachment"] as? Bool ?? false
        let attachmentFileName = args["attachmentFileName"] as? String ?? ""
        let attchemntFileExtension = args["attchemntFileExtension"] as? String ?? ""
        let attachmentFileUrl = args["attachmentFileUrl"] as? String ?? ""
        let attachmentMimeType = args["attachmentMimeType"] as? String ?? ""
        let metadata = args["metadata"] as? String ?? ""
        let muid = args["muid"] as? String ?? ""
        
        let messageType : CometChat.MessageType
        switch msgType {
            case "image":
                messageType = .image
            case "video":
                messageType = .video
            case "audio":
                messageType = .audio
            default:
                messageType = .file
        }
        
        let receiverType : CometChat.ReceiverType
        switch receiver {
            case "user":
                receiverType =  CometChat.ReceiverType.user
            default:
                receiverType =   CometChat.ReceiverType.group
        }
        
        let mediaMessage = MediaMessage(receiverUid: receiverid, fileurl: filePath!, messageType: messageType, receiverType: receiverType)
        
        if(hasAttachment){
            mediaMessage.attachment = Attachment(fileName: attachmentFileName, fileExtension: attchemntFileExtension, fileMimeType: attachmentMimeType, fileUrl: attachmentFileUrl);
        }
        mediaMessage.muid = muid
        
        if (caption != ""){
            mediaMessage.caption = caption
        }
        
        if (parentMessageId > 0) {
            mediaMessage.parentMessageId = parentMessageId
        }
        
        if(!tags.isEmpty){
            mediaMessage.tags = tags
        }
        
        if (!metadata.isEmpty){
            mediaMessage.metaData = convertToDictionary(text: metadata)
        }
        
        CometChat.sendMediaMessage(message: mediaMessage, onSuccess: { (response) in
            let user = CometChat.getLoggedInUser();
            response.sender = user
            result(self.getMessageMap(message: response))
        }) { (error) in
            result(FlutterError(code: error?.errorCode ?? "",
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func fetchNextConversations(args: [String: Any], result: @escaping FlutterResult){
        
        let limit = args["limit"] as? Int ?? 50
        let typeValue = args["type"] as? String
        let initializeBuilder = args["init"] as? Bool ?? true
        let withUserAndGroupTags = args["withUserAndGroupTags"] as? Bool ?? true
        let withTags = args["withTags"] as? Bool ?? true
        let tags = args["tags"] as? [String] ?? []
        var key = args["key"] as? String
        var convRequest:ConversationRequest;
        
        
        if( key == nil || conversationRequestDict[key!] == nil ){
            convRequest = ConversationRequest.ConversationRequestBuilder(limit: 20).setConversationType(conversationType: .user).build()
            var builder = ConversationRequest.ConversationRequestBuilder(limit: limit)
            
            if let typeValue = typeValue {
                if typeValue == "user" {
                    builder = builder.setConversationType(conversationType: .user)
                } else if typeValue == "group" {
                    builder = builder.setConversationType(conversationType: .group)
                }
            }
            if(withUserAndGroupTags){
                builder.withUserAndGroupTags(withUserAndGroupTags)
            }
            if(withTags){
                builder = builder.withTags(true)
            }
            if(!tags.isEmpty){
                builder = builder.setTags(tags)
            }
           
        convRequest = builder.build()
            
            if(key == nil){
                counter+=1
                key = String(counter)
            }
            
            
            conversationRequestDict[key!] = convRequest
            
        }else{
            convRequest = conversationRequestDict[key!]!
        }
            
        
        
        convRequest.fetchNext(onSuccess: { (conversationList) in
            let list = conversationList.map { (e) -> [String : Any]? in
                return self.getConversationMap(conversation: e)
            }
            var rectDict: [String: Any] = [:]
            rectDict["key"] = key
            rectDict["list"] = list
            result(rectDict)
            print("list count ",list.count)
        }) { (exception) in
            print("here exception \(String(describing: exception?.errorDescription))")
            result(FlutterError(code: exception?.errorCode ?? "",
                                message: exception?.errorDescription, details: exception?.debugDescription))
        }
        
        //        If we Want to fetch by Messages
        //        self.messagesRequest = MessagesRequest.MessageRequestBuilder().set(limit: limit).build();
        //        self.messagesRequest.fetchNext(onSuccess: { (response) in
        //            print("Message count is ,", response?.count ?? 0)
        //
        //            if let messages = response{
        //                let conversationList = messages.map { (eachMsg) -> [String : Any]? in
        //                    if let conversation = CometChat.getConversationFromMessage(eachMsg){
        //                        return self.getConversationMap(conversation: conversation)
        //                    }
        //                    return [:]
        //                }
        //                result(conversationList)
        //            }
        //
        //        }) { (error) in
        //
        //          print("Message receiving failed with error: " + error!.errorDescription);
        //          print("here exception \(String(describing: error?.errorDescription))")
        //          result(FlutterError(code: error?.errorCode ?? "",
        //                                message: error?.errorDescription, details: error?.debugDescription))
        //        }
    }
 
    
    
    private func fetchPreviousMessages(args: [String: Any], result: @escaping FlutterResult){
        let limit = args["limit"] as? Int ?? 50
        let uid = args["uid"] as? String ?? ""
        let guid = args["guid"] as? String ?? ""
        let searchTerm = args["searchTerm"] as? String ?? ""
        let messageId = args["messageId"] as? Int ?? 0
        
        let timestamp = args["timestamp"] as? Int ?? 0
        let unread = args["unread"] as? Bool ?? false
        let hideblockedUsers = args["hideblockedUsers"] as? Bool ?? false
        let updateAfter = args["updateAfter"] as? Int ?? 0
        let updatesOnly = args["updatesOnly"] as? Bool ?? false
        let categories = args["categories"] as? [String] ?? []
        let types = args["types"] as? [String] ?? []
        let parentMessageId = args["parentMessageId"] as? Int ?? 0
        let hideReplies = args["hideReplies"] as? Bool ?? false
        let hideDeletedMessages = args["hideDeletedMessages"] as? Bool ?? false
        let initializeBuilder = args["init"] as? Bool ?? true
        let withTags = args["withTags"] as? Bool ?? true
        let tags = args["tags"] as? [String] ?? []
        var key = args["key"] as? String
        var _messagesRequest:MessagesRequest;
    
        
        if( key == nil || messageRequestDict[key!] == nil ){
            _messagesRequest = MessagesRequest.MessageRequestBuilder().set(limit: 50).build()
            var builder = MessagesRequest.MessageRequestBuilder()

            if (limit > 0) {
                builder = builder.set(limit: limit)
            }
            
            
            if (uid != "") {
                builder = builder.set(uid: uid)
            } else if (guid != "") {
                builder = builder.set(guid: guid)
            }
            if (searchTerm != ""){
                builder = builder.set(searchKeyword: searchTerm)
            }
            if (messageId > 0){
                builder = builder.set(messageID: messageId)
            }
            
            
            if (timestamp > 0) {
                builder = builder.set(timeStamp: timestamp)
            }
            if (unread) {
                builder = builder.set(unread:unread)
            }
            if (hideblockedUsers) {
                builder = builder.hideMessagesFromBlockedUsers(hideblockedUsers)
            }
            if (updateAfter > 0) {
                builder = builder.setUpdatedAfter(timeStamp: updateAfter)
            }
            if (updatesOnly) {
                builder = builder.updatesOnly(onlyUpdates: updatesOnly)
            }
            if (!categories.isEmpty){
                builder = builder.set(categories: categories)
            }
            if (!types.isEmpty){
                builder = builder.set(types: types)
            }
            if (parentMessageId > 0) {
                builder = builder.setParentMessageId(parentMessageId: parentMessageId)
            }
            if (hideReplies) {
                builder = builder.hideReplies(hide: hideReplies)
            }
            if (hideDeletedMessages) {
                builder = builder.hideDeletedMessages(hide: hideDeletedMessages)
            }
            if(withTags){
                builder = builder.withTags(withTags)
            }
            if(!tags.isEmpty){
                builder = builder.setTags(tags)
            }
            
            
            builder = builder.set(timeStamp: timestamp)
            
            _messagesRequest = builder.build()
            
            if(key == nil){
                counter+=1
                key = String(counter)
            }
            
            
            messageRequestDict[key!] = _messagesRequest
            
        }else{
            _messagesRequest = messageRequestDict[key!]!
        }
        
        
        _messagesRequest.fetchPrevious(onSuccess: { (response) in
            if let messages = response{
                let messageList = messages.map { (eachMsg) -> [String : Any]? in
                    return self.getMessageMap(message: eachMsg)
                    
                }
                
                var rectDict: [String: Any] = [:]
                rectDict["key"] = key
                rectDict["list"] = messageList
                result(rectDict)
            }
        }) { (error) in
            print("Message receiving failed with error: " + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    
   
    private func deleteMessage(args: [String: Any], result: @escaping FlutterResult){
        let msgID = args["messageId"] as? Int ?? 1
        print("received message id  \(msgID)")
        CometChat.deleteMessage(msgID , onSuccess: { (baseMessage) in
          
            result(self.getMessageMap(message: baseMessage))
        }) { (error) in
            //print("delete message failed with error: \(error.errorDescription)")
            result(FlutterError(code: error.errorCode ,
                                message: error.errorDescription, details: error.debugDescription))
        }
        
    }
    private func createGroup(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        let name = args["name"] as? String ?? ""
        let icon = args["icon"] as? String
        let description = args["description"] as? String
        
        let membersCount = args["membersCount"] as? Int ?? 0
        let metadata = args["metadata"] as? String
        let joinedAt = args["joinedAt"] as? Int
        let hasJoined = args["hasJoined"] as? Bool
        
        let createdAt = args["createdAt"] as? Int
        let owner = args["owner"] as? String
        let updatedAt = args["updatedAt"] as? Int
        let tags = args["tags"] as? [String]
        
        let grpType = args["type"] as? String ?? ""
        let groupType : CometChat.groupType = grpType == "private" ? .private : grpType == "public" ? .public : .password
        
        let scope = args["scope"] as? String ?? ""
        let groupScope : CometChat.GroupMemberScopeType = scope == "participant" ? .participant : scope == "moderator" ? .moderator : .admin
        
        
        
        let password = args["password"] as? String ?? nil //mandatory in case of password protected group type
        
    
        let newGroup : Group = Group(guid: guid, name: name, groupType: groupType, password: password)
        
        
        if let icon = icon {
            newGroup.icon = icon
        }
        
        if let description = description {
            newGroup.groupDescription = description
        }
    
        
        if(membersCount>0){
            newGroup.membersCount = membersCount
        }
        
        if let metadata = metadata {
            newGroup.metadata = convertToDictionary(text: metadata)
        }
        
        if let joinedAt = joinedAt {
            newGroup.joinedAt = joinedAt
        }
        
        if let hasJoined = hasJoined {
            newGroup.hasJoined = hasJoined
        }
        
        if let createdAt = createdAt {
            newGroup.createdAt = createdAt
        }
        
        if let owner = owner {
            newGroup.owner = owner
        }
        
        if let updatedAt = updatedAt {
            newGroup.updatedAt = updatedAt
        }
        
        if let tags = tags {
            newGroup.tags = tags
        }
        
        newGroup.scope = groupScope
       
        CometChat.createGroup(group: newGroup, onSuccess: { (group) in
            
            print("Group created successfully. " + group.stringValue())
            result(self.getGroupMap(group: group))
            
        }) { (error) in
            
            print("Group creation failed with error:" + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    private func joinGroup(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        let grpType = args["groupType"] as? String ?? ""
        let groupType : CometChat.groupType = grpType == "private" ? .private : grpType == "public" ? .public : .password
        let password = args["password"] as? String ?? nil //mandatory in case of password protected group type
        
        CometChat.joinGroup(GUID: guid, groupType: groupType, password: password, onSuccess: { (group) in
            
            print("Group joined successfully. " + group.stringValue())
            result(self.getGroupMap(group: group))
            
        }) { (error) in
            
            print("Group joining failed with error:" + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    private func leaveGroup(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        CometChat.leaveGroup(GUID: guid, onSuccess: { (response) in
            
            print("Left group successfully.")
            result(response)
            
        }) { (error) in
            
            print("Group leaving failed with error:" + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    private func deleteGroup(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        CometChat.deleteGroup(GUID: guid, onSuccess: { (response) in
            
            print("Group deleted successfully.")
            result(response)
            
        }) { (error) in
            
            print("Group delete failed with error: " + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    
    private func fetchNextGroupMembers(args: [String: Any], result: @escaping FlutterResult){
        let limit = args["limit"] as? Int ?? 50
        let guid = args["guid"] as? String ?? ""
        let keyword = args["keyword"] as? String ?? ""
        let scopes = args["scopes"] as? [String] ?? []
        var key = args["key"] as? String
        var groupMembersRequest:GroupMembersRequest;
        if( key == nil || groupMemberRequestDict[key!] == nil ){
            groupMembersRequest = GroupMembersRequest.GroupMembersRequestBuilder(guid: "").set(limit: 50).build();
            var builder = GroupMembersRequest.GroupMembersRequestBuilder(guid: guid)
            if (limit > 0) {
                builder = builder.set(limit: limit)
            }
            if (keyword != ""){
                builder = builder.set(searchKeyword: keyword)
            }
            if(!scopes.isEmpty){
                builder = builder.set(scopes: scopes)
            }
            groupMembersRequest = builder.build();
            if(key == nil){
                counter+=1
                key = String(counter)
            }
            groupMemberRequestDict[key!] = groupMembersRequest
        }else{
            groupMembersRequest = groupMemberRequestDict[key!]!
        }
        groupMembersRequest.fetchNext(onSuccess: { (groupMembers) in
            var resultDict: [String: Any] = [:]
            resultDict["key"] = key
            resultDict["list"] = self.getGroupMemberMap(members : groupMembers)
            result(resultDict)
        }) { (error) in
            result(FlutterError(code: error?.errorCode ?? "" , message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func fetchNextGroups(args: [String: Any], result: @escaping FlutterResult){
        
        let limit = args["limit"] as? Int ?? 50
        let searchTerm = args["searchTerm"] as? String ?? ""
        let joinedOnly = args["joinedOnly"] as? Bool ?? true
        let tags = args["tags"] as? [String] ?? []
        let withTags = args["withTags"] as? Bool ?? false
        
        var key = args["key"] as? String
        var groupsRequest:GroupsRequest;
    
        
        if( key == nil || groupRequestDict[key!] == nil ){
            groupsRequest  = GroupsRequest.GroupsRequestBuilder(limit: 50).build();
            var builder = GroupsRequest.GroupsRequestBuilder(limit: limit)
            
            if (searchTerm != "") {
                builder = builder.set(searchKeyword:searchTerm)
            }
            
            if(joinedOnly){
                builder = builder.set(joinedOnly: joinedOnly)
            }
            
            if (!tags.isEmpty){
                builder = builder.set(tags: tags)
            }
            if (withTags){
                builder = builder.withTags(withTags)
            }
            
            groupsRequest  = builder.build();
            if(key == nil){
                counter+=1
                key = String(counter)
            }
            
            
            groupRequestDict[key!] = groupsRequest
            
        }else{
            groupsRequest = groupRequestDict[key!]!
        }
        
        
        
        groupsRequest.fetchNext(onSuccess: { (groups) in
            
            let list = groups.map { (eachGrp) -> [String : Any]? in
                return self.getGroupMap(group: eachGrp)
            }
            var resultDict: [String: Any] = [:]
            resultDict["key"] = key
            resultDict["list"] = list
            result(resultDict)
            
        }) { (error) in
            
            print("Groups list fetching failed with error:" + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    
    private func getUnreadMessageCount(result: @escaping FlutterResult){
        CometChat.getUnreadMessageCount(onSuccess: { (response) in
            print("Unread message count: \(response)")
            result(response)
            
        }) { (error) in
            print("Error in fetching unread count: \(error)")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func markAsRead(args: [String: Any], result: @escaping FlutterResult){
        let baseMessageMap = args["baseMessage"] as? Dictionary<String,AnyObject?> ?? [:]
    
        let baseMessage = toBaseMessage(messageMap: baseMessageMap)
        CometChat.markAsRead(  baseMessage: baseMessage, onSuccess: {
            print("markAsRead Succces")
            result("Success")
        }, onError: {(error) in
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        })
    }
    
    private func callExtension(args: [String: Any], result: @escaping FlutterResult){
        
        let slug = args["slug"] as? String ?? ""
        let requestType = args["requestType"] as? String ?? ""
        let postType : HTTPMethod = HTTPMethod(rawValue: requestType) ?? .get
        let endPoint = args["endPoint"] as? String ?? ""
        let body = args["body"] as? [String:Any]

        CometChat.callExtension(slug: slug,
                                type: postType,
                                endPoint: endPoint,
                                body: body) { (response) in
//            print("Response: \(response)")
            result(self.toJson(dictionary: response) as Any)
            
        } onError: { (error) in
            
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func registerTokenForPushNotification(args: [String: Any], result: @escaping FlutterResult){
        let token = args["token"] as? String ?? ""
        CometChat.registerTokenForPushNotification(token: token) { (response) in
            result(response)
        } onError: { (error) in
            result(FlutterError(code: error?.errorCode ?? "" , message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func blockUsers(args: [String: Any], result: @escaping FlutterResult){
        let uids = args["uids"] as? [String] ?? []
        CometChat.blockUsers(uids, onSuccess: { (users) in
            print("Blocked user successfully.")
            result(users)
        }, onError: { (error) in
            print("Blocked user failed with error: \(error?.errorDescription)")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        })
    }
    
    private func unblockUsers(args: [String: Any], result: @escaping FlutterResult){
        let uids = args["uids"] as? [String] ?? []
        
        CometChat.unblockUsers(uids) { (users) in
            print("Unblocked user successfully.")
            result(users)
        } onError: { (error) in
            print("Unblocked user failed with error: \(error?.errorDescription)")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func fetchBlockedUsers(args: [String: Any], result: @escaping FlutterResult){
        
        let limit = args["limit"] as? Int ?? 50
        var key = args["key"] as? String
        let direction = args["direction"] as? String ?? ""
        var blockedUserRequest:BlockedUserRequest;
        if( key == nil || blockedUserRequestDict[key!] == nil ){
            var builder = BlockedUserRequest.BlockedUserRequestBuilder();
            
            //blockedUserRequest = BlockedUserRequest.BlockedUserRequestBuilder().build();
            if (limit > 0) {
                builder = builder.set(limit: limit)
            }
            if (direction != "") {
                    if direction == "blockedByMe" {
                        builder = builder.set(direction: .byMe)
                    } else if direction == "hasBlockedMe" {
                        builder = builder.set(direction: .me)
                    }else if direction == "both" {
                        builder = builder.set(direction: .both)
                    }
            }
            
            if(key == nil){
                counter+=1
                key = String(counter)
            }
            
            blockedUserRequest = builder.build()
            blockedUserRequestDict[key!] = blockedUserRequest
            
        }else{
            blockedUserRequest = blockedUserRequestDict[key!]!
        }
        
        
        
        
        blockedUserRequest.fetchNext (onSuccess: { (blockedUsers) in
            let users = blockedUsers ?? []
            
            let list = users.map({ (e) -> [String : Any]? in
                return self.getUserMap(user: e)
            })
            
            var resultDict: [String: Any] = [:]
            resultDict["key"] = key
            resultDict["list"] = list
            result(resultDict)
            
        }, onError: { (error) in
            print("exco Error while fetching the blocked user request:  \(error?.errorDescription)");
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        })
    }
    
    private func fetchUsers(args: [String: Any], result: @escaping FlutterResult){
        
        let searchTerm = args["searchTerm"] as? String ?? ""
        let limit = args["limit"] as? Int ?? 50
        let hidebloackedUsers = args["hidebloackedUsers"] as? Bool ?? false
        let userRoles = args["userRoles"] as? [String] ?? []
        let friendsOnly = args["friendsOnly"] as? Bool ?? false
        let tags = args["tags"] as? [String] ?? []
        let uids = args["uids"] as? [String] ?? []
        let withTags = args["withTags"] as? Bool ?? false
        let userStatus = args["userStatus"] as? String ?? ""
        
        var key = args["key"] as? String
        var usersRequest:UsersRequest;
    
        
        if( key == nil || userRequestDict[key!] == nil ){
            
            usersRequest = UsersRequest.UsersRequestBuilder().set(limit: 50).build();
            
            var builder = UsersRequest.UsersRequestBuilder();
            
            if (limit > 0) {
                builder = builder.set(limit: limit)
            }
            if (searchTerm != "") {
                builder = builder.set(searchKeyword:searchTerm)
            }
            if (hidebloackedUsers){
                builder = builder.hideBlockedUsers(hidebloackedUsers)
            }
            if (!userRoles.isEmpty){
                builder = builder.set(roles: userRoles)
            }
            if (friendsOnly){
                builder = builder.friendsOnly( friendsOnly)
            }
            if (!tags.isEmpty){
                builder = builder.set(tags: tags)
            }
            if (!uids.isEmpty){
                builder = builder.set(UIDs:uids)
            }
            if (withTags){
                builder = builder.withTags(withTags)
            }
            if (userStatus != "") {
                if userStatus.compare("online", options: .caseInsensitive) == .orderedSame {
                    builder = builder.set(status:CometChat.UserStatus.available)
                }
                else{
                    builder = builder.set(status: CometChat.UserStatus.offline)
                }
                
            }
            
            usersRequest = builder.build();
            
            
            if(key == nil){
                counter+=1
                key = String(counter)
            }
            
            
            userRequestDict[key!] = usersRequest
            
        }else{
            usersRequest = userRequestDict[key!]!
        }
        
        
        
        usersRequest.fetchNext(onSuccess: { (userList) in
            let list = userList.map { (e) -> [String : Any]? in
                return self.getUserMap(user: e)
            }
            var resultDict: [String: Any] = [:]
            resultDict["key"] = key
            resultDict["list"] = list
            result(resultDict)
            
        }) { (error) in
            
            print("Users list fetching failed with error:" + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    
    
    
    private func startTyping(args: [String: Any], result: @escaping FlutterResult){
        
        let uid = args["uid"] as? String ?? ""
        let receiver = args["receiverType"] as? String ?? ""
        let receiverType : CometChat.ReceiverType
        switch receiver {
        case "user":
            receiverType =  CometChat.ReceiverType.user
        default:
            receiverType =   CometChat.ReceiverType.group
        }
        let typingIndicator = TypingIndicator(receiverID: uid, receiverType: receiverType)
        CometChat.startTyping(indicator: typingIndicator)
        
    }
    private func endTyping(args: [String: Any], result: @escaping FlutterResult){
        
        let uid = args["uid"] as? String ?? ""
        let receiver = args["receiverType"] as? String ?? ""
        let receiverType : CometChat.ReceiverType
        switch receiver {
        case "user":
            receiverType =  CometChat.ReceiverType.user
        default:
            receiverType =   CometChat.ReceiverType.group
        }
        let typingIndicator = TypingIndicator(receiverID: uid, receiverType: receiverType)
        CometChat.endTyping(indicator: typingIndicator)
        
    }
    
    private func getConversation(args: [String: Any], result: @escaping FlutterResult){
        
        let conversationWith = args["conversationWith"] as? String ?? ""
        let conversationType = args["conversationType"] as? String ?? ""
        let passedConversationType:CometChat.ConversationType
        switch conversationType {
        case "user":
            passedConversationType =  CometChat.ConversationType.user
        default:
            passedConversationType =   CometChat.ConversationType.group
        }
        
        CometChat.getConversation(conversationWith: conversationWith, conversationType: passedConversationType, onSuccess: { (conversation) in
            print("success \(String(describing: conversation?.stringValue()))")
            result(self.getConversationMap(conversation: conversation))
        }) { (exception) in
            print("here exception \(String(describing: exception?.errorDescription))")
            result(FlutterError(code: exception?.errorCode ?? "",
                                message: exception?.errorDescription, details: exception?.debugDescription))
        }
        
    
    }
    
    private func fetchNextMessages(args: [String: Any], result: @escaping FlutterResult){
        let limit = args["limit"] as? Int ?? 50
        let uid = args["uid"] as? String ?? ""
        let guid = args["guid"] as? String ?? ""
        let searchTerm = args["searchTerm"] as? String ?? ""
        let messageId = args["messageId"] as? Int ?? 0
        
        let timestamp = args["timestamp"] as? Int ?? 0
        let unread = args["unread"] as? Bool ?? false
        let hideblockedUsers = args["hideblockedUsers"] as? Bool ?? false
        let updateAfter = args["updateAfter"] as? Int ?? 0
        let updatesOnly = args["updatesOnly"] as? Bool ?? false
        let categories = args["categories"] as? [String] ?? []
        let types = args["types"] as? [String] ?? []
        let parentMessageId = args["parentMessageId"] as? Int ?? 0
        let hideReplies = args["hideReplies"] as? Bool ?? false
        let hideDeletedMessages = args["hideDeletedMessages"] as? Bool ?? false
        let withTags = args["withTags"] as? Bool ?? false
        let tags = args["tags"] as? [String] ?? []
        var key = args["key"] as? String
        var messagesRequest:MessagesRequest;
    
        
        if( key == nil || messageRequestDict[key!] == nil ){
            messagesRequest = MessagesRequest.MessageRequestBuilder().set(limit: 50).build()
            var builder = MessagesRequest.MessageRequestBuilder()

            if (limit > 0) {
                builder = builder.set(limit: limit)
            }
            
            
            if (uid != "") {
                builder = builder.set(uid: uid)
            } else if (guid != "") {
                builder = builder.set(guid: guid)
            }
            if (searchTerm != ""){
                builder = builder.set(searchKeyword: searchTerm)
            }
            if (messageId > 0){
                builder = builder.set(messageID: messageId)
            }
            
            
            if (timestamp > 0) {
                builder = builder.set(timeStamp: timestamp)
            }
            if (unread) {
                builder = builder.set(unread:unread)
            }
            if (hideblockedUsers) {
                builder = builder.hideMessagesFromBlockedUsers(hideblockedUsers)
            }
            if (updateAfter > 0) {
                builder = builder.setUpdatedAfter(timeStamp: updateAfter)
            }
            if (updatesOnly) {
                builder = builder.updatesOnly(onlyUpdates: updatesOnly)
            }
            if (!categories.isEmpty){
                builder = builder.set(categories: categories)
            }
            if (!types.isEmpty){
                builder = builder.set(types: types)
            }
            if (parentMessageId > 0) {
                builder = builder.setParentMessageId(parentMessageId: parentMessageId)
            }
            if (hideReplies) {
                builder = builder.hideReplies(hide: hideReplies)
            }
            if (hideDeletedMessages) {
                builder = builder.hideDeletedMessages(hide: hideDeletedMessages)
            }
            if(withTags){
                builder = builder.withTags(withTags)
            }
            if(!tags.isEmpty){
                builder = builder.setTags(tags)
            }
                
            
            
            builder = builder.set(timeStamp: timestamp)
            
            messagesRequest = builder.build()
            if(key == nil){
                counter+=1
                key = String(counter)
            }
            
            
            messageRequestDict[key!] = messagesRequest
            
        }else{
            messagesRequest = messageRequestDict[key!]!
        }
        
        
        
        messagesRequest.fetchNext(onSuccess: { (response) in
            if let messages = response{
                let list = messages.map { (eachMsg) -> [String : Any]? in
                    return self.getMessageMap(message: eachMsg)
                    
                }
                var resultDict: [String: Any] = [:]
                resultDict["key"] = key
                resultDict["list"] = list
                result(resultDict)
            }
        }) { (error) in
            print("Message receiving failed with error: " + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    
    
    private func getUnreadMessageCountForGroup(args: [String: Any],result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        let hideMessagesFromBlockedUsers = args["hideMessagesFromBlockedUsers"] as? Bool ?? false
        
        CometChat.getUnreadMessageCountForGroup(guid,hideMessagesFromBlockedUsers: hideMessagesFromBlockedUsers, onSuccess: { (response) in
            print("Unread message count: \(response)")
            result(response)
            
        }) { (error) in
            print("Error in fetching unread count: \(error)")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func getUnreadMessageCountForAllUsers(args: [String: Any],result: @escaping FlutterResult){
        let hideMessagesFromBlockedUsers = args["hideMessagesFromBlockedUsers"] as? Bool ?? false
        
        CometChat.getUnreadMessageCountForAllUsers(hideMessagesFromBlockedUsers: hideMessagesFromBlockedUsers, onSuccess: { (response) in
            print("Unread message count: \(response)")
            result(response)
            
        }) { (error) in
            print("Error in fetching unread count: \(error)")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    
    private func getUnreadMessageCountForAllGroups(args: [String: Any],result: @escaping FlutterResult){
        let hideMessagesFromBlockedUsers = args["hideMessagesFromBlockedUsers"] as? Bool ?? false
        
        
        CometChat.getUnreadMessageCountForAllGroups(hideMessagesFromBlockedUsers: hideMessagesFromBlockedUsers, onSuccess: { (response) in
            print("Unread message count: \(response)")
            result(response)
            
        }) { (error) in
            print("Error in fetching unread count: \(error)")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    
    private func markAsDelivered(args: [String: Any], result: @escaping FlutterResult){
        let baseMessageMap = args["baseMessage"] as? Dictionary<String,AnyObject?> ?? [:]
    
        let baseMessage = toBaseMessage(messageMap: baseMessageMap)

        CometChat.markAsDelivered(  baseMessage: baseMessage, onSuccess: {
            print("markAsRead Succces")
            result("Success")
        }, onError: {(error) in
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        })
    }
    
    
    private func getMessageReceipts(args: [String: Any], result: @escaping FlutterResult){
        let messageId = args["id"] as? Int ?? -1
        CometChat.getMessageReceipts(messageId, onSuccess: { (receipt) in
            let receiptMap = receipt.map { (eachReceipt) -> [String : Any]? in
                return self.getMessageReceiptMap(messageReceipt: eachReceipt)
            }
            result(receiptMap)
        }) { (error) in
            result(FlutterError(code: error?.errorCode ?? "" , message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    
    private func editMessage(args: [String: Any], result: @escaping FlutterResult){
        let baseMessageMap = args["baseMessage"] as? Dictionary<String,AnyObject?> ?? [:]
    
        let baseMessage: BaseMessage
        if(baseMessageMap["category"] as! String == "custom"){
            baseMessage = toCustomMessage(messageMap: baseMessageMap)
        }
        else{
            baseMessage = toTextMessage(messageMap: baseMessageMap)
        }
            CometChat.editMessage( baseMessage, onSuccess: { (baseMessage) in
            print("success \(String(describing: baseMessage.description))")
            result(self.getMessageMap(message:baseMessage))
                        
        }) { (error) in
            print(error.errorDescription)
              result(FlutterError(code: error.errorCode ?? "" ,
                                  message: error.errorDescription, details: error.debugDescription))
        }
    }
    
    private func deleteConversation(args: [String: Any], result: @escaping FlutterResult){
        
        let conversationWith = args["conversationWith"] as? String ?? ""
        let conversationType = args["conversationType"] as? String ?? ""
        let passedConversationType:CometChat.ConversationType
        switch conversationType {
        case "user":
            passedConversationType =  CometChat.ConversationType.user
        default:
            passedConversationType =   CometChat.ConversationType.group
        }

        CometChat.deleteConversation(conversationWith: conversationWith, conversationType: passedConversationType, onSuccess: { message in
            print("Conversation deleted",message)
            result(message)
        }, onError: {error in
            print("exco Error while fetching the blocked user request:  \(error?.errorDescription)");
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        })
        
    }
    
    
    private func sendTransientMessage(args: [String: Any], result: @escaping FlutterResult){
        
        let receiverId = args["receiverId"] as? String ?? ""
        let receiverType = args["receiverType"] as? String ?? ""
        let data = args["data"] as? Dictionary<String,String> ?? [:]
        
        
        let passedReceiverType:CometChat.ReceiverType
        switch receiverType {
        case "user":
            passedReceiverType =  CometChat.ReceiverType.user
        default:
            passedReceiverType =   CometChat.ReceiverType.group
        }

        let transientMessage = TransientMessage(receiverID: receiverId, receiverType: passedReceiverType, data: data)
        CometChat.sendTransientMessage(message: transientMessage)
        result("Message Sent")
        
    }
    
    
    private func getOnlineUserCount(args: [String: Any], result: @escaping FlutterResult){
        
        CometChat.getOnlineUserCount(onSuccess: { count in
            print("Conversation deleted",count)
            result(count)
        }, onError: {error in
            print("exco Error while fetching onlint user count:  \(error?.errorDescription)");
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        })
        
    }
    
    
    private func updateUser(args: [String: Any], result: @escaping FlutterResult){
        
        let apiKey = args["apiKey"] as? String ?? ""
        let uid = args["uid"] as? String ?? ""
        let name = args["name"] as? String ?? ""
        let avatar = args["avatar"] as? String
        let link = args["link"] as? String
        let tags = args["tags"] as? [String]
        let metadata = args["metadata"] as? String
        let statusMessage = args["statusMessage"] as? String
        let role = args["role"] as? String
        let blockedByMe = args["blockedByMe"] as? Bool
        let deactivatedAt = args["deactivatedAt"] as? Double
        let hasBlockedMe = args["hasBlockedMe"] as? Bool
        let lastActiveAt = args["lastActiveAt"] as? Double
        let status = args["status"] as? String
        
        
        
        
        let updatedUser : User = User(uid: uid, name: name)
        
    
        
        
        if let avatar = avatar {
          updatedUser.avatar = avatar
        }
        
        if let link = link {
          updatedUser.link = link
        }
        
        if let metadata = metadata {
          updatedUser.metadata = convertToDictionary(text: metadata)
        }
        
        if let tags = tags {
          updatedUser.tags = tags
        }
        
        if let statusMessage = statusMessage {
          updatedUser.statusMessage = statusMessage
        }
        
        if let role = role {
          updatedUser.role = role
        }
        
        if let blockedByMe = blockedByMe {
          updatedUser.blockedByMe = blockedByMe
        }
        if let hasBlockedMe = hasBlockedMe {
          updatedUser.hasBlockedMe = hasBlockedMe
        }
        if let lastActiveAt = lastActiveAt {
          updatedUser.lastActiveAt = lastActiveAt
        }
        if let status = status {
            switch status {
            case "online":
                updatedUser.status = CometChat.UserStatus.online
            case "offline":
                updatedUser.status = CometChat.UserStatus.offline
            default:
                updatedUser.status = CometChat.UserStatus.offline
            }
        }
        
        
        // Replace with your uid and the name for the user to be created.
        CometChat.updateUser(user: updatedUser, apiKey: apiKey, onSuccess: { (user) in
             print("User updated successfully. \(user.stringValue())")
            result(self.getUserMap(user: user));
         }) { (error) in
             print("The error is \(String(describing: error?.description))")
             result(FlutterError(code: error?.errorCode ?? "" ,
                                 message: error?.errorDescription, details: error?.debugDescription))
         }
        
    }
    
    
    private func updateCurrentUserDetails(args: [String: Any], result: @escaping FlutterResult){
        
        let uid = args["uid"] as? String ?? ""
        let name = args["name"] as? String ?? ""
        let avatar = args["avatar"] as? String
        let link = args["link"] as? String
        let tags = args["tags"] as? [String]
        let metadata = args["metadata"] as? String
        let statusMessage = args["statusMessage"] as? String
        let role = args["role"] as? String
        let blockedByMe = args["blockedByMe"] as? Bool
        let hasBlockedMe = args["hasBlockedMe"] as? Bool
        let lastActiveAt = args["lastActiveAt"] as? Double
        let status = args["status"] as? String
        
        let updatedUser : User = User(uid: uid, name: name)
        
        if let avatar = avatar {
          updatedUser.avatar = avatar
        }
        
        if let link = link {
          updatedUser.link = link
        }
        
        if let metadata = metadata {
          updatedUser.metadata = convertToDictionary(text: metadata)
        }
        
        if let tags = tags {
          updatedUser.tags = tags
        }
        
        if let statusMessage = statusMessage {
          updatedUser.statusMessage = statusMessage
        }
        
        
        if let role = role {
          updatedUser.role = role
        }
        
        if let blockedByMe = blockedByMe {
          updatedUser.blockedByMe = blockedByMe
        }
        if let hasBlockedMe = hasBlockedMe {
          updatedUser.hasBlockedMe = hasBlockedMe
        }
        if let lastActiveAt = lastActiveAt {
          updatedUser.lastActiveAt = lastActiveAt
        }
        if let status = status {
            switch status {
            case "online":
                updatedUser.status = CometChat.UserStatus.online
            case "offline":
                updatedUser.status = CometChat.UserStatus.offline
            default:
                updatedUser.status = CometChat.UserStatus.offline
            }
        }
        
        
        CometChat.updateCurrentUserDetails(user: updatedUser,  onSuccess: { (user) in
             print("User updated successfully. \(user.stringValue())")
            result(self.getUserMap(user: user));
         }) { (error) in
             print("The error is \(String(describing: error?.description))")
             result(FlutterError(code: error?.errorCode ?? "" ,
                                 message: error?.errorDescription, details: error?.debugDescription))
         }
        
    }
    
    private func getGroup(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        
        CometChat.getGroup(GUID: guid, onSuccess: { (group) in
            print("Group details fetched successfully. " + group.stringValue())
            result(self.getGroupMap(group: group));

        }) { (error) in
            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    
    private func getOnlineGroupMemberCount(args: [String: Any], result: @escaping FlutterResult){
        
        let guids = args["guids"] as? [String] ?? []
        
        CometChat.getOnlineGroupMemberCount(guids, onSuccess: { countData in
            print(countData)
            result(countData);
        }, onError: { error in
            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
         })
        
    }
    private func updateGroup(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        let name = args["name"] as? String ?? ""
        let icon = args["icon"] as? String
        let description = args["description"] as? String
        
        let membersCount = args["membersCount"] as? Int ?? 0
        let metadata = args["metadata"] as? String
        let joinedAt = args["joinedAt"] as? Int
        let hasJoined = args["hasJoined"] as? Bool
        
        let createdAt = args["createdAt"] as? Int
        let owner = args["owner"] as? String
        let updatedAt = args["updatedAt"] as? Int
        let tags = args["tags"] as? [String]
        
        let grpType = args["type"] as? String ?? ""
        let groupType : CometChat.groupType = grpType == "private" ? .private : grpType == "public" ? .public : .password
        
        let scope = args["scope"] as? String ?? ""
        let groupScope : CometChat.GroupMemberScopeType = scope == "participant" ? .participant : scope == "moderator" ? .moderator : .admin
        
        
        
        let password = args["password"] as? String ?? nil //mandatory in case of password protected group type
        
    
        let newGroup : Group = Group(guid: guid, name: name, groupType: groupType, password: password)
        
        
        if let icon = icon {
            newGroup.icon = icon
        }
        
        if let description = description {
            newGroup.groupDescription = description
        }
    
        
        if(membersCount>0){
            newGroup.membersCount = membersCount
        }
        
        if let metadata = metadata {
            newGroup.metadata = convertToDictionary(text: metadata)
        }
        
        if let joinedAt = joinedAt {
            newGroup.joinedAt = joinedAt
        }
        
        if let hasJoined = hasJoined {
            newGroup.hasJoined = hasJoined
        }
        
        if let createdAt = createdAt {
            newGroup.createdAt = createdAt
        }
        
        if let owner = owner {
            newGroup.owner = owner
        }
        
        if let updatedAt = updatedAt {
            newGroup.updatedAt = updatedAt
        }
        
        if let tags = tags {
            newGroup.tags = tags
        }
        
        newGroup.scope = groupScope
       

        CometChat.updateGroup(group: newGroup, onSuccess: { (group) in
          print("Groups details updated successfully. " + group.stringValue())
            result(self.getGroupMap(group: group));
            

        }) { (error) in
            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func addMembersToGroup(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        let groupMembers = args["groupMembers"] as? [Dictionary<String,AnyObject?>] ?? []
        var groupMemberList = [GroupMember]()
        
        for groupMember in groupMembers {
            groupMemberList.append(toGroupMember(groupMemberMap: groupMember))
        }
        
        
        CometChat.addMembersToGroup(guid: guid, groupMembers: groupMemberList, onSuccess: { (response) in
                print("Response from addMembersGroup: \(response)")
            result(response)
            
        }, onError : { (error) in
            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
            
        })
    }
    

    
    private func kickGroupMember(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        let uid = args["uid"] as? String ?? ""
        
        CometChat.kickGroupMember(UID: uid, GUID: guid, onSuccess: { (response) in

          print("\(uid) is kicked from the group \(guid) successfully.")
            result(response)

        }) { (error) in

            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    private func banGroupMember(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        let uid = args["uid"] as? String ?? ""
        
        CometChat.banGroupMember(UID: uid, GUID: guid, onSuccess: { (response) in

          print("\(uid) is kicked from the group \(guid) successfully.")
            result(response)

        }) { (error) in

            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func unbanGroupMember(args: [String: Any], result: @escaping FlutterResult){
        
        let guid = args["guid"] as? String ?? ""
        let uid = args["uid"] as? String ?? ""
        
        CometChat.unbanGroupMember(UID: uid, GUID: guid, onSuccess: { (response) in

          print("\(uid) is kicked from the group \(guid) successfully.")
            result(response)

        }) { (error) in

            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
    }
    
    private func updateGroupMemberScope(args: [String: Any], result: @escaping FlutterResult){
        
        let GUID = args["guid"] as? String ?? ""
        let UID = args["uid"] as? String ?? ""
        let passedScope = args["scope"] as? String ?? ""
        let scope : CometChat.MemberScope = passedScope == "admin" ? .admin : passedScope == "moderator" ? .moderator : .participant
        
        CometChat.updateGroupMemberScope(UID: UID, GUID: GUID, scope: scope, onSuccess: { (response) in

             print("Update group member scope changed successfully.")
            result(response)

        }) { (error) in

            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    
    
    private func transferGroupOwnership(args: [String: Any], result: @escaping FlutterResult){
        
        let GUID = args["guid"] as? String ?? ""
        let UID = args["uid"] as? String ?? ""
        CometChat.transferGroupOwnership(UID: UID, GUID: GUID) { (response) in
                    
            print("Transfer Group Ownership Successfully")
            result(response)

        } onError: { (error) in

            print("Transfer Group Ownership failed with error \(error?.errorDescription)")
            print("The error is \(String(describing: error?.description))")
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    
    
    private func fetchBlockedGroupMembers(args: [String: Any], result: @escaping FlutterResult){
        
        let searchTerm = args["searchKeyword"] as? String ?? ""
        let limit = args["limit"] as? Int ?? 50
        let guid = args["guid"] as? String ?? ""
        var key = args["key"] as? String
        var bannedGroupMemberRequest:BannedGroupMembersRequest
    
        
        if( key == nil || bannedGroupMemberRequestDict[key!] == nil ){
            
            var builder = BannedGroupMembersRequest.BannedGroupMembersRequestBuilder(guid: guid);
            
            if (limit > 0) {
                builder = builder.set(limit: limit)
            }
            if (searchTerm != "") {
                builder = builder.set(searchKeyword:searchTerm)
            }
            
            bannedGroupMemberRequest = builder.build();
            
            if(key == nil){
                counter+=1
                key = String(counter)
            }
            
            bannedGroupMemberRequestDict[key!] = bannedGroupMemberRequest
            
            
        }else{
            bannedGroupMemberRequest =   bannedGroupMemberRequestDict[key!]!
            
        }
        
        bannedGroupMemberRequest.fetchNext(onSuccess: { (groupMembers) in
            
            var resultDict: [String: Any] = [:]
            resultDict["key"] = key
            resultDict["list"] = self.getGroupMemberMap(members: groupMembers)
            result(resultDict)
            
        }) { (error) in
            
            print("Banned member list fetching failed with error:" + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "" ,
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
    }
    
    

    private func getLastDeliveredMessageId(args: [String: Any], result: @escaping FlutterResult){
        let lastMessageDeliveredId = CometChat.getLastDeliveredMessageId();
        result(lastMessageDeliveredId)
        
    }
    
    

    private func getConnectionStatus( result: @escaping FlutterResult){
        let connectionStatus = CometChat.getConnectionStatus?.value
        result(connectionStatus)
        
    }
    
    
    private func sendCustomMessage(args: [String: Any], result: @escaping FlutterResult){
        let receiverId = args["receiverId"] as? String ?? ""
        let receiverType = args["receiverType"] as? String ?? ""
        let customType = args["customType"] as? String ?? ""
        let customData = args["customData"] as? Dictionary<String,Any> ?? [:]
        let tags = args["tags"] as? [String] ?? []
        let muid = args["muid"] as? String ?? ""
        let parentMessageId = args["parentMessageId"] as? Int ?? 0
        let metadata = args["metadata"] as? String ?? ""
        
        let customMessage : CustomMessage = CustomMessage(receiverUid: receiverId, receiverType: (receiverType == "user" ? .user : .group), customData : customData, type: customType)
        if(!tags.isEmpty){
            customMessage.tags = tags
        }
        if(muid != ""){
            customMessage.muid = muid
        }
        
        if (parentMessageId > 0) {
            customMessage.parentMessageId = parentMessageId
        }
                
        if (!metadata.isEmpty){
            customMessage.metaData = convertToDictionary(text: metadata)
        }
        
        CometChat.sendCustomMessage(message: customMessage, onSuccess: { (message) in
            let user = CometChat.getLoggedInUser();
            message.sender = user
            result(self.getMessageMap(message: message))
        }) { (error) in
            print("Custom sending failed with error: " + error!.errorDescription);
            result(FlutterError(code: error?.errorCode ?? "",
                                message: error?.errorDescription, details: error?.debugDescription))
        }
        
        
    }
    
    
    
    private func getConversationMap(conversation: Conversation?) -> [String: Any]? {
        if let conversation = conversation {
            var conversationWith : [String : Any]?
            var conversationType : String
            
            switch conversation.conversationType {
            case .user:
                conversationType = "user"
                conversationWith = getUserMap(user: conversation.conversationWith as? User)
            default:
                conversationType = "group"
                conversationWith = getGroupMap(group: conversation.conversationWith as? Group)
            }
            return [
                "conversationId" : conversation.conversationId ?? "",
                "conversationType" : conversationType,
                "conversationWith" : conversationWith ?? [:],
                "updatedAt" : Int(conversation.updatedAt) ,
                "unreadMessageCount" : conversation.unreadMessageCount,
                "lastMessage":self.getMessageMap(message: conversation.lastMessage) ?? [:],
                "tags" : conversation.tags,
            ]
        } else {
            return nil
        }
    }
    
    private func getMessageMap(message: BaseMessage?, methodName: String = "") -> [String: Any]? {
        //print(message as Any)
        if let message = message {
            
            var receiver : [String : Any]?
            var receiverType : String
            switch message.receiverType {
            case .user:
                receiverType = "user"
                receiver = getUserMap(user: message.receiver as? User)
            default:
                receiverType = "group"
                receiver = getGroupMap(group: message.receiver as? Group)
            }
            
            var category : String = "custom"
            switch message.messageCategory {
            case CometChat.MessageCategory.message:
                category = "message"
            case CometChat.MessageCategory.action:
                category = "action"
            case CometChat.MessageCategory.custom:
                category = "custom"
            case CometChat.MessageCategory.call:
                category = "call"
            default:
                category = "custom"
            }
            
            var type : String = "custom"
            
            if(category=="custom"){
                if let customMessage = message as? CustomMessage{
                    
                    type =  customMessage.type ?? ""
                }
                
            }else if category == "call"{
                
                if let call = message as? Call{
                    
                    switch call.callType {
                    case CometChat.CallType.audio:
                        type = "audio"
                    case CometChat.CallType.video:
                        type = "video"
                    default:
                        type = "audio"
                    }
                }
                
               
            }
            else if category == "message"{
                switch message.messageType {
                case CometChat.MessageType.text:
                    type = "text"
                case CometChat.MessageType.image:
                    type = "image"
                case CometChat.MessageType.video:
                    type = "video"
                case CometChat.MessageType.file:
                    type = "file"
                case CometChat.MessageType.audio:
                    type = "audio"
                case CometChat.MessageType.audio:
                    type = "audio"
                case CometChat.MessageType.groupMember:
                    type = "groupMember"
                default:
                    type = "custom"
                }
            }else{
               
                if let action = (message as? ActionMessage)?.action{
                    switch action {
                  
                    case .added:
                        type = "groupMember"
                    case .banned:
                        type = "groupMember"
                    case .joined:
                        type = "groupMember"
                    case .kicked:
                        type = "groupMember"
                    case .left:
                        type = "groupMember"
                    case .messageDeleted:
                        type = "message"
                    case .messageEdited:
                        type = "message"
                    default:
                        type = "groupMember"
                    }
                    
                }else{
                    type = "groupMember"
                }
                
                
                
            }
            
            
            
            var messageMap = [
                "id" : message.id as Any,
                "muid" : message.muid  as Any,
                "sender" : getUserMap(user: message.sender) as Any,
                "receiver" : receiver as Any,
                "receiverUid" : message.receiverUid as Any,
                "type" : type,
                "receiverType" : receiverType,
                "category" : category,
                "sentAt" : Int(message.sentAt),
                "deliveredAt" : Int(message.deliveredAt),
                "readAt" : Int(message.readAt),
                //"metadata" :  toJson(dictionary: message.metaData) as Any,
                "metadata" :  toJson(dictionary: message.metaData) as Any,
                "readByMeAt" : Int(message.readByMeAt),
                "deliveredToMeAt" : Int(message.deliveredToMeAt),
                "deletedAt" : Int(message.deletedAt),
                "editedAt" : Int(message.editedAt),
                "deletedBy" : message.deletedBy,
                "editedBy" : message.editedBy,
                "updatedAt" : Int(message.updatedAt),
                "conversationId" : message.conversationId,
                "parentMessageId" : message.parentMessageId,
                "replyCount" : message.replyCount,
                "senderUid":  message.senderUid,
                "methodName":methodName
            ]
            
            if let text = message as? TextMessage {
                let map = [
                    "text" : text.text,
                    "tags" : text.tags
                ] as [String : Any]
                map.forEach { (key, value) in messageMap[key] = value }
            } else if let media = message as? MediaMessage{
                let map = [
                    "caption" : media.caption as Any,
                    "attachment" : getAttachmentMap(attachment: media.attachment) as Any,
                    "tags" : media.tags
                ]
                map.forEach { (key, value) in messageMap[key] = value }
            }  else if let customMessage = message as? CustomMessage{
                let map = [
                    "customData" : toJson(dictionary: customMessage.customData) as Any,
                    "subType" : customMessage.subType,
                    "tags" : customMessage.tags
                ]
                map.forEach { (key, value) in messageMap[key] = value }
            } else if let action = message as? ActionMessage{
                
                var actionOn : [String : Any]?
                var actionFor : [String : Any]?
                var actionBy : [String : Any]?
                
                let oldScope : String?
                switch action.oldScope {
                case .admin:
                    oldScope = "admin"
                case .moderator:
                    oldScope = "moderator"
                case .participant:
                    oldScope = "participant"
                default:
                    oldScope = nil
                }
                
                
                let newScope : String?
                switch action.newScope {
                case .admin:
                    newScope = "admin"
                case .moderator:
                    newScope = "moderator"
                case .participant:
                    newScope = "participant"
                default:
                    newScope = nil
                }
                
                
                
                let actionString : String?
                if let actionType = action.action{
                    switch actionType {
                  
                    case .added:
                        actionString = "added"
                    case .banned:
                        actionString = "banned"
                    case .joined:
                        actionString = "joined"
                    case .kicked:
                        actionString = "kicked"
                    case .left:
                        actionString = "left"
                    case .messageDeleted:
                        actionString = "messageDeleted"
                    case .messageEdited:
                        actionString = "messageEdited"
                    default:
                        actionString = nil
                    }
                    
                    
                }else{
                    actionString = nil
                }
                
                actionOn = getAppEntityMap(passedEntity: action.actionOn)
                
                actionBy = getAppEntityMap(passedEntity: action.actionBy)
                
                actionFor = getAppEntityMap(passedEntity: action.actionFor)
                
                
                
                let map = [
                    "message" : action.message as Any,
                    "rawData" : action.rawData as Any,
                    "action" : actionString ,
                    "oldScope" : oldScope,
                    "newScope" : newScope,
                    "actionOn": actionOn,
                    "actionBy": actionBy,
                    "actionFor": actionFor
                ]
                map.forEach { (key, value) in messageMap[key] = value }
            } else if let call = message as? Call{
                var callInitiator : [String : Any]?
                var callReceiver : [String : Any]?
                var callStatus : String
            
                if(call.callInitiator is User ){
                    callInitiator = getUserMap(user: call.callInitiator as? User)
                }else{
                    callInitiator = getGroupMap(group: call.callInitiator as? Group)
                }
                
                if(call.callReceiver is User ){
                    callReceiver = getUserMap(user: call.callReceiver as? User)
                }else{
                    callReceiver = getGroupMap(group: call.callReceiver as? Group)
                }
                
                switch call.callStatus {
                case CometChat.callStatus.busy:
                    callStatus = "busy"
                case CometChat.callStatus.cancelled:
                    callStatus = "cancelled"
                case CometChat.callStatus.ended:
                    callStatus = "ended"
                case CometChat.callStatus.initiated:
                    callStatus = "initiated"
                case CometChat.callStatus.ongoing:
                    callStatus = "ongoing"
                case CometChat.callStatus.rejected:
                    callStatus = "rejected"
                case CometChat.callStatus.unanswered:
                    callStatus = "unanswered"
                default:
                    callStatus = "rejected"
                }
                let map = [
                    "sessionId" : call.sessionID as Any,
                    "callStatus" : callStatus ,
                    "action" : call.action ,
                    "rawData" : call.rawData ,
                    "initiatedAt" : Int(call.initiatedAt),
                    "joinedAt" : Int(call.joinedAt),
                    "callInitiator" : callInitiator,
                    "callReceiver" : callReceiver,
                ]
                map.forEach { (key, value) in messageMap[key] = value }
            }
            return messageMap;
            
        } else {
            return nil
        }
    }
    
    private func getAttachmentMap(attachment: Attachment?) -> [String: Any]? {
        if let attachment = attachment {
            return [
                "fileName" : attachment.fileName,
                "fileExtension" : attachment.fileExtension,
                "fileSize" : Int(attachment.fileSize) ,
                "fileMimeType" : attachment.fileMimeType as Any,
                "fileUrl" : attachment.fileUrl as Any,
            ]
        } else {
            return nil
        }
    }
    
    private func getUserMap(user: User?, methodName : String = "") -> [String: Any]? {
        if let user = user {
            let status : String
            switch user.status {
            case .online:
                status = "online"
            default:
                status = "offline"
            }
            let userMap = [
                "uid" : user.uid ?? "",
                "name" : user.name ?? "",
                "avatar" : user.avatar ?? "",
                "link" : user.link ?? "",
                "role" : user.role ?? "",
                "metadata" : toJson(dictionary: user.metadata) as Any,
                "status" : status,
                "statusMessage" : user.statusMessage ?? "",
                "lastActiveAt" : Int(user.lastActiveAt) ,
                "tags" : user.tags,
                "blockedByMe" : user.blockedByMe,
                "hasBlockedMe" : user.hasBlockedMe,
                "methodName":methodName
            ]
            return userMap;
        } else {
            return nil
        }
    }
    
    private func getGroupMap(group: Group?, methodName : String = "")-> [String: Any]? {
        let type : String
        switch group?.groupType {
        case .public:
            type = "public"
        case .private:
            type = "private"
        case .password:
            type = "password"
        default:
            type = "public"
        }
        
        let scope : String?
        switch group?.scope {
        case .admin:
            scope = "admin"
        case .moderator:
            scope = "moderator"
        case .participant:
            scope = "participant"
        default:
            scope = nil
        }
        
        
        if let group = group {
            return [
                "guid" : group.guid ,
                "name" : group.name ?? "",
                "type" : type,
                "password" : group.password ?? "",
                "icon" : group.icon ?? "",
                "description" : group.groupDescription ,
                "owner" : group.owner ?? "",
                "metadata" : toJson(dictionary: group.metadata) as Any,
                "createdAt" : group.createdAt ,
                "updatedAt" : group.updatedAt,
                "hasJoined" : group.hasJoined,
                "joinedAt" : group.joinedAt,
                "scope" : scope,
                "membersCount" : group.membersCount,
                "tags" : group.tags,
                "methodName":methodName
            ]
        } else {
            return nil
        }
    }
    
    private func getGroupMemberMap(members: [GroupMember]) -> [[String:Any]]{
        var membersMap = [[String:Any]]()
        members.forEach { (member) in
            let status : String
            switch member.status {
            case .online:
                status = "online"
            default:
                status = "offline"
            }
            let scope : String?
            switch  member.scope {
            case .admin:
                scope = "admin"
            case .moderator:
                scope = "moderator"
            case .participant:
                scope = "participant"
            default:
                scope = nil
            }
            let eachMember = [
                "uid" : member.uid ?? "",
                "name" : member.name ?? "",
                "avatar" : member.avatar ?? "",
                "link" : member.link ?? "",
                "role" : member.role ?? "",
                "metadata" : toJson(dictionary: member.metadata) as Any,
                "status" : status,
                "statusMessage" : member.statusMessage ?? "",
                "lastActiveAt" : Int(member.lastActiveAt) ,
                "tags" : member.tags,
                "scope" : scope ?? "",
                "joinedAt" : member.joinedAt,
                "hasBlockedMe": member.hasBlockedMe,
                "blockedByMe": member.blockedByMe,
                "methodName": ""
            ]
            membersMap.append(eachMember)
        }
        return membersMap
    }
    
    
    private func getTypingIndicatorMap(typingIndicator: TypingIndicator?, methodName:String="")-> [String: Any]? {
        
        let receiverType : String
        switch typingIndicator?.receiverType{
        case .user:
            receiverType = "user"
        case .group:
            receiverType = "group"
        default:
            receiverType = "user"
        }
        if let typingIndicator = typingIndicator {
            return [
                "sender" : getUserMap(user: typingIndicator.sender) ,
                "receiverId" : typingIndicator.receiverID ,
                "receiverType" : receiverType,
                "metadata" : typingIndicator.metadata ,
                "methodName":methodName
            ]
        } else {
            return nil
        }
    
    }
    
    
    private func getMessageReceiptMap(messageReceipt: MessageReceipt?, methodName:String="")-> [String: Any]? {
        
        
        let receiverType : String
        switch messageReceipt?.receiverType{
        case .user:
            receiverType = "user"
        case .group:
            receiverType = "group"
        default:
            receiverType = "user"
        }
        
        let receiptType : String
        switch messageReceipt?.receiptType{
        case .delivered:
            receiptType = "delivered"
        case .read:
            receiptType = "read"
        default:
            receiptType = "delivered"
        }
        
    
        
        if let messageReceipt = messageReceipt {
            return [
                "messageId" : messageReceipt.messageId,
                "sender" : getUserMap(user: messageReceipt.sender) ,
                "receivertype" : receiverType ,
                "receiverId" : messageReceipt.receiverId ,
                "timestamp" : messageReceipt.timeStamp ,
                "receiptType" : receiptType ,
                "deliveredAt" : messageReceipt.deliveredAt ,
                "readAt" : messageReceipt.readAt,
                "methodName":methodName
            ]
        } else {
            return nil
        }
    
    }
    
    private func getTransientMessageMap(transientMessage: TransientMessage?, methodName:String="")-> [String: Any]? {
        let receiverType : String
        switch transientMessage?.receiverType{
        case .user:
            receiverType = "user"
        case .group:
            receiverType = "group"
        default:
            receiverType = "user"
        }
        
        if let transientMessage = transientMessage {
            return [
                "receiverId" : transientMessage.receiverID ,
                "receiverType" : receiverType,
                "data" : transientMessage.data as Any ,
                "methodName":methodName,
                "sender" : getUserMap(user: transientMessage.sender) ,
            ]
        } else {
            return nil
        }
    
    }
    
    private func toJson(dictionary: [String: Any]?)-> String? {
        if let dictionary = dictionary {
            if let jsonData = (try? JSONSerialization.data(withJSONObject: dictionary , options: [])){
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
                return jsonString
            } else {
                return nil
            }
        }else {
            return nil
        }
        
    }
    
    private func tagConversation(args: [String: Any], result: @escaping FlutterResult){
        
        let conversationWith = args["conversationWith"] as? String ?? ""
        let conversationType = args["conversationType"] as? String ?? ""
        let tags = args["tags"] as? [String] ?? []
        let passedConversationType:CometChat.ConversationType
        switch conversationType {
        case "user":
            passedConversationType =  CometChat.ConversationType.user
        default:
            passedConversationType =   CometChat.ConversationType.group
        }
        
        CometChat.tagConversation(conversationWith: conversationWith, conversationType: passedConversationType,
                        tags: tags        ,onSuccess: { (conversation) in
            print("success \(String(describing: conversation?.stringValue()))")
            result(self.getConversationMap(conversation: conversation))
        }) { (exception) in
            print("here exception \(String(describing: exception?.errorDescription))")
            result(FlutterError(code: exception?.errorCode ?? "",
                                message: exception?.errorDescription, details: exception?.debugDescription))
        }
        
    
    }
    
    private func connect( result: @escaping FlutterResult){
        CometChat.connect()
    }
    
    private func disconnect( result: @escaping FlutterResult){
        CometChat.disconnect()
    }
    
    private func isExtensionEnabled(args: [String: Any], result: @escaping FlutterResult){
        
        let extensionId = args["extensionId"] as? String ?? ""
        
        CometChat.isExtensionEnabled(extensionId: extensionId) { res in
            result(res)
        } onError: { exception in
            result(FlutterError(code: exception?.errorCode ?? "",
                                message: exception?.errorDescription, details: exception?.debugDescription))

        }

        
        
    }
    
    
    private func setSource(args: [String: Any], result: @escaping FlutterResult){
        let resource = args["resource"] as? String ?? ""
        let platform = args["platform"] as? String ?? ""
        let language = args["language"] as? String ?? ""
        CometChat.setSource(resource: resource, platform: platform, language: language)
        result(nil)
    }
    
    private func setPlatformParams(args: [String: Any], result: @escaping FlutterResult){
        let platform = args["platform"] as? String ?? ""
        let sdkVersion = args["sdkVersion"] as? String ?? ""
        CometChat.setPlatformParams(platform: platform, sdkVersion: sdkVersion)
        result(true)
    }


    private func getAppEntityMap(passedEntity: AppEntity?)-> [String: Any]? {
        
        let appEntityMap: [String: Any]?
        
        if let appEntityObjectPassed  = passedEntity{
            
            if(appEntityObjectPassed is User){
                appEntityMap  = getUserMap(user: appEntityObjectPassed as! User);
            }else if (appEntityObjectPassed is Group){
                appEntityMap  = getGroupMap(group: appEntityObjectPassed as! Group)
            }else if(appEntityObjectPassed is BaseMessage){
                
                appEntityMap  = getMessageMap(message: appEntityObjectPassed as! BaseMessage)
            }else {
                return nil;
            }
            return appEntityMap
        }else{
            return nil
        }
        
        return nil
    
    }
    
    
}


//MARK: - ------------ Cometchat Message Delegates -----------------
extension SwiftCometchatPlugin : CometChatMessageDelegate{
    
    public func onTextMessageReceived(textMessage: TextMessage) {
        guard let eventSink = self.sink else { return }
        let parsedMsg = self.getMessageMap(message: textMessage,methodName: "onTextMessageReceived")
        print("From textmsg ",parsedMsg)
        eventSink(parsedMsg)
        //return parsedMsg obj back to flutter
    }
    
    public func onMediaMessageReceived(mediaMessage: MediaMessage) {
        guard let eventSink = self.sink else { return }
        let parsedMsg = self.getMessageMap(message: mediaMessage, methodName: "onMediaMessageReceived")
        print("From mediaMsg ",parsedMsg)
        eventSink(parsedMsg)
    }
    
    public func onCustomMessageReceived(customMessage: CustomMessage) {
        guard let eventSink = self.sink else { return }
        let parsedMsg = self.getMessageMap(message: customMessage, methodName: "onCustomMessageReceived")
        print("From textmsg ",parsedMsg)
        eventSink(parsedMsg)
        
    }
    
    public func onTypingStarted(_ typingDetails : TypingIndicator) {
        print("On Typingh Started")
        guard let eventSink = self.sink else { return }
        let parsedIndicator = self.getTypingIndicatorMap(typingIndicator: typingDetails, methodName: "onTypingStarted")
        print("From textmsg ",parsedIndicator)
        eventSink(parsedIndicator)
        print("Typing started  at other end")
    }
    
    public func onTypingEnded(_ typingDetails: TypingIndicator) {
        guard let eventSink = self.sink else { return }
        let parsedIndicator = self.getTypingIndicatorMap(typingIndicator: typingDetails, methodName: "onTypingEnded")
        print("From typing ended ",parsedIndicator)
        eventSink(parsedIndicator)
        print("Typing end at other end")
    }
    
    public func onTransisentMessageReceived(_ message: TransientMessage) {
        guard let eventSink = self.sink else { return }
        let parsedTransientMessage = self.getTransientMessageMap( transientMessage : message, methodName: "onTransientMessageReceived")
        print("From textmsg ",parsedTransientMessage)
        eventSink(parsedTransientMessage)
        print("Transient Message")
       }
    
    public func onMessagesDelivered(receipt: MessageReceipt) {
        guard let eventSink = self.sink else { return }
        print("Message Receipt",receipt.messageId)
        let parsedMsg = self.getMessageReceiptMap(messageReceipt: receipt, methodName: "onMessagesDelivered")
        print("From textmsg ",parsedMsg)
        eventSink(parsedMsg)
        print("Typing end at other end")
    }
    
    public func onMessagesRead(receipt: MessageReceipt) {
        guard let eventSink = self.sink else { return }
        let parsedMsg = self.getMessageReceiptMap(messageReceipt: receipt, methodName: "onMessagesRead")
        print("From textmsg ",parsedMsg)
        eventSink(parsedMsg)
        print("Typing end at other end")
    }
    
    public func onMessageEdited(message: BaseMessage) {
        guard let eventSink = self.sink else { return }
        print("Message before parse")
        print(message.metaData)
        let parsedMsg = self.getMessageMap(message: message, methodName: "onMessageEdited")
        print("From editMessage ",parsedMsg)
        eventSink(parsedMsg)
        print("Typing end at other end")
    }
    
    public func onMessageDeleted(message: BaseMessage) {
        guard let eventSink = self.sink else { return }
        let parsedMsg = self.getMessageMap(message: message,methodName: "onMessageDeleted")
        print("From textmsg  ",parsedMsg)
        eventSink(parsedMsg)
        print("Typing end at other end")
    }
    
}

//MARK: - ------------ Cometchat User Delegates -----------------
extension SwiftCometchatPlugin : CometChatUserDelegate{
    
    public func onUserOnline(user: User) {
        print("on User Online ")
        guard let eventSink = self.sink else { return }
        let parsedUser = self.getUserMap(user: user,methodName: "onUserOnline")
        print("From User ",parsedUser)
        eventSink(parsedUser)
        print("on User Online ")
    }
    
    public func onUserOffline(user: User) {
        guard let eventSink = self.sink else { return }
        let parsedUser = self.getUserMap(user: user,methodName: "onUserOffline")
        print("From User ",parsedUser)
        eventSink(parsedUser)
    }
}


//MARK: - ------------ Cometchat Group Delegates -----------------
extension SwiftCometchatPlugin : CometChatGroupDelegate{
    public func onGroupMemberJoined(action: ActionMessage, joinedUser: User, joinedGroup: Group) {
        print("From onGroupMemberJoined ")
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["action"] = getMessageMap(message: action)
        responseMap["joinedUser"] = getUserMap(user: joinedUser)
        responseMap["joinedGroup"] = getGroupMap(group:joinedGroup)
        responseMap["methodName"] = "onGroupMemberJoined"
        print("From User ",responseMap)
        eventSink(responseMap)
    }
    
    public func onGroupMemberLeft(action: ActionMessage, leftUser: User, leftGroup: Group) {
        print("From onGroupMemberLeft ")
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["action"] = getMessageMap(message: action)
        responseMap["leftUser"] = getUserMap(user: leftUser)
        responseMap["leftGroup"] = getGroupMap(group:leftGroup)
        responseMap["methodName"] = "onGroupMemberLeft"
        print("From User ",responseMap)
        eventSink(responseMap)
    }
    
    public func onGroupMemberKicked(action: ActionMessage, kickedUser: User, kickedBy: User, kickedFrom: Group) {
        print("From onGroupMemberKicked ")
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["action"] = getMessageMap(message: action)
        responseMap["kickedUser"] = getUserMap(user: kickedUser)
        responseMap["kickedBy"] = getUserMap(user: kickedBy)
        responseMap["kickedFrom"] = getGroupMap(group:kickedFrom)
        responseMap["methodName"] = "onGroupMemberKicked"
        print("From User ",responseMap)
        eventSink(responseMap)
    }
    
    public func onGroupMemberBanned(action: ActionMessage, bannedUser: User, bannedBy: User, bannedFrom: Group) {
        print("From onGroupMemberBanned ")
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["action"] = getMessageMap(message: action)
        responseMap["bannedUser"] = getUserMap(user: bannedUser)
        responseMap["bannedBy"] = getUserMap(user: bannedBy)
        responseMap["bannedFrom"] = getGroupMap(group:bannedFrom)
        responseMap["methodName"] = "onGroupMemberBanned"
        print("From User ",responseMap)
        eventSink(responseMap)
    }
    
    public func onGroupMemberUnbanned(action: ActionMessage, unbannedUser: User, unbannedBy: User, unbannedFrom: Group) {
        print("From onGroupMemberUnbanned ")
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["action"] = getMessageMap(message: action)
        responseMap["unbannedUser"] = getUserMap(user: unbannedUser)
        responseMap["unbannedBy"] = getUserMap(user: unbannedBy)
        responseMap["unbannedFrom"] = getGroupMap(group:unbannedFrom)
        responseMap["methodName"] = "onGroupMemberUnbanned"
        print("From User ",responseMap)
        eventSink(responseMap)
    }
    
    public func onGroupMemberScopeChanged(action: ActionMessage, scopeChangeduser: User, scopeChangedBy: User, scopeChangedTo: String, scopeChangedFrom: String, group: Group) {
        print("From onGroupMemberScopeChanged ")
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["action"] = getMessageMap(message: action)
        responseMap["updatedUser"] = getUserMap(user: scopeChangeduser)
        responseMap["updatedBy"] = getUserMap(user: scopeChangedBy)
        responseMap["scopeChangedTo"] = scopeChangedTo
        responseMap["scopeChangedFrom"] = scopeChangedFrom
        responseMap["group"] = getGroupMap(group:group)
        responseMap["methodName"] = "onGroupMemberScopeChanged"
        print("From User ",responseMap)
        eventSink(responseMap)
    }
    
    public func onMemberAddedToGroup(action: ActionMessage, addedBy: User, addedUser: User, addedTo: Group) {
        print("From onMemberAddedToGroup ")
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["action"] = getMessageMap(message: action)
        responseMap["addedby"] = getUserMap(user: addedBy)
        responseMap["userAdded"] = getUserMap(user: addedUser)
        responseMap["addedTo"] = getGroupMap(group:addedTo)
        responseMap["methodName"] = "onMemberAddedToGroup"
        print("From User ",responseMap)
        eventSink(responseMap)
    }
    
    
    
    
}



//MARK: - ------------ Cometchat Login Delegates -----------------
extension SwiftCometchatPlugin : CometChatLoginDelegate{
    public func onLoginSuccess(user: User) {
        guard let eventSink = self.sink else { return }
        let parsedUser = self.getUserMap(user: user,methodName: "onLoginSuccess")
        print("From User ",parsedUser)
        eventSink(parsedUser)
    }
    
    public func onLoginFailed(error: CometChatException?) {
        guard let eventSink = self.sink else { return }
        let parsedUser = self.getCometChatExceptionMap(error: error , methodName: "onLoginFailed")
        print("From Login Failed ",parsedUser)
        eventSink(parsedUser)
    }
    
    public func onLogoutSuccess() {
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["methodName"] = "onLogoutSuccess"
        print("From Logout ",responseMap)
        eventSink(responseMap)
    }
    
    public func onLogoutFailed(error: CometChatException?) {
        guard let eventSink = self.sink else { return }
        let parsedUser = self.getCometChatExceptionMap(error: error , methodName: "onLogoutFailed")
        print("From Logout Failed ",parsedUser)
        eventSink(parsedUser)
    }
    
    
   private func getCometChatExceptionMap(error: CometChatException?, methodName: String  = "") -> [String: Any]? {
        if let error = error {
            return [
                "code" : error.errorCode ,
                "details" : error.description,
                "messsage" : error.errorDescription ,
                "methodName":methodName
            ]
        } else {
            return nil
        }
        
    }
    
}

extension SwiftCometchatPlugin : CometChatConnectionDelegate{
    public func connecting() {
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["methodName"] = "onConnecting"
        print("From connecting ",responseMap)
        eventSink(responseMap)
    }
    
    public func connected() {
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["methodName"] = "onConnected"
        print("From connected ",responseMap)
        eventSink(responseMap)
    }
    
    public func disconnected() {
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["methodName"] = "onDisconnected"
        print("From disconnected ",responseMap)
        eventSink(responseMap)
    }

    public func onfeatureThrottled(){
        guard let eventSink = self.sink else { return }
        var responseMap: [String: Any?] = [:]
        responseMap["methodName"] = "onFeatureThrottled"
        print("From onfeatureThrottled ",responseMap)
        eventSink(responseMap)
    }
}



//MARK: - ------------- FlutterEventChannel Delegates -----------------
extension SwiftCometchatPlugin : FlutterStreamHandler{
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        debugPrint("On Listen Call")
        self.sink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.sink = nil
        return nil
    }
    
    
   
    
    private func toBaseMessage(messageMap : [String:Any?]) -> BaseMessage {
        let receiverType : CometChat.ReceiverType
        switch messageMap["receiverType"] as! String {
        case "user":
            receiverType =  CometChat.ReceiverType.user
        default:
            receiverType =   CometChat.ReceiverType.group
        }
        let sender: [String:AnyObject?] = messageMap["sender"] as? Dictionary<String,AnyObject?> ?? [:]
        let receaver:[String:AnyObject?] = messageMap["receiver"] as? Dictionary<String,AnyObject?> ?? [:]
        
        var type : CometChat.MessageType = CometChat.MessageType.text
        
            switch messageMap["type"] as! String {
            case "text" :
                type = CometChat.MessageType.text
            case "image":
                type = CometChat.MessageType.image
            case "video":
                type = CometChat.MessageType.video
            case "file":
                type = CometChat.MessageType.file
            case "audio":
                type = CometChat.MessageType.audio
            default:
                type = CometChat.MessageType.text
            }
        
        let rec : String;
        if(receiverType == CometChat.ReceiverType.user){
            rec = receaver["uid"] as? String ?? ""
        }else{
            rec = receaver["guid"] as? String ?? ""
        }
        
        print("receaver id is \(rec)")
        
        var message = BaseMessage(receiverUid: rec, messageType: type, receiverType: receiverType)
        
        message.senderUid = sender["uid"] as! String
        message.id = messageMap["id"] as! Int
        message.sender = User(uid: sender["uid"] as! String,
                              name: sender["name"] as! String)
        
        if(receiverType ==  CometChat.ReceiverType.group){
            message.receiver = Group(guid: receaver["guid"] as! String, name: receaver["guid"] as! String, groupType: CometChat.groupType.public, password: nil)
        }else{
            message.receiver = User(uid: receaver["uid"] as! String,
                                   name: receaver["name"] as! String)
        }
        
        
        
        return message
    }
    
    
    private func toTextMessage(messageMap : [String:Any?]) -> BaseMessage {
        let receiverType : CometChat.ReceiverType
        switch messageMap["receiverType"] as! String {
        case "user":
            receiverType =  CometChat.ReceiverType.user
        default:
            receiverType =   CometChat.ReceiverType.group
        }
        let sender: [String:AnyObject?] = messageMap["sender"] as? Dictionary<String,AnyObject?> ?? [:]
        let receaver:[String:AnyObject?] = messageMap["receiver"] as? Dictionary<String,AnyObject?> ?? [:]
        
        var type : CometChat.MessageType = CometChat.MessageType.text
        
            switch messageMap["type"] as! String {
            case "text" :
                type = CometChat.MessageType.text
            case "image":
                type = CometChat.MessageType.image
            case "video":
                type = CometChat.MessageType.video
            case "file":
                type = CometChat.MessageType.file
            case "audio":
                type = CometChat.MessageType.audio
            default:
                type = CometChat.MessageType.text
            }
        
        
        let message  = TextMessage(receiverUid: messageMap["receiverUid"] as! String, text: messageMap["text"] as! String , receiverType: receiverType)
        
        message.senderUid = sender["uid"] as! String
        message.id = messageMap["id"] as! Int
        message.sender = User(uid: sender["uid"] as! String,
                              name: sender["name"] as! String)
        
        if(receiverType ==  CometChat.ReceiverType.group){
            message.receiver = Group(guid: receaver["guid"] as! String, name: receaver["guid"] as! String, groupType: CometChat.groupType.public, password: nil)
        }else{
            message.receiver = User(uid: receaver["uid"] as! String,
                                   name: receaver["name"] as! String)
        }
        
        message.messageType = type
        message.tags = messageMap["tags"] as! [String]
        
        if let meta = messageMap["metadata"] as? Dictionary<String, Any> {
            message.metaData = meta ;
        }
        
        
        
        return message
    }
    
    
    
    private func toCustomMessage(messageMap : [String:Any?]) -> CustomMessage {
        let receiverType : CometChat.ReceiverType
        switch messageMap["receiverType"] as! String {
        case "user":
            receiverType =  CometChat.ReceiverType.user
        default:
            receiverType =   CometChat.ReceiverType.group
        }
        let sender: [String:AnyObject?] = messageMap["sender"] as? Dictionary<String,AnyObject?> ?? [:]
        let receaver:[String:AnyObject?] = messageMap["receiver"] as? Dictionary<String,AnyObject?> ?? [:]
        
        let customData: Dictionary<String, Any> ;
        
        if let localCustomData = messageMap["customData"] as? Dictionary<String, Any>  {
            customData  = localCustomData
        }else{
            
            customData  = [String:Any]()
        }
        
        let message  = CustomMessage(receiverUid: messageMap["receiverUid"] as! String, receiverType: receiverType, customData:  customData)
        
        
        message.senderUid = sender["uid"] as! String
        message.id = messageMap["id"] as! Int
        message.sender = User(uid: sender["uid"] as! String,
                              name: sender["name"] as! String)
        
        if(receiverType ==  CometChat.ReceiverType.group){
            message.receiver = Group(guid: receaver["guid"] as! String, name: receaver["guid"] as! String, groupType: CometChat.groupType.public, password: nil)
        }else{
            message.receiver = User(uid: receaver["uid"] as! String,
                                   name: receaver["name"] as! String)
        }
        
        message.type = messageMap["type"] as! String
        message.tags = messageMap["tags"] as! [String]
        
        if let meta = messageMap["metadata"] as? Dictionary<String, Any> {
            message.metaData = meta ;sender["uid"] as! String
        }
        
        return message
    }
    
    private func toGroupMember(groupMemberMap : [String:Any?]) -> GroupMember {
        let passedScope = groupMemberMap["scope"] as? String ?? ""
        let scope : CometChat.GroupMemberScopeType = passedScope == "admin" ? .admin : passedScope == "moderator" ? .moderator : .participant
        let groupMember  = GroupMember(UID: groupMemberMap["uid"] as! String, groupMemberScope: scope)
        return groupMember
    }
    
    
}


//MARK: Calling Functions
extension SwiftCometchatPlugin: CometChatCallDelegate {
    
    private func getUserAuthToken(result: @escaping FlutterResult){
        let token: String? = CometChat.getUserAuthToken()
        if (token != nil){
            result(token)
        }else{
            result(FlutterError(code: "Error", message: "User auth token is null", details: "User is not logged in."))
        }
    }
    
    private func initiateCall(args: [String: Any], result: @escaping FlutterResult){
        let receiverUid = args["receiverUid"] as! String
        let receiverType = args["receiverType"] as! String
        let callType =  args["callType"] as! String
        let call = Call(receiverId: receiverUid, callType: getCallType(from: callType), receiverType: getReceiverType(from: receiverType))

        CometChat.initiateCall(call: call) { calls in
            result(self.callToMap(call: calls))
        } onError: { error in
            result(FlutterError(code: error!.errorCode, message: error!.description, details: error!.errorDescription))
        }

    }

    private func acceptCall(args: [String: Any], result: @escaping FlutterResult){
        let sessionID = args["sessionID"] as? String
        
        guard let sessionID = sessionID else {
            result(FlutterError(code: "sessionID Missing", message: "Session id not found in args in method channel", details: "Session ID is nil"))
            
            return
        }
        
        CometChat.acceptCall(sessionID: sessionID) { call in
            result(self.callToMap(call: call))
        } onError: { error in
            result(FlutterError(code: error!.errorCode, message: error!.description, details: error!.errorDescription))
        }

    }
    
    private func rejectCall(args: [String: Any], result: @escaping FlutterResult){
        let sessionID = args["sessionID"] as! String
        let status = args["status"] as! String
        
        CometChat.rejectCall(sessionID: sessionID, status: getCallStatus(from: status)) { call in
            result(self.callToMap(call: call))
        } onError: { error in
            result(FlutterError(code: error!.errorCode, message: error!.description, details: error!.errorDescription))
        }

    }
    
    private func endCall(args: [String: Any], result: @escaping FlutterResult){
        let sessionID = args["sessionID"] as! String
        
        CometChat.endCall(sessionID: sessionID) { call in
            result(self.callToMap(call: call))
        } onError: { error in
            result(FlutterError(code: error!.errorCode, message: error!.description, details: error!.errorDescription))
        }

    }
    
    private func callToMap(call: Call?) -> [String: Any?] {
        guard let call = call else {
            return [:]
        }
        var callInitiator: [String: Any?]? = [:]
        var callReceiver: [String: Any?]? = [:]
        var mataData: [String: Any?]? = nil
        var receiver: [String: Any?]? = nil
        if let receiverUser = (call.receiver as? User) {
            receiver = getUserMap(user: receiverUser)
        }else if let receiverGroup = (call.receiver as? Group) {
            receiver = getGroupMap(group: receiverGroup)
        }
        if call.metaData != nil {
            mataData = call.metaData
        }
        
        if let user = (call.callInitiator as? User) {
            callInitiator = getUserMap(user: user)
        }else if let group = call.callInitiator as? Group {
            callInitiator = getGroupMap(group: group)
        }
        
        if(call.callReceiver is User ){
            callReceiver = getUserMap(user: (call.callReceiver as? User))
        }else{
            callReceiver = getGroupMap(group: (call.callReceiver as? Group))
        }
        
        
        var category : String = "custom"
        switch call.messageCategory {
        case CometChat.MessageCategory.message:
            category = "message"
        case CometChat.MessageCategory.action:
            category = "action"
        case CometChat.MessageCategory.custom:
            category = "custom"
        case CometChat.MessageCategory.call:
            category = "call"
        default:
            category = "custom"
        }
        
        
        return [
            "sessionId": call.sessionID ?? "",
            "callStatus": getCallStatusString(from: call.callStatus),
            "action": call.action ?? "",
            "rawData": call.rawData,
            "category": category,
            "initiatedAt": Int(call.initiatedAt), //changes
            "joinedAt": Int(call.joinedAt), //changes
            "callInitiator": callInitiator ?? [:],
            "callReceiver": callReceiver ?? [:],
            "id": call.id,
            "muid": call.muid,
            "sender": getUserMap(user: call.sender),
            "receiver": receiver ?? [:],
            "receiverUid": call.receiverUid,
            "type": getCallTypeString(from: call.callType),
            "receiverType": getReceiverTypeString(from: call.receiverType),
            "sentAt": Int(call.sentAt),
            "deliveredAt": Int(call.deliveredAt),
            "readAt": Int(call.readAt),
            "metadata": mataData,
            "readByMeAt": Int(call.readByMeAt),
            "deliveredToMeAt": Int(call.deliveredToMeAt),
            "deletedAt": Int(call.deletedAt),
            "editedAt": Int(call.editedAt),
            "deletedBy": call.deletedBy,
            "editedBy": call.editedBy,
            "updatedAt": Int(call.updatedAt),
            "conversationId": call.conversationId,
            "parentMessageId": call.parentMessageId,
            "replyCount": call.replyCount
        ]
    }
    
    private func getCallStatusString(from callStatus: CometChat.callStatus) -> String {
        switch callStatus{
        case .initiated:
            return "initiated"
        case .ongoing:
            return "ongoing"
        case .unanswered:
            return "unanswered"
        case .rejected:
            return "rejected"
        case .busy:
            return "busy"
        case .cancelled:
            return "cancelled"
        case .ended:
            return "ended"
        @unknown default:
            return "nil"
        }
    }
    
    private func getCallTypeString(from call: CometChat.CallType) -> String? {
        switch call{
        case CometChat.CallType.audio:
            return "audio"
        case CometChat.CallType.video:
            return "video"
        default:
            print("getCallTypeString func call type not found")
            return nil
        }
    }
    //Receiver
    private func getReceiverTypeString(from receiver: CometChat.ReceiverType) -> String? {
        switch receiver{
        case CometChat.ReceiverType.group:
            return "group"
        case CometChat.ReceiverType.user:
            return "user"
        default:
            print("getReceiverTypeString func call type not found")
            return nil
        }
    }
    
    private func getCallType(from callString: String) -> CometChat.CallType {
        switch callString {
        case "audio":
            return CometChat.CallType.audio
        case "video":
            return CometChat.CallType.video
        default:
            print("getCallType func call type not found")
            return CometChat.CallType.audio
        }
    }
    
    private func getReceiverType(from receiverString: String) -> CometChat.ReceiverType {
        switch receiverString {
        case "group":
            return CometChat.ReceiverType.group
        case "user":
            return CometChat.ReceiverType.user
        default:
            print("getReceiverType func receiver type not found")
            return CometChat.ReceiverType.user
        }
    }
    
    
    private func getCallStatus(from callString: String) -> CometChat.callStatus {
        switch callString {
        case "initiated":
            return CometChat.callStatus.initiated
        case "unanswered":
            return CometChat.callStatus.unanswered
        case "busy":
            return CometChat.callStatus.busy
        case "ended":
            return CometChat.callStatus.ended
        case "rejected":
            return CometChat.callStatus.rejected
        case "cancelled":
            return CometChat.callStatus.cancelled
        case "ongoing":
            return CometChat.callStatus.ongoing
        default:
            print("getCallStatus func status not found")
            return CometChat.callStatus.ended
        }
    }
    
    private func getActiveCall(result: @escaping FlutterResult) {
        let activeCallObj = CometChat.getActiveCall()
        if(activeCallObj != nil){
            result(callToMap(call: activeCallObj))
        }else{
            result(nil)
        }
    }
    
    //Call Delegate functions
    public func onIncomingCallReceived(incomingCall: CometChatPro.Call?, error: CometChatPro.CometChatException?) {
        if let incomingCall = incomingCall {
            var responseMap: [String: Any] = [:]
            responseMap["call"] = callToMap(call: incomingCall)
            responseMap["methodName"] = "onIncomingCallReceived"
            sink?(responseMap)
        } else if let error = error {
            sink?(FlutterError(code: error.errorCode, message: error.errorDescription, details: error.description))
        }
    }
    
    public func onOutgoingCallAccepted(acceptedCall: CometChatPro.Call?, error: CometChatPro.CometChatException?) {
        if let acceptedCall = acceptedCall {
            var responseMap: [String: Any] = [:]
            responseMap["call"] = callToMap(call: acceptedCall)
            responseMap["methodName"] = "onOutgoingCallAccepted"
            sink?(responseMap)
        } else if let error = error {
            sink?(FlutterError(code: error.errorCode, message: error.errorDescription, details: error.description))
        }
    }
    
    public func onOutgoingCallRejected(rejectedCall: CometChatPro.Call?, error: CometChatPro.CometChatException?) {
        if let rejectedCall = rejectedCall {
            var responseMap: [String: Any] = [:]
            responseMap["call"] = callToMap(call: rejectedCall)
            responseMap["methodName"] = "onOutgoingCallRejected"
            sink?(responseMap)
        } else if let error = error {
            sink?(FlutterError(code: error.errorCode, message: error.errorDescription, details: error.description))
        }
    }
    
    public func onIncomingCallCancelled(canceledCall: CometChatPro.Call?, error: CometChatPro.CometChatException?) {
        if let canceledCall = canceledCall {
            var responseMap: [String: Any] = [:]
            responseMap["call"] = callToMap(call: canceledCall)
            responseMap["methodName"] = "onIncomingCallCancelled"
            sink?(responseMap)
        } else if let error = error {
            sink?(FlutterError(code: error.errorCode, message: error.errorDescription, details: error.description))
        }
    }
    
    public func onCallEndedMessageReceived(endedCall: Call?, error: CometChatException?) {
        if let endedCall = endedCall {
            var responseMap: [String: Any] = [:]
            responseMap["call"] = callToMap(call: endedCall)
            responseMap["methodName"] = "onCallEndedMessageReceived"
            sink?(responseMap)
        } else if let error = error {
            sink?(FlutterError(code: error.errorCode, message: error.errorDescription, details: error.description))
        }
    }

}
