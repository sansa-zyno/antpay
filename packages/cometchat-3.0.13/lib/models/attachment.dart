class Attachment {
  String fileUrl;
  String fileName;
  String fileExtension;
  String fileMimeType;
  int? fileSize;

  Attachment(
    this.fileUrl,
    this.fileName,
    this.fileExtension,
    this.fileMimeType,
    this.fileSize,
  );

  factory Attachment.fromMap(dynamic map) {
    if (map == null) throw ArgumentError('The type of attachment map is null');
    return Attachment(
      map['fileUrl'],
      map['fileName'],
      map['fileExtension'],
      map['fileMimeType'],
      map['fileSize'],
    );
  }
}
