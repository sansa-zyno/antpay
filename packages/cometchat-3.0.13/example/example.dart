import 'package:cometchat/cometchat_sdk.dart';

class TestClass with MessageListener{

  initializeCometChat(){
    String region = "REGION";
    String appId = "APP_ID";

    AppSettings appSettings= (AppSettingsBuilder()
      ..subscriptionType = CometChatSubscriptionType.allUsers
      ..region= region
      ..autoEstablishSocketConnection =  true
    ).build();

    CometChat.init(appId, appSettings, onSuccess: (String successMessage) {
      // "Initialization completed successfully  $successMessage"
    }, onError: (CometChatException excep) {
      // "Initialization failed with exception: ${excep.message}";
    });
  }

  //CometChat.addMessageListener("listenerId", this);

  @override
  void onTextMessageReceived(TextMessage textMessage) {
    // TODO: implement onTextMessageReceived
  }

  @override
  void onMediaMessageReceived(MediaMessage mediaMessage) {
    // TODO: implement onMediaMessageReceived
    super.onMediaMessageReceived(mediaMessage);
  }

  @override
  void onCustomMessageReceived(CustomMessage customMessage) {
    // TODO: implement onCustomMessageReceived
    super.onCustomMessageReceived(customMessage);
  }

  @override
  void onMessagesRead(MessageReceipt messageReceipt) {
    // TODO: implement onMessagesRead
    super.onMessagesRead(messageReceipt);
  }


  @override
  void onMessagesDelivered(MessageReceipt messageReceipt) {
    // TODO: implement onMessagesDelivered

  }

  @override
  void onMessageEdited(BaseMessage message) {
    // TODO: implement onMessageEdited

  }

  @override
  void onMessageDeleted(BaseMessage message) {
    // TODO: implement onMessageDeleted

  }

  @override
  void onTypingStarted(TypingIndicator typingIndicator) {
    // TODO: implement onTypingStarted

  }

  @override
  void onTypingEnded(TypingIndicator typingIndicator) {
    // TODO: implement onTypingEnded
    super.onTypingEnded(typingIndicator);
  }

  @override
  void onTransientMessageReceived(TransientMessage message) {
    // TODO: implement onTransientMessageReceived

  }
}