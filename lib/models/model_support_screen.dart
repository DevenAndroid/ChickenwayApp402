class ModelSupportScreen {
  bool? status;
  String? message;
  Data? data;

  ModelSupportScreen({this.status, this.message, this.data});

  ModelSupportScreen.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<SupportScreen>? supportScreen;

  Data({this.supportScreen});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['support_screen'] != null) {
      supportScreen = <SupportScreen>[];
      json['support_screen'].forEach((v) {
        supportScreen!.add(SupportScreen.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (supportScreen != null) {
      data['support_screen'] = supportScreen!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SupportScreen {
  dynamic iconUrl1;
  dynamic question1;
  dynamic answer1;
  dynamic iconUrl2;
  dynamic question2;
  dynamic answer2;
  dynamic iconUrl3;
  dynamic question3;
  dynamic answer3;
  dynamic iconUrl4;
  dynamic question4;
  dynamic answer4;
  dynamic iconUrl5;
  dynamic question5;
  dynamic answer5;
  dynamic iconUrl6;
  dynamic question6;
  dynamic answer6;
  dynamic iconUrl7;
  dynamic question7;
  dynamic answer7;
  dynamic iconUrl8;
  dynamic question8;
  dynamic answer8;
  dynamic iconUrl9;
  dynamic question9;
  dynamic answer9;
  dynamic iconUrl10;
  dynamic question10;
  dynamic answer10;
  dynamic phoneNumber;
  dynamic whatsappLink;
  dynamic emailField;

  SupportScreen(
      {this.iconUrl1,
      this.question1,
      this.answer1,
      this.iconUrl2,
      this.question2,
      this.answer2,
      this.iconUrl3,
      this.question3,
      this.answer3,
      this.iconUrl4,
      this.question4,
      this.answer4,
      this.iconUrl5,
      this.question5,
      this.answer5,
      this.iconUrl6,
      this.question6,
      this.answer6,
      this.iconUrl7,
      this.question7,
      this.answer7,
      this.iconUrl8,
      this.question8,
      this.answer8,
      this.iconUrl9,
      this.question9,
      this.answer9,
      this.iconUrl10,
      this.question10,
      this.answer10,
      this.phoneNumber,
      this.whatsappLink,
      this.emailField});

  SupportScreen.fromJson(Map<String, dynamic> json) {
    iconUrl1 = json['icon_url1'];
    question1 = json['question_1'];
    answer1 = json['answer_1'];
    iconUrl2 = json['icon_url2'];
    question2 = json['question_2'];
    answer2 = json['answer_2'];
    iconUrl3 = json['icon_url3'];
    question3 = json['question_3'];
    answer3 = json['answer_3'];
    iconUrl4 = json['icon_url4'];
    question4 = json['question_4'];
    answer4 = json['answer_4'];
    iconUrl5 = json['icon_url5'];
    question5 = json['question_5'];
    answer5 = json['answer_5'];
    iconUrl6 = json['icon_url6'];
    question6 = json['question_6'];
    answer6 = json['answer_6'];
    iconUrl7 = json['icon_url7'];
    question7 = json['question_7'];
    answer7 = json['answer_7'];
    iconUrl8 = json['icon_url8'];
    question8 = json['question_8'];
    answer8 = json['answer_8'];
    iconUrl9 = json['icon_url9'];
    question9 = json['question_9'];
    answer9 = json['answer_9'];
    iconUrl10 = json['icon_url10'];
    question10 = json['question_10'];
    answer10 = json['answer_10'];
    phoneNumber = json['phone_number'];
    whatsappLink = json['whatsapp_link_'];
    emailField = json['email_field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon_url1'] = iconUrl1;
    data['question_1'] = question1;
    data['answer_1'] = answer1;
    data['icon_url2'] = iconUrl2;
    data['question_2'] = question2;
    data['answer_2'] = answer2;
    data['icon_url3'] = iconUrl3;
    data['question_3'] = question3;
    data['answer_3'] = answer3;
    data['icon_url4'] = iconUrl4;
    data['question_4'] = question4;
    data['answer_4'] = answer4;
    data['icon_url5'] = iconUrl4;
    data['question_5'] = question5;
    data['answer_5'] = answer5;
    data['icon_url6'] = iconUrl6;
    data['question_6'] = question6;
    data['answer_6'] = answer6;
    data['icon_url7'] = iconUrl7;
    data['question_7'] = question7;
    data['answer_7'] = answer7;
    data['icon_url8'] = iconUrl8;
    data['question_8'] = question8;
    data['answer_8'] = answer8;
    data['icon_url9'] = iconUrl9;
    data['question_9'] = question9;
    data['answer_9'] = answer9;
    data['icon_url10'] = iconUrl10;
    data['question_10'] = question10;
    data['answer_10'] = answer10;
    data['phone_number'] = phoneNumber;
    data['whatsapp_link_'] = whatsappLink;
    data['email_field'] = emailField;
    return data;
  }
}
