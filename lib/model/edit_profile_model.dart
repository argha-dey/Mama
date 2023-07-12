class EditProfileModel {
  Data? data;
  String? message;

  EditProfileModel({this.data, this.message});

  EditProfileModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? userId;
  String? nameEn;
  String? nameFr;
  String? email;
  Null? mobileCode;
  String? mobile;
  Null? profileImage;
  Null? dateOfBirth;
  String? address;
  String? groupType;
  String? userRole;
  String? deviceToken;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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