import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/repositories/new_common_repo/repository.dart';
import 'package:dinelah/ui/widget/app_bar.dart';
import 'package:dinelah/utils/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controller/new_controllers/cart_controller.dart';
import '../../controller/new_controllers/address_controller.dart';
import '../../models/model_shipping_methods.dart';
import '../../models/new_models/create_order_model.dart';
import 'address/address_screen.dart';
import 'bottom_nav_bar.dart';
import 'cart_screen.dart';
import 'item/thankyou_page.dart';

bool selectAddressForOrder = false;
Future getShippingList() async {
  if (shippingMethodsList.data == null) {
    await Repositories().postApi(url: ApiUrls.shippingMethodsUrl).then((value) {
      shippingMethodsList =
          ModelShippingMethodsList.fromJson(jsonDecode(value));
      log("Shipping methods......    ${jsonEncode(shippingMethodsList)}");
    }).then((value) {});
  }
}

class CheckoutCScreen extends StatefulWidget {
  static const String route = "/CheckoutCScreen";

  const CheckoutCScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutCScreen> createState() => _CheckoutCScreenState();
}

class _CheckoutCScreenState extends State<CheckoutCScreen> {
  final cartController = Get.put(CartController());
  final ScrollController scrollController = ScrollController();
  final addressController = Get.put(AddressController());
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? mapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: const LatLng(0, 0).checkLatLong,
    zoom: 10.4746,
  );
  final Set<Marker> markers = {};

  Future<void> _onAddMarkerButtonPressed(
    LatLng lastMapPosition,
    markerTitle,
  ) async {
    markers.clear();
    markers.add(Marker(
        markerId: MarkerId(lastMapPosition.toString()),
        position: lastMapPosition,
        infoWindow: InfoWindow(
          title: markerTitle,
        ),
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
    if (mounted) {
      setState(() {});
    }
  }

  _getAddressFromLatLng(LatLng latLong) async {
    await placemarkFromCoordinates(latLong.latitude, latLong.longitude)
        .then((List<Placemark> placemarks) {
      var place = placemarks[0];
      deliveryLocation = placemarks[0];
      String address =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      _onAddMarkerButtonPressed(
        latLong,
        address,
      );
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  Placemark deliveryLocation = Placemark();

  applyCouponCode() {
    cartController.repositories
        .postApi(
            url: ApiUrls.applyCouponCode,
            mapData: {"coupon_code": cartController.couponCode.text.trim()},
            context: context)
        .then((value) {
      ModelResponseCommon modelResponseCommon =
          ModelResponseCommon.fromJson(jsonDecode(value));
      showToast(modelResponseCommon.message.toString());
      if (modelResponseCommon.status.toString() == "true") {
        createOrder();
      }
    });
  }

  createOrder() {
    Map<String, dynamic> map = {};

    map["home_data"] = cartController.deliveryAddress.value.home;
    map["country_code"] = cartController.deliveryAddress.value.countryCode;
    map["Building"] = cartController.deliveryAddress.value.building;
    map["Floor"] = cartController.deliveryAddress.value.floor;
    map["address"] = cartController.deliveryAddress.value.address;
    map["phone_number"] = cartController.deliveryAddress.value.countryCode! +
        cartController.deliveryAddress.value.phoneNo!;
    map["lat"] = cartController.deliveryAddress.value.lat ?? "0";
    map["long"] = cartController.deliveryAddress.value.longitute ?? "0";
    map["sp_request"] = cartController.specialRequest.text.trim();
    if (cartController.model.value.data!.couponCode!.isNotEmpty) {
      map["coupon_code"] = cartController.couponCode.text.trim();
    }
    map["city"] = cartController.selectedShippingMethod!.zoneName ??
        deliveryLocation.locality ??
        deliveryLocation.administrativeArea!;
    map["country_code"] = deliveryLocation.isoCountryCode;
    map["sp_request"] = cartController.specialRequest.text.trim();
    map["row_location"] = deliveryLocation.toJson().toString();

    cartController.repositories
        .postApi(url: ApiUrls.createOrderUrl, mapData: map, context: context)
        .then((value) {
      ModelCreateOrderResponse model =
          ModelCreateOrderResponse.fromJson(jsonDecode(value));
      showToast(model.message.toString());
      if (model.status.toString() == "Success") {
        model.total = cartController.model.value.data!.items!
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
        cartController.couponCode.clear();
        cartController.specialRequest.clear();
        cartController.model.value.data!.items = [];
        cartController.getData();

        Get.offAll(() => const ThankYouPage(), arguments: model);
      }
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      cartController.allowNavigation = false;
      if (addressController.model.value.data != null) {
        if (addressController.model.value.data!.userAddress!.isNotEmpty) {
          cartController.deliveryAddress.value =
              addressController.model.value.data!.userAddress!.first;
          if (shippingMethodsList.data != null) {
            ShippingData item = shippingMethodsList.data!.firstWhere(
                (element) =>
                    element.zoneName.toString() ==
                    cartController.deliveryAddress.value.shipping_city
                        .toString(),
                orElse: () => ShippingData());
            if (item.zoneName != null) {
              cartController.selectedShippingMethod = item;
            }
          }
        }
      }
      cartController.getData();
      getShippingList().then((value) {
        if (shippingMethodsList.data != null) {
          ShippingData item = shippingMethodsList.data!.firstWhere(
              (element) =>
                  element.zoneName.toString() ==
                  cartController.deliveryAddress.value.shipping_city.toString(),
              orElse: () => ShippingData());
          if (item.zoneName != null) {
            cartController.selectedShippingMethod = item;
          }
        }
        setState(() {});
      });
    });
  }

  RxBool allowOrder = false.obs;

  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(
          title: "CHECKOUT", showCart: false, backGround: Colors.white),
      body: Obx(() {
        if (cartController.deliveryAddress.value.home != null) {
          if (mapController != null) {
            if (cartController.allowNavigation == false) {
              cartController.allowNavigation = true;
              LatLng ll = LatLng(
                      double.parse(cartController.deliveryAddress.value.lat ??
                          "33.888630"),
                      double.parse(
                          cartController.deliveryAddress.value.longitute ??
                              "35.495480"))
                  .checkLatLong;
              mapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: ll, zoom: 15)));
              _getAddressFromLatLng(ll);
            }
          }
        }
        return RefreshIndicator(
          onRefresh: () async {
            await getShippingList().then((value) {
              setState(() {});
            });
          },
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1,
                              offset: Offset(1, 1))
                        ]),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      onTap: (v) {
                        selectAddressForOrder = true;
                        Get.toNamed(AddressScreenn.route, arguments: "sdddsad");
                      },
                      initialCameraPosition: _kGooglePlex,
                      markers: markers,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        _controller.complete(controller);
                        if (loaded == false) {
                          loaded = true;
                          if (cartController.deliveryAddress.value.home !=
                              null) {
                            LatLng ll = LatLng(
                                    double.parse(cartController
                                            .deliveryAddress.value.lat ??
                                        "33.888630"),
                                    double.parse(cartController
                                            .deliveryAddress.value.longitute ??
                                        "35.495480"))
                                .checkLatLong;
                            mapController!.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    CameraPosition(target: ll, zoom: 15)));
                            _getAddressFromLatLng(ll);
                          }
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1,
                              offset: Offset(.5, .5)),
                        ]),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffEAEAEA)),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFFE02020),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child:
                                  cartController.deliveryAddress.value.home !=
                                          null
                                      ? Text(
                                          "${cartController.deliveryAddress.value.home!} ${cartController.deliveryAddress.value.address!}\n"
                                          "No. ${cartController.deliveryAddress.value.countryCode ?? ""}${cartController.deliveryAddress.value.phoneNo ?? ""}",
                                          style: GoogleFonts.poppins(
                                              color: const Color(0xFF333333),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : Text(
                                          "Select Your Delivery Location",
                                          style: GoogleFonts.poppins(
                                              color: const Color(0xFF333333),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                            ),
                            InkWell(
                              onTap: () {
                                selectAddressForOrder = true;
                                Get.toNamed(AddressScreenn.route,
                                    arguments: "sdddsad");
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  cartController.deliveryAddress.value.home !=
                                          null
                                      ? 'Change'
                                      : "Select",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFFE02020),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 53),
                          child: Text(
                            'Select the location properly so that the delivery guy can deliver your order properly',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF666666),
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1,
                              offset: Offset(.5, .5))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pay With',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF333333),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              shape: const CircleBorder(
                                  side: BorderSide(color: Color(0xFFE02020))),
                              visualDensity: const VisualDensity(
                                  horizontal: -3, vertical: -4),
                              checkColor: Colors.white,
                              activeColor: const Color(0xFFE02020),
                              value: true,
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Image.asset('assets/images/cash.png'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Cash On Delivery',
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF333333),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (cartController.selectedShippingMethod != null)
                    buildHero(size,
                        deliveryFee:
                            cartController.selectedShippingMethod != null
                                ? (cartController.selectedShippingMethod!
                                        .shippingAmount!.isEmpty
                                    ? "Free"
                                    : cartController.selectedShippingMethod!
                                            .shippingAmount! +
                                        cartController.model.value.data!
                                            .cartmeta!.currencySymbol!)
                                : "Shipping Unavailable",
                        shippingAmount: int.tryParse(cartController
                            .selectedShippingMethod!.shippingAmount!
                            .toString())),
                  appBottomLogo()
                ]),
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Container(
        height: 76,
        width: size.width,
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 1, offset: Offset(1, 1))
            ]),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 16),
          child: InkWell(
            onTap: () {
              if (formKey.currentState!.validate()) {
                if (cartController.deliveryAddress.value.home != null) {
                  if (cartController.model.value.data!.couponCode!.isNotEmpty) {
                    applyCouponCode();
                  } else {
                    createOrder();
                  }
                } else {
                  showToast("Please select delivery location");
                  scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                }
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFE02020),
                ),
                child: Center(
                  child: Text(
                    'PLACE ORDER',
                    style: GoogleFonts.poppins(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
