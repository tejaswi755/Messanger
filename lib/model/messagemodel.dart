class MessageModel {
  String? sender;
  String? text;
  DateTime? createdon;
  bool? seen;

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    createdon = map["createdon"];
    seen = map["seen"];
  }

  Map<String, dynamic> tomap() {
    return {
      "sender":sender,
      "text":text,
      "createdon":createdon,
      "seen":seen
    };
  }
}
