class PollingListModel {
  List<PollingListData>? data;

  PollingListModel({this.data});

  PollingListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PollingListData>[];
      json['data'].forEach((v) {
        data!.add(new PollingListData.fromJson(v));
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

class PollingListData {
  dynamic pollingId;
  dynamic name;
  dynamic image;
  dynamic description;
  dynamic startOn;
  dynamic endOn;
  dynamic activeStatus;
  dynamic createdBy;
  dynamic pollingHour;
  List<PollingQuestion>? pollingQuestion;

  PollingListData(
      {this.pollingId,
      this.name,
      this.image,
      this.description,
      this.startOn,
      this.endOn,
      this.activeStatus,
      this.createdBy,
      this.pollingHour,
      this.pollingQuestion});

  PollingListData.fromJson(Map<String, dynamic> json) {
    pollingId = json['polling_id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    startOn = json['start_on'];
    endOn = json['end_on'];
    activeStatus = json['active_status'];
    createdBy = json['created_by'];
    pollingHour = json['polling_hour'];
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
    data['polling_hour'] = this.pollingHour;
    if (this.pollingQuestion != null) {
      data['polling_question'] =
          this.pollingQuestion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PollingQuestion {
  dynamic pollingQuestionId;
  dynamic question;
  dynamic option1;
  dynamic option2;
  dynamic option3;
  dynamic option4;
  dynamic option5;
  dynamic point;
  dynamic answer;

  PollingQuestion(
      {this.pollingQuestionId,
      this.question,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.option5,
      this.point,
      this.answer});

  PollingQuestion.fromJson(Map<String, dynamic> json) {
    pollingQuestionId = json['polling_question_id'];
    question = json['question'];
    option1 = json['option_1'];
    option2 = json['option_2'];
    option3 = json['option_3'];
    option4 = json['option_4'];
    option5 = json['option_5'];
    point = json['point'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polling_question_id'] = this.pollingQuestionId;
    data['question'] = this.question;
    data['option_1'] = this.option1;
    data['option_2'] = this.option2;
    data['option_3'] = this.option3;
    data['option_4'] = this.option4;
    data['option_5'] = this.option5;
    data['point'] = this.point;
    data['answer'] = this.answer;
    return data;
  }
}
