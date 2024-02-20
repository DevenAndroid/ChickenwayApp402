import 'dart:async';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/ui/screens/popupmsg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../controller/menu_controller.dart';
import '../../../controller/new_controllers/address_controller.dart';
import '../../../helper/helper.dart';
import '../../../models/model_shipping_methods.dart';
import '../../../models/new_models/model_my_addresses.dart';
import '../../../utils/countries.dart';
import '../../widget/app_bar.dart';
import '../../widget/phone_field.dart';
import '../bottom_nav_bar.dart';
import '../checkout_screen.dart';
import 'choose_address.dart';

class AddAddress extends StatefulWidget {
  static String route = "/AddAddress";

  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final addressController = Get.put(AddressController());
  final menuController = Get.put(ProductsMenuController());
  final cartController = Get.put(CartController());
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? mapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
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

  // ignore: unused_element
  _getAddressFromLatLng(LatLng latLong) async {
    await placemarkFromCoordinates(latLong.latitude, latLong.longitude)
        .then((List<Placemark> placemarks) {
      addressController.place = placemarks[0];
      if (mounted) {
        address.text =
            '${addressController.place.street}, ${addressController.place.subLocality}, ${addressController.place.subAdministrativeArea}, ${addressController.place.postalCode}';
        setState(() {});
      }
    }).catchError((e) {
      debugPrint(e.toString());
    });
    if (kDebugMode) {}
  }

  final TextEditingController home = TextEditingController();
  final TextEditingController building = TextEditingController();
  final TextEditingController floor = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  String initialCode = "LB";

