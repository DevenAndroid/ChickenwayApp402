import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client_information/client_information.dart';
import 'package:dinelah/controller/wishlist_controller.dart';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/models/new_models/model_site_url.dart';
import 'package:dinelah/splash_screen.dart';
import 'package:dinelah/ui/screens/timer_widget.dart';
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
import '../../models/match_apk_model.dart';
import '../../models/model_popup_data.dart';
import '../../models/model_shipping_methods.dart';
import '../../models/notificaton_onclick_model.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../res/app_assets.dart';
import '../../utils/api_constant.dart';
import '../widget/drawer.dart';
import 'cart_screen.dart';
import 'package:collection/collection.dart';
import 'checkout_screen.dart';
import 'notification_screen.dart';
import 'notification_service.dart';
import 'orderdetails.dart';
import 'single_product_screen.dart';
import 'menu_screen.dart';

ModelSiteUrl modelSiteUrl = ModelSiteUrl();

NotificationServices notificationServices = NotificationServices();

Future manageSiteUrl() async {
  if (modelSiteUrl.data == null) {
    await Repositories().postApi(url: ApiUrls.siteUrl, mapData: {}).then((value) {
      modelSiteUrl = ModelSiteUrl.fromJson(jsonDecode(value));
      getShippingList();
    });
  }
}

bool showSplashScreen = false;
bool shouldShowCartIcon = true;
String fcm = "";

DateTime reverseTime(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23 - date.hour, 59 - date.minute, 59 - date.second);
}

ModelShippingMethodsList shippingMethodsList = ModelShippingMethodsList();

class MainHomeScreen extends StatefulWidget {
  static const String route = "/MainHomeScreen";

  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  MainHomeScreenState createState() => MainHomeScreenState();

  static fromColors({required Color baseColor, required Color highlightColor, required Container child}) {}
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
  Rx<RxStatus> statusOfPopUp = RxStatus
      .empty()
      .obs;
  final Repositories repositories = Repositories();

