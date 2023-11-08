class ModelTermsAndCondition {
  bool? status;
  String? message;
  Data? data;

  ModelTermsAndCondition({this.status, this.message, this.data});

  ModelTermsAndCondition.fromJson(Map<String, dynamic> json) {
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
  List<TermsAndConditions>? termsAndConditions;

  Data({this.termsAndConditions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['terms-and-conditions'] != null) {
      termsAndConditions = <TermsAndConditions>[];
      json['terms-and-conditions'].forEach((v) {
        termsAndConditions!.add(TermsAndConditions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (termsAndConditions != null) {
      data['terms-and-conditions'] =
          termsAndConditions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TermsAndConditions {
 dynamic name;
 dynamic slug;
 dynamic content;

  TermsAndConditions({this.name, this.slug, this.content});

  TermsAndConditions.fromJson(Map<String, dynamic> json) {
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
