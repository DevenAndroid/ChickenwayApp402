import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/model_your_order.dart';
import '../repositories/new_common_repo/repository.dart';
import '../utils/api_constant.dart';

class OrderController extends GetxController{

  final Repositories repositories = Repositories();
  Rx<YourOrderProfile> model = YourOrderProfile().obs;
  Rx<RxStatus> order = RxStatus.empty().obs;

  Future yourOrder({bool? reset}) async {
    if(reset == true){
      model.value = YourOrderProfile();
      order.value = RxStatus.empty();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('user_details') != null) {
      await repositories.postApi(url: ApiUrls.yourOrderUrl, mapData: {}).then((
          value) {
        model.value = YourOrderProfile.fromJson(jsonDecode(value));
        if (model.value.status!) {
          order.value = RxStatus.success();
        } else {
          order.value = RxStatus.error();
        }
      });
    }
  }

}