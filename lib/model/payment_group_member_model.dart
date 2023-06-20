class PaymentGroupMemberModel {
  List<PaymentGroupMember>? data;

  PaymentGroupMemberModel({this.data});

  PaymentGroupMemberModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PaymentGroupMember>[];
      json['data'].forEach((v) {
        data!.add(new PaymentGroupMember.fromJson(v));
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

class PaymentGroupMember {
  int? groupMemberId;
  User? user;
  int? approveStatus;
  String? memberType;
  bool? has_payment;

  PaymentGroupMember(
      {this.groupMemberId, this.user, this.approveStatus, this.memberType});

  PaymentGroupMember.fromJson(Map<String, dynamic> json) {
    groupMemberId = json['group_member_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    approveStatus = json['approve_status'];
    memberType = json['member_type'];
    has_payment = json['has_payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_member_id'] = this.groupMemberId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['approve_status'] = this.approveStatus;
    data['member_type'] = this.memberType;
    data['has_payment'] = this.has_payment;
    return data;
  }
}

class User {
  int? userId;
  String? nameEn;
  String? nameFr;
  String? email;
  String? mobileCode;
  String? mobile;
  String? profileImage;
  String? dateOfBirth;
  String? address;
  String? groupType;
  String? userRole;
  String? deviceToken;

  User(
      {this.userId,
      this.nameEn,
      this.nameFr,
      this.email,
      this.mobileCode,
      this.mobile,
      this.profileImage,
      this.dateOfBirth,
      this.address,
      this.groupType,
      this.userRole,
      this.deviceToken});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    nameEn = json['name_en'];
    nameFr = json['name_fr'];
    email = json['email'];
    mobileCode = json['mobile_code'];
    mobile = json['mobile'];
    profileImage = json['profile_image'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
    groupType = json['group_type'];
    userRole = json['user_role'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name_en'] = this.nameEn;
    data['name_fr'] = this.nameFr;
    data['email'] = this.email;
    data['mobile_code'] = this.mobileCode;
    data['mobile'] = this.mobile;
    data['profile_image'] = this.profileImage;
    data['date_of_birth'] = this.dateOfBirth;
    data['address'] = this.address;
    data['group_type'] = this.groupType;
    data['user_role'] = this.userRole;
    data['device_token'] = this.deviceToken;
    return data;
  }
}
