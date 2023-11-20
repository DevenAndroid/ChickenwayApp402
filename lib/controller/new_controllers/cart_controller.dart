import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dinelah/models/model_get_cart.dart';
import 'package:dinelah/repositories/new_common_repo/repository.dart';
import 'package:dinelah/utils/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/model_shipping_methods.dart';
import '../../models/new_models/model_my_addresses.dart';
import '../menu_controller.dart';
import '../orders_controller.dart';
import '../profile_controller.dart';
import '../wishlist_controller.dart';
import 'address_controller.dart';

class CartController extends GetxController {
  final menuController = Get.put(ProductsMenuController());
  final orderController = Get.put(OrderController());
  final wishList = Get.put(WishlistController());
  final profileController = Get.put(ProfileController());
  final addressController = Get.put(AddressController());




  RxBool isDataLoading = false.obs;

  ShippingData? selectedShippingMethod;
  Rx<ModelGetCartData> model = ModelGetCartData().obs;
  final Repositories repositories = Repositories();
  Rx<UserAddress> deliveryAddress = UserAddress().obs;
  bool allowNavigation = false;
  final TextEditingController specialRequest = TextEditingController();
  final TextEditingController crispyPlus = TextEditingController();

  final TextEditingController couponCode = TextEditingController();
  RxInt refreshInt = 0.obs;
  Map<String, int> productsMap = {};
  String price = "";

  Future getData({bool? allowClear = false, BuildContext? context}) async {
    if(allowClear == true){
      model.value = ModelGetCartData();
      isDataLoading.value = false;
      updateUi();
    }
    Map<String, dynamic> map = {};
    if(couponCode.text.trim().isNotEmpty) {
      map["coupon_code"] = couponCode.text.trim();
    }
    await repositories.postApi(url: ApiUrls.getCartUrl,mapData: map,context: context).then((value){
      model.value = ModelGetCartData.fromJson(jsonDecode(value));
      productsMap.clear();
      for (var element in model.value.data!.items!) {
        if(productsMap[element.product!.id.toString()] == null){
          productsMap[element.product!.id.toString()] = int.tryParse(element.quantity.toString()) ?? 1;
        }
        else {
          int? temp = productsMap[element.product!.id.toString()];
          temp = temp! + (int.tryParse(element.quantity.toString()) ?? 1);
          productsMap[element.product!.id.toString()] = temp;
        }
      }
      isDataLoading.value = true;
      updateUi();
    });
  }

  updateUi(){
    refreshInt.value = DateTime.now().millisecondsSinceEpoch;
  }

  StreamSubscription? subscription;
  bool hasInternetConnection = true;

  @override
  void onInit() {
    super.onInit();
    menuController.getAll();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        hasInternetConnection = false;
        updateUi();
      } else {
        hasInternetConnection = true;
        updateUi();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      subscription!.cancel();
    } catch(e){
      return;
    }
  }

  resetAll(){
    model.value = ModelGetCartData();
    deliveryAddress = UserAddress().obs;
    allowNavigation = false;
    specialRequest.clear();
    couponCode.clear();
    getData(allowClear: true);
    updateUi();

    if(
    menuController.forMenuScreen.isEmpty &&
    menuController.homeScreenTop.isEmpty &&
    menuController.yalCategories.isEmpty &&
        menuController.storeInfo.data == null){
      menuController.getAll();
    }
    orderController.yourOrder(reset: true);
    wishList.getWishListData(reset: true);
    profileController.getProfile(reset: true);
    addressController.getAddresses(reset: true);
  }

}
