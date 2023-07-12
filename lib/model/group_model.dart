class GroupModel {
  List<GroupData>? data;


  GroupModel({this.data, });

  GroupModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GroupData>[];
      json['data'].forEach((v) {
        data!.add(new GroupData.fromJson(v));
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

class GroupData {
  dynamic groupId;
  dynamic name;
  dynamic image;
  dynamic description;
  dynamic rating;
  dynamic totalMember;
  dynamic activeStatus;
  dynamic createdAt;
  dynamic updatedAt;

  GroupData(
      {this.groupId,
        this.name,
        this.image,
        this.description,
        this.rating,
        this.totalMember,
        this.activeStatus,
        this.createdAt,
        this.updatedAt});

  GroupData.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    rating = json['rating'];
    totalMember = json['total_member'];
    activeStatus = json['active_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['total_member'] = this.totalMember;
    data['active_status'] = this.activeStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
