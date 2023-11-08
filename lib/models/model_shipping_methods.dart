class ModelShippingMethodsList {
  bool? status;
  String? message;
  List<ShippingData>? data;

  ModelShippingMethodsList({this.status, this.message, this.data});

  ModelShippingMethodsList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ShippingData>[];
      json['data'].forEach((v) {
        data!.add(ShippingData.fromJson(v));
      });
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

class ShippingData {
  String? zoneName;
  String? shippingTitle;
  String? shippingAmount;

  ShippingData({this.zoneName, this.shippingTitle, this.shippingAmount});

  ShippingData.fromJson(Map<String, dynamic> json) {
    zoneName = json['zone_name'];
    shippingTitle = json['shipping_title'];
    shippingAmount = json['shipping_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone_name'] = zoneName;
    data['shipping_title'] = shippingTitle;
    data['shipping_amount'] = shippingAmount;
    return data;
  }
}
