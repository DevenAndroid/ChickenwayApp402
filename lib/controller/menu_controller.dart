import 'dart:convert';
import 'dart:developer';

import 'package:dinelah/utils/api_constant.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../models/menu_models/model_store_info.dart';
import '../models/model_food_menu.dart';
import '../repositories/new_common_repo/repository.dart';
// ModelFoodMenuProducts menuItemsModel = ModelFoodMenuProducts();

class ProductsMenuController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool isReverse = false.obs;
  final Repositories repositories = Repositories();
  ModelStoreInfo storeInfo = ModelStoreInfo();
  RxInt refreshInt = 0.obs;
  // ScrollController scrollController = ScrollController();
  Map<String, FoodMenuData> yalCategories = {};
  Map<String, FoodMenuData> forMenuScreen = {};
  Map<String, FoodMenuData> homeScreenTop = {};

  AutoScrollController? autoScrollController;

  updateUi() {
    refreshInt.value = DateTime.now().millisecondsSinceEpoch;
  }

  Future getStoreInfo() async {
    await repositories
        .postApi(url: ApiUrls.getStoreInfoUrl, mapData: {}).then((value) {
      storeInfo = ModelStoreInfo.fromJson(jsonDecode(value));
      updateUi();
    });
  }

  Future getProducts() async {
    await repositories
        .postApi(url: ApiUrls.getAllMenuProductsUrl, mapData: {}).then((value) {
      ModelFoodMenuProducts menuItemsModel =
          ModelFoodMenuProducts.fromJson(jsonDecode(value));
      menuItemsModel.data!.removeWhere((element) =>
          element.productsData == null || element.productsData!.isEmpty);
      if (menuItemsModel.data != null) {
        yalCategories.clear();
        forMenuScreen.clear();
        homeScreenTop.clear();
        for (var element in menuItemsModel.data!) {
          if (element.yallaMenu.toString() == "true") {
            yalCategories[
                    "${int.tryParse(element.priority.toString()) ?? "TermId${element.termId.toString()}"}"] =
                element;
          }
          if (element.menuscreen.toString() == "true") {
            forMenuScreen[
                    "${int.tryParse(element.priority.toString()) ?? "TermId${element.termId.toString()}"}"] =
                element;
          }
          if (element.homescreentop.toString() == "true") {
            homeScreenTop[
                    "${int.tryParse(element.priority.toString()) ?? "TermId${element.termId.toString()}"}"] =
                element;
          }
        }
        homeScreenTop = Map.fromEntries(homeScreenTop.entries.toList()
          ..sort((a, b) => (int.tryParse(a.key) ?? 1000)
              .compareTo((int.tryParse(b.key) ?? 1000))));
        yalCategories = Map.fromEntries(yalCategories.entries.toList()
          ..sort((a, b) => (int.tryParse(a.key) ?? 1000)
              .compareTo((int.tryParse(b.key) ?? 1000))));
        forMenuScreen = Map.fromEntries(forMenuScreen.entries.toList()
          ..sort((a, b) => (int.tryParse(a.key) ?? 1000)
              .compareTo((int.tryParse(b.key) ?? 1000))));
        log("homescreentop list.......     $homeScreenTop");
        log("yala list.......     $yalCategories");
        log("Menu Screen list.......     $forMenuScreen");
        // yalCategories
      }
      updateUi();
    });
  }

  getAll() {
    getStoreInfo();
    getProducts();
  }

  getAllAsync() async {
    await getStoreInfo();
    await getProducts();
  }
}
