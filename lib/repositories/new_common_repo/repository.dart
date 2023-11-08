import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:client_information/client_information.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/new_controllers/cart_controller.dart';
import '../../helper/helper.dart';
import '../../models/model_login.dart';
import '../../utils/api_constant.dart';

class Repositories {
  String deviceId = "";
  OverlayEntry? loader;
  hideLoader() {
    Helpers.hideLoader(loader!);
  }

  Future assignDeviceToken() async {
    try {
      await ClientInformation.fetch().then((value) {
        deviceId = value.deviceId.toString();
      });
    } on PlatformException {
      log('Failed to get client information');
    }
  }

  Future<dynamic> postApi({
    BuildContext? context,
    required String url,
    bool? showMap = false,
    bool? showResponse = true,
    Map<String, dynamic>? mapData,
  }) async {
    loader = Helpers.overlayLoader(context);
    if (context != null) {
      Overlay.of(context).insert(loader!);
    }
    await assignDeviceToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('user_details') != null) {
      ModelLoginResponse model = ModelLoginResponse.fromJson(
          jsonDecode(preferences.getString("user_details")!));
      if (mapData != null) {
        mapData['cookie'] = model.data!.cookie!;
      } else {
        mapData = {};
        mapData['cookie'] = model.data!.cookie!;
      }
    } else {
      if (mapData != null) {
        mapData['cookie'] = deviceId;
      } else {
        mapData = {};
        mapData['cookie'] = deviceId;
      }
    }
    try {
      final Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      };
      if (kDebugMode) {
        log("API Url.....  $url");
        log("API mapData.....  ${jsonEncode(mapData)}");
        if (showMap!) {
          log("API mapData.....  $headers");
        }
      }

      http.Response response = await http.post(Uri.parse(url),
          body: jsonEncode(mapData), headers: headers);

      if (kDebugMode) {
        if (showResponse!) {
          log("API Response........  ${response.body} \n$url");
          log("API Response Status Code........  ${response.statusCode}");
          log("API Response Reason Phrase........  ${response.reasonPhrase}");
        }
      }

      Helpers.hideLoader(loader!);

      if (response.body
          .toString()
          .contains("Invalid authentication cookie. Use the")) {
        clearAll();
        return;
      }

      if (response.statusCode == 200 ||
          response.statusCode == 404 ||
          response.statusCode == 400) {
        return response.body;
      } else if (response.statusCode == 401) {
      } else {
        showToast(response.body);
        throw Exception(response.body);
      }
    } on SocketException catch (e) {
      Helpers.hideLoader(loader!);
      showToast("No Internet Access");
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> getApi({
    BuildContext? context,
    required String url,
    bool? showMap = true,
    bool? showResponse = true,
    bool? returnResponse = false,
    dynamic mapData,
  }) async {
    loader = Helpers.overlayLoader(context);
    if (context != null) {
      Overlay.of(context).insert(loader!);
    }
    await assignDeviceToken();

    try {
      final Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      };

      if (kDebugMode) {
        if (showMap!) {
          log("API Url.....  $url");
          log("API mapData.....  $headers");
        }
      }

      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (kDebugMode) {
        if (showResponse!) {
          log("API Url.....  $url");
          log("API Response........  ${response.body}");
          log("API Response Status Code........  ${response.statusCode}");
          log("API Response Reason Phrase........  ${response.reasonPhrase}");
        }
      }

      Helpers.hideLoader(loader!);
      if (returnResponse!) {
        return response;
      } else {
        if (response.statusCode == 200 || response.statusCode == 400) {
          return response.body;
        } else if (response.statusCode == 401) {
        } else {
          throw Exception(response.statusCode);
        }
      }
    } on SocketException {
      Helpers.hideLoader(loader!);
      showToast("No Internet Access");
      throw Exception("No Internet Access");
    } catch (e) {
      Helpers.hideLoader(loader!);
      throw Exception(e);
    }
  }

  Future<dynamic> multiPartApi({
    required mapData,
    required List<Map<String, File>> images,
    required context,
    required String url,
  }) async {
    loader = Helpers.overlayLoader(context);
    Overlay.of(context).insert(loader!);
    try {
      final Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      };
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headers);

      request.fields.addAll(mapData);
      for (var item in images) {
        if (item.values.first.path != "") {
          request.files
              .add(await multipartFile(item.keys.first, item.values.first));
        }
      }
      if (kDebugMode) {
        log(request.fields.toString());
        log(request.files.map((e) => e.filename).toList().toString());
      }

      final response = await request.send();
      Helpers.hideLoader(loader!);
      if (response.statusCode == 200) {
        String value = await response.stream.bytesToString();
        log(value);
        return value;
      } else if (response.statusCode == 401) {
        // logOutUser();
        throw Exception(await response.stream.bytesToString());
      } else {
        Helpers.hideLoader(loader!);
        throw Exception(await response.stream.bytesToString());
      }
    } on SocketException catch (e) {
      Helpers.hideLoader(loader!);
      showToast("No Internet Access");
      throw Exception(e);
    } catch (e) {
      Helpers.hideLoader(loader!);
      showToast(
          "Something went wrong.....${e.toString().substring(0, math.min(e.toString().length, 50))}");
      throw Exception(e);
    }
  }

  Future<http.MultipartFile> multipartFile(
      String? fieldName, File file1) async {
    return http.MultipartFile(
      fieldName ?? 'file',
      http.ByteStream(Stream.castFrom(file1.openRead())),
      await file1.length(),
      filename: file1.path.split('/').last,
    );
  }
}

clearAll() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  final cartController = Get.put(CartController());
  cartController.resetAll();
}