  Duration difference = Duration();

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
                          Image(
                            image: NetworkImage(modelPopUp.value.data!.img.toString()),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                                getInit();
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                )));

        // : const CommonProgressIndicator();
      },
    );
  }

  makingPhoneCall(web) async {
    var url = Uri.parse(web);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getInit() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.notification != null) {
      NotificationOnClickModel groupModal =
      NotificationOnClickModel.fromJson(jsonDecode(initialMessage.data["payload"]));

      if (groupModal.screenType == 'chat') {
        Get.toNamed(OrderDetails.route, arguments: [groupModal.orderId.toString()]);
      } else if (groupModal.screenType == 'post_or_product_update') {
        if (groupModal.isAnother == true) {
          makingPhoneCall(groupModal.pLink.toString());
        } else {
          if (groupModal.isProduct == true) {
            Get.toNamed(SingleProductScreen.route, arguments: [groupModal.pId.toString()]);
          } else {
            makingPhoneCall(groupModal.pLink.toString());
          }
        }
      } else {}
    }
  }

  manageNotification() async {
    print("functionnnnn callll");
    NotificationService().initializeNotification();
    getInit();

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Notification issss  ${event.notification!.title.toString()}');
      print('Notification issss dataedereere ${event.data['payload']}');
      print('Notificatio data ${event.data}');
      NotificationOnClickModel groupModal = NotificationOnClickModel.fromJson(jsonDecode(event.data["payload"]));

      if (groupModal.screenType == 'chat') {
        Get.toNamed(OrderDetails.route, arguments: [groupModal.orderId.toString()]);
      } else if (groupModal.screenType == 'post_or_product_update') {
        if (groupModal.isAnother == true) {
          makingPhoneCall(groupModal.pLink.toString());
        } else {
          if (groupModal.isProduct == true) {
            Get.toNamed(SingleProductScreen.route, arguments: [groupModal.pId.toString()]);
          } else {
            makingPhoneCall(groupModal.pLink.toString());
          }
        }
      } else {}
      print('something went wrong');
    });


    FirebaseMessaging.onBackgroundMessage((event) async {
      print('Notification issss  ${event.notification?.title.toString()}');
      print('Notification issss dataedereere ${event.data?['payload']}');

      if (event.data != null) {
        final payload = event.data!['payload'];
        if (payload != null) {
          NotificationOnClickModel groupModal = NotificationOnClickModel.fromJson(jsonDecode(payload));

          if (groupModal.screenType == 'chat') {
            Get.toNamed(OrderDetails.route, arguments: [groupModal.orderId.toString()]);
          } else if (groupModal.screenType == 'post_or_product_update') {
            if (groupModal.isAnother == true) {
              makingPhoneCall(groupModal.pLink.toString());
            } else {
              if (groupModal.isProduct == true) {
                Get.toNamed(SingleProductScreen.route, arguments: [groupModal.pId.toString()]);
              } else {
                makingPhoneCall(groupModal.pLink.toString());
              }
            }
          } else {
            print('Unhandled screenType: ${groupModal.screenType}');
          }
        } else {
          print('Payload is null');
        }
      } else {
        print('Data is null');
      }

      // Ensure that the function returns a Future<void>
      return Future.value(); // or return null;
    });
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

  // final menuController = Get.put(ProductsMenuController());

  Rx<ModelResponseCommon> modelDelete = ModelResponseCommon().obs;

  Rx<RxStatus> statusOfDelete = RxStatus
      .empty()
      .obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  updateCartCount({
    required id,
    required bool increase,
  }) {
    repositories.postApi(context: context, url: ApiUrls.updateCartUrl, mapData: {
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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(border), color: Colors.white),
      ),
    );
  }

  Rx<HomeModel> model = HomeModel().obs;
  Rx<RxStatus> status = RxStatus
      .empty()
      .obs;

  Future homeData() async {
    await repositories.postApi(url: ApiUrls.homePage, mapData: {}, showMap: true, showResponse: true).then((value) {
      model.value = HomeModel.fromJson(jsonDecode(value));
      if (model.value.data != null) {
        DateTime? time11;
        try {
          // time11 = DateFormat("yyyy-MM-dd").parse(model.value.data!.timeBannerAd![4].offerDuration.toString());
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
    repositories.postApi(url: ApiUrls.addToCart, mapData: map, context: context).then((value) {
      modelAddToCart.value = ModelResponseCommon.fromJson(jsonDecode(value));
      cartController.getData();
      if (modelAddToCart.value.status!) {
        showToast(modelAddToCart.value.message
            .toString()
            .split("'")
            .first);
      } else {
        showToast(modelAddToCart.value.message.toString());
      }
    });
  }

  Rx<ModelResponseCommon> modelAddToWishlist = ModelResponseCommon().obs;

  addToWishlist(id) {
    Map<String, dynamic> map = {};
    map['product_id'] = id;
    repositories.postApi(url: ApiUrls.addToWishlist, mapData: map, context: context).then((value) {
      modelAddToWishlist.value = ModelResponseCommon.fromJson(jsonDecode(value));
      if (modelAddToWishlist.value.message.toString().contains("added")) {
        wishList.favProductsList.add(id.toString());
      } else {
        wishList.favProductsList.removeWhere((element) => element.toString() == id.toString());
      }
      if (modelAddToWishlist.value.status!) {
        showToast(modelAddToWishlist.value.message
            .toString()
            .split("'")
            .first);
        // homeData();
      } else {
        showToast(modelAddToWishlist.value.message.toString());
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

// GET FCM AND DRVICE ID BEFORE LOGIN
  String deviceId = "";

  getFcmBeforLogin() async {
    var fcmToekn = await FirebaseMessaging.instance.getToken();
    await ClientInformation.fetch().then((value) {
      deviceId = value.deviceId.toString();
      log('Device Id BEFORE ${deviceId}');
    });
    log("DATTTTTTAAAA");
    Map<String, dynamic> map = {};
    map['device_id'] = deviceId;
    map['fcm_token'] = fcmToekn!;
    log("Data ${map.toString()}");
    repositories
        .postApi(
        url: ("https://chickenway.app/wp-json/api/woocustomer/update_user_fcm_data"),
        mapData: map,
        context: context)
        .then((value) {
      log("Data before login ${map.toString()}");
    });
  }

  Rx<MatchApkModel> matchApkVersion = MatchApkModel().obs;
  Rx<RxStatus> statusOfMatch = RxStatus
      .empty()
      .obs;

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

  getFcm() async {
    fcm = (await FirebaseMessaging.instance.getToken())!;
    log(" FCM IS ${fcm}");
  }

  @override
  _launchAppStore() async {
    const url = 'https://apps.apple.com/us/app/chickenway/id6450103488'; // Replace this with your App Store link
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchPlayStore() async {
    final String packageName = 'com.chickenway.moka'; // Replace with your app's package name
    final url = 'market://details?id=$packageName';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final fallbackUrl = 'https://play.google.com/store/apps/details?id=$packageName';
      await launch(fallbackUrl);
    }
  }

  initState() {
    super.initState();
    homeData();
    cartController.getData();
    wishList.getWishListData();
    menuController.getProducts();
    menuController.getAllAsync();
    menuController.getAll();
    getInit();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
    getFcmBeforLogin();
    getFcm();
    setTimer(givenTime: DateTime.now());
    manageNotification();
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
    int seconds = ((givenTime.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond) -
        DateTime
            .now()
            .millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond);
    // DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    // referenceTime = DateTime.parse("2022-09-10 00:00:00.000000").add(Duration(seconds: timeInSeconds));

    int hours = seconds ~/ (60 * 60);

    if (kDebugMode) {
      print("Time...........       $seconds");
    }
    referenceTime = DateTime.parse("2024-02-17 00:00:00.000000").add(Duration(seconds: seconds.abs()));
    fiveMinute = seconds;
    log(time.value);
    var logTime1 = DateFormat("mm:ss");
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (fiveMinute > 0) {
        fiveMinute--;
        hours = fiveMinute ~/ (60 * 60);
        referenceTime = referenceTime.subtract(const Duration(seconds: 1));
        time.value = "${hours == 0 ? "00" : hours < 10 ? "0$hours" : hours}:${logTime1.format(referenceTime)}";
        log("TIME ISSSS" + time.value);
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
              return status.value.isSuccess
                  ? RefreshIndicator(
                onRefresh: () async {
                  await homeData();
                  await cartController.getData();
                  await wishList.getWishListData();
                  await menuController.getProducts();
                  await menuController.getAllAsync();

                  // }
                  manageSiteUrl();
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
                                image: AssetImage(AppAssets.dashboardNewBg), alignment: Alignment.topLeft)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    scaffoldKey.currentState!.openDrawer();
                                  },
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 13, top: 8),
                                    child: Image.asset(
                                      'assets/images/drawer_icon.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 24.0, top: 8),
                                  child: Obx(() {
                                    return InkWell(
                                      onTap: () {
                                        Get.toNamed(CartScreen.route);
                                      },
                                      child: (cartController.isDataLoading.value &&
                                          cartController.model.value.data != null)
                                          ? Badge(
                                          badgeStyle: const BadgeStyle(badgeColor: Colors.black),
                                          badgeContent: Text(
                                            cartController.model.value.data!
                                                .items!
                                                .map((e) => int.parse((e.quantity ?? 0).toString()))
                                                .toList()
                                                .sum
                                                .toString(),
                                            style:
                                            GoogleFonts.poppins(color: Colors.white, fontSize: 10),
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
                                  log((await FirebaseMessaging.instance.getToken())!);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text('What would you\nlike to eat?',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: const Color(0xFF292323),
                                      fontWeight: FontWeight.w600,
                                    )).padded(givePadding: const EdgeInsets.only(left: 15)),
                              ),
                            ),
                            addHeight(10),
                            menuItems(),
                            addHeight(40),
                            bannerSlider(),
                            addHeight(35),
                            ...yallaMenu()
                          ],
                        ),
                      ),
                      if (time.value == "00:00" &&
                          model.value.data!.timeBannerAd![0].addScreen == "Activate")
                        timerAd(context),
                      addHeight(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          model.value.data!.bestSellerData!.icon != ""
                              ? CachedNetworkImage(
                              width: 25,
                              height: 25,
                              imageUrl: model.value.data!.bestSellerData!.icon.toString(),
                              errorWidget: (_, __, ___) =>
                                  Image.asset(
                                    'assets/images/chicken_icon.png',
                                    width: 25,
                                    height: 25,
                                  ),
                              placeholder: (_, __) =>
                                  Image.asset(
                                    'assets/images/chicken_icon.png',
                                    width: 25,
                                    height: 25,
                                  ))
                              : Image
                              .asset(
                            'assets/images/chicken_icon.png',
                            width: 25,
                            height: 25,
                          )
                              .toAppIcon,
                          addWidth(9),
                          Text(
                            model.value.data!.bestSellerData!.title!.toUpperCase().toString(),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF292323),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ).padded(givePadding: const EdgeInsets.only(left: 12)),
                      SizedBox(
                        height: 225,
                        child: ListView.builder(
                          primary: false,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: model.value.data!.vSlider!.length,
                          // padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(SingleProductScreen.route, arguments: [
                                      model.value.data!.vSlider![index].productId,
                                      model.value.data!.vSlider![index].image,
                                    ]);
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 205,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: model.value.data!.vSlider![index].image.toString(),
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
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
                          height: 140,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 0, 9, 10),
                                      child: Card(
                                        elevation: 4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(14.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      model.value.data!.freeDeliverys![0].freeDeliveryTitle
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: GoogleFonts.poppins(
                                                          color: const Color(0xffE02020),
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      model
                                                          .value.data!.freeDeliverys![0].freeDeliveryContent
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: GoogleFonts.poppins(
                                                        // color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                          color: const Color(0xff656565)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: context.getDeviceSize.width * .3,
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
                                    imageUrl: model.value.data!.freeDeliverys![0].freeDeliverys.toString(),
                                    fit: BoxFit.contain,
                                    errorWidget: (_, __, ___) => const SizedBox(),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          model.value.data!.shortcutsData!.icon != ""
                              ? CachedNetworkImage(
                              width: 25,
                              height: 25,
                              imageUrl: model.value.data!.shortcutsData!.icon.toString(),
                              errorWidget: (_, __, ___) =>
                                  Image.asset(
                                    'assets/images/chicken_icon.png',
                                    width: 25,
                                    height: 25,
                                  ),
                              placeholder: (_, __) =>
                                  Image.asset(
                                    'assets/images/chicken_icon.png',
                                    width: 25,
                                    height: 25,
                                  ))
                              : Image
                              .asset(
                            'assets/images/chicken_icon.png',
                            width: 25,
                            height: 25,
                          )
                              .toAppIcon,
                          addWidth(9),
                          Text(
                            model.value.data!.shortcutsData!.title!.toUpperCase().toString(),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF292323),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ).padded(givePadding: const EdgeInsets.only(left: 13)),
                      addHeight(6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            //moka 4
                            ...model.value.data!.serviceSection!
                                .map(
                                  (service) =>
                                  GestureDetector(
                                    onTap: () {
                                      if (service.isProduct == true) {
                                        Get.toNamed(SingleProductScreen.route,
                                            arguments: [service.pId.toString()]);
                                      } else {
                                        Get.toNamed(MenuScreen.route,
                                            arguments: [service.casteSlug.toString()]);
                                      }
                                      // if (service.isProduct !=
                                      //     null) {
                                      //   Get.offAllNamed(
                                      //       service.serviceUrl!);
                                      //
                                      // }
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0).copyWith(left: 20, right: 0),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: const Color(0xFFFEF4D9),
                                            ),
                                            margin: const EdgeInsets.all(5),
                                            child: CachedNetworkImage(
                                              imageUrl: service.serviceImages.toString(),
                                              height: 43,
                                              width: 54,
                                              errorWidget: (_, __, ___) =>
                                              const SizedBox(
                                                height: 43,
                                                width: 54,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Text(
                                              service.serviceTitle.toString().replaceAll(" ", " "),
                                              // maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.5,
                                                color: const Color(0xFF292323),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            padding: const EdgeInsets.all(5).copyWith(top: 40),
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
                                      (index) =>
                                      Padding(
                                          padding: const EdgeInsets.all(5).copyWith(top: 15),
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
                                  padding: const EdgeInsets.all(8).copyWith(top: 25),
                                  child: buildShimmer(
                                    border: 15,
                                    width: AddSize.screenWidth * .75,
                                    height: 175,
                                  )),
                              Padding(
                                  padding: const EdgeInsets.all(8).copyWith(top: 25),
                                  child: buildShimmer(
                                    border: 15,
                                    width: AddSize.screenWidth * .75,
                                    height: 175,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8).copyWith(top: 25),
                            child: buildShimmer(
                              border: 5,
                              width: AddSize.screenWidth * .2,
                              height: 35,
                            )),
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8).copyWith(top: 25),
                                child: buildShimmer(
                                  border: 5,
                                  width: AddSize.screenWidth * .28,
                                  height: 120,
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8).copyWith(top: 25),
                                child: buildShimmer(
                                  border: 5,
                                  width: AddSize.screenWidth * .28,
                                  height: 120,
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8).copyWith(top: 25),
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
                                padding: const EdgeInsets.all(8).copyWith(top: 25),
                                child: buildShimmer(
                                  border: 5,
                                  width: AddSize.screenWidth * .28,
                                  height: 120,
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8).copyWith(top: 25),
                                child: buildShimmer(
                                  border: 5,
                                  width: AddSize.screenWidth * .28,
                                  height: 120,
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8).copyWith(top: 25),
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
              (e) =>
              InkWell(
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
          Image
              .asset(
            'assets/images/chicken_icon.png',
            width: 25,
            height: 25,
          )
              .toAppIcon,
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
                  (popularProduct) =>
                  Padding(
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
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: CachedNetworkImage(
                                imageUrl: popularProduct.imageUrl.toString(),
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
                            left: 8, top: 8, child: buildPositioned(popularProduct.id.toString(), context))
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

  Widget timerAd(BuildContext context) {
    String apiTimeString = model.value.data!.timeBannerAd![0].offerDuration.toString();
    print(apiTimeString);

    return TimerWidgetScreen(
      time: apiTimeString,
      adsUrl: model.value.data!.timeBannerAd![0].adsUrl.toString(),
      timeBannerAd: model.value.data!.timeBannerAd![0],
    );
  }

  List<Widget> yallaMenu() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          model.value.data!.yallaData!.icon != ""
              ? CachedNetworkImage(
              width: 25,
              height: 25,
              imageUrl: model.value.data!.yallaData!.icon.toString(),
              errorWidget: (_, __, ___) =>
                  Image.asset(
                    'assets/images/chicken_icon.png',
                    width: 25,
                    height: 25,
                  ),
              placeholder: (_, __) =>
                  Image.asset(
                    'assets/images/chicken_icon.png',
                    width: 25,
                    height: 25,
                  ))
              : Image
              .asset(
            'assets/images/chicken_icon.png',
            width: 25,
            height: 25,
          )
              .toAppIcon,
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
      ).padded(givePadding: const EdgeInsets.only(left: 10)),
      addHeight(10),

      Obx(() {
        if (menuController.refreshInt.value > 0) {}
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150, crossAxisSpacing: 6, mainAxisSpacing: 6, childAspectRatio: 1),
          itemCount: menuController.yalCategories.entries.length,
          itemBuilder: (context, index) {
            print('manish');
            final shortcut = menuController.yalCategories.entries.toList()[index].value;
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.toNamed(MenuScreen.route, arguments: shortcut.slug.toString());
              },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
        );
      }),
      addHeight(20),
    ];
  }

  SingleChildScrollView menuItems() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() {
        if (menuController.refreshInt.value > 0) {}
        return Row(
          children: [
            ...menuController.homeScreenTop.entries
                .map((e) =>
                Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(MenuScreen.route, arguments: e.value.slug.toString());
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: CachedNetworkImage(
                              imageUrl: e.value.iconCate.toString(),
                              width: 40,
                              height: 40,
                              errorWidget: (_, __, ___) =>
                              const SizedBox(
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
            const SizedBox(
              width: 15,
            ),
          ],
        );
      }),
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
              ? CachedNetworkImage(
              width: 25,
              height: 25,
              imageUrl: model.value.data!.deliciousData!.icon.toString(),
              errorWidget: (_, __, ___) =>
                  Image.asset(
                    'assets/images/chicken_icon.png',
                    width: 25,
                    height: 25,
                  ),
              placeholder: (_, __) =>
                  Image.asset(
                    'assets/images/chicken_icon.png',
                    width: 25,
                    height: 25,
                  ))
              : Image
              .asset(
            'assets/images/chicken_icon.png',
            width: 25,
            height: 25,
          )
              .toAppIcon,
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
      ).padded(givePadding: const EdgeInsets.only(left: 13)),
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .90,
                  margin: const EdgeInsets.all(5).copyWith(left: 12, right: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 1, offset: Offset(1, 1))]),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(SingleProductScreen.route, arguments: [
                        model.value.data!.categoryProducts!.products![index].id.toString(),
                        model.value.data!.categoryProducts!.products![index].imageUrl.toString(),
                        model.value.data!.categoryProducts!.products![index].name.toString()
                      ]);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: CachedNetworkImage(
                                imageUrl: model.value.data!.categoryProducts!.products![index].imageUrl.toString(),
                                width: 100,
                                height: 100,
                                errorWidget: (_, __, ___) =>
                                const SizedBox(
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
                                          .value.data!.categoryProducts!.products![index].currencySymbol
                                          .toString();
                                    }
                                    return Row(
                                      children: [
                                        if (cartController.productsMap[
                                        model.value.data!.categoryProducts!.products![index].id.toString()] !=
                                            null)
                                          Text(
                                            "${cartController.productsMap[model.value.data!.categoryProducts!
                                                .products![index].id.toString()]}X",
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFFE02020),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        Expanded(
                                          child: Text(
                                            model.value.data!.categoryProducts!.products![index].name.toString(),
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
                                    model.value.data!.categoryProducts!.products![index].shortDescription.toString(),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      formatPrice2(
                                        model.value.data!.categoryProducts!.products![index].regularPrice ?? '',
                                        model.value.data!.categoryProducts!.products![index].currencySymbol ?? '',
                                        GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500, fontSize: 13, color: const Color(0xFF444444)),
                                      ),
                                      addWidth(20),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                                        child: InkWell(
                                          onTap: () {
                                            addToCart(
                                                model.value.data!.categoryProducts!.products![index].id.toString());
                                            cartBottomWidget();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            height: 25,
                                            // width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6), color: const Color(0xFFE02020)),
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
  await Repositories().postApi(url: ApiUrls.addToWishlist, mapData: map, context: context).then((value) {
    ModelResponseCommon modelAddToWishlist = ModelResponseCommon.fromJson(jsonDecode(value));
    if (modelAddToWishlist.message.toString().contains("added")) {
      wishList.getWishListData();
      wishList.favProductsList.add(id.toString());
    } else {
      wishList.favProductsList.removeWhere((element) => element.toString() == id.toString());
      wishList.model.value.data!.removeWhere((element) => element.id.toString() == id.toString());
    }
    if (modelAddToWishlist.status!) {
      showToast(modelAddToWishlist.message
          .toString()
          .split("'")
          .first);
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
                  progressIndicatorBuilder: (context, url, progress) =>
                      Center(
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
                progressIndicatorBuilder: (context, url, progress) =>
                    Center(
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
