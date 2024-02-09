// class NotificationOnClickModel {
//   dynamic  screenType;
//   dynamic orderId;
//   dynamic receiverDetails;
//   dynamic receiverType;
//
//   NotificationOnClickModel(
//       {this.screenType, this.orderId, this.receiverDetails, this.receiverType});
//
//   NotificationOnClickModel.fromJson(Map<String, dynamic> json) {
//     screenType = json['screen_type'];
//     orderId = json['order_id'];
//     receiverDetails = json['receiver_details'];
//     receiverType = json['receiver_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['screen_type'] = this.screenType;
//     data['order_id'] = this.orderId;
//     data['receiver_details'] = this.receiverDetails;
//     data['receiver_type'] = this.receiverType;
//     return data;
//   }
// }
class NotificationOnClickModel {
  String? screenType;
  String? pLink;
  String? pDescription;
  String? title;
  int? pId;
  bool? isAnother;
  bool? isProduct;
  String? receiverType;
  dynamic orderId;

  NotificationOnClickModel(
      {this.screenType,
        this.pLink,
        this.pDescription,
        this.title,
        this.pId,
        this.isProduct,
        this.orderId,
        this.isAnother,
        this.receiverType});

  NotificationOnClickModel.fromJson(Map<String, dynamic> json) {
    screenType = json['screen_type'];
    pLink = json['p_link'];
    pDescription = json['p_description'];
    title = json['title'];
    isProduct = json['is_product'];
    pId = json['p_id'];
    orderId= json['order_id'];
    isAnother = json['is_another'];
    receiverType = json['receiver_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['screen_type'] = this.screenType;
    data['p_link'] = this.pLink;
    data['p_description'] = this.pDescription;
    data['title'] = this.title;
    data['is_product'] = this.isProduct;
    data['p_id'] = this.pId;
    data['order_id'] = this.orderId;
    data['is_another'] = this.isAnother;
    data['receiver_type'] = this.receiverType;
    return data;
  }
}
