class ModelPrivacyPolicy {
  bool? status;
  String? message;
  Data? data;

  ModelPrivacyPolicy({this.status, this.message, this.data});

  ModelPrivacyPolicy.fromJson(Map<String, dynamic> json) {
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
  List<PrivacyPolicyScreen>? privacyPolicyScreen;

  Data({this.privacyPolicyScreen});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['privacy-policy-screen'] != null) {
      privacyPolicyScreen = <PrivacyPolicyScreen>[];
      json['privacy-policy-screen'].forEach((v) {
        privacyPolicyScreen!.add(PrivacyPolicyScreen.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (privacyPolicyScreen != null) {
      data['privacy-policy-screen'] =
          privacyPolicyScreen!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrivacyPolicyScreen {
 dynamic name;
 dynamic slug;
 dynamic content;

  PrivacyPolicyScreen({this.name, this.slug, this.content});

  PrivacyPolicyScreen.fromJson(Map<String, dynamic> json) {
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
