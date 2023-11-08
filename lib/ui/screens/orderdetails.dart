import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/utils/price_format.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import '../../controller/orders_controller.dart';
import '../../models/model_single_order.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../utils/api_constant.dart';
import '../../widgets/circular_progressindicator.dart';
import '../../widgets/common_error_widget.dart';
import '../widget/app_bar.dart';
import 'bottom_nav_bar.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);
  static const String route = "/OrderDetails";

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  GoogleMapController? mapController;
  Placemark place = Placemark();

  Future _getAddressFromLatLng(LatLng latLong) async {
    await placemarkFromCoordinates(latLong.latitude, latLong.longitude)
        .then((List<Placemark> placemarks) {
      place = placemarks[0];
      if (mounted) {
        setState(() {});
      }
    }).catchError((e) {
      debugPrint(e.toString());
    });
    // if (kDebugMode) {}
  }

  CameraPosition _kGooglePlex = CameraPosition(
    target: const LatLng(0, 0).checkLatLong,
    zoom: 10.4746,
  );

  final Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();
  // _addPolyLine() {
  //   PolylineId id = const PolylineId("poly");
  //   Polyline polyline = Polyline(
  //       polylineId: id, color: Colors.red, points: polylineCoordinates);
  //   polylines[id] = polyline;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

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

  int rating = 5;

  final Repositories repositories = Repositories();

  Rx<SingleOrderModel> model = SingleOrderModel().obs;
  Rx<RxStatus> order = RxStatus.empty().obs;
  String orderId = "";

  Future singleOrder() async {
    Map<String, dynamic> map = {};
    map['order_id'] = orderId;
    await repositories
        .postApi(url: ApiUrls.singleOrder, mapData: map)
        .then((value) async {
      model.value = SingleOrderModel.fromJson(jsonDecode(value));
      if (model.value.status! && mounted) {
        if (model.value.data!.addressData!.isNotEmpty) {
          LatLng ll = LatLng(
                  double.tryParse(model.value.data!.addressData!.first.lat
                          .toString()) ??
                      0,
                  double.tryParse(model.value.data!.addressData!.first.long
                          .toString()) ??
                      0)
              .checkLatLong;
          await _getAddressFromLatLng(ll);
          _onAddMarkerButtonPressed(ll, "Selected Location");
          if (mapController != null) {
            mapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: ll, zoom: 14)));
          }
        }
        for (var i = 0; i < orderStatus.length; i++) {
          if (orderStatus[i] == model.value.data!.status.toString()) {
            currentStep = i;
          }
        }

        if (model.value.data!.status.toString() == "completed" ||
            model.value.data!.status.toString() == "cancelled") {
          showDetails = false;
        }
        order.value = RxStatus.success();
        setState(() {});
      } else {
        order.value = RxStatus.error();
        setState(() {});
      }
    });
  }

  bool inactive(int value) {
    return currentStep < value;
  }

  final orderController = Get.put(OrderController());

  cancelOrder() {
    repositories.postApi(
        url: ApiUrls.cancelOrderUrl,
        context: context,
        mapData: {"order_id": orderId}).then((value) {
      ModelResponseCommon mod = ModelResponseCommon.fromJson(jsonDecode(value));
      showToast(mod.message);
      if (mod.status) {
        orderController.yourOrder();
        Get.back();
        Get.back();
      }
    });
  }

  showDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 18),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to cancel this order?",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Text(
                          "Back",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 15),
                        ),
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          cancelOrder();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Text(
                          "Cancel Order",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 15),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    orderId = Get.arguments[0].toString();
    singleOrder();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showGoogleMaps = true;
      });
    });
  }

  @override
  void dispose() {
    try {
      if (mapController != null) {
        mapController!.dispose();
      }
    } catch (e) {
      return;
    }
    super.dispose();
  }

  final TextEditingController review = TextEditingController();
  FocusNode? focusNode = FocusNode();

  addReview() {
    if (review.text.isNotEmpty) {
      Map<String, String> map = {};
      map["order_id"] = orderId;
      map["review"] = review.text.trim();
      map["rating"] = rating.toInt().toString();
      repositories
          .postApi(url: ApiUrls.addReviewUrl, context: context, mapData: map)
          .then((value) {
        jsonDecode(value)["product_review"];
        showToast(jsonDecode(value)["product_review"]);
        singleOrder().then((value) {
          setState(() {});
        });
      });
    } else {
      showToast("Please write something for order.");
      focusNode!.requestFocus();
    }
  }

  // confirming-order
  // preparing
  // driver-assigned
  // completed
  List<String> orderStatus = [
    "confirming-order",
    "preparing",
    "driver-assigned",
    "completed",
  ];

  int currentStep = (-1);

  bool showDetails = true;

  bool _showGoogleMaps = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: commonAppBar(
            title: "DELIVERY LOCATION",
            backGround: Colors.white,
            showCart: false),
        body: order.value.isSuccess
            ? RefreshIndicator(
                onRefresh: () async {
                  await singleOrder();
                },
                child: SafeArea(
                  child: Stack(
                    children: [
                      if (_showGoogleMaps) googleMapUI(),
                      SingleChildScrollView(
                        child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .32 -
                                    9),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: const Color(0xFFFAFAFA),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 1,
                                      offset: const Offset(1, -1)),
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 1,
                                      offset: const Offset(-1, -1)),
                                ]),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  deliveryLocation(),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Divider(
                                    thickness: 0,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  if (model.value.data!.status.toString() ==
                                      "completed")
                                    reviewSection(size),
                                  if (showDetails) stepper(),
                                  if (model.value.data!.status.toString() ==
                                      "cancelled")
                                    Center(
                                      child: Text(
                                        "Order Canceled",
                                        style: GoogleFonts.poppins(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Order Summary',
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF333333),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: model.value.data!.orderData!
                                          .lineItems!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        '${model.value.data!.orderData!.lineItems![index].quantity} x ',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                    Text(
                                                      model
                                                          .value
                                                          .data!
                                                          .orderData!
                                                          .lineItems![index]
                                                          .name
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: const Color(
                                                            0xFF333333),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: formatPrice2(
                                                      model
                                                          .value
                                                          .data!
                                                          .orderData!
                                                          .lineItems![index]
                                                          .total,
                                                      model
                                                          .value
                                                          .data!
                                                          .orderData!
                                                          .lineItems![index]
                                                          .currencySymbol,
                                                      GoogleFonts.poppins(
                                                          color: const Color(
                                                              0xFF333333),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textAlign: TextAlign.end),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        );
                                      }),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'Payment method',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF333333),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          "COD",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF333333),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'Delivery time',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF333333),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          '35 mins',
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF333333),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  appBottomLogo()
                                ])),
                      ),
                    ],
                  ),
                ),
              )
            : order.value.isError
                ? CommonErrorWidget(
                    errorText: model.value.message.toString(),
                    onTap: () {
                      singleOrder();
                    },
                  )
                : const CommonProgressIndicator());
  }

  stepper() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      lottie.Lottie.asset(
                        'assets/lotie/search.json',
                        width: 45,
                        height: 45,
                        fit: BoxFit.fill,
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 10,
                          child: DottedLine(
                            direction: Axis.vertical,
                            lineThickness: 2.6,
                            dashLength: 8.0,
                            dashColor: Colors.grey,
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          inactive(0)
                              ? "Confirming your order"
                              : "Order Confirmed",
                          style: GoogleFonts.poppins(
                              color: inactive(0)
                                  ? Colors.grey.shade600
                                  : Colors.black,
                              fontWeight: inactive(0)
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              fontSize: 16),
                        ),
                        if (model.value.data!.status == "processing")
                          InkWell(
                              onTap: () {
                                showDeleteDialog();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(8.0).copyWith(left: 0),
                                child: Text(
                                  "Cancel order",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400),
                                ),
                              )),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ))
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      lottie.Lottie.asset(
                        'assets/lotie/cooking.json',
                        width: 45,
                        height: 45,
                        fit: BoxFit.fill,
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 10,
                          child: DottedLine(
                            direction: Axis.vertical,
                            lineThickness: 2.6,
                            dashLength: 8.0,
                            dashColor: Colors.grey,
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          inactive(1) ? "Preparing your food" : "Food Prepared",
                          style: GoogleFonts.poppins(
                              color: inactive(1)
                                  ? Colors.grey.shade600
                                  : Colors.black,
                              fontWeight: inactive(1)
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                          child: Text(
                            "Be Patient, we are confirming your order",
                            style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ))
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      lottie.Lottie.asset(
                        'assets/lotie/bike.json',
                        width: 45,
                        height: 45,
                        fit: BoxFit.fill,
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 10,
                          child: DottedLine(
                            direction: Axis.vertical,
                            lineThickness: 2.6,
                            dashLength: 8.0,
                            dashColor: Colors.grey,
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          inactive(2) ? "Assigning Driver" : "Driver Assigned",
                          style: GoogleFonts.poppins(
                              color: inactive(2)
                                  ? Colors.grey.shade600
                                  : Colors.black,
                              fontWeight: inactive(2)
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                          child: Text(
                            "The Driver’s name will serve your food to your door",
                            style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ))
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      lottie.Lottie.asset(
                        'assets/lotie/location.json',
                        width: 45,
                        height: 45,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 14,
                        ),
                        Text(
                          inactive(3)
                              ? "Delivering your food"
                              : "Order delivered",
                          style: GoogleFonts.poppins(
                              color: inactive(3)
                                  ? Colors.grey.shade600
                                  : Colors.black,
                              fontWeight: inactive(3)
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                          child: Text(
                            "Be patient we are delivering your food",
                            style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container reviewSection(Size size) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: size.width,
      color: Colors.white,
      child: model.value.data!.commentData!.commentContent.toString().isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '  Leave Your Review',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  thickness: 0,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RatingBar.builder(
                        initialRating: rating.toDouble(),
                        minRating: 1,
                        itemSize: 30,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFA600),
                          size: 30,
                        ),
                        onRatingUpdate: (val) {
                          rating = val.toInt();
                          dev.log(val.toString());
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          addReview();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            backgroundColor: Colors.red),
                        child: Text(
                          "Submit",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Icon(
                        Icons.message_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: review,
                        focusNode: focusNode,
                        minLines: 4,
                        maxLines: 12,
                        decoration: InputDecoration(
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w400),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 14),
                            enabled: true,
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText:
                                'How was your Food? \nHow was the driver behavior? \n Any Comments should we know about? How can we make your experience better?'),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '  Reviewed',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  thickness: 0,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                IgnorePointer(
                  ignoring: true,
                  child: RatingBar.builder(
                    initialRating: double.tryParse(
                            model.value.data!.commentData!.rating.toString()) ??
                        1,
                    minRating: 1,
                    itemSize: 30,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFA600),
                      size: 30,
                    ),
                    onRatingUpdate: (val) {
                      rating = val.toInt();
                      dev.log(val.toString());
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "You: ${model.value.data!.commentData!.commentContent ?? "Gave ${model.value.data!.commentData!.rating.toString()}"
                      " rating"}",
                  style: GoogleFonts.poppins(color: Colors.grey.shade700),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
    );
  }

  Row deliveryLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffEAEAEA)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              if (place.country != null)
                Text(
                  // "${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}",
                  model.value.data!.billing!.address1 +
                      ", " +
                      model.value.data!.billing!.address2 +
                      ", " +
                      model.value.data!.billing!.city +
                      ", " +
                      model.value.data!.billing!.country,
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              if (model.value.data!.addressData!.isNotEmpty)
                Text(
                  'Mobile number: ${model.value.data!.addressData!.first.phoneNumber}',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF666666),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
            ],
          ),
        ),
      ],
    );
  }

  googleMapUI() {
    return Container(
      height: MediaQuery.of(context).size.height * .32,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(15),
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 1, offset: Offset(1, 1))
          ]),
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: markers,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          // _controller.complete(controller);
          mapController = controller;
          if (model.value.data!.addressData!.isNotEmpty) {
            LatLng ll = LatLng(
                    double.tryParse(model.value.data!.addressData!.first.lat
                            .toString()) ??
                        0,
                    double.tryParse(model.value.data!.addressData!.first.long
                            .toString()) ??
                        0)
                .checkLatLong;
            _kGooglePlex = CameraPosition(
              target: ll.checkLatLong,
              zoom: 14.4746,
            );
            mapController!
                .animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: ll, zoom: 14)))
                .then((value) async {
              if (place.country == null) {
                await _getAddressFromLatLng(ll);
                _onAddMarkerButtonPressed(ll, "Selected Location");
              }
            });
          }
        },
      ),
    );
  }
}
