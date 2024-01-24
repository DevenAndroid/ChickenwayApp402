import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dinelah/controller/wishlist_controller.dart';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/models/new_models/model_site_url.dart';
import 'package:dinelah/splash_screen.dart';
import 'package:dinelah/utils/dimensions.dart';
import 'package:dinelah/utils/price_format.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/menu_controller.dart';
import '../../controller/profile_controller.dart';
import '../../controller/new_controllers/address_controller.dart';
import '../../controller/orders_controller.dart';
import '../../helper/helper.dart';
import '../../models/chicken/model_home.dart';
import '../../models/model_popup_data.dart';
import '../../models/model_shipping_methods.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../res/app_assets.dart';
import '../../res/theme/theme.dart';
import '../../utils/api_constant.dart';
import '../../widgets/circular_progressindicator.dart';
import '../../widgets/common_error_widget.dart';
import '../widget/drawer.dart';
import 'cart_screen.dart';
import 'package:collection/collection.dart';
import 'checkout_screen.dart';
import 'single_product_screen.dart';
import 'menu_screen.dart';

// String siteUrl = "";
ModelSiteUrl modelSiteUrl = ModelSiteUrl();

Future manageSiteUrl() async {
  if (modelSiteUrl.data == null) {
    await Repositories()
        .postApi(url: ApiUrls.siteUrl, mapData: {}).then((value) {
      modelSiteUrl = ModelSiteUrl.fromJson(jsonDecode(value));
      getShippingList();
    });
  }
}

bool showSplashScreen = false;
bool shouldShowCartIcon = true;

// Future<bool> isFirstTime() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool isFirstTime = prefs.getBool('first_time') ?? true;
//
//   if (isFirstTime) {
//     prefs.setBool('first_time', false);
//   }
//
//   return isFirstTime;
// }

ModelShippingMethodsList shippingMethodsList = ModelShippingMethodsList();

class MainHomeScreen extends StatefulWidget {
  static const String route = "/MainHomeScreen";

  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  MainHomeScreenState createState() => MainHomeScreenState();

  static fromColors(
      {required Color baseColor,
      required Color highlightColor,
      required Container child}) {}
}

class MainHomeScreenState extends State<MainHomeScreen> {
  popup() {
    repositories.getApi(url: ApiUrls.popUpUrl, mapData: {}).then((value) {
      modelPopUp.value = ModelPopUp.fromJson(jsonDecode(value));
      if (modelPopUp.value.status!) {
        statusOfPopUp.value = RxStatus.success();
        if (modelPopUp.value.data != null) {
          _showPopup();
        }
      } else {
        statusOfPopUp.value = RxStatus.error();
      }
    });
  }

