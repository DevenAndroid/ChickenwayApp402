import 'dart:convert';
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/repositories/new_common_repo/repository.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/utils/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/model_shipping_methods.dart';
import '../../models/new_models/model_my_addresses.dart';
import '../../ui/screens/address/address_screen.dart';
import '../../ui/screens/checkout_screen.dart';

// extension Extract

class AddressController extends GetxController {
  Rx<ModelMyAddressList> model =
      ModelMyAddressList(data: AddressData(userAddress: [])).obs;
  final Repositories repositories = Repositories();
  RxBool loaded = false.obs;
  CameraPosition cameraPosition =
      CameraPosition(target: const LatLng(0, 0).checkLatLong);
  Placemark place = Placemark();
  String id = "";
  String userId = "";
  String countryCode = "";
  String mobile = "";

  ShippingData? selectedShippingMethod;

  Future getAddresses({bool? reset}) async {
    if (reset == true) {
      model.value = ModelMyAddressList(data: AddressData(userAddress: []));
      loaded.value = false;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('user_details') != null) {
      await repositories.postApi(
        url: ApiUrls.getAddressUrl,
        mapData: {},
      ).then((value) {
        loaded.value = true;
        model.value = ModelMyAddressList.fromJson(jsonDecode(value));
        if (model.value.data != null) {
          model.value.data!.userAddress =
              model.value.data!.userAddress!.reversed.toList();
        }
      });
    }
  }

  Future addAddressApi(
      {required homeData,
      required countryCode,
      required building,
      required floor,
      required address,
      required billingPhone,
      required lat,
      required long,
      required String shippingCity,
      BuildContext? context}) async {
    Map<String, dynamic> map = {};
    map["home_data"] = homeData.toString();
    map["country_code"] = countryCode.toString();
    map["building"] = building.toString();
    map["floor"] = floor.toString();
    map["address"] = address.toString();
    map["billing_phone"] = billingPhone.toString();
    map["lat"] = lat.toString();
    map["long"] = long.toString();
    map["shipping_city"] = shippingCity;

    if (id.isNotEmpty) {
      map["id"] = id;
      map["userid"] = userId;
    }

    // showConfirmationDialog(
    //     context: context,
    //     map: map
    // );
    await repositories
        .postApi(url: ApiUrls.updateAddressUrl, mapData: map, context: context)
        .then((value) {
      ModelResponseCommon model =
          ModelResponseCommon.fromJson(jsonDecode(value));
      if (!model.message.toString().contains("otp")) {
        getAddresses();
        if (selectAddressForOrder) {
          Get.back();
          Get.offNamedUntil(AddressScreenn.route, (route) => true,
              arguments: "asdd");
        } else {
          Get.back();
          Get.offNamedUntil(AddressScreenn.route, (route) => true);
        }
        // if(userId.toString().isEmpty){
        // Get.back();
        // }
        // Get.back();
      } else {
        List<String> otpMsg = model.message.toString().split(" ");
        if (otpMsg.length < 6) return;
        String otp = otpMsg[5];
        // showConfirmationDialog(context: context, map: map);

        addAddressApiWithOTP(otp: otp, map: map, context: context);
      }
    });
  }

  Future addAddressApiWithOTP({
    required Map<String, dynamic> map,
    required String otp,
    BuildContext? context,
  }) async {
    map["otp"] = otp;
    await repositories
        .postApi(
            url: ApiUrls.addressVerifyOtpUrl, mapData: map, context: context)
        .then((value) {
      ModelResponseCommon model =
          ModelResponseCommon.fromJson(jsonDecode(value));
      showToast(model.message.toString().split("'").first);
      if (model.status) {
        getAddresses();
        if (selectAddressForOrder) {
          Get.back();
          Get.offNamedUntil(AddressScreenn.route, (route) => true,
              arguments: "asdd");
        } else {
          Get.back();
          Get.offNamedUntil(AddressScreenn.route, (route) => true);
        }
        // if(userId.toString().isEmpty){
        //   Get.back();
        // }
        // Get.back();
        // Get.back();
      }
    });
  }

  showConfirmationDialog({
    required context,
    required Map<String, dynamic> map,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          final TextEditingController otpController = TextEditingController();
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 18),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Verify Phone Number\nEnter OTP to verify entered number",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    textStyle: GoogleFonts.poppins(color: Colors.black),
                    controller: otpController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    pastedTextStyle: GoogleFonts.poppins(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "OTP code Required";
                      } else if (v.length != 4) {
                        return "Enter complete OTP code";
                      }
                      return null;
                    },
                    length: 4,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      disabledColor: Colors.grey,
                      selectedColor: Colors.grey,
                      activeFillColor: Colors.grey,
                      inactiveFillColor: Colors.grey,
                      fieldWidth: 60,
                      borderWidth: 4,
                      fieldHeight: 60,
                      activeColor: Colors.grey,
                      inactiveColor: Colors.grey,
                      selectedFillColor: Colors.grey,
                      errorBorderColor: Colors.grey,
                    ),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    onSubmitted: (v) {
                      // if(_formKey.currentState!.validate()){
                      //   verifyOtp();
                      // }
                    },
                    onChanged: (String value) {
                      if (value.length == 4) {
                        addAddressApiWithOTP(
                            otp: value, map: map, context: context);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      addAddressApiWithOTP(
                          otp: otpController.text.trim(),
                          map: map,
                          context: context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xffE02020),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                'Verify OTP',
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
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void onInit() {
    super.onInit();
    getAddresses();
  }
}
