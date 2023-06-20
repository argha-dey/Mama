class AdminGroupListModel {
  List<Data>? data;

  AdminGroupListModel({this.data});

  AdminGroupListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? groupId;
  String? name;
  String? image;
  String? description;
  String? termsAndCondition;
  String? privacyPolicy;
  dynamic rating;
  int? totalMember;
  List<GroupMember>? groupMember;
  List<Review>? review;
  int? activeStatus;
  dynamic isGroupMember;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.groupId,
      this.name,
      this.image,
      this.description,
      this.termsAndCondition,
      this.privacyPolicy,
      this.rating,
      this.totalMember,
      this.groupMember,
      this.review,
      this.activeStatus,
      this.isGroupMember,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    termsAndCondition = json['terms_and_condition'];
    privacyPolicy = json['privacy_policy'];
    rating = json['rating'];
    totalMember = json['total_member'];
    if (json['group_member'] != null) {
      groupMember = <GroupMember>[];
      json['group_member'].forEach((v) {
        groupMember!.add(new GroupMember.fromJson(v));
      });
    }
    if (json['review'] != null) {
      review = <Review>[];
      json['review'].forEach((v) {
        review!.add(new Review.fromJson(v));
      });
    }
    activeStatus = json['active_status'];
    isGroupMember = json['is_group_member'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['terms_and_condition'] = this.termsAndCondition;
    data['privacy_policy'] = this.privacyPolicy;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class GroupMember {
  int? groupMemberId;
  User? user;
  int? approveStatus;
  String? memberType;
  bool? hasPayment;

  GroupMember(
      {this.groupMemberId,
      this.user,
      this.approveStatus,
      this.memberType,
      this.hasPayment});

  GroupMember.fromJson(Map<String, dynamic> json) {
    groupMemberId = json['group_member_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    approveStatus = json['approve_status'];
    memberType = json['member_type'];
    hasPayment = json['has_payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_member_id'] = this.groupMemberId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['approve_status'] = this.approveStatus;
    data['member_type'] = this.memberType;
    data['has_payment'] = this.hasPayment;
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

class Review {
  int? reviewId;
  String? point;
  String? description;
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