  Rx<ModelPopUp> modelPopUp = ModelPopUp().obs;
  Rx<RxStatus> statusOfPopUp = RxStatus.empty().obs;
  final Repositories repositories = Repositories();

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Dialog(
   clipBehavior: Clip.none,
            backgroundColor: Colors.transparent,

            elevation: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Stack(
                    children: [
                      // Positioned(
                      //   right: 10,
                      //   top: 50,
                      //   child: GestureDetector(
                      //     onTap: (){
                      //       Get.back();
                      //     },
                      //     child: const Icon(
                      //       Icons.close,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      Image(
                        image: NetworkImage(
                            modelPopUp.value.data!.img.toString()),
                      ),
                      Positioned(
                        right: 30,
                        top: 10,
                        child: GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red
                            ),
                            child: const Icon(

                              Icons.close,
                              color: Colors.white,
                            size: 13,),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,)
                ],
              ),
            ),
          ),
        );

        // : const CommonProgressIndicator();
      },
    );
  }

  checkFirstAppLaunch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("initial_dialog") == null) {
      popup();
      sharedPreferences.setString("initial_dialog", "done");
    }
  }

  final CartController cartController = Get.put(CartController());
  final orderController = Get.put(OrderController());
  final wishList = Get.put(WishlistController());
  final profileController = Get.put(ProfileController());
  final addressController = Get.put(AddressController());
  final menuController = Get.put(ProductsMenuController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  updateCartCount({
    required id,
    required bool increase,
  }) {
    repositories
        .postApi(context: context, url: ApiUrls.updateCartUrl, mapData: {
      "product_id": id,
      "quantity": increase ? "1" : "-1",
    }).then((value) {
      cartController.getData();
    });
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(border), color: Colors.white),
      ),
    );
  }

  Rx<HomeModel> model = HomeModel().obs;
  Rx<RxStatus> status = RxStatus.empty().obs;

  Future homeData() async {
    await repositories
        .postApi(
            url: ApiUrls.homePage,
            mapData: {},
            showMap: true,
            showResponse: true)
        .then((value) {
      model.value = HomeModel.fromJson(jsonDecode(value));
      if (model.value.data != null) {
        DateTime? time11;
        try {
          // time11 = DateFormat("yyyy-MM-dd").parse(model.value.data!.timeBannerAd![0].offerDuration.toString());
          if (kDebugMode) {
            print("Time...........       $time11");
          }
        } catch (e) {
          return;
        }
        // setTimer(givenTime: time11);
      }
      if (model.value.status!) {
        status.value = RxStatus.success();
      } else {
        showToast(model.value.message.toString());
        status.value = RxStatus.error();
      }
    });
  }

  Rx<ModelResponseCommon> modelAddToCart = ModelResponseCommon().obs;

  addToCart(id) {
    Map<String, dynamic> map = {};
    map['quantity'] = '1';
    map['product_id'] = id;
    repositories
        .postApi(url: ApiUrls.addToCart, mapData: map, context: context)
        .then((value) {
      modelAddToCart.value = ModelResponseCommon.fromJson(jsonDecode(value));
      cartController.getData();
      if (modelAddToCart.value.status!) {
        showToast(modelAddToCart.value.message.toString().split("'").first);
      } else {
        showToast(modelAddToCart.value.message.toString());
      }
    });
  }

  Rx<ModelResponseCommon> modelAddToWishlist = ModelResponseCommon().obs;

  addToWishlist(id) {
    Map<String, dynamic> map = {};
    map['product_id'] = id;
    repositories
        .postApi(url: ApiUrls.addToWishlist, mapData: map, context: context)
        .then((value) {
      modelAddToWishlist.value =
          ModelResponseCommon.fromJson(jsonDecode(value));
      if (modelAddToWishlist.value.message.toString().contains("added")) {
        wishList.favProductsList.add(id.toString());
      } else {
        wishList.favProductsList
            .removeWhere((element) => element.toString() == id.toString());
      }
      if (modelAddToWishlist.value.status!) {
        showToast(modelAddToWishlist.value.message.toString().split("'").first);
        // homeData();
      } else {
        showToast(modelAddToWishlist.value.message.toString());
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  manageSplash() {
    if (showSplashScreen == true) {
      Future.delayed(const Duration(seconds: 4)).then((value) {
        showSplashScreen = false;
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    manageSplash();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      popup();
      checkFirstAppLaunch();
      manageSiteUrl();
      homeData();
      cartController.resetAll();
    });
  }

  bool noInternetRetry = false;

  RxString time = "00:00".obs;
  var logTime = "2022-09-10 00:05:00.000000";
  Timer? timer;
  int fiveMinute = 0;

  DateTime referenceTime = DateTime.now();

  setTimer({required DateTime givenTime}) {
    if (timer != null) {
      timer!.cancel();
    }
    int seconds =
        ((givenTime.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond) -
            DateTime.now().millisecondsSinceEpoch ~/
                Duration.millisecondsPerSecond);
    // DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond
    // referenceTime = DateTime.parse("2022-09-10 00:00:00.000000").add(Duration(seconds: timeInSeconds));

    int hours = seconds ~/ (60 * 60);

    if (kDebugMode) {
      print("Time...........       $seconds");
    }
    referenceTime = DateTime.parse("2022-09-10 00:00:00.000000")
        .add(Duration(seconds: seconds.abs()));
    fiveMinute = seconds;
    log(time.value);
    var logTime1 = DateFormat("mm:ss");
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (fiveMinute > 0) {
        fiveMinute--;
        hours = fiveMinute ~/ (60 * 60);
        referenceTime = referenceTime.subtract(const Duration(seconds: 1));
        time.value =
            "${hours == 0 ? "00" : hours < 10 ? "0$hours" : hours}:${logTime1.format(referenceTime)}";
      } else {
        timer.cancel();
        fiveMinute = 0;
        time.value = "00:00";
        log("Timer Stopped");
      }
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showSplashScreen
        ? const SplashScreen()
        : WillPopScope(
            onWillPop: () async {
              repositories.hideLoader();
              return true;
            },
            child: Container(
              color: Colors.white,
              child: Scaffold(
                key: scaffoldKey,
                drawer: const CustomDrawer(),
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Obx(() {
                    // if(menuItemsModel.data == null &&
                    //     menuController.storeInfo.data == null){
                    //   menuController.getAll();
                    // }
                    return status.value.isSuccess
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await homeData();
                              await cartController.getData();
                              await wishList.getWishListData();
                              // if (menuController.forMenuScreen.isEmpty &&
                              //     menuController.storeInfo.data == null) {
                              await menuController.getAllAsync();
                              // }
                              manageSiteUrl();
                              setState(() {});
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                AppAssets.dashboardNewBg),
                                            alignment: Alignment.topLeft)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                scaffoldKey.currentState!
                                                    .openDrawer();
                                              },
                                              icon: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 13, top: 8),
                                                child: Image.asset(
                                                  'assets/images/drawer_icon.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 24.0, top: 8),
                                              child: Obx(() {
                                                return InkWell(
                                                  onTap: () {
                                                    Get.toNamed(
                                                        CartScreen.route);
                                                  },
                                                  child: (cartController
                                                              .isDataLoading
                                                              .value &&
                                                          cartController.model
                                                                  .value.data !=
                                                              null)
                                                      ? Badge(
                                                          badgeStyle:
                                                              const BadgeStyle(
                                                                  badgeColor:
                                                                      Colors
                                                                          .black),
                                                          badgeContent: Text(
                                                            cartController
                                                                .model
                                                                .value
                                                                .data!
                                                                .items!
                                                                .map((e) => int.parse(
                                                                    (e.quantity ??
                                                                            0)
                                                                        .toString()))
                                                                .toList()
                                                                .sum
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
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
                                        ),
                                        addHeight(10),
                                        GestureDetector(
                                          onTap: () async {
                                            // log((DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond).toString());
                                            if (kDebugMode) {
                                              log((await FirebaseMessaging
                                                  .instance
                                                  .getToken())!);
                                            }
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                                    'What would you\nlike to eat?',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      color: const Color(
                                                          0xFF292323),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ))
                                                .padded(
                                                    givePadding:
                                                        const EdgeInsets.only(
                                                            left: 15)),
                                          ),
                                        ),
                                        addHeight(20),
                                        menuItems(),
                                        addHeight(40),
                                        bannerSlider(),
                                        addHeight(35),
                                        ...yallaMenu()
                                      ],
                                    ),
                                  ),
                                  if (time.value == "00:00" &&
                                      model.value.data!.timeBannerAd![0]
                                              .addScreen ==
                                          "Activate")
                                    timerAd(context),
                                  addHeight(20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      model.value.data!.bestSellerData!.icon !=
                                              ""
                                          ? Image.network(
                                              model.value.data!.bestSellerData!
                                                  .icon
                                                  .toString(),
                                              width: 25,
                                              height: 25,
                                            )
                                          : Image.asset(
                                              'assets/images/chicken_icon.png',
                                              width: 25,
                                              height: 25,
                                            ).toAppIcon,
                                      addWidth(9),
                                      Text(
                                        model.value.data!.bestSellerData!.title!
                                            .toUpperCase()
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF292323),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ).padded(
                                      givePadding:
                                          const EdgeInsets.only(left: 15)),
                                  SizedBox(
                                    height: 225,
                                    child: ListView.builder(
                                      primary: false,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          model.value.data!.vSlider!.length,
                                      // padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                    SingleProductScreen.route,
                                                    arguments: [
                                                      model
                                                          .value
                                                          .data!
                                                          .vSlider![index]
                                                          .productId,
                                                      model
                                                          .value
                                                          .data!
                                                          .vSlider![index]
                                                          .image,
                                                    ]);
                                              },
                                              child: Container(
                                                width: 180,
                                                height: 170,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CachedNetworkImage(
                                                      imageUrl: model
                                                          .value
                                                          .data!
                                                          .vSlider![index]
                                                          .image
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      errorWidget:
                                                          (_, __, ___) =>
                                                              const SizedBox(
                                                        width: 160,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  ...delicious(),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(MenuScreen.route);
                                    },
                                    child: SizedBox(
                                      width: context.getDeviceSize.width,
                                      height: 180,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          3, 0, 6, 15),
                                                  child: Card(
                                                    elevation: 4,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(14.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  model
                                                                      .value
                                                                      .data!
                                                                      .freeDeliverys![
                                                                          0]
                                                                      .freeDeliveryContent
                                                                      .toString()
                                                                      .toUpperCase(),
                                                                  style: GoogleFonts.poppins(
                                                                      color: const Color(
                                                                          0xffE02020),
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  model
                                                                      .value
                                                                      .data!
                                                                      .freeDeliverys![
                                                                          0]
                                                                      .freeDeliveryContent
                                                                      .toString()
                                                                      .toUpperCase(),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                          // color: Colors.red,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              const Color(0xff656565)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: context
                                                                  .getDeviceSize
                                                                  .width *
                                                              .3,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: SizedBox(
                                              height: 140,
                                              child: CachedNetworkImage(
                                                imageUrl: model
                                                    .value
                                                    .data!
                                                    .freeDeliverys![0]
                                                    .freeDeliverys
                                                    .toString(),
                                                fit: BoxFit.contain,
                                                errorWidget: (_, __, ___) =>
                                                    const SizedBox(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  addHeight(20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      model.value.data!.shortcutsData!.icon !=
                                              ""
                                          ? Image.network(
                                              model.value.data!.shortcutsData!
                                                  .icon
                                                  .toString(),
                                              width: 25,
                                              height: 25,
                                            )
                                          : Image.asset(
                                              'assets/images/chicken_icon.png',
                                              width: 25,
                                              height: 25,
                                            ).toAppIcon,
                                      addWidth(9),
                                      Text(
                                        model.value.data!.shortcutsData!.title!
                                            .toUpperCase()
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF292323),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ).padded(
                                      givePadding:
                                          const EdgeInsets.only(left: 15)),
                                  addHeight(6),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...model.value.data!.serviceSection!
                                            .map(
                                              (service) => GestureDetector(
                                                onTap: () {
                                                  if (service.serviceUrl !=
                                                      null) {
                                                    Get.offAllNamed(
                                                        service.serviceUrl!);
                                                    launchUrlToWeb(
                                                        service.serviceUrl);
                                                  }
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                                  5.0)
                                                              .copyWith(
                                                                  left: 15,
                                                                  right: 0),
                                                      child: Container(
                                                        height: 80,
                                                        width: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color(
                                                              0xFFFEF4D9),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .all(5),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: service
                                                              .serviceImages
                                                              .toString(),
                                                          height: 43,
                                                          width: 54,
                                                          errorWidget: (_, __,
                                                                  ___) =>
                                                              const SizedBox(
                                                            height: 43,
                                                            width: 54,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        service.serviceTitle
                                                            .toString()
                                                            .replaceAll(
                                                                " ", "\n"),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12.5,
                                                          color: const Color(
                                                              0xFF292323),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList()
                                      ],
                                    ),
                                  ),
                                  Obx(() {
                                    if (wishList.refreshInt.value > 0) {}
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: favoriteList(context),
                                    );
                                  }),
                                  appBottomLogo()
                                ],
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              if (noInternetRetry == false) {
                                noInternetRetry = true;
                                await homeData().catchError((e) {
                                  noInternetRetry = false;
                                });
                                await cartController.getData().catchError((e) {
                                  noInternetRetry = false;
                                });
                                manageSiteUrl();
                                noInternetRetry = false;
                              }
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(5)
                                          .copyWith(top: 40),
                                      child: buildShimmer(
                                        border: 15,
                                        width: AddSize.screenWidth * .35,
                                        height: 50,
                                      )),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: List.generate(
                                            9,
                                            (index) => Padding(
                                                padding: const EdgeInsets.all(5)
                                                    .copyWith(top: 15),
                                                child: buildShimmer(
                                                  border: 15,
                                                  width: 50,
                                                  height: 60,
                                                )))),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8)
                                                .copyWith(top: 25),
                                            child: buildShimmer(
                                              border: 15,
                                              width: AddSize.screenWidth * .75,
                                              height: 175,
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.all(8)
                                                .copyWith(top: 25),
                                            child: buildShimmer(
                                              border: 15,
                                              width: AddSize.screenWidth * .75,
                                              height: 175,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8)
                                          .copyWith(top: 25),
                                      child: buildShimmer(
                                        border: 5,
                                        width: AddSize.screenWidth * .2,
                                        height: 35,
                                      )),
                                  Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8)
                                              .copyWith(top: 25),
                                          child: buildShimmer(
                                            border: 5,
                                            width: AddSize.screenWidth * .28,
                                            height: 120,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(8)
                                              .copyWith(top: 25),
                                          child: buildShimmer(
                                            border: 5,
                                            width: AddSize.screenWidth * .28,
                                            height: 120,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(8)
                                              .copyWith(top: 25),
                                          child: buildShimmer(
                                            border: 5,
                                            width: AddSize.screenWidth * .28,
                                            height: 120,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8)
                                              .copyWith(top: 25),
                                          child: buildShimmer(
                                            border: 5,
                                            width: AddSize.screenWidth * .28,
                                            height: 120,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(8)
                                              .copyWith(top: 25),
                                          child: buildShimmer(
                                            border: 5,
                                            width: AddSize.screenWidth * .28,
                                            height: 120,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(8)
                                              .copyWith(top: 25),
                                          child: buildShimmer(
                                            border: 5,
                                            width: AddSize.screenWidth * .28,
                                            height: 120,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                  }),
                ),
                bottomNavigationBar: cartBottomWidget(
                    // onTap: () async {
                    //   await homeData();
                    //   await cartController.getData();
                    //   if(siteUrl.isEmpty){
                    //     await repositories.postApi(url: ApiUrls.siteUrl,mapData: {}).then((value) {
                    //       ModelSiteUrl modelSiteUrl = ModelSiteUrl.fromJson(jsonDecode(value));
                    //       if(modelSiteUrl.status!){
                    //         siteUrl = modelSiteUrl.data!.siteUrl ?? "";
                    //       }
                    //     });
                    //   }
                    // }
                    ),
              ),
            ),
          );
  }

  bannerSlider() {
    return CarouselSlider(
        options: CarouselOptions(
            viewportFraction: .85,
            autoPlay: true,
            padEnds: false,
            onPageChanged: (value, _) {},
            autoPlayCurve: Curves.ease,
            height: 172),
        items: model.value.data!.hSlider!
            .map(
              (e) => InkWell(
                onTap: () {
                  Get.toNamed(
                    SingleProductScreen.route,
                    arguments: [
                      e.productId.toString(),
                      e.image.toString(),
                    ],
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: e.image.toString(),
                      height: 172,
                      fit: BoxFit.fill,
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      errorWidget: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                ),
              ),
            )
            .toList());
  }

  List<Widget> favoriteList(BuildContext context) {
    if (wishList.model.value.data == null) {
      wishList.getWishListData();
    }
    return wishList.model.value.data!.isNotEmpty
        ? [
            addHeight(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/chicken_icon.png',
                  width: 25,
                  height: 25,
                ).toAppIcon,
                addWidth(9),
                Text(
                  'FAVORITES',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF292323),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ).padded(givePadding: const EdgeInsets.only(left: 15)),
            addHeight(15),
            wishList.model.value.data!.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...wishList.model.value.data!
                            .map(
                              (popularProduct) => Padding(
                                padding: const EdgeInsets.only(left: 14),
                                child: Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          SingleProductScreen.route,
                                          arguments: [
                                            popularProduct.id.toString(),
                                            popularProduct.imageUrl.toString(),
                                            popularProduct.name.toString()
                                          ],
                                        );
                                      },
                                      child: Container(
                                        height: 142,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: CachedNetworkImage(
                                            imageUrl: popularProduct.imageUrl
                                                .toString(),
                                            errorWidget: (_, __, ___) =>
                                                const SizedBox(
                                              height: 142,
                                              width: 130,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        left: 8,
                                        top: 8,
                                        child: buildPositioned(
                                            popularProduct.id.toString(),
                                            context))
                                  ],
                                ),
                              ),
                            )
                            .toList()
                      ],
                    ),
                  )
                : const Center(
                    child: Text("No Favorite Product"),
                  ),
          ]
        : [];
  }

  Container timerAd(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 35, right: 5),
      margin: const EdgeInsets.symmetric(horizontal: 14).copyWith(top: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                model.value.data!.timeBannerAd![0].adsUrl.toString()),
            fit: BoxFit.contain),
      ),
      height: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          flex: 2,
          child: time.value != "00:00"
              ? Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(125)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 22),
                      child: Obx(() {
                        return Text(
                          time.value,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ),
                  ],
                )
              : const SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.value.data!.timeBannerAd![0].adsTitle.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  model.value.data!.timeBannerAd![0].adsSubtitle.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: const Color(0xff656565),
                  ),
                )
              ]),
        )
      ]),
    );
  }

  List<Widget> yallaMenu() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          model.value.data!.yallaData!.icon != ""
              ? Image.network(
                  model.value.data!.yallaData!.icon.toString(),
                  width: 25,
                  height: 25,
                )
              : Image.asset(
                  'assets/images/chicken_icon.png',
                  width: 25,
                  height: 25,
                ).toAppIcon,
          addWidth(9),
          Text(
            model.value.data!.yallaData!.title!.toUpperCase().toString(),
            style: GoogleFonts.poppins(
              color: const Color(0xFF292323),
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ).padded(givePadding: const EdgeInsets.only(left: 15)),
      addHeight(10),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1),
        itemCount: menuController.yalCategories.entries.length,
        itemBuilder: (context, index) {
          final shortcut =
              menuController.yalCategories.entries.toList()[index].value;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.toNamed(MenuScreen.route,
                  arguments: shortcut.slug.toString());
            },
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: shortcut.yallaImage.toString(),
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const SizedBox(),
                  )),
            ),
          );
        },
      ),
      addHeight(20),
    ];
  }

  SingleChildScrollView menuItems() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...menuController.homeScreenTop.entries
              .map((e) => Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(MenuScreen.route,
                                arguments: e.value.slug.toString());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: CachedNetworkImage(
                                imageUrl: e.value.iconCate.toString(),
                                width: 40,
                                height: 40,
                                errorWidget: (_, __, ___) => const SizedBox(
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        addHeight(5),
                        Text(
                          e.value.name.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: const Color(0xFF292323),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          // ...model.value.data!.category!.categories!
          //     .map((cat) => Container(
          //           width: 60,
          //           margin: const EdgeInsets.symmetric(horizontal: 4),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               InkWell(
          //                 onTap: () {
          //                   Get.toNamed(MenuScreen.route,
          //                       arguments: cat.slug.toString());
          //                 },
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10)),
          //                   margin: const EdgeInsets.all(0),
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(7),
          //                     child: Image.network(
          //                       cat.imageUrl.toString(),
          //                       width: 40,
          //                       height: 40,
          //                       errorBuilder: (_, __, ___) => const SizedBox(
          //                         width: 40,
          //                         height: 40,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               addHeight(5),
          //               Text(
          //                 cat.name.toString(),
          //                 maxLines: 1,
          //                 overflow: TextOverflow.ellipsis,
          //                 textAlign: TextAlign.center,
          //                 style: GoogleFonts.poppins(
          //                   fontWeight: FontWeight.w400,
          //                   fontSize: 10,
          //                   color: const Color(0xFF292323),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ))
          //     .toList(),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  List<Widget> delicious() {
    return [
      addHeight(25),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          model.value.data!.deliciousData!.icon != ""
              ? Image.network(
            model.value.data!.deliciousData!.icon.toString(),
                  width: 25,
                  height: 25,
                )
              : Image.asset(
                  'assets/images/chicken_icon.png',
                  width: 25,
                  height: 25,
                ).toAppIcon,
          addWidth(6),
          Text(
            model.value.data!.deliciousData!.title!.toUpperCase().toString(),
            style: GoogleFonts.poppins(
              color: const Color(0xFF292323),
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ).padded(givePadding: const EdgeInsets.only(left: 15)),
      addHeight(6),
      SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.value.data!.categoryProducts!.products!.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * .85,
                  margin: const EdgeInsets.all(5).copyWith(left: 15, right: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 1,
                            offset: Offset(1, 1))
                      ]),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(SingleProductScreen.route, arguments: [
                        model.value.data!.categoryProducts!.products![index].id
                            .toString(),
                        model.value.data!.categoryProducts!.products![index]
                            .imageUrl
                            .toString(),
                        model
                            .value.data!.categoryProducts!.products![index].name
                            .toString()
                      ]);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: CachedNetworkImage(
                                imageUrl: model.value.data!.categoryProducts!
                                    .products![index].imageUrl
                                    .toString(),
                                width: 100,
                                height: 100,
                                errorWidget: (_, __, ___) => const SizedBox(
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  addHeight(13),
                                  Obx(() {
                                    if (cartController.refreshInt.value > 0) {
                                      cartController.price = model
                                          .value
                                          .data!
                                          .categoryProducts!
                                          .products![index]
                                          .currencySymbol
                                          .toString();
                                    }
                                    return Row(
                                      children: [
                                        if (cartController.productsMap[model
                                                .value
                                                .data!
                                                .categoryProducts!
                                                .products![index]
                                                .id
                                                .toString()] !=
                                            null)
                                          Text(
                                            "${cartController.productsMap[model.value.data!.categoryProducts!.products![index].id.toString()]}X",
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFFE02020),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        Expanded(
                                          child: Text(
                                            model.value.data!.categoryProducts!
                                                .products![index].name
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: const Color(0xFF292323),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  addHeight(4),
                                  Text(
                                    model.value.data!.categoryProducts!
                                        .products![index].shortDescription
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: false,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: const Color(0xFF444444),
                                    ),
                                  ),
                                  addHeight(10),
                                  const SizedBox(
                                      height: 2,
                                      width: 200,
                                      child: Divider(
                                        thickness: 1,
                                        color: Color(0xFFEAEAEA),
                                      )),
                                  addHeight(10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      formatPrice2(
                                        model
                                                .value
                                                .data!
                                                .categoryProducts!
                                                .products![index]
                                                .regularPrice ??
                                            '',
                                        model
                                                .value
                                                .data!
                                                .categoryProducts!
                                                .products![index]
                                                .currencySymbol ??
                                            '',
                                        GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: const Color(0xFF444444)),
                                      ),
                                      addWidth(20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, bottom: 10),
                                        child: InkWell(
                                          onTap: () {
                                            addToCart(model
                                                .value
                                                .data!
                                                .categoryProducts!
                                                .products![index]
                                                .id
                                                .toString());
                                            cartBottomWidget();
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: const Color(0xFFE02020)),
                                            child: Center(
                                              child: Text(
                                                'ADD TO CART',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            );
          },
        ),
      ),
      addHeight(30),
    ];
  }
}

Future addToWishlist(id, context) async {
  final wishList = Get.put(WishlistController());
  Map<String, dynamic> map = {};
  map['product_id'] = id;
  await Repositories()
      .postApi(url: ApiUrls.addToWishlist, mapData: map, context: context)
      .then((value) {
    ModelResponseCommon modelAddToWishlist =
        ModelResponseCommon.fromJson(jsonDecode(value));
    if (modelAddToWishlist.message.toString().contains("added")) {
      wishList.getWishListData();
      wishList.favProductsList.add(id.toString());
    } else {
      wishList.favProductsList
          .removeWhere((element) => element.toString() == id.toString());
      wishList.model.value.data!
          .removeWhere((element) => element.id.toString() == id.toString());
    }
    if (modelAddToWishlist.status!) {
      showToast(modelAddToWishlist.message.toString().split("'").first);
    } else {
      showToast(modelAddToWishlist.message.toString());
    }
    wishList.updateUi();
  });
}

buildPositioned(String id, context) {
  final wishList = Get.put(WishlistController());
  return Obx(() {
    if (wishList.refreshInt.value > 0) {}
    return SizedBox(
      child: InkWell(
        onTap: () {
          addToWishlist(id.toString(), context);
        },
        child: wishList.favProductsList.contains(id.toString())
            ? Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6.6),
                child: SvgPicture.asset("assets/icons/liked_icon.svg"),
              )
            : Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset("assets/icons/unliked_icon.svg"),
              ),
      ),
    );
  });
}

Future<void> launchUrlToWeb(value) async {
  final Uri url = Uri.parse("$value");
  try {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    throw Exception(e);
  }
}

appBottomLogo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      addHeight(30),
      Column(
        children: [
          GestureDetector(
            onTap: () {
              if (modelSiteUrl.data != []) {
                launchUrlToWeb(modelSiteUrl.data!.first.cwUrl);
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                  imageUrl: modelSiteUrl.data!.first.cwLogo ?? '',
                ),
              ),
            ),
          ),
          addHeight(16),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (modelSiteUrl.data != []) {
                launchUrlToWeb(modelSiteUrl.data!.first.mokaUrl);
              }
            },
            child: Center(
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    value: progress.progress,
                  ),
                ),
                imageUrl: modelSiteUrl.data!.first.mokaLogo ?? '',
              ),
            ),
          ),
        ],
      ),
      addHeight(40),
    ],
  );
}
