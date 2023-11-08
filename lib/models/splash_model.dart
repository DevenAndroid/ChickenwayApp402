class SplashModel {
  bool? status;
  String? message;
  Data? data;

  SplashModel({this.status, this.message, this.data});

  SplashModel.fromJson(Map<String, dynamic> json) {
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
  String? splashScreen;

  Data({this.splashScreen});

  Data.fromJson(Map<String, dynamic> json) {
    splashScreen = json['splash_screen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['splash_screen'] = this.splashScreen;
    return data;
  }
}