  @override
  void initState() {
    super.initState();
    getShippingList();
    if (Get.arguments != null) {
      UserAddress userAddress = Get.arguments;
      addressController.id = userAddress.id.toString();
      addressController.userId = userAddress.userid.toString();
      home.text = userAddress.home.toString();
      building.text = userAddress.building.toString();
      address.text = userAddress.address.toString();
      floor.text = userAddress.floor.toString();
      addressController.countryCode = userAddress.countryCode.toString();
      mobileController.text = userAddress.phoneNo.toString();
      addressController.mobile = userAddress.phoneNo.toString();
      LatLng ll = LatLng(double.tryParse((userAddress.lat ?? "0").toString())!,
              double.tryParse((userAddress.longitute ?? "0").toString())!)
          .checkLatLong;
      addressController.cameraPosition = CameraPosition(target: ll, zoom: 14);
      if (shippingMethodsList.data != null) {
        ShippingData item = shippingMethodsList.data!.firstWhere(
            (element) =>
                element.zoneName.toString() ==
                userAddress.shipping_city.toString(),
            orElse: () => ShippingData());
        if (item.zoneName != null) {
          addressController.selectedShippingMethod = item;
        }
      }
      _getAddressFromLatLng(ll);
    } else {
      mobileController.text = addressController.mobile;
      home.text = ''; //addressController.place.subLocality ?? "";
      building.text = ''; //addressController.place.name ?? "";
      address.text = '';
      address.text = '';
      // address.text = (addressController.place.subLocality != null &&
      //         addressController.place.subAdministrativeArea != null)
      //     ? '${addressController.place.subLocality} '
      //         ' ${addressController.place.subAdministrativeArea} '
      //         ' ${addressController.place.postalCode} '
      //     : "";
    }
    if (addressController.countryCode.toString().isNotEmpty) {
      initialCode = countriesList
          .firstWhere((element) =>
              element.dialCode.toString() ==
              addressController.countryCode.toString().replaceAll("+", ""))
          .code;
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: commonAppBar(
            title: "EDIT ADDRESS", backGround: Colors.white, elevation: 1),
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              // Container(
              //   height: MediaQuery.of(context).size.height * .3,
              //   width: MediaQuery.of(context).size.width,
              //   padding: const EdgeInsets.all(0),
              //   decoration: const BoxDecoration(
              //       color: Colors.white,
              //       shape: BoxShape.rectangle,
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.black26,
              //             blurRadius: 1,
              //             offset: Offset(1, 1))
              //       ]),
              //   child: GoogleMap(
              //     mapType: MapType.normal,
              //     initialCameraPosition: _kGooglePlex,
              //     markers: markers,
              //     onMapCreated: (GoogleMapController controller) {
              //       mapController = controller;
              //       _controller.complete(controller);
              //       mapController!
              //           .animateCamera(CameraUpdate.newCameraPosition(
              //               addressController.cameraPosition))
              //           .then((value) {
              //         _onAddMarkerButtonPressed(
              //             addressController.cameraPosition.target,
              //             "Selected Location");
              //       });
              //     },
              //   ),
              // ),
              // Container(
              //   padding: const EdgeInsets.all(10),
              //   decoration: const BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.only(
              //           bottomLeft: Radius.circular(10),
              //           bottomRight: Radius.circular(10)),
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.black26,
              //             blurRadius: 1,
              //             offset: Offset(1, 1))
              //       ]),
              //   child: Column(
              //     children: [
              //       const SizedBox(
              //         height: 8,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Container(
              //             padding: const EdgeInsets.all(6),
              //             decoration: BoxDecoration(
              //                 border: Border.all(
              //                   color: const Color(0xffEAEAEA),
              //                 ),
              //                 shape: BoxShape.circle),
              //             child: const Icon(
              //               Icons.location_on,
              //               color: Color(0xFFE02020),
              //             ),
              //           ),
              //           const SizedBox(
              //             width: 15,
              //           ),
              //           Expanded(
              //             child: Padding(
              //               padding: const EdgeInsets.only(top: 8.0),
              //               child: Text(
              //                 '${addressController.place.subLocality} ${addressController.place.subAdministrativeArea} ${addressController.place.postalCode}',
              //                 style: GoogleFonts.poppins(
              //                     color: const Color(0xFF333333),
              //                     fontSize: 17,
              //                     fontWeight: FontWeight.w600),
              //               ),
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 8.0),
              //             child: InkWell(
              //               onTap: () {
              //                 if (Get.arguments != null) {
              //                   Get.offNamed(ChooseAddress.route,
              //                       arguments: Get.arguments);
              //                 } else {
              //                   Get.back();
              //                 }
              //               },
              //               child: Text(
              //                 'Change',
              //                 style: GoogleFonts.poppins(
              //                     color: const Color(0xFFE02020),
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w600),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(left: 50, right: 10),
              //         child: Text(
              //           'Add Your Location on map, so our drivers can easily deliver your orders',
              //           style: GoogleFonts.poppins(
              //               color: const Color(0xFF666666),
              //               fontSize: 15,
              //               fontWeight: FontWeight.w500),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 10, right: 10),
              //   child: Text(
              //     "Give this address a label so you can easily choose between them (e.g. Parent’s Home)",
              //     style: GoogleFonts.poppins(
              //         color: Colors.grey.shade700,
              //         fontWeight: FontWeight.w400,
              //         fontSize: 14,
              //         height: 1.2),
              //   ),
              // ),
              addHeight(14),
              TextFormField(
                controller: home,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Home required*";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(.3))),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(.3))),
                    hintText: 'Home *',
                    hintStyle:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
              ),
              addHeight(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: building,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Building Number required*";
                        } else {
                          return null;
                        }
                      },
                      // validator: MultiValidator([
                      //   RequiredValidator(errorText: 'Building'),
                      // ]),
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(.3))),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          enabled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(.3))),
                          hintText: 'Building *',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      controller: floor,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Floor required*";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(.3))),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          enabled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(.3))),
                          hintText: 'Floor *',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey)),
                    ),
                  ),
                ],
              ),
              addHeight(20),
              TextFormField(
                controller: address,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Address is required*";
                  } else {
                    return null;
                  }
                },
                // validator: MultiValidator([
                //   RequiredValidator(errorText: 'Address is required'),
                // ]),
                keyboardType: TextInputType.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(.3))),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(.3))),
                    hintText: 'Address Details *',
                    hintStyle:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<ShippingData>(
                  isExpanded: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(.3))),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(.3))),
                      hintText: 'Shipping City',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey)),
                  validator: (value) {
                    if (value == null) {
                      return "Shipping City is required";
                    } else {
                      return null;
                    }
                  },
                  value: addressController.selectedShippingMethod,
                  items: shippingMethodsList.data!
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                Expanded(child: Text(e.zoneName!)),
                                Text(e.shippingAmount.toString().isNotEmpty
                                    ? "${e.shippingAmount} ${cartController.price}"
                                    : "Free")
                              ],
                            ),
                          )))
                      .toList(),
                  onChanged: (value) {
                    addressController.selectedShippingMethod = value!;
                    setState(() {});
                  }),
              const SizedBox(
                height: 20,
              ),
              CustomIntlPhoneField(
                controller: mobileController,
                dropdownIconPosition: IconPosition.trailing,
                dropdownTextStyle: GoogleFonts.poppins(color: Colors.black),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Your Phone Number',
                  labelStyle:
                      GoogleFonts.poppins(color: Colors.grey.withOpacity(.9)),
                  counterText: "",
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3), width: 1.5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3), width: 1.2)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3), width: 1.2)),
                ),
                initialCountryCode: initialCode,
                onCountryChanged: (value) {
                  addressController.countryCode = value.dialCode;
                  if (kDebugMode) {
                    print(addressController.countryCode);
                  }
                },
                onChanged: (phone) {
                  addressController.countryCode = phone.countryCode;
                  if (kDebugMode) {
                    print(addressController.countryCode);
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    addressController
                        .addAddressApi(
                            homeData: home.text.trim(),
                            countryCode: addressController.countryCode,
                            building: building.text.trim(),
                            floor: floor.text.trim(),
                            address: address.text.trim(),
                            billingPhone: mobileController.text.trim(),
                            lat: addressController
                                .cameraPosition.target.latitude,
                            long: addressController
                                .cameraPosition.target.longitude,
                            shippingCity: addressController
                                .selectedShippingMethod!.zoneName!,
                            context: context)
                        .then((value) {});
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffE02020),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Update Address',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              if (addressController.userId.toString().isNotEmpty)
                InkWell(
                  onTap: () {
                    showDialogue14(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffE02020),
                            ),
                            color: Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              'Delete',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: const Color(0xffE02020),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        )));
  }

  showDialogue14(context) {
    showDialog(
        context: context,
        builder: (context) {
          return const PopUPScreen();
        });
  }
}
