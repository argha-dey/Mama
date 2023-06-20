class PollingCreateModel {
  String? nameEn;
  String? nameFr;
  String? image;
  String? description;
  int? activeStatus;
  String? startOn;
  String? endOn;
  int? createdBy;
  List<PollingQuestion>? pollingQuestion;

  PollingCreateModel(
      {this.nameEn,
        this.nameFr,
        this.image,
        this.description,
        this.activeStatus,
        this.startOn,
        this.endOn,
        this.createdBy,
        this.pollingQuestion});

  PollingCreateModel.fromJson(Map<String, dynamic> json) {
    nameEn = json['name_en'];
    nameFr = json['name_fr'];
    image = json['image'];
    description = json['description'];
    activeStatus = json['active_status'];
    startOn = json['start_on'];
    endOn = json['end_on'];
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
    data['name_en'] = this.nameEn;
    data['name_fr'] = this.nameFr;
    data['image'] = this.image;
    data['description'] = this.description;
    data['active_status'] = this.activeStatus;
    data['start_on'] = this.startOn;
    data['end_on'] = this.endOn;
    data['created_by'] = this.createdBy;
    if (this.pollingQuestion != null) {
      data['polling_question'] =
          this.pollingQuestion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PollingQuestion {
  String? questionEn;
  String? questionFr;
  String? option1En;
  String? option2En;
  String? option3En;
  String? option4En;
  String? option5En;
  String? option1Fr;
  String? option2Fr;
  String? option3Fr;
  String? option4Fr;
  String? option5Fr;
  String? point;
  String? answer;

  PollingQuestion(
      {this.questionEn,
        this.questionFr,
        this.option1En,
        this.option2En,
        this.option3En,
        this.option4En,
        this.option5En,
        this.option1Fr,
        this.option2Fr,
        this.option3Fr,
        this.option4Fr,
        this.option5Fr,
        this.point,
        this.answer});

  PollingQuestion.fromJson(Map<String, dynamic> json) {
    questionEn = json['question_en'];
    questionFr = json['question_fr'];
    option1En = json['option_1_en'];
    option2En = json['option_2_en'];
    option3En = json['option_3_en'];
    option4En = json['option_4_en'];
    option5En = json['option_5_en'];
    option1Fr = json['option_1_fr'];
    option2Fr = json['option_2_fr'];
    option3Fr = json['option_3_fr'];
    option4Fr = json['option_4_fr'];
    option5Fr = json['option_5_fr'];
    point = json['point'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_en'] = this.questionEn;
    data['question_fr'] = this.questionFr;
    data['option_1_en'] = this.option1En;
    data['option_2_en'] = this.option2En;
    data['option_3_en'] = this.option3En;
    data['option_4_en'] = this.option4En;
    data['option_5_en'] = this.option5En;
    data['option_1_fr'] = this.option1Fr;
    data['option_2_fr'] = this.option2Fr;
    data['option_3_fr'] = this.option3Fr;
    data['option_4_fr'] = this.option4Fr;
    data['option_5_fr'] = this.option5Fr;
    data['point'] = this.point;
    data['answer'] = this.answer;
    return data;
  }
}