class PaymentMonthModel {
  List<PaymentData>? data;
  Links? links;
  Meta? meta;

  PaymentMonthModel({this.data, this.links, this.meta});

  PaymentMonthModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PaymentData>[];
      json['data'].forEach((v) {
        data!.add(new PaymentData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class PaymentData {
  dynamic eventId;
  dynamic groupId;
  dynamic name;
  dynamic qrCode;
  dynamic description;
  dynamic startOn;
  dynamic endOn;
  dynamic paymentMonth;
  dynamic activeStatus;
  dynamic createdAt;
  dynamic updatedAt;

  PaymentData(
      {this.eventId,
        this.groupId,
        this.name,
        this.qrCode,
        this.description,
        this.startOn,
        this.endOn,
        this.paymentMonth,
        this.activeStatus,
        this.createdAt,
        this.updatedAt});

  PaymentData.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    groupId = json['group_id'];
    name = json['name'];
    qrCode = json['qr_code'];
    description = json['description'];
    startOn = json['start_on'];
    endOn = json['end_on'];
    paymentMonth = json['payment_month'];
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
    data['payment_month'] = this.paymentMonth;
    data['active_status'] = this.activeStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Links {
  dynamic first;
  dynamic last;
  dynamic prev;
  dynamic next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  dynamic currentPage;
  dynamic from;
  dynamic lastPage;
  List<Links>? links;
  dynamic path;
  dynamic perPage;
  dynamic to;
  dynamic total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

