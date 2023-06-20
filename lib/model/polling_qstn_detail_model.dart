/*
class PollingQstnDetailsModel {
  Data? data;

  PollingQstnDetailsModel({this.data});

  PollingQstnDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? pollingId;
  String? name;
  String? image;
  String? description;
  String? startOn;
  String? endOn;
  int? activeStatus;
  int? createdBy;
  List<PollingQuestion>? pollingQuestion;

  Data(
      {this.pollingId,
        this.name,
        this.image,
        this.description,
        this.startOn,
        this.endOn,
        this.activeStatus,
        this.createdBy,
        this.pollingQuestion});

  Data.fromJson(Map<String, dynamic> json) {
    pollingId = json['polling_id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    startOn = json['start_on'];
    endOn = json['end_on'];
    activeStatus = json['active_status'];
    createdBy = json['created_by'];
    if (json['polling_question'] != null) {
      pollingQuestion = <PollingQuestion>[];
      json['polling_question'].forEach((v) {
        pollingQuestion!.add(new PollingQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polling_id'] = this.pollingId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['start_on'] = this.startOn;
    data['end_on'] = this.endOn;
    data['active_status'] = this.activeStatus;
    data['created_by'] = this.createdBy;
    if (this.pollingQuestion != null) {
      data['polling_question'] =
          this.pollingQuestion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PollingQuestion {
  int? pollingQuestionId;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  int? option1Avg;
  int? option2Avg;
  int? option3Avg;

  PollingQuestion(
      {this.pollingQuestionId,
        this.question,
        this.option1,
        this.option2,
        this.option3,
        this.option1Avg,
        this.option2Avg,
        this.option3Avg});

  PollingQuestion.fromJson(Map<String, dynamic> json) {
    pollingQuestionId = json['polling_question_id'];
    question = json['question'];
    option1 = json['option_1'];
    option2 = json['option_2'];
    option3 = json['option_3'];
    option1Avg = json['option_1_avg'];
    option2Avg = json['option_2_avg'];
    option3Avg = json['option_3_avg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polling_question_id'] = this.pollingQuestionId;
    data['question'] = this.question;
    data['option_1'] = this.option1;
    data['option_2'] = this.option2;
    data['option_3'] = this.option3;
    data['option_1_avg'] = this.option1Avg;
    data['option_2_avg'] = this.option2Avg;
    data['option_3_avg'] = this.option3Avg;
    return data;
  }
}
*/

class PollingQstnDetailsModel {
  Data? data;
  String? massage;
  bool? status;

  PollingQstnDetailsModel({this.data, this.massage, this.status});

  PollingQstnDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    massage = json['massage'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['massage'] = this.massage;
    data['status'] = this.status;

    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }

    return data;
  }
}

class Data {
  int? pollingId;
  int? groupId;
  String? name;
  String? image;
  String? description;
  String? startOn;
  String? endOn;
  int? activeStatus;
  int? createdBy;
  int? pollingHour;
  bool? currentTimeBetween;
  List<PollingQuestion>? pollingQuestion;

  Data(
      {this.pollingId,
        this.groupId,
        this.name,
        this.image,
        this.description,
        this.startOn,
        this.endOn,
        this.activeStatus,
        this.createdBy,
        this.pollingHour,
        this.currentTimeBetween,
        this.pollingQuestion});

  Data.fromJson(Map<String, dynamic> json) {
    pollingId = json['polling_id'];
    groupId = json['group_id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    startOn = json['start_on'];
    endOn = json['end_on'];
    activeStatus = json['active_status'];
    createdBy = json['created_by'];
    pollingHour = json['polling_hour'];
    currentTimeBetween = json['current_time_between'];
    if (json['polling_question'] != null) {
      pollingQuestion = <PollingQuestion>[];
      json['polling_question'].forEach((v) {
        pollingQuestion!.add(new PollingQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polling_id'] = this.pollingId;
    data['group_id'] = this.groupId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['start_on'] = this.startOn;
    data['end_on'] = this.endOn;
    data['active_status'] = this.activeStatus;
    data['created_by'] = this.createdBy;
    data['polling_hour'] = this.pollingHour;
    data['current_time_between'] = this.currentTimeBetween;
    if (this.pollingQuestion != null) {
      data['polling_question'] =
          this.pollingQuestion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PollingQuestion {
  int? pollingQuestionId;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  int? option1Avg;
  int? option2Avg;
  int? option3Avg;

  PollingQuestion(
      {this.pollingQuestionId,
        this.question,
        this.option1,
        this.option2,
        this.option3,
        this.option1Avg,
        this.option2Avg,
        this.option3Avg});

  PollingQuestion.fromJson(Map<String, dynamic> json) {
    pollingQuestionId = json['polling_question_id'];
    question = json['question'];
    option1 = json['option_1'];
    option2 = json['option_2'];
    option3 = json['option_3'];
    option1Avg = json['option_1_avg'];
    option2Avg = json['option_2_avg'];
    option3Avg = json['option_3_avg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polling_question_id'] = this.pollingQuestionId;
    data['question'] = this.question;
    data['option_1'] = this.option1;
    data['option_2'] = this.option2;
    data['option_3'] = this.option3;
    data['option_1_avg'] = this.option1Avg;
    data['option_2_avg'] = this.option2Avg;
    data['option_3_avg'] = this.option3Avg;
    return data;
  }
}
