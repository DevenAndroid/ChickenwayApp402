class ModelAboutApp {
  bool? status;
  String? message;
  Data? data;

  ModelAboutApp({this.status, this.message, this.data});

  ModelAboutApp.fromJson(Map<String, dynamic> json) {
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
  AboutApp? aboutApp;

  Data({this.aboutApp});

  Data.fromJson(Map<String, dynamic> json) {
    aboutApp = json['about-app'] != null
        ? new AboutApp.fromJson(json['about-app'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aboutApp != null) {
      data['about-app'] = this.aboutApp!.toJson();
    }
    return data;
  }
}

class AboutApp {
  dynamic name;
  dynamic slug;
  dynamic content;

  AboutApp({this.name, this.slug, this.content});

  AboutApp.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['content'] = this.content;
    return data;
  }
}
