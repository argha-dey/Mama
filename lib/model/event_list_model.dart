class EventListModel {
  List<EventData>? data;

  EventListModel({this.data});

  EventListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EventData>[];
      json['data'].forEach((v) {
        data!.add(new EventData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class EventData {
  int? eventId;
  int? groupId;
  dynamic name;
  dynamic qrCode;
  String? description;
  String? startOn;
  String? endOn;
  int? activeStatus;
  dynamic createdAt;
  dynamic updatedAt;

  EventData(
      {this.eventId,
      this.groupId,
      this.name,
      this.qrCode,
      this.description,
      this.startOn,
      this.endOn,
      this.activeStatus,
      this.createdAt,
      this.updatedAt});

  EventData.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    groupId = json['group_id'];
    name = json['name'];
    qrCode = json['qr_code'];
    description = json['description'];
    startOn = json['start_on'];
    endOn = json['end_on'];
    activeStatus = json['active_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['group_id'] = this.groupId;
    data['name'] = this.name;
    data['qr_code'] = this.qrCode;
    data['description'] = this.description;
    data['start_on'] = this.startOn;
    data['end_on'] = this.endOn;
    data['active_status'] = this.activeStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
