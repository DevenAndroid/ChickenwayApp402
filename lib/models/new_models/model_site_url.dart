class ModelSiteUrl {
  bool? status;
  String? message;
  List<Data>? data = [];

  ModelSiteUrl({this.status, this.message, this.data});

  ModelSiteUrl.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? cwLogo;
  String? cwUrl;
  String? mokaLogo;
  String? mokaUrl;

  Data({this.cwLogo, this.cwUrl, this.mokaLogo, this.mokaUrl});

  Data.fromJson(Map<String, dynamic> json) {
    cwLogo = json['cw_logo'];
    cwUrl = json['cw_url'];
    mokaLogo = json['moka_logo'];
    mokaUrl = json['moka_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cw_logo'] = cwLogo;
    data['cw_url'] = cwUrl;
    data['moka_logo'] = mokaLogo;
    data['moka_url'] = mokaUrl;
    return data;
  }
}
