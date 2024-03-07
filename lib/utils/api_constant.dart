import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dinelah/res/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiUrls {
  static const String apiBaseUrl = 'https://chickenway.app/wp-json/api/';

  static const String loginUrl = "${apiBaseUrl}woocustomer/sign_in";
  static const String deleteAddress =
      "${apiBaseUrl}woocustomer/delete_addresses";

  static const String verifySignIn = "${apiBaseUrl}woocustomer/sign_in_verify";

  static const String getStoreInfoUrl =
      "${apiBaseUrl}woohomepage/get_food_menu";

  static const String categories = "${apiBaseUrl}woo_api/category_products";

  static const String signUpUrl = "${apiBaseUrl}woocustomer/register";

  static const String yourOrderUrl = "${apiBaseUrl}woocustomer/get_orders";
  static const String singleOrder = "${apiBaseUrl}woocustomer/single_order";
  static const String delete = "${apiBaseUrl}woocustomer/delete_user_account";

  static const String getCartUrl = "${apiBaseUrl}woocustomer/get_cart";

  static const String updateProfileUrl =
      "${apiBaseUrl}woocustomer/update_profile_fields";

  static const String profile = "${apiBaseUrl}woocustomer/get_profile_fields";

  // static const String getSingleProductUrl = "${apiBaseUrl}woo_api/get_product";
  static const String getSingleProductUrl =
      "${apiBaseUrl}woo_api/get_product_copy";

  static const String updateCartUrl = "${apiBaseUrl}woocustomer/update_cart";
  static const String splashScreenUrl =
      "${apiBaseUrl}woohomepage/splash_screen";

  static const String homePage =
      "https://chickenway.app/wp-json/api/woohomepage/get_home_data";

  static const String addToCart = "${apiBaseUrl}woocustomer/update_cart";
  static const String aboutUs =
      "https://www.chickenway.me/wp-json/wp/v2/pages/9095";
  static const String apkVersion = "https://chickenway.app/wp-json/api/woohomepage/get_apk_version";
  static const String matchApkVersion = "https://chickenway.app/wp-json/api/woohomepage/send_apk_version";
  // static const String aboutUs = "${apiBaseUrl}woohomepage/about_us";
  static const String privicyPolicy =
      "${apiBaseUrl}woohomepage/privacy_policy_screen";
  static const String termCondition =
      "${apiBaseUrl}woohomepage/Term_and_condition";
  static const String supportScreen = "${apiBaseUrl}woohomepage/support_screen";

  static const String deleteProfile =
      "${apiBaseUrl}woocustomer/delete_user_account";

  static const String updateAddressUrl =
      "${apiBaseUrl}woocustomer/update_addresses";
  static const String addressVerifyOtpUrl =
      "${apiBaseUrl}woocustomer/address_in_verify";
  static const String getAddressUrl = "${apiBaseUrl}woocustomer/get_addresses";

  static const String addToWishlist = "${apiBaseUrl}add_wishlist_item";
  static const String createOrderUrl = "${apiBaseUrl}process/create_order";
  static const String applyCouponCode = "${apiBaseUrl}woocustomer/coupon";
  static const String getWishListUrl = "${apiBaseUrl}get_wishlist_items";
  static const String siteUrl = "${apiBaseUrl}woohomepage/site_url";
  static const String addReviewUrl = "${apiBaseUrl}woo_api/product_review";

  static const String switchOffUrl =
      "https://chickenway.app/wp-json/api/woohomepage/switch_off_store";
  static const String popUpUrl =
      "https://chickenway.app/wp-json/api/woohomepage/popup_data";

  static const String getAllMenuProductsUrl =
      "${apiBaseUrl}woo_api/category_all_products";
  static const String shippingMethodsUrl =
      "${apiBaseUrl}woocustomer/shipping_methods";
  static const String cancelOrderUrl = "${apiBaseUrl}woocustomer/cancel_order";
}

logPrint(String logis) {
  log(logis);
}

final headers = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.acceptHeader: 'application/json',
};

showToast(message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppTheme.newprimaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

bool validateStructure(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

  return regExp.hasMatch(em);
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

// Future<bool> isLogIn() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   return pref.getString('user') == null ? false : true;
// }
