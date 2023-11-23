import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/repositories/new_common_repo/repository.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/utils/api_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/menu_controller.dart';
import '../../helper/helper.dart';
import '../../models/new_models/single_product_model.dart';
import '../../utils/dimensions.dart';
import '../../utils/price_format.dart';
import 'bottom_nav_bar.dart';
import 'package:collection/collection.dart';
import 'menu_screen.dart';

class SingleProductScreen extends StatefulWidget {
  static const String route = "/SingleProductScreen";

  const SingleProductScreen({Key? key}) : super(key: key);

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  final menuController = Get.put(ProductsMenuController());

  Rx<ModelSingleProduct> model = ModelSingleProduct().obs;
  String productId = "";
  final Repositories repositories = Repositories();
  final CartController cartController = Get.put(CartController());
  final TextEditingController crispyPlus = TextEditingController();
  Color darkRedColor = const Color(0xffE02020);

  int allAvailableOptions = 0;
  bool allAvailableOptionsDone = false;
  int assignedOptions = 0;

  Future getProductDetails() async {
    await repositories.postApi(url: ApiUrls.getSingleProductUrl, mapData: {"product_id": productId}).then((value) {
      model.value = ModelSingleProduct.fromJson(jsonDecode(value));
      List<AddonsData> befores = [];
      List<AddonsData> afters = [];
      if (model.value.productOption != null) {
        for (var element in model.value.productOption!) {
          if (element.sectionsPlacement.toString() == "before") {
            befores.add(element);
          }
          if (element.sectionsPlacement.toString() == "after") {
            afters.add(element);
          }
        }
        model.value.productOption!.removeWhere((element) =>
            befores.map((e) => e.uniId!.first.toString()).toList().contains(element.uniId!.first.toString()) ||
            afters.map((e) => e.uniId!.first.toString()).toList().contains(element.uniId!.first.toString()));
        for (var element in befores.reversed.toList()) {
          model.value.productOption!.insert(0, element);
        }
        model.value.productOption!.addAll(afters);
        Future.delayed(const Duration(seconds: 1)).then((value) {
          if (mounted) {
            setState(() {});
          }
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  int radioOptions = 0;
  int checkBoxOptions = 0;
  int cartItemNumbers = 1;
  bool showAllValidation = false;
  int radiosPrice = 0;
  String imageUrl = "";
  String productName = "";

  Map<String, bool> validationCheck = {};

  Future updateCart({required bool increase}) async {
    Map<String, dynamic> map = {};
    map["product_id"] = productId;
    map["quantity"] = cartItemNumbers;

    Map<String, dynamic> optionValues = {};

    Map<String, dynamic> optionPrice = {};

    // For radio
    if (model.value.productOption != null && model.value.productOption!.isNotEmpty) {
      List<String> radioOptions = [];
      List<int> radioPrice = [];
      for (var item in model.value.selectedRadios.entries) {
        radioOptions.add(item.value.toString().split("||").first);
        if (kDebugMode) {
          print(item.value.toString().split("--").last);
        }
        radioPrice.add((int.tryParse(item.value.toString().split("--").last) ?? 0));
      }

      for (var i = 0; i < radioOptions.length; i++) {
        optionValues["tmcp_radio_1_$i"] = radioOptions[i];
        optionPrice["radio_price"] = radioPrice.sum;
      }

      /// For CheckBox
      if (model.value.productOption != null && model.value.productOption!.isNotEmpty) {
        for (var i = 0; i < model.value.selected1.length; i++) {
          optionValues["tmcp_checkbox_1_$i"] = model.value.selected1[i].toString().split("--").first;

          optionPrice["$i"] = model.value.selected1[i].toString().split("--").last.split("==========").first;
        }
      }
    }

    if (optionValues.isNotEmpty) {
      map["option_values"] = optionValues;
      map["option_price"] = optionPrice.entries.map((e) => double.tryParse(e.value.toString()) ?? 0).toList().sum;
    }

    if (kDebugMode) {
      print(map);
    }

    await repositories.postApi(context: context, url: ApiUrls.updateCartUrl, mapData: map).then((value) {
      ModelResponseCommon responseCommon = ModelResponseCommon.fromJson(jsonDecode(value));
      if (responseCommon.status) {
        Get.back();
        Get.toNamed(MenuScreen.route);
        cartController.getData().then((value) {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      productId = Get.arguments[0].toString();
      List gg = Get.arguments;
      if (gg.length == 3) {
        imageUrl = Get.arguments[1];
        productName = Get.arguments[2];
      }
      getProductDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (model.value.productOption != null && model.value.productOption!.isNotEmpty) {
      radiosPrice = model.value.selectedRadios.entries
          .map((e) => (int.tryParse(e.value.toString().split("--").last) ?? 0))
          .toList()
          .sum;
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return RefreshIndicator(
            onRefresh: () async {
              await getProductDetails();
            },
            child: SingleChildScrollView(
                child: Column(children: [
              productImage(size),
              if (model.value.data != null) ...[
                if (model.value.productOption != null && model.value.productOption!.isNotEmpty) ...[
                  // if (model.value.productOption!.first.title != null &&
                  //     model.value.productOption!.first.title!.isNotEmpty)
                  //   ...titlesUi(size),
                  if (model.value.productOption!.first.multipleRadiobuttonsOptionsTitle != null)
                    ...model.value.productOption!
                        .map((e) => Column(
                              children: [
                                titlesUi(size, addon: e),
                                radioButtons(size, addon: e),
                                addonsCheckLists(size, addon: e)
                              ],
                            ))
                        .toList(),
                  // ...radioButtons(size),
                  // if (model.value.productOption!.first.optionsTitle != null)
                  //   ...model.value.productOption!
                  //       .map((e) => addonsCheckLists(size, addon: e))
                  //       .toList(),
                  // ...addonsCheckLists(size),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Crispy Plus ',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              height: 2,
                              thickness: 1,
                            ),
                            TextField(
                              controller: cartController.crispyPlus,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xff999999), fontWeight: FontWeight.w400, fontSize: 10),
                                  prefixIcon: Image.asset('assets/images/special.png'),
                                  hintText: 'write your special request here'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                appBottomLogo()
              ],
              if (model.value.data == null)
                SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8).copyWith(top: 10),
                                  child: buildShimmer(
                                    border: 15,
                                    width: AddSize.screenWidth * .75,
                                    height: 25,
                                  ))
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8).copyWith(top: 10),
                              child: buildShimmer(
                                border: 15,
                                width: AddSize.screenWidth,
                                height: 75,
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8).copyWith(top: 10),
                              child: buildShimmer(
                                border: 15,
                                width: AddSize.screenWidth,
                                height: 175,
                              )),
                        ],
                      )
                    ],
                  ),
                )
            ])),
          );
        }),
      ),
      bottomNavigationBar: model.value.data != null
          ? Material(
              elevation: 10,
              child: Container(
                  color: Colors.grey.shade50,
                  padding: const EdgeInsets.only(top: 15, left: 15, bottom: 22, right: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      showAllValidation = true;
                      bool canCheckOut = !validationCheck.entries.map((e) => e.value).toList().contains(false);
                      if (canCheckOut) {
                        updateCart(increase: true);
                      } else {
                        showToast("Please select the above required addons to add to cart");
                      }
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFFFA5A5),
                            ),
                            child: Text(
                              cartItemNumbers.toString(),
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFFFFFFFF), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Add To Cart',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: formatPrice2(
                                  (((double.tryParse((model.value.data!.first.price ?? "0").toString()) ?? 0) +
                                                  (model.value.productOption!.isNotEmpty
                                                      ? (model.value.selected1
                                                              .map((e) =>
                                                                  double.tryParse(e
                                                                      .toString()
                                                                      .split("--")
                                                                      .last
                                                                      .toString()
                                                                      .split("==========")
                                                                      .first) ??
                                                                  0)
                                                              .toList()
                                                              .sum +
                                                          (radiosPrice))
                                                      : 0))
                                              .toInt() *
                                          cartItemNumbers)
                                      .toString(),
                                  model.value.data!.first.currencySymbol ?? "",
                                  GoogleFonts.poppins(
                                      color: const Color(0xFFFFFFFF),
                                      fontSize: 14,
                                      letterSpacing: .7,
                                      fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                  )),
            )
          : null,
    );
  }

  radioButtons(Size size, {required AddonsData addon}) {
    List<String> titles = addon.radiobuttonsHeaderTitle!.entries.map((e) => e.value.toString()).toList();
    List<String> subtitle = addon.radiobuttonsHeaderSubtitle!.entries.map((e) => e.value.toString()).toList();
    List<bool> required = addon.radioButtonsRequired!.entries.map((e) => e.value.toString() == "1").toList();

    List<List<String>> radioValue = addon.radiobuttonsOptionsValue!.entries.map((e) => e.value).toList();
    List<List<String>> images = addon.radiobuttonsOptionsImage!.entries.map((e) => e.value).toList();
    List<List<String>> price = addon.radiobuttonsOptionsPrice!.entries.map((e) => e.value).toList();
    List<int> makeDefault =
        addon.radioOptionsDefaultValue!.entries.map((e) => int.tryParse(e.value.toString()) ?? -1).toList();

    if (addon.makeDefaults) {
      for (var i = 0; i < makeDefault.length; i++) {
        if (makeDefault[i] != (-1)) {
          String title = "${titles[i]}===$i";

          model.value.selectedRadios[i.toString() + addon.uniId!.first.toString()] =
              "${radioValue[i][makeDefault[i]]}||$title${addon.uniId!.first.toString()}--${price[i][makeDefault[i]]}";
          if (kDebugMode) {
            print("${radioValue[i][makeDefault[i]]}||$title${addon.uniId!.first.toString()}--${price[i][makeDefault[i]]}");
          }
        }
      }
      addon.makeDefaults = false;
    }

    return Column(
      children: List.generate(
          titles.length,
          (index) => addonsRadio(
                indexTop: index.toString() + addon.uniId!.first.toString(),
                size: size,
                uniqueId: addon.uniId!.first.toString(),
                title: "${titles[index]}===$index${addon.uniId!.first.toString()}",
                subtitle: subtitle[index],
                options: radioValue[index],
                image: images[index],
                price: price[index],
                isRequired: required[index],
              )),
    );
  }

  titlesUi(Size size, {required AddonsData addon}) {
    // model.value.productOption!.first.title!.first
    addon.title!.removeWhere((key, value) => value.toString().isEmpty);
    addon.headerSubtitle!.removeWhere((key, value) => value.toString().isEmpty);
    List<String> titles = addon.title!.entries.map((e) => "${e.value}").toList();
    List<String> headerSubtitle = addon.headerSubtitle!.entries.map((e) => "${e.value}").toList();
    headerSubtitle.addAll(List.generate(20, (index) => ""));

    return Column(
      children: List.generate(
          titles.length,
          (index) => Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 14),
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 0, offset: Offset(0, 0))]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titles[index],
                        // 'Choice of Chicken',
                        style:
                            GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 15.5, fontWeight: FontWeight.w600),
                      ),
                      Html(
                        data: headerSubtitle[index],
                        // "model.value.productOption!.first.headerSubtitle!.first"
                      ),
                    ],
                  ),
                ),
              )),
    );
  }

  addonsCheckLists(Size size, {required AddonsData addon}) {
    List<List<String>> optionsTitle = addon.optionsTitle!.entries.map((e) => e.value).toList();
    // print(optionsTitle);
    addon.checkBoxesHeaderSubtitle!.removeWhere((key, value) => value.toString().isEmpty);
    List<String> headerSubtitle = addon.checkBoxesHeaderSubtitle!.entries
        .map((e) => "==========${e.value}==${addon.uniId!.first.toString()}")
        .toList();
    List<bool> required = addon.checkBoxesRequired!.entries.map((e) => e.value.toString() == "1").toList();

    headerSubtitle.addAll(List.generate(20, (index) => "==========sd==${addon.uniId!.first.toString()}"));
    List<List<String>> optionsPrice = addon.optionsPrice!.entries.map((e) => e.value).toList();
    List<String> titles = addon.checkBoxesHeaderTitle!.entries.map((e) => e.value.toString()).toList();
    List<List<String>> images = addon.optionsImage!.entries.map((e) => e.value).toList();

    List<List<int>> makeDefault = addon.checkBoxesOptionsDefaultValue!.entries
        .map((e) => e.value.map((e2) => (int.tryParse(e2.toString()) ?? -1)).toList())
        .toList();
    if (allAvailableOptionsDone == false) {
      allAvailableOptionsDone = true;
      for (var element in makeDefault) {
        for (var element1 in element) {
          if (element1 != (-1)) {
            allAvailableOptions++;
          }
        }
      }
    }

    return Column(
      children: List.generate(
          optionsTitle.length,
          (index) => addonsCheckList(size,
              goodIndex: index,
              uniqueId: addon.uniId!.first.toString(),
              defaults: makeDefault[index],
              title: titles[index],
              subTitle: headerSubtitle[index],
              optionTitles: optionsTitle[index],
              optionPrice: optionsPrice[index],
              images: images[index],
              addon: addon,
              isRequired: required[index])),
    );
  }

  SizedBox productImage(Size size) {
    return SizedBox(
        height: size.height * .55,
        child: Stack(children: [
          Hero(
            tag: imageUrl,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: size.width,
                height: size.height * .40,
                child: CachedNetworkImage(
                  imageUrl: model.value.data != null && model.value.data!.isNotEmpty
                      ? model.value.data!.first.imageUrl!
                      : imageUrl,
                  errorWidget: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 2),
                child: Container(
                  width: size.width * .95,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.value.data != null && model.value.data!.isNotEmpty
                            ? model.value.data!.first.name ?? ""
                            : productName,
                        // 'Red Hot Twister Plus',
                        style:
                            GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      if (model.value.data != null && model.value.data!.isNotEmpty)
                        Text(
                          model.value.data!.first.shortDescription!,
                          maxLines: 3,
                          style:
                              GoogleFonts.poppins(color: const Color(0xFF444444), fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                    ],
                  ),
                )),
          ),
          Positioned(
              top: 20,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
              ))
        ]));
  }

  Row productCalculations() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: formatPrice2(
          ((double.tryParse((model.value.data!.first.price ?? "0").toString()) ?? 0) +
                  (model.value.productOption!.isNotEmpty
                      ? (model.value.selected1
                              .map((e) =>
                                  double.tryParse(e.toString().split("--").last.toString().split("==========").first) ?? 0)
                              .toList()
                              .sum +
                          (radiosPrice))
                      : 0))
              .toInt()
              .toString(),
          model.value.data!.first.currencySymbol ?? "",
          GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 16.5, fontWeight: FontWeight.w600),
        )),
        InkWell(
          onTap: () {
            if (cartItemNumbers != 1) {
              cartItemNumbers--;
              setState(() {});
            }
          },
          child: Container(
            height: 31,
            width: 31,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E1E1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            cartItemNumbers.toString(),
            style: GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {
            cartItemNumbers++;
            setState(() {});
            //    updateCart(increase: true);
          },
          child: Container(
            height: 31,
            width: 31,
            decoration: BoxDecoration(
              color: const Color(0xFFE02020),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Padding addonsRadio({
    required Size size,
    required String title,
    required String indexTop,
    required String subtitle,
    required String uniqueId,
    required List<String> options,
    required List<String> price,
    required List<String> image,
    required bool isRequired,
  }) {
    bool showError2 = isRequired &&
        model.value.selectedRadios.entries
            .where((element) => element.value.toString().split("||").last.split("--").first == title)
            .toList()
            .isEmpty;
    if (showError2) {
      validationCheck[title] = false;
    } else {
      validationCheck[title] = true;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(top: 14),
      child: Container(
        width: size.width,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 0, offset: Offset(0, 0))]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toString().split("===").first,
              style: GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 1,
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    if (kDebugMode) {
                      print("this.......      "
                          "${options[index]}||$title--${price[index]}");
                    }
                    model.value.selectedRadios[indexTop.toString()] = "${options[index]}||$title--${price[index]}";
                    setState(() {});
                    return;
                  },
                  dense: true,
                  minLeadingWidth: 0,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: image[index],
                        width: 40,
                        height: 40,
                        errorWidget: (_, __, ___) => const SizedBox(
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          options[index],
                          style:
                              GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                      if (price[index].isNotEmpty && price[index] != '0')
                        formatPrice2(
                            price[index].isNotEmpty ? price[index] : "0",
                            model.value.data!.first.currencySymbol ?? '',
                            GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 14, fontWeight: FontWeight.w400)),
                      model.value.selectedRadios[indexTop] == "${options[index]}||$title--${price[index]}"
                          ? Icon(
                              Icons.check_circle,
                              color: darkRedColor,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: darkRedColor,
                            ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.grey,
                  thickness: 0,
                );
              },
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0,
            ),
            if (showError2 && showAllValidation)
              Padding(
                padding: const EdgeInsets.only(top: 14, left: 8),
                child: Text(
                  "Please Select one of the above add-on",
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              )
          ],
        ),
      ),
    );
  }

  addonsCheckList(Size size,
      {required int goodIndex,
      required String subTitle,
      required String uniqueId,
      required List<String> optionTitles,
      required List<int> defaults,
      required List<String> optionPrice,
      required List<String> images,
      required AddonsData addon,
      required bool isRequired,
      required title}) {
    bool showError1 = (isRequired == true &&
        model.value.selected1
            .where((element) => (element.toString().split("--")[1].toString()) == "$goodIndex+$subTitle")
            .toList()
            .isEmpty);

    if (showError1) {
      validationCheck["$goodIndex$uniqueId+$subTitle"] = false;
    } else {
      validationCheck["$goodIndex$uniqueId+$subTitle"] = true;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(top: 14),
      child: Column(
        children: [
          Container(
            width: size.width,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 0, offset: Offset(0, 0))]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.toString().isNotEmpty)
                  Text(
                    title.toString().split("===").first,
                    style: GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                const SizedBox(height: 1),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: optionTitles.length,
                  itemBuilder: (context, index) {
                    if (addon.makeDefaultsCheckBox) {
                      if (defaults[index] != (-1)) {
                        model.value.selected1
                            .add("${optionTitles[index]}--$goodIndex+$subTitle--${optionPrice[index]}$subTitle");
                        assignedOptions++;
                        if (assignedOptions == allAvailableOptions || assignedOptions > allAvailableOptions) {
                          addon.makeDefaultsCheckBox = false;
                        }
                        model.value.selected1 = model.value.selected1.toSet().toList();
                      }
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: images[index],
                          width: 40,
                          height: 40,
                          errorWidget: (_, __, ___) => const SizedBox(
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            optionTitles[index],
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF333333), fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        if (optionPrice[index].isNotEmpty && optionPrice[index] != '0')
                          formatPrice2(
                              optionPrice[index].isNotEmpty ? optionPrice[index] : "0",
                              model.value.data!.first.currencySymbol ?? '',
                              GoogleFonts.poppins(
                                  color: const Color(0xFF333333), fontSize: 14, fontWeight: FontWeight.w400)),
                        Theme(
                          data: ThemeData(
                              primarySwatch: Colors.red, primaryColor: darkRedColor, unselectedWidgetColor: darkRedColor),
                          child: Checkbox(
                              activeColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3), side: BorderSide(color: darkRedColor)),
                              value: model.value.selected1
                                  .contains("${optionTitles[index]}--$goodIndex+$subTitle--${optionPrice[index]}$subTitle"),
                              // value: true,
                              onChanged: (value) {
                                if (value == true) {
                                  model.value.selected1
                                      .add("${optionTitles[index]}--$goodIndex+$subTitle--${optionPrice[index]}$subTitle");
                                  if (kDebugMode) {
                                    print(model.value.selected1);
                                  }
                                } else {
                                  model.value.selected1.removeWhere((element) =>
                                      element.toString() ==
                                      "${optionTitles[index]}--$goodIndex+$subTitle--${optionPrice[index]}$subTitle");
                                }

                                if (mounted) {
                                  setState(() {});
                                }
                              }),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.grey,
                      thickness: 0,
                    );
                  },
                ),
                if (showError1 && showAllValidation)
                  Padding(
                    padding: const EdgeInsets.only(top: 14, left: 8),
                    child: Text(
                      "Please Select one of the above add-on",
                      style: GoogleFonts.poppins(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )
              ],
            ),
          ),
          addHeight(10),
        ],
      ),
    );
  }

  buildShimmer({
    required double height,
    required double width,
    required double border,
  }) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffEAE9E9),
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
      ),
    );
  }
}

extension LowerTheString on String {
  String get lower {
    return toLowerCase();
  }
}
