import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/utils/price_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/menu_controller.dart';
import '../../models/menu_models/model_store_info.dart';
import '../../models/model_food_menu.dart';
import '../../res/theme/theme.dart';
import '../../utils/api_constant.dart';
import '../../utils/dimensions.dart';
import '../widget/menu_category_buttons.dart';
import 'bottom_nav_bar.dart';
import 'cart_screen.dart';
import 'single_product_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);
  static String route = "/MenuScreen";

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14), color: Colors.white),
      ),
    );
  }

  final cartController = Get.put(CartController());
  final menuController = Get.put(ProductsMenuController());

  getOfferText(ShopDetails shopInfo, int i) {
    switch (i) {
      case 0:
        return shopInfo.offerTag1.toString();
      case 1:
        return shopInfo.offerTag2.toString();
      case 2:
        return shopInfo.offerTag3.toString();
      case 3:
        return shopInfo.offerTag4.toString();
      case 4:
        return shopInfo.offerTag5.toString();
      case 5:
        return shopInfo.offerTag6.toString();
    }
    return '';
  }

  addToCart(id) {
    Map<String, dynamic> map = {};
    map['quantity'] = '1';
    map['product_id'] = id;
    menuController.repositories
        .postApi(url: ApiUrls.addToCart, mapData: map, context: context)
        .then((value) {
      var item = ModelResponseCommon.fromJson(jsonDecode(value));
      if (mounted) {
        showToast(item.message.toString());
        cartController.getData();
      }
    });
  }

  ScrollController scrollControllerVertical = ScrollController();

  listenToScroll() {
    int tempInt = menuController.selectedIndex.value;
    scrollControllerVertical.addListener(() {
      // scrollControllerVertical
      for (var i = 0; i < menuController.forMenuScreen.entries.length; i++) {
        if (checkContextPosition(menuController.forMenuScreen.entries
            .toList()[i]
            .value
            .menuKeyLower
            .currentContext)) {
          tempInt = i;
          if (tempInt != menuController.selectedIndex.value) {
            // log("Now Moving..........$i");
            menuController.autoScrollController!.scrollToIndex(i,
                preferPosition: AutoScrollPosition.middle,
                duration: const Duration(milliseconds: 10));
            menuController.selectedIndex.value = i;
          }
          break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (menuController.forMenuScreen.isEmpty &&
        menuController.storeInfo.data == null) {
      menuController.getAll();
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (Get.arguments != null) {
        if (kDebugMode) {
          print(Get.arguments);
        }
        if (menuController.forMenuScreen.isNotEmpty) {
          for (var i = 0;
              i < menuController.forMenuScreen.entries.length;
              i++) {
            if (kDebugMode) {
              print(menuController.forMenuScreen.entries
                  .toList()[i]
                  .value
                  .slug
                  .toString());
            }
            if (menuController.forMenuScreen.entries
                    .toList()[i]
                    .value
                    .slug
                    .toString() ==
                Get.arguments.toString()) {
              menuController.selectedIndex.value = i;
              menuController.autoScrollController!.scrollToIndex(i,
                  preferPosition: AutoScrollPosition.middle,
                  duration: const Duration(milliseconds: 200));
              setState(() {});
              final keyContext1 = menuController.forMenuScreen.entries
                  .toList()[i]
                  .value
                  .menuKeyUpper
                  .currentContext;
              if (keyContext1 != null) {
                Scrollable.ensureVisible(keyContext1,
                    curve: Curves.ease,
                    alignment: .1,
                    duration: const Duration(seconds: 1));
              }
              final keyContext = menuController.forMenuScreen.entries
                  .toList()[i]
                  .value
                  .menuKeyLower
                  .currentContext;
              if (keyContext != null) {
                Scrollable.ensureVisible(keyContext,
                    curve: Curves.ease,
                    alignment: .05,
                    duration: const Duration(seconds: 1));
              }
              log("......................      ${menuController.selectedIndex.value}");
              setState(() {});
              break;
            }
          }
        }
      }
      listenToScroll();
    });
  }

  bool checkContextPosition(BuildContext? context) {
    // widget is visible
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final pos = box.localToGlobal(Offset.zero);
      if (pos.dy > 160 && pos.dy < 320) {
        return true;
      } else {
        return false;
      }
    } else {
      log(context.toString());
      return false;
    }
  }

  Offset? getContextPosition(FoodMenuData gg) {
    // widget is visible
    if (gg.menuKeyUpper.currentContext != null) {
      final box =
          gg.menuKeyUpper.currentContext!.findRenderObject() as RenderBox;
      final pos = box.localToGlobal(Offset.zero);
      return pos;
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    scrollControllerVertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        menuController.repositories.hideLoader();
        return true;
      },
      child: Scaffold(
        // backgroundColor: const Color(0xfff5f5f5),
        body: Obx(() {
          if (menuController.refreshInt.value > 0) {}
          return menuController.forMenuScreen.isNotEmpty &&
                  menuController.storeInfo.data != null
              ? RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: AppTheme.primaryColor,
                  onRefresh: () async {
                    await menuController.getProducts();
                  },
                  child: CustomScrollView(
                    controller: scrollControllerVertical,
                    shrinkWrap: true,
                    slivers: [
                      firstAppBar(size),
                      secondAppBar(),
                      SliverToBoxAdapter(
                        child: Column(children: [
                          ListView.builder(
                              itemCount:
                                  menuController.forMenuScreen.entries.length,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var menu = menuController.forMenuScreen.entries
                                    .toList()[index]
                                    .value;
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/Group 660.svg',
                                          height: 22,
                                        ),
                                        const SizedBox(
                                          width: 9,
                                        ),
                                        Text(
                                          menu.name.toString().toString(),
                                          style: GoogleFonts.poppins(
                                              color: const Color(0xFF292323),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                          key: menu.menuKeyLower,
                                        ),
                                        const SizedBox(
                                          width: 9,
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons/Group 660.svg',
                                          height: 22,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                        itemCount: menu.productsData!.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index1) {
                                          // print("bottom list indexes.......      $index1");
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 10),
                                            child: productsUi(
                                                product:
                                                    menu.productsData![index1],
                                                size: size),
                                          );
                                        })
                                  ],
                                );
                              }),
                          appBottomLogo()
                        ]),
                      )
                    ],
                  ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.all(8).copyWith(top: 25),
                              child: buildShimmer(
                                border: 15,
                                width: AddSize.screenWidth * .95,
                                height: 180,
                              )),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: List.generate(
                                5,
                                (index) => Padding(
                                    padding: const EdgeInsets.all(5)
                                        .copyWith(top: 15),
                                    child: buildShimmer(
                                      border: 15,
                                      width: 200,
                                      height: 65,
                                    )))),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                              5,
                              (index) => Padding(
                                  padding: const EdgeInsets.only(left: 25)
                                      .copyWith(top: 20),
                                  child: buildShimmer(
                                    border: 15,
                                    width: 100,
                                    height: 60,
                                  ))),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.all(5).copyWith(top: 40),
                              child: buildShimmer(
                                border: 15,
                                width: AddSize.screenWidth * .50,
                                height: 50,
                              )),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8).copyWith(top: 25),
                          child: buildShimmer(
                            border: 15,
                            width: AddSize.screenWidth * .95,
                            height: 180,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(8).copyWith(top: 25),
                          child: buildShimmer(
                            border: 15,
                            width: AddSize.screenWidth * .95,
                            height: 180,
                          )),
                    ],
                  ),
                );
        }),
        bottomNavigationBar: cartBottomWidget(),
      ),
    );
  }

  secondAppBar() {
    return SliverAppBar(
        expandedHeight: 60,
        pinned: true,
        primary: false,
        toolbarHeight: 45,
        collapsedHeight: 45,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        titleSpacing: 0,
        title: const MenuButtonsList(),
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            height: 0,
            color: const Color(0xfff5f5f5),
          ),
        ));
  }

  SliverAppBar firstAppBar(Size size) {
    return SliverAppBar(
      pinned: true,
      expandedHeight:Platform.isAndroid? 365:310,
      collapsedHeight: 56,
      flexibleSpace: headerSection(size),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: AnimatedBuilder(
          animation: scrollControllerVertical,
          builder: (context, child) {
            return Opacity(
              opacity: (scrollControllerVertical.offset / 375) > 1
                  ? 1
                  : scrollControllerVertical.offset / 375,
              child: SizedBox(
                height: 5,
                width: 5,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // width: 5,
                      // height: 5,
                      // padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey)),
                      child: const Icon(Icons.arrow_back, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            );
          }),
      centerTitle: true,
      title: AnimatedBuilder(
        animation: scrollControllerVertical,
        builder: (context, child) {
          return Opacity(
            opacity: (scrollControllerVertical.offset / 375) > 1
                ? 1
                : scrollControllerVertical.offset / 375,
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Image.asset(
                      'assets/images/cock.png',
                      height: 23,
                    ).toAppIcon,
                  ),
                  const TextSpan(text: '  '),
                  TextSpan(
                    text: "Menu",
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF292323),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: '  '),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/images/cock.png',
                      height: 23,
                    ).toAppIcon,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [

          Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 8),
            child: Obx(() {
              return InkWell(
                onTap: () {
                  Get.toNamed(CartScreen.route);
                },
                child: (cartController.isDataLoading.value &&
                    cartController.model.value.data != null &&
                    cartController.model.value.data!.items!.isNotEmpty)
                    ? Badge(
                    badgeStyle: const BadgeStyle(badgeColor: Colors.black),
                    badgeContent: Text(
                      cartController.model.value.data!.items!
                          .map((e) => int.parse((e.quantity ?? 0).toString()))
                          .toList()
                          .sum
                          .toString(),
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
                    ),
                    child: Image.asset(
                      'assets/images/cooking_icon.png',
                      width: 26,
                      height: 26,
                    ))
                    : Image.asset(
                  'assets/images/cooking_icon.png',
                  width: 26,
                  height: 26,
                ),
              );
            }),
          )

      ],
    );
  }

  InkWell productsUi({required ProductsData product, required Size size}) {
    cartController.price = product.currencySymbol;
    return InkWell(
      onTap: () {
        Get.toNamed(
          SingleProductScreen.route,
          arguments: [
            product.id.toString(),
            product.imageUrl ?? "Product ${product.id}",
            product.name ?? "Product ${product.id}"
          ],
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Obx(() {
                              if (cartController.refreshInt.value > 0) {}
                              return Row(
                                children: [
                                  if (cartController
                                          .productsMap[product.id.toString()] !=
                                      null)
                                    Text(
                                      "${cartController.productsMap[product.id.toString()]} x ",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFFE02020),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  Expanded(
                                    child: Text(
                                      product.name ?? "Product ${product.id}",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF292323),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(
                              height: 6,
                            ),
                            Expanded(
                              child: Text(
                                "${product.shortDescription ?? ""}"
                                "\n\n\n\n\n\n\n\n\n\n\n\n",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF444444),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'CUSTOMIZE',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF203EE0),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 5,
                                  height: 5,
                                ),
                                SvgPicture.asset(
                                  'assets/images/Group 672.svg',
                                  height: 12,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        height: 120,
                        child: Hero(
                          tag: product.imageUrl ?? "Product ${product.id}",
                          child: Material(
                            color: Colors.transparent,
                            child: Image.network(
                              product.imageUrl ?? "Product ${product.id}",
                              height: 130,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          const Divider(
                            thickness: 0,
                            height: 0,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                if (int.parse(product.regularPrice!) !=
                                    int.parse(product.price!))
                                  formatPrice2(
                                    product.regularPrice ?? '0',
                                    product.currencySymbol ?? '',
                                    GoogleFonts.poppins(
                                        color: const Color(0xFF444444),
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 12),
                                  ),
                                formatPrice2(
                                    product.price ?? '0',
                                    product.currencySymbol ?? '',
                                    GoogleFonts.poppins(
                                        color: const Color(0xFF444444),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )
                        ],
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () {
                          addToCart(product.id.toString());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE02020),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10)),
                          ),
                          child: Text(
                            'ADD TO CART',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFFFFFFF),
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: buildPositioned(product.id.toString(), context)),
        ],
      ),
    );
  }

  headerSection(Size size) {
    var shopInfo = menuController.storeInfo.data!.shopDetails!.first;
    return FlexibleSpaceBar(
      background: Container(
        color: const Color(0xffF5F5F5),
        height: 340,
        child: Stack(children: [
          SizedBox(
            height: 230,
            width: context.getDeviceSize.width,
            child: CachedNetworkImage(
              imageUrl: shopInfo.bannerShop.toString(),
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          Positioned(
            top: 170,
            child: Column(
              children: [
                Container(
                  width: size.width * .9,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    shopInfo.title1.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF888888),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 9),
                                    child: Text(
                                      shopInfo.subtitle1.toString(),
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF444444),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const VerticalDivider(
                                    color: Color(0xffEAEAEA),
                                    thickness: 2,
                                  )
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              width: 0,
                              color: Color(0xffEAEAEA),
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    shopInfo.title2.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF888888),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    shopInfo.subtitle2.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF444444),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              width: 0,
                              color: Color(0xffEAEAEA),
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    shopInfo.title3.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF888888),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    shopInfo.subtitle3.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF444444),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0xffEAEAEA),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    shopInfo.title4.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF888888),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    shopInfo.subtitle4.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF444444),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              width: 2,
                              color: Color(0xffEAEAEA),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    shopInfo.title5.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF888888),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    shopInfo.subtitle5.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF444444),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: context.getDeviceSize.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          for (int i = 0; i < 6; i++)
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  Container(

                                    width: size.width * .60,
                                    // height: 150,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFFFEF4D9)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/discount.svg',
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            getOfferText(shopInfo, i),
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFFFA6400),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                         // SizedBox(height:  3,)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 60,)
                                ],
                              ),
                            ),
                          // SizedBox(height:  3,)
                        ],
                      ),
                    ),
                  ),
                ),
               
              ],
            ),
          ),
          Positioned(
              top: 40,
              left: 8,
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.4)),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  )))
        ]),
      ),
    );
  }
}
