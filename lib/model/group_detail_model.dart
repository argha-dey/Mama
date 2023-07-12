class GroupDetailModel {
  Data? data;

  GroupDetailModel({this.data});

  GroupDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic groupId;
  dynamic name;
  dynamic image;
  dynamic description;
  dynamic rating;
  dynamic totalMember;
  dynamic  terms_and_condition;
  dynamic privacy_policy;
  List<GroupMember>? groupMember;
  List<Review>? review;
  dynamic activeStatus;
  dynamic isGroupMember;
  dynamic paymentStartDate;
  dynamic paymentEndDate;
  dynamic createdAt;
  dynamic updatedAt;

  Data(
      {this.groupId,
        this.name,
        this.image,
        this.description,
        this.terms_and_condition,
        this.privacy_policy,
        this.rating,
        this.totalMember,
        this.groupMember,
        this.review,
        this.activeStatus,
        this.isGroupMember,
        this.paymentStartDate,
        this.paymentEndDate,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    terms_and_condition = json['terms_and_condition'];
    privacy_policy = json['privacy_policy'];
    rating = json['rating'];
    if (json['review'] != null) {
      review = <Review>[];
      json['review'].forEach((v) {
        review!.add(new Review.fromJson(v));
      });
    }
    totalMember = json['total_member'];
    if (json['group_member'] != null) {
      groupMember = <GroupMember>[];
      json['group_member'].forEach((v) {
        groupMember!.add(new GroupMember.fromJson(v));
      });
    }

    activeStatus = json['active_status'];
    isGroupMember = json['is_group_member'];
    paymentStartDate = json['payment_start_date'];
    paymentEndDate = json['payment_end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['terms_and_condition'] = this.terms_and_condition;
    data['privacy_policy'] = this.privacy_policy;
    data['rating'] = this.rating;
    data['total_member'] = this.totalMember;
    if (this.groupMember != null) {
      data['group_member'] = this.groupMember!.map((v) => v.toJson()).toList();
    }
    if (this.review != null) {
      data['review'] = this.review!.map((v) => v.toJson()).toList();
    }
    data['active_status'] = this.activeStatus;
    data['is_group_member'] = this.isGroupMember;
    data['payment_start_date'] = this.paymentStartDate;
    data['payment_end_date'] = this.paymentEndDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
class Review {
  dynamic reviewId;
  dynamic point;
  dynamic description;
  User? user;

  Review({this.reviewId, this.point, this.description, this.user});

  Review.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    point = json['point'];
    description = json['description'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review_id'] = this.reviewId;
    data['point'] = this.point;
    data['description'] = this.description;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
class GroupMember {
  dynamic groupMemberId;
  User? user;
  dynamic approveStatus;
  dynamic memberType;

  GroupMember(
      {this.groupMemberId, this.user, this.approveStatus, this.memberType});

  GroupMember.fromJson(Map<String, dynamic> json) {
    groupMemberId = json['group_member_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    approveStatus = json['approve_status'];
    memberType = json['member_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_member_id'] = this.groupMemberId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['approve_status'] = this.approveStatus;
    data['member_type'] = this.memberType;
    return data;
  }
}

class User {
  dynamic userId;
  dynamic nameEn;
  dynamic nameFr;
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