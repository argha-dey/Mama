class RegisterModel {
  User? user;
  dynamic totalPoint;
  String? accessToken;
  String? message;

  RegisterModel({this.user, this.totalPoint, this.accessToken, this.message});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    totalPoint = json['total_point'];
    accessToken = json['access_token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['total_point'] = this.totalPoint;
    data['access_token'] = this.accessToken;
    data['message'] = this.message;
    return data;
  }
}

class User {
  dynamic userId;
  dynamic name;
  dynamic email;
  dynamic mobileCode;
  dynamic mobile;
  dynamic profileImage;
  dynamic dateOfBirth;
  dynamic address;
  dynamic groupType;
  dynamic userRole;
  dynamic deviceToken;

  User(
      {this.userId,
        this.name,
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
    name = json['name'];
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
    data['name'] = this.name;
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