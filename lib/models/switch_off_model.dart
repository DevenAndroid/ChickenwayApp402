class ModelSwitchOff {
  bool? status;
  String? message;
  Data? data;

  ModelSwitchOff({this.status, this.message, this.data});

  ModelSwitchOff.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? switchOffOn;
  String? switchTitle;

  Data({this.switchOffOn, this.switchTitle});

  Data.fromJson(Map<String, dynamic> json) {
    switchOffOn = json['switch_off_on'];
    switchTitle = json['switch_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['switch_off_on'] = this.switchOffOn;
    data['switch_title'] = this.switchTitle;
    return data;
  }
}
