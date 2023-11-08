class ModelAboutApp {
  bool? status;
  String? message;
  Data? data;
  String? html;

  ModelAboutApp({this.status, this.message, this.data});

  ModelAboutApp.fromHtmlJson(Map<String, dynamic> json) {
    if (!json.containsKey('content')) {
      status = false;
      return;
    }

    if (!json['content'].containsKey('rendered')) {
      status = false;
      return;
    }

    html = json['content']['rendered'];
    status = true;
  }

  ModelAboutApp.fromJson(Map<String, dynamic> json) {
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
  List<AboutApp>? aboutApp;

  Data({this.aboutApp});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['about-app'] != null) {
      aboutApp = <AboutApp>[];
      json['about-app'].forEach((v) {
        aboutApp!.add(AboutApp.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (aboutApp != null) {
      data['about-app'] = aboutApp!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    data['content'] = content;
    return data;
  }
}
