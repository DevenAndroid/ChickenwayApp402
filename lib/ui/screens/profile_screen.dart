import 'dart:convert';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/profile_controller.dart';
import '../../main.dart';
import '../../models/model_update_profile.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../utils/api_constant.dart';
import '../../utils/countries.dart';
import '../widget/app_bar.dart';
import '../widget/phone_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final loginFormKey = GlobalKey<FormState>();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var phoneNumber = TextEditingController();
  var email = TextEditingController();
  String countryCode = "";
  final Repositories repositories = Repositories();
  final profileController = Get.put(ProfileController());
  String initialCode = "IN";

  profile() {
    firstName.text = profileController.model.value.data!.firstName.toString();
    lastName.text = profileController.model.value.data!.lastName.toString();
    phoneNumber.text = profileController.model.value.data!.phone.toString();
    email.text = profileController.model.value.data!.email.toString();

    initialCode = countriesList
        .firstWhere((element) =>
    element.dialCode.toString() ==
        profileController.model.value.data!.countryCode.toString().replaceAll("+", ""))
        .code;
    if(mounted) {
      setState(() {});
    }
  }
  Rx<ModelResponseCommon> model = ModelResponseCommon().obs;
  updateProfile() {
    Map<String, dynamic> map = {};
    map["first_name"] = firstName.text;
    map["last_name"] = lastName.text;
    map["last_name"] = lastName.text;
    map["email"] = email.text;
    map["country_code"] = countryCode;
    map["phone"] = phoneNumber.text;

    repositories
        .postApi(url: ApiUrls.updateProfileUrl, mapData: map,context: context)
        .then((value) {
      final model1 = UpdateProfileModel.fromJson(jsonDecode(value));
      if (model1.status!) {
        profileController.getProfile();
        showToast(model1.message.toString().split("'").first);
      } else {
        showToast(model1.message.toString());
      }
    });
  }

  deleteProfile() {
    Map<String, dynamic> map = {};
    repositories.postApi(url: ApiUrls.delete, mapData: map,context: context).then((value) async {
      model.value = ModelResponseCommon.fromJson(jsonDecode(value));
      if (model.value.status!) {
        Get.back();
        SharedPreferences preferences =
            await SharedPreferences.getInstance();
        await preferences.clear();
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        final cartController = Get.put(CartController());
        cartController.resetAll();
      } else {
        showToast(model.value.message.toString());
        // order.value = RxStatus.error();
      }
    });
  }

  showDeleteDialogue() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure your want to delete your account.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              deleteProfile();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: Text(
                              "Delete",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
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
    checkUserInfo();
  }

  checkUserInfo() {
    if (profileController.model.value.data != null) {
      profile();
    } else {
      profileController.getProfile().then((value) {
        profile();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  const Color(0xffF5F5F5),
        appBar: commonAppBar(
            title: "MY PROFILE", showCart: false, backGround: Colors.white),
        body: Obx(() {
          return profileController.showData.value
              ? SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 30, left: 30, top: 40),
                    child: Column(
                      children: [
                        Text(
                          "You are able to edit your personal information. Please don’t forget to save before leaving this page",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              height: 1.5,
                              color: const Color(0xff555555),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          controller: firstName,
                          validator: (value) {
                            if (value.toString().trim().isEmpty) {
                              return "First name is required";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.name,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(.3))),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 14),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(.3))),
                              hintText: 'First Name *',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: lastName,
                          validator: (value) {
                            if (value.toString().trim().isEmpty) {
                              return "last name is required";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.name,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(.3))),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 14),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(.3))),
                              hintText: 'last Name *',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey)),
                        ),

                        const SizedBox(
                          height: 20,
                        ),


                        IgnorePointer(
                          ignoring: true,
                          child: CustomIntlPhoneField(
                            controller: phoneNumber,
                            dropdownIconPosition:
                            IconPosition.trailing,
                            dropdownTextStyle: GoogleFonts.poppins(
                                color: Colors.black),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              // labelText: 'Your Phone Number',
                              labelStyle: GoogleFonts.poppins(
                                  color:
                                  Colors.grey.withOpacity(.9)),
                              counterText: "",
                              enabled: true,
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(.3),
                                      width: 1.5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(.3),
                                      width: 1.2)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(.3),
                                      width: 1.2)),
                            ),
                            initialCountryCode: initialCode,
                            onCountryChanged: (value) {
                              countryCode = value.dialCode;
                              initialCountryCode = value.code;
                              if (kDebugMode) {
                                print(countryCode);
                                print(initialCountryCode);
                              }
                            },
                            onChanged: (phone) {
                              countryCode = phone.countryCode;
                              initialCountryCode = phone.countryISOCode;
                              if (kDebugMode) {
                                print(countryCode);
                                print(initialCountryCode);
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: email,
                          validator: (value) {
                            if (value.toString().trim().isEmpty) {
                              return "email is required";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.name,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(.3))),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 14),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .withOpacity(.3))),
                              hintText: 'Email',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey)),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              onTap: () {
                                //firstName.text.trim();
                                updateProfile();
                              },
                              child: Container(
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xffE50019),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(17),
                                  child: Text(
                                    'Save Updates',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            InkWell(onTap: (){
                              showDeleteDialogue();
                            },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(.3))),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    'Delete Account',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        // TextButton(
                        //   child: Text(
                        //     _buttonText,
                        //     style: GoogleFonts.poppins(fontSize: 15),
                        //   ),
                        //   onPressed: () {},
                        //   style: TextButton.styleFrom(
                        //       foregroundColor: Colors.white,
                        //       elevation: 2,
                        //       backgroundColor: Colors.red),
                        // ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        }));
  }
}
