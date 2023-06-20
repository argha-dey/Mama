class EventCreateModel {
  List<EventCreateData>? data;

  EventCreateModel({
    this.data,
  });

  EventCreateModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EventCreateData>[];
      json['data'].forEach((v) {
        data!.add(new EventCreateData.fromJson(v));
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

class EventCreateData {
  dynamic groupId;
  dynamic event_id;

  dynamic name;
  dynamic description;
  dynamic start_on;
  dynamic end_on;
  dynamic active_status;

  EventCreateData({
    this.groupId,
    this.event_id,
    this.name,
    this.description,
    this.start_on,
    this.end_on,
    this.active_status,
  });

  EventCreateData.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    event_id = json['event_id'];
    name = json['name'];
    description = json['description'];
    start_on = json['start_on'];
    end_on = json['end_on'];
    active_status = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['event_id'] = this.event_id;

    data['description'] = this.description;
    data['name'] = this.name;
    data['start_on'] = this.start_on;
    data['end_on'] = this.end_on;
    data['active_status'] = this.active_status;

    return data;
  }
}
