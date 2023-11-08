import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/ui/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../controller/new_controllers/address_controller.dart';
import '../../../models/model_shipping_methods.dart';
import '../bottom_nav_bar.dart';
import '../checkout_screen.dart';
import 'add_address_screen.dart';
import 'choose_address.dart';

class AddressScreenn extends StatefulWidget {
  static const String route = "/AddressScreenn";
  const AddressScreenn({Key? key}) : super(key: key);

  @override
  State<AddressScreenn> createState() => _AddressScreennState();
}

class _AddressScreennState extends State<AddressScreenn> {
  final addressController = Get.put(AddressController());
  final cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    getShippingList();
    addressController.getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: commonAppBar(
            title: "ADDRESS", backGround: Colors.white, elevation: 1),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: InkWell(
              onTap: () {
                addressController.mobile = "";
                addressController.countryCode = "";
                addressController.cameraPosition =
                    CameraPosition(target: const LatLng(0, 0).checkLatLong);
                addressController.id = "";
                addressController.userId = "";
                addressController.place = Placemark();
                addressController.selectedShippingMethod = null;
                Get.toNamed(ChooseAddress.route);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffE02020),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 53,
                  child: Center(
                    child: Text(
                      'Add New Address',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Obx(() {
              return addressController.loaded.value
                  ? addressController.model.value.data!.userAddress!.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await addressController.getAddresses();
                          },
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: addressController
                                  .model.value.data!.userAddress!.length,
                              itemBuilder: (context, index) {
                                final item = addressController
                                    .model.value.data!.userAddress![index];
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: false,
                                            onChanged: (value) {
                                              if (!selectAddressForOrder) {
                                                addressController.mobile = "";
                                                addressController.countryCode =
                                                    "";
                                                addressController
                                                        .cameraPosition =
                                                    CameraPosition(
                                                        target:
                                                            const LatLng(0, 0)
                                                                .checkLatLong);
                                                addressController.id = "";
                                                addressController.userId = "";
                                                addressController.place =
                                                    Placemark();
                                                addressController
                                                        .selectedShippingMethod =
                                                    null;
                                                Get.toNamed(AddAddress.route,
                                                    arguments: item);
                                              } else {
                                                cartController.deliveryAddress
                                                    .value = item;
                                                cartController.allowNavigation =
                                                    false;
                                                if (shippingMethodsList.data !=
                                                    null) {
                                                  ShippingData item11 =
                                                      shippingMethodsList.data!.firstWhere(
                                                          (element) =>
                                                              element.zoneName
                                                                  .toString() ==
                                                              cartController
                                                                  .deliveryAddress
                                                                  .value
                                                                  .shipping_city
                                                                  .toString(),
                                                          orElse: () =>
                                                              ShippingData());
                                                  if (item11.zoneName != null) {
                                                    cartController
                                                            .selectedShippingMethod =
                                                        item11;
                                                  }
                                                }
                                                Future.delayed(const Duration(
                                                        seconds: 3))
                                                    .then((value) {
                                                  cartController
                                                      .allowNavigation = false;
                                                });
                                                Get.back();
                                              }
                                            },
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                if (!selectAddressForOrder) {
                                                  return;
                                                }
                                                addressController.mobile = "";
                                                addressController.countryCode =
                                                    "";
                                                addressController
                                                        .cameraPosition =
                                                    CameraPosition(
                                                        target:
                                                            const LatLng(0, 0)
                                                                .checkLatLong);
                                                addressController.id = "";
                                                addressController.userId = "";
                                                addressController.place =
                                                    Placemark();
                                                addressController
                                                        .selectedShippingMethod =
                                                    null;
                                                Get.toNamed(AddAddress.route,
                                                    arguments: item);
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          'Home:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                        ),
                                                        const SizedBox(
                                                          width: 80,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              item.home ?? "",
                                                              style: GoogleFonts.poppins(
                                                                  color: const Color(
                                                                      0xff555555),
                                                                  fontSize:
                                                                      11.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          'Building:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 13),
                                                        ),
                                                        const SizedBox(
                                                          width: 63,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              item
                                                                      .building ??
                                                                  "",
                                                              style: GoogleFonts.poppins(
                                                                  color: const Color(
                                                                      0xff555555),
                                                                  fontSize:
                                                                      11.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  if ((item.floor ?? "")
                                                      .isNotEmpty)
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15),
                                                          child: Text(
                                                            'Floor:',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        13),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 85,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              item.floor ?? "",
                                                              style: GoogleFonts.poppins(
                                                                  color: const Color(
                                                                      0xff555555),
                                                                  fontSize:
                                                                      11.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        )
                                                      ],
                                                    ),
                                                  if ((item.floor ?? "")
                                                      .isNotEmpty)
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 15),
                                                        child: Text(
                                                          'Address:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 13),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 63,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            item.address ?? "",
                                                            style: GoogleFonts.poppins(
                                                                color: const Color(
                                                                    0xff555555),
                                                                fontSize: 11.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 15),
                                                        child: Text(
                                                          'Phone Number:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 13),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            (item.countryCode ??
                                                                    "") +
                                                                (item.phoneNo ??
                                                                    ""),
                                                            style: GoogleFonts.poppins(
                                                                color: const Color(
                                                                    0xff555555),
                                                                fontSize: 11.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index ==
                                        addressController.model.value.data!
                                                .userAddress!.length -
                                            1)
                                      const Divider()
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              }),
                        )
                      : const Center(
                          child: Text("No address added yet"),
                        )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }),
          )
        ]));
  }
}
