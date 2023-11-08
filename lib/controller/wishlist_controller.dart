import 'dart:convert';

import 'package:dinelah/utils/api_constant.dart';
import 'package:get/get.dart';

import '../models/model_wish_list.dart';
import '../repositories/new_common_repo/repository.dart';

class WishlistController extends GetxController{
  final Repositories repositories = Repositories();
  Rx<ModelWishList> model = ModelWishList().obs;
  RxBool loaded = false.obs;
  List<String> favProductsList = [];
  RxInt refreshInt = 0.obs;

  updateUi(){
    refreshInt.value = DateTime.now().millisecondsSinceEpoch;
  }

  getWishListData({bool? reset}){
    if(reset == true){
      model.value = ModelWishList();
      loaded.value = false;
      updateUi();
    }
    repositories.postApi(url: ApiUrls.getWishListUrl,mapData: {}).then((value) {
      model.value = ModelWishList.fromJson(jsonDecode(value));
      loaded.value = true;
      if(model.value.data!.isNotEmpty) {
        favProductsList =model.value.data!.map((e) => e.id.toString()).toList();
      }
      updateUi();
    }).catchError((e){
      model.value = ModelWishList();
      updateUi();
    });
  }

}