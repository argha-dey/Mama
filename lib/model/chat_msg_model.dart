class ChatMessageModel {
  dynamic id;
  dynamic created_at;
  dynamic sender_id;
  dynamic receiver_id;
  dynamic seen;
  dynamic content;
  dynamic type;
  dynamic name_en;
  dynamic name_fr;
  dynamic is_sent_by_system;
  dynamic is_redirect;
  dynamic polling_id;

  ChatMessageModel(
      {this.id,
      this.created_at,
      this.sender_id,
      this.receiver_id,
      this.seen,
      this.content,
      this.type,
      this.name_en,
      this.name_fr,
      this.is_sent_by_system,
      this.is_redirect,
      this.polling_id});

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created_at = json['created_at'];
    sender_id = json['sender_id'];
    receiver_id = json['receiver_id'];
    seen = json['seen'];
    content = json['content'];
    name_en = json['name_en'];
    name_fr = json['name_fr'];
    type = json['type'];
    is_sent_by_system = json['is_sent_by_system'];
    is_redirect = json['is_redirect'];
    polling_id = json['polling_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'created_at': this.created_at,
      'sender_id': this.sender_id,
      'receiver_id': this.receiver_id,
      'seen': this.seen,
      'content': this.content,
      'name_fr': this.name_fr,
      'name_en': this.name_en,
      'type': this.type,
      'is_sent_by_system': this.is_sent_by_system,
      'is_redirect': this.is_redirect,
      'polling_id': this.polling_id,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.created_at;
    data['sender_id'] = this.sender_id;
    data['receiver_id'] = this.receiver_id;
    data['seen'] = this.seen;
    data['content'] = this.content;
    data['name_fr'] = this.name_fr;
    data['name_en'] = this.name_en;
    data['type'] = this.type;
    data['is_sent_by_system'] = this.is_sent_by_system;
    data['is_redirect'] = this.is_redirect;
    data['polling_id'] = this.polling_id;
    return data;
  }
}
