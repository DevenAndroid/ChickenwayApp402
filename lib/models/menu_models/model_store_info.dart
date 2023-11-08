class ModelStoreInfo {
  bool? status;
  String? message;
  Data? data;

  ModelStoreInfo({this.status, this.message, this.data});

  ModelStoreInfo.fromJson(Map<String, dynamic> json) {
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
  List<ShopDetails>? shopDetails;

  Data({
    this.shopDetails,
    // this.categoryList
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['shop_details'] != null) {
      shopDetails = <ShopDetails>[];
      json['shop_details'].forEach((v) {
        shopDetails!.add(ShopDetails.fromJson(v));
      });
    }
    // if (json['category_list'] != null) {
    //   categoryList = <CategoryList>[];
    //   json['category_list'].forEach((v) {
    //     categoryList!.add(CategoryList.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shopDetails != null) {
      data['shop_details'] = shopDetails!.map((v) => v.toJson()).toList();
    }
    // if (categoryList != null) {
    //   data['category_list'] =
    //       categoryList!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class ShopDetails {
  String? bannerShop;
  String? title1;
  String? subtitle1;
  String? title2;
  String? subtitle2;
  String? title3;
  String? subtitle3;
  String? title4;
  String? subtitle4;
  String? title5;
  String? subtitle5;
  String? offerTag1;
  String? offerTag2;
  String? offerTag3;
  String? offerTag4;
  String? offerTag5;
  String? offerTag6;

  ShopDetails(
      {this.bannerShop,
      this.title1,
      this.subtitle1,
      this.title2,
      this.subtitle2,
      this.title3,
      this.subtitle3,
      this.title4,
      this.subtitle4,
      this.title5,
      this.subtitle5,
      this.offerTag1,
      this.offerTag2,
      this.offerTag3,
      this.offerTag4,
      this.offerTag5,
      this.offerTag6});

  ShopDetails.fromJson(Map<String, dynamic> json) {
    bannerShop = json['banner_shop'];
    title1 = json['title_1'];
    subtitle1 = json['subtitle_1'];
    title2 = json['title_2'];
    subtitle2 = json['subtitle_2'];
    title3 = json['title_3'];
    subtitle3 = json['subtitle_3'];
    title4 = json['title_4'];
    subtitle4 = json['subtitle_4'];
    title5 = json['title_5'];
    subtitle5 = json['subtitle_5'];
    offerTag1 = json['offer_tag_1'];
    offerTag2 = json['offer_tag_2'];
    offerTag3 = json['offer_tag_3'];
    offerTag4 = json['offer_tag_4'];
    offerTag5 = json['offer_tag_5'];
    offerTag6 = json['offer_tag_6'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner_shop'] = bannerShop;
    data['title_1'] = title1;
    data['subtitle_1'] = subtitle1;
    data['title_2'] = title2;
    data['subtitle_2'] = subtitle2;
    data['title_3'] = title3;
    data['subtitle_3'] = subtitle3;
    data['title_4'] = title4;
    data['subtitle_4'] = subtitle4;
    data['title_5'] = title5;
    data['subtitle_5'] = subtitle5;
    data['offer_tag_1'] = offerTag1;
    data['offer_tag_2'] = offerTag2;
    data['offer_tag_3'] = offerTag3;
    data['offer_tag_4'] = offerTag4;
    data['offer_tag_5'] = offerTag5;
    data['offer_tag_6'] = offerTag6;
    return data;
  }
}
