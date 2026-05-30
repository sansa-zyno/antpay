class CometChatException implements Exception{
  String code ;
  String? details;
  String? message;

  CometChatException(this.code, this.details,this.message);

  factory CometChatException.fromMap(dynamic map) {
    return CometChatException(
     map['code'],
      map['details'],
      map['message']
    );
  }

  @override
  String toString() {
    return 'CometChatException{code: $code, details: $details , message $message}';
  }
}