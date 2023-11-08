class ModelMyAddressList {
  bool? status;
  String? message;
  AddressData? data;

  ModelMyAddressList({this.status, this.message, this.data});

  ModelMyAddressList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null && json['data'].toString() != "[]"
        ? AddressData.fromJson(json['data'])
        : AddressData(userAddress: []);
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

class AddressData {
  List<UserAddress>? userAddress;

  AddressData({this.userAddress});

  AddressData.fromJson(Map<String, dynamic> json) {
    if (json['user_address'] != null) {
      userAddress = <UserAddress>[];
      json['user_address'].forEach((v) {
        userAddress!.add(UserAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userAddress != null) {
      data['user_address'] = userAddress!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserAddress {
  dynamic id;
  dynamic home;
  dynamic countryCode;
  dynamic building;
  dynamic floor;
  dynamic address;
  dynamic phoneNo;
  dynamic userid;
  dynamic lat;
  dynamic longitute;
  // ignore: non_constant_identifier_names
  dynamic shipping_city;

  UserAddress(
      {this.id,
      this.home,
      this.countryCode,
      this.building,
      this.floor,
      this.address,
      this.phoneNo,
      this.userid,
      // ignore: non_constant_identifier_names
      this.shipping_city,
      this.lat,
      this.longitute});

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    home = json['home'];
    countryCode = json['country_code'];
    building = json['building'];
    floor = json['floor'];
    address = json['address'];
    phoneNo = json['phone_no'];
    userid = json['userid'];
    lat = json['lat'];
    longitute = json['longitute'];
    shipping_city = json['shipping_city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['home'] = home;
    data['country_code'] = countryCode;
    data['building'] = building;
    data['floor'] = floor;
    data['address'] = address;
    data['phone_no'] = phoneNo;
    data['userid'] = userid;
    data['lat'] = lat;
    data['longitute'] = longitute;
    data['shipping_city'] = shipping_city;
    return data;
  }
}
