import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/models/model_get_cart.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/repositories/new_common_repo/repository.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/ui/screens/login_screen.dart';
import 'package:dinelah/ui/screens/signup_screen.dart';
import 'package:dinelah/ui/widget/common_button.dart';
import 'package:dinelah/ui/widget/common_button_white.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/new_controllers/address_controller.dart';
import '../../helper/helper.dart';
import '../../models/switch_off_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/price_format.dart';
import '../widget/app_bar.dart';
import 'package:collection/collection.dart';
import 'bottom_nav_bar.dart';
import 'checkout_screen.dart';
import 'menu_screen.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefs;

class CartScreen extends StatefulWidget {
  static const String route = "/CartScreen";

  const CartScreen({Key? key}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.put(CartController());
  final Repositories repositories = Repositories();
  final double subtotal = 100.0;
  final double shipping = 10.0;


  final addressController = Get.put(AddressController());

  Future<bool> _handleLocationPermission() async {
    await Permission.locationWhenInUse.request();
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled().then((value) {
      if (!value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      }
      return value;
    });
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission().then((value) {
      if (value == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      }
      return value;
    });
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission().then((value) {
        if (value == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        }
        return value;
      });
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  LatLng currentLatLong = const LatLng(0, 0);

  // Future<void> _getCurrentPosition() async {
  //   await Permission.locationWhenInUse.request();
  //   final hasPermission = await _handleLocationPermission();
  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
  //     currentLatLong = LatLng(position.latitude, position.longitude).checkLatLong;
  //     _getAddressFromLatLng(currentLatLong);
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   }).catchError((e) {
  //     debugPrint(e.toString());
  //   });
  // }

  String address = "";

  _getAddressFromLatLng(LatLng latLong) async {
    await placemarkFromCoordinates(latLong.latitude, latLong.longitude).then((List<Placemark> placemarks) {
      var place = placemarks[0];
      address = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      if (mounted) {
        setState(() {});
      }
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  switchUser() {
    // Map<String, dynamic> map = {};

    repositories.getApi(url: ApiUrls.switchOffUrl, mapData: {}).then((value) {
      modelSwitchOff.value = ModelSwitchOff.fromJson(jsonDecode(value));
      if (modelSwitchOff.value.status!) {
        statusSwitchOff.value = RxStatus.success();
      } else {
        statusSwitchOff.value = RxStatus.error();
      }
    });
  }

  updateCartCount({required CartProductItem product, required bool increase, required Function() updated}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // if (preferences.getString('user_details') != null) {
    Map<String, dynamic> map = {};
    map["product_id"] = product.product!.id;
    map["quantity"] = increase ? "1" : "-1";
    if (product.addons!.cCustomOptions != null && product.addons!.cCustomOptions!.isNotEmpty) {
      map["option_values"] = product.addons!.cCustomOptions!;
      map["option_price"] =
          preferences.getString('user_details') != null ? product.addons!.iCustomPrice : product.addons!.option_price;
    }

    repositories.postApi(url: ApiUrls.updateCartUrl, mapData: map, context: context).then((value) {
      log("update Response....     $value");
      ModelResponseCommon modelResponseCommon = ModelResponseCommon.fromJson(jsonDecode(value));
      if (modelResponseCommon.status == true) {
        updated();
      }
      cartController.getData();
    });
  }

  RxString currentCoupon = "".obs;
  RxString appliedCoupon = "".obs;

  Rx<ModelSwitchOff> modelSwitchOff = ModelSwitchOff().obs;
  Rx<RxStatus> statusSwitchOff = RxStatus.empty().obs;

  @override
  void initState() {
    super.initState();
    // _getCurrentPosition();
    cartController.getData();
    addressController.getAddresses();
    switchUser();
    getShippingList().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: commonAppBar(title: "BASKET", showCart: false, backGround: Colors.white),
      body: Obx(() {
        if (cartController.refreshInt.value > 0) {}
        return (cartController.isDataLoading.value &&
                statusSwitchOff.value.isSuccess &&
                cartController.model.value.data != null)
            ? cartController.model.value.data!.items!.isNotEmpty
        &&statusSwitchOff.value.isSuccess
                ? RefreshIndicator(
                    onRefresh: () async {
                      // _getCurrentPosition();
                      await cartController.getData();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (address.isNotEmpty)
                            const SizedBox(
                              height: 16,
                            ),
                          if (address.isNotEmpty)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                  padding: const EdgeInsets.all(5),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ),
                                5.slideX,
                                Expanded(
                                    child: Text(
                                  address,
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                ))
                              ],
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                          ...cartController.model.value.data?.items
                              ?.map((product) => cartItems(product, () {
                            cartController.model.value.data!.items!.remove(product);
                            setState(() {});
                          }))
                              ?.toList() ?? [],
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                    Text('Special request ',
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
                                      controller: cartController.specialRequest,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: GoogleFonts.poppins(
                                              color: const Color(0xff999999), fontWeight: FontWeight.w400, fontSize: 10),
                                          prefixIcon: Image.asset('assets/images/special.png'),
                                          hintText: 'write your special request here'),
                                    ),
                                    addHeight(20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(13),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Save on your order',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        Text('Add Voucher',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xffE02020),
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller: cartController.couponCode,
                                      onChanged: (value) {
                                        currentCoupon.value = value;
                                      },
                                      decoration: InputDecoration(
                                          enabled: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                              )),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              )),
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: TextButton(
                                              onPressed: () {
                                                if (cartController.couponCode.text.trim().isNotEmpty) {
                                                  cartController.getData(context: context).then((value) {
                                                    if (cartController.model.value.data!.couponCode!.isNotEmpty) {
                                                      showToast("Coupon Code Applied");
                                                      appliedCoupon.value = cartController.couponCode.text.trim();
                                                    }
                                                  });
                                                } else {
                                                  showToast("Please enter coupon code");
                                                }
                                              },
                                              child: Obx(() {
                                                return Text(
                                                  currentCoupon.value != appliedCoupon.value
                                                      ? "Apply"
                                                      : cartController.model.value.data!.couponCode!.isNotEmpty
                                                          ? " Applied"
                                                          : "Apply",
                                                  style: GoogleFonts.poppins(
                                                    color: AppTheme.primaryColor,
                                                    fontSize: 15,
                                                  ),
                                                );
                                              }),
                                            ),
                                          )),
                                    ),
                                    addHeight(20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildHero(size),
                          appBottomLogo()
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text("No Product in cart"),
                  )
            : const Center(
                child: CircularProgressIndicator(),
              );
      }),
      bottomNavigationBar: Material(
        elevation: 10,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonButtonWhite(
                  buttonHeight: 6,
                  text: 'Add items',
                  onTap: () async {
                    Get.off(() => const MenuScreen());
                  },
                  mainGradient: AppTheme.primaryGradientColor,
                  buttonWidth: 0,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
                Expanded(
                  child: CommonButton(
                    buttonHeight: 6.7,
                    btnColor: const Color(0xffE02020),
                    text: 'Checkout',
                    onTap: () async {
                      prefs.SharedPreferences preferences = await prefs.SharedPreferences.getInstance();
                      if (preferences.getString('user_details') != null) {
                        if (cartController.model.value.data!.items!.isNotEmpty) {
                          Get.toNamed(CheckoutCScreen.route);
                        } else {
                          showToast("Please add item in your cart");
                        }
                      } else {
                        showToast("Please log in to continue");
                        Get.to(() => const LoginScreen());
                        Get.to(() => const SignUpScreen());
                      }
                    },
                    buttonWidth: 0,
                  ),
                )


            ],
          ),
        ),
      ),
    );
  }

  Container cartItems(CartProductItem product, Function() remove) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(
                        text: "${product.quantity}x ",
                        style:
                            GoogleFonts.poppins(color: const Color(0xFFE02020), fontSize: 15, fontWeight: FontWeight.w600),
                        children: <InlineSpan>[
                          TextSpan(
                              text: product.product!.name ?? "",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF292323), fontSize: 15, fontWeight: FontWeight.w600))
                        ])),
                    const SizedBox(
                      height: 4,
                    ),
                    if (product.addons != null)
                      Text(
                        product.addons!.cCustomOptions!.entries.map((e) => e.value.toString()).toList().join(" + "),
                        style:
                            GoogleFonts.poppins(color: const Color(0xFF444444), fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                height: 85,
                width: 85,
                child: CachedNetworkImage(
                  imageUrl: product.product!.imageUrl.toString(),
                  errorWidget: (_, __, ___) => const SizedBox(),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Divider(
                      thickness: 0,
                      height: 0,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: formatPrice2(
                          product.addons!.cCustomOptions!.isNotEmpty
                              ? product.totalPrice.toString() != "0"
                                  ? int.parse(product.totalPrice.toString())
                                  : (int.parse(product.product!.price.toString()) *
                                      (int.tryParse(product.quantity.toString()) ?? 1))
                              : (int.parse(product.product!.price.toString()) *
                                  (int.tryParse(product.quantity.toString()) ?? 1)),
                          product.product!.currencySymbol!,
                          GoogleFonts.poppins(color: const Color(0xFF444444), fontSize: 16, fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  updateCartCount(
                      product: product,
                      increase: false,
                      updated: () {
                        product.quantity = ((int.tryParse(product.quantity.toString()) ?? 0) - 1).toString();
                        if ((int.tryParse(product.quantity.toString()) ?? 0) <= 0) {
                          remove();
                        }
                        setState(() {});
                      });
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
              Text(
                product.quantity.toString(),
                style: GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  updateCartCount(
                      product: product,
                      increase: true,
                      updated: () {
                        product.quantity = ((int.tryParse(product.quantity.toString()) ?? 0) + 1).toString();
                        setState(() {});
                      });
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
          ),
        ],
      ),
    );
  }
}

cartBottomWidget({onTap}) {
  final cartController = Get.put(CartController());
  return Obx(() {
    if (cartController.refreshInt.value > 0) {}
    return cartController.hasInternetConnection
        ? (cartController.isDataLoading.value && cartController.model.value.data != null)
            ? cartController.model.value.data!.items!.isNotEmpty
                ? Hero(
                    tag: "Cart",
                    child: Material(
                      elevation: 10,
                      child: Container(
                          color: Colors.grey.shade50,
                          padding: const EdgeInsets.all(15),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(CartScreen.route);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xFFFFA5A5),
                                    ),
                                    child: Text(
                                      cartController.model.value.data!.items!
                                          .map((e) => int.parse((e.quantity ?? 0).toString()))
                                          .toList()
                                          .sum
                                          .toString(),
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFFFFFFFF), fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'View Basket',
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Obx(() {
                                      int total = cartController.model.value.data!.items!
                                          .map((e) =>
                                              double.tryParse(e.totalPrice.toString() != "0"
                                                  ? e.totalPrice.toString()
                                                  : (int.parse(e.product!.price.toString()) *
                                                          int.parse(e.quantity.toString()))
                                                      .toString()) ??
                                              0)
                                          .toList()
                                          .sum
                                          .toInt();
                                      return formatPrice2(
                                          total,
                                          cartController.model.value.data!.cartmeta!.currencySymbol ?? '',
                                          GoogleFonts.poppins(
                                              color: const Color(0xFFFFFFFF),
                                              fontSize: 14,
                                              letterSpacing: .7,
                                              fontWeight: FontWeight.w400));
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink()
        : Hero(
            tag: "Cart",
            child: Material(
              elevation: 10,
              child: Container(
                  color: Colors.grey.shade50,
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: onTap ?? () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No Internet Connection',
                        style:
                            GoogleFonts.poppins(color: const Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )),
            ),
          );
  });
}

buildHero(Size size, {String? deliveryFee, int? shippingAmount}) {
  final cartController = Get.put(CartController());

  int total = cartController.model.value.data!.items!
      .map((e) => double.tryParse(e.totalPrice.toString() != "0" ?
  e.totalPrice.toString() :
  (int.parse(e.product!.price.toString()) * int.parse(e.quantity.toString())).toString()) ??
      0).toList().sum.toInt();

   // final cleanedDeliveryFee = deliveryFee?.replaceAll(RegExp(r'[^0-9.]'), '');
   // final formattedDeliveryFee = cleanedDeliveryFee != null
   //     ? NumberFormat.decimalPattern().format(double.parse(cleanedDeliveryFee))
   //     : null;

  return Material(
    color: Colors.white,
    elevation: 0,
    borderRadius: BorderRadius.circular(5),
    child: Container(
      margin: const EdgeInsets.all(15.0),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Payment Summary',
            style: GoogleFonts.poppins(color: const Color(0xFF333333), fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Divider(
            thickness: 0,
            color: Color(0xffEAEAEA),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Basket Total',
                style: GoogleFonts.poppins(color: const Color(0xFF555555), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              formatPrice2(total, cartController.model.value.data!.cartmeta!.currencySymbol ?? '',
                  GoogleFonts.poppins(color: const Color(0xFF555555), fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.end),
            ],
          ),
          if (cartController.model.value.data!.couponCode!.isNotEmpty) ...[
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Applied Coupon Code discount',
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                formatPrice2(
                    cartController.model.value.data!.couponCode!.first.discount,
                    cartController.model.value.data!.cartmeta!.currencySymbol ?? '',
                    GoogleFonts.poppins(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.end),
              ],
            ),
          ],
          const SizedBox(
            height: 8,
          ),
          if (deliveryFee != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Fee',
                  style: GoogleFonts.poppins(color: const Color(0xFF555555), fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  deliveryFee,
                  // formattedDeliveryFee!,
                  // Use the formatted delivery fee
                  style: GoogleFonts.poppins(color: const Color(0xFF555555), fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total amount',
                style: GoogleFonts.poppins(color: const Color(0xFF555555), fontSize: 15, fontWeight: FontWeight.w600),
              ),
              formatPrice2(
                  (total -
                      (cartController.model.value.data!.couponCode!.isNotEmpty
                          ? (int.tryParse(cartController.model.value.data!.couponCode!.first.discount.toString()) ?? 0)
                          : 0) +
                      (shippingAmount ?? 0))
                      .toString(),
                  cartController.model.value.data!.cartmeta!.currencySymbol ?? '',
                  GoogleFonts.poppins(color: const Color(0xFF555555), fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.end),
            ],
          ),
        ],
      ),
    ),
  );
}



