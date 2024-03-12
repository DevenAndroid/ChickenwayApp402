import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dinelah/models/model_login.dart';
import 'package:dinelah/routers/my_router.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model_response_common.dart';
import '../models/model_verify_otp_forgot_password.dart';
import '../utils/api_constant.dart';

Future<ModelResponseCommon> deleteUser(BuildContext context,) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  ModelLoginResponse model = ModelLoginResponse.fromJson(jsonDecode(pref.getString("user_details")!));
  pref.getString("user_info");
  var map = <String, dynamic>{};

  map['cookie'] =model.data!.cookie;


  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
     // HttpHeaders.authorizationHeader: 'Bearer ${user.authToken}'


  };

  http.Response response = await http.post(Uri.parse(ApiUrls.deleteUser),
      headers: headers,body: jsonEncode(map));

  if (response.statusCode == 200  || response.statusCode == 400) {
    log("::::::::::Delete user:::::::::::${response.body}");
    return ModelResponseCommon.fromJson(json.decode(response.body));
  }  else if (response.statusCode == 401) {
    print(response.statusCode);
    logOutUser();
    throw Exception(response.body);
  } else {
    throw Exception(response.body);
  }
}

logOutUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.clear();
  Get.offAllNamed(MyRouter.logInScreen);
}