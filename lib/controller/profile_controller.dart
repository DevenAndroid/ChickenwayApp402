import 'dart:convert';
import 'package:dinelah/utils/api_constant.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/model_profile.dart';
import '../repositories/new_common_repo/repository.dart';

class ProfileController extends GetxController {
  final Repositories repositories = Repositories();
  Rx<ProfileModel> model = ProfileModel().obs;
  RxBool showData = false.obs;
  RxInt refreshInt = 0.obs;

  updateUi(){
    refreshInt.value = DateTime.now().millisecondsSinceEpoch;
  }

  Future getProfile({bool? reset}) async {
    if(reset == true){
      model.value = ProfileModel();
      showData.value = false;
      updateUi();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('user_details') != null) {
      await repositories
          .postApi(url: ApiUrls.profile, mapData: {})
          .then((value) {
        model.value = ProfileModel.fromJson(jsonDecode(value));
        if (model.value.status!) {
          showData.value = true;
        }
        updateUi();
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }
}
