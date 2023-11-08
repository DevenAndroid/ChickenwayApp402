import 'dart:convert';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/models/model_login.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/res/app_assets.dart';
import 'package:dinelah/res/strings.dart';
import 'package:dinelah/utils/api_constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../helper/helper.dart';
import '../../main.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../res/theme/theme.dart';
import '../../routers/my_router.dart';
import '../widget/common_button.dart';
import '../widget/phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart' as sha;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var mobileController = TextEditingController();
  String countryCode = "";
  final formKey = GlobalKey<FormState>();
  final Repositories repositories = Repositories();
  bool _checkbox = false;
  bool showValidation = false;

  signUpUser() {
    Map<String, dynamic> map = {};
    map["first_name"] = firstName.text.trim();
    map["last_name"] = lastName.text.trim();
    map["country_code"] = countryCode;
    map["phone"] = mobileController.text.trim();
    map["social_login_id"] = "";
    map["social_type"] = "manual";
    repositories
        .postApi(
      url: ApiUrls.signUpUrl,
      mapData: map,
      context: context,
    )
        .then((value) {
      ModelResponseCommon model =
          ModelResponseCommon.fromJson(jsonDecode(value));
      showToast(model.message ?? "Something went Wrong");
      if (model.status!) {
        // Get.back();
        signIn(mobileController.text.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(
                AppAssets.logInBg,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: screenSize.height * 0.12,
                  left: screenSize.width * 0.05,
                  child: Text(
                    'Glad to \nmeet you.',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 36,
                    ),
                  )),
              Stack(
                children: [
                  Positioned(
                      top: screenSize.height * 0.04,
                      left: screenSize.width * 0.05,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xffEAEAEA),
                                )),
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Color(0xffEAEAEA),
                              ),
                            )),
                      ))
                ],
              ),
              Positioned(
                  top: screenSize.height * 0.2,
                  child: Stack(
                    children: [
                      Theme(
                        data: ThemeData(
                            primaryColor: Colors.red,
                            primarySwatch: Colors.red),
                        child: SizedBox(
                          width: screenSize.width,
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin:
                                      const EdgeInsets.fromLTRB(19, 56, 19, 30),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          Strings.sign,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),

                                        Text(
                                          Strings.signToYourAc,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),

                                        addHeight(
                                          screenSize.height * 0.03,
                                        ),
                                        TextFormField(
                                          controller: firstName,
                                          validator: (value) {
                                            if (value
                                                .toString()
                                                .trim()
                                                .isEmpty) {
                                              return "First name is required";
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.name,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(.3))),
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenSize.height * 0.02,
                                                  vertical:
                                                      screenSize.width * 0.02),
                                              enabled: true,
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(.3))),
                                              labelText: 'First Name *',
                                              labelStyle: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ),
                                        SizedBox(
                                          height: screenSize.height * 0.02,
                                        ),
                                        TextFormField(
                                          controller: lastName,
                                          validator: (value) {
                                            if (value
                                                .toString()
                                                .trim()
                                                .isEmpty) {
                                              return "Last name is required";
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.name,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(.3))),
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenSize.height * 0.02,
                                                  vertical:
                                                      screenSize.width * 0.02),
                                              enabled: true,
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(.3))),
                                              labelText: 'last Name *',
                                              labelStyle: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ),
                                        const SizedBox(
                                          height: 23,
                                        ),
                                        CustomIntlPhoneField(
                                          controller: mobileController,
                                          dropdownIconPosition:
                                              IconPosition.trailing,
                                          dropdownTextStyle:
                                              GoogleFonts.poppins(
                                                  color: Colors.black),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Your Phone Number *',
                                            labelStyle: GoogleFonts.poppins(
                                                color: Colors.grey
                                                    .withOpacity(.9)),
                                            counterText: "",
                                            enabled: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenSize.height *
                                                            0.02,
                                                    vertical: screenSize.width *
                                                        0.02),
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
                                          initialCountryCode:
                                              initialCountryCode.isEmpty
                                                  ? 'LB'
                                                  : initialCountryCode,
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
                                            initialCountryCode =
                                                phone.countryISOCode;
                                            if (kDebugMode) {
                                              print(countryCode);
                                              print(initialCountryCode);
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Transform.scale(
                                              scale: 1.3,
                                              child: Checkbox(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                side: BorderSide(
                                                    color: showValidation
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .error
                                                        : const Color(
                                                            0xffEFEFF4),
                                                    width: 1),
                                                value: _checkbox,
                                                onChanged: (value) {
                                                  if (mounted) {
                                                    setState(() {
                                                      _checkbox = !_checkbox;
                                                      showValidation = false;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Column(
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'I read and agree to the \n',
                                                              style: GoogleFonts.poppins(
                                                                  color: showValidation
                                                                      ? Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .error
                                                                      : Colors
                                                                          .grey,
                                                                  height: 1.5),
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        'Terms & Conditions',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                      height:
                                                                          1.3,
                                                                      color: showValidation
                                                                          ? Theme.of(context)
                                                                              .colorScheme
                                                                              .error
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {
                                                                            Get.toNamed(MyRouter.term);
                                                                          }),
                                                                TextSpan(
                                                                  text:
                                                                      '  and  \n',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: showValidation
                                                                        ? Theme.of(context)
                                                                            .colorScheme
                                                                            .error
                                                                        : Colors
                                                                            .grey,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                    text:
                                                                        'Privacy Policy',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                      color: showValidation
                                                                          ? Theme.of(context)
                                                                              .colorScheme
                                                                              .error
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {
                                                                            Get.toNamed(MyRouter.privacypolicy);
                                                                          })
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),

                                        // RichText(
                                        //   text: TextSpan(
                                        //     text: 'Hello ',
                                        //     style: DefaultGoogleFonts.poppins.of(context).style,
                                        //     children: const <TextSpan>[
                                        //       TextSpan(text: 'w600', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                        //       TextSpan(text: ' world!'),
                                        //     ],
                                        //   ),
                                        // )
                                        addHeight(screenSize.height * 0.02),
                                        CommonButton(
                                          buttonHeight: 6.5,
                                          buttonWidth: 95,
                                          mainGradient:
                                              AppTheme.primaryGradientColor,
                                          text: Strings.buttonSign,
                                          textColor: Colors.white,
                                          onTap: () {
                                            showValidation = true;
                                            if (mounted) {
                                              setState(() {});
                                            }
                                            if (formKey.currentState!
                                                .validate()) {
                                              if (_checkbox == false) {
                                                return;
                                              } else {
                                                showValidation = false;
                                                signUpUser();
                                              }
                                            }
                                          },
                                        ),
                                        /*addHeight(16),
                                        Row(
                                          children: [
                                            Expanded(child: Divider()),
                                            Text('  or  '),
                                            Expanded(child: Divider()),
                                          ],
                                        ),*/
                                        addHeight(screenSize.height * 0.02),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                bottom: screenSize.height * 0.05,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: RichText(
                          text: TextSpan(
                              text: Strings.signIn,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: const Color(0xFFE02020)),
                              children: [
                                TextSpan(
                                    text: Strings.signInNow,
                                    recognizer: TapGestureRecognizer(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: const Color(0xFFE02020),
                                      fontWeight: FontWeight.w600,
                                    )),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn(
    phoneNumer,
  ) {
    Map<String, dynamic> map = {};
    map["country_code"] = countryCode;
    map["phone"] = phoneNumer;

    repositories
        .postApi(url: ApiUrls.loginUrl, context: context, mapData: map)
        .then((value) {
      ModelResponseCommon model =
          ModelResponseCommon.fromJson(jsonDecode(value));
      if (model.status!) {
        // showToast(model.message.toString().split("'").first);
        // Get.toNamed(OTPVerification.route, arguments: phoneNumber.text.trim());
        if (model.message.toString().split(" ").length >= 5) {
          verifyOtp(model.message.toString().split(" ")[5], phoneNumer);
        }
      } else {
        showToast(model.message.toString());
      }
    });
  }

  verifyOtp(otp, phoneNumber) async {
    Map<String, dynamic> map = {};
    map["phone"] = phoneNumber;
    map["otp"] = otp;
    map["fcm_token"] = await FirebaseMessaging.instance.getToken();
    repositories
        .postApi(
      url: ApiUrls.verifySignIn,
      mapData: map,
    )
        .then((value) async {
      ModelLoginResponse model = ModelLoginResponse.fromJson(jsonDecode(value));
      // showToast(model.message ?? "Something went wrong");
      if (model.status!) {
        sha.SharedPreferences prefs = await sha.SharedPreferences.getInstance();
        prefs.setString("user_details", jsonEncode(model));
        if (kDebugMode) {
          print(jsonDecode(prefs.get("user_details").toString())[""]);
        }
        Get.back();
        Get.back();
        final cartController = Get.put(CartController());
        cartController.resetAll();
      }
    });
  }
}




//
// import 'dart:convert';
//
//
// import 'package:dinelah/models/model_response_common.dart';
// import 'package:dinelah/res/app_assets.dart';
// import 'package:dinelah/res/strings.dart';
//
// import 'package:dinelah/utils/api_constant.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import '../../helper/helper.dart';
// import '../../main.dart';
// import '../../repositories/new_common_repo/repository.dart';
// import '../../res/theme/theme.dart';
// import '../../routers/my_router.dart';
// import '../widget/common_button.dart';
// import '../widget/phone_field.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);
//
//   @override
//   SignUpScreenState createState() => SignUpScreenState();
// }
//
// class SignUpScreenState extends State<SignUpScreen> {
//   var firstName = TextEditingController();
//   var lastName = TextEditingController();
//   var mobileController = TextEditingController();
//   String countryCode = "";
//   final formKey = GlobalKey<FormState>();
//   final Repositories repositories = Repositories();
//   bool _checkbox = false;
//   bool showValidation = false;
//
//   signUpUser() {
//     Map<String, dynamic> map = {};
//     map["first_name"] = firstName.text.trim();
//     map["last_name"] = lastName.text.trim();
//     map["country_code"] = countryCode;
//     map["phone"] = mobileController.text.trim();
//     map["social_login_id"] = "";
//     map["social_type"] = "manual";
//     repositories
//         .postApi(
//       url: ApiUrls.signUpUrl,
//       mapData: map,
//       context: context,
//     )
//         .then((value) {
//       ModelResponseCommon model =
//       ModelResponseCommon.fromJson(jsonDecode(value));
//       showToast(model.message ?? "Something went Wrong");
//       if (model.status!) {
//         Get.back();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             image: DecorationImage(
//               image: AssetImage(
//                 AppAssets.logInBg,
//               ),
//               fit: BoxFit.cover,
//             ),
//           ),
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Stack(
//             children: [
//               Positioned(
//                   top: 100,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Text(
//                           'Glad to \nmeet you.',
//                           style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 36,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16,),
//                       Theme(
//                         data: ThemeData(
//                             primaryColor: Colors.red, primarySwatch: Colors.red),
//                         child: SizedBox(
//                           width: screenSize.width,
//                           child: Form(
//                             key: formKey,
//                             child: Column(
//                               children: [
//                                 Card(
//                                   elevation: 5,
//                                   color: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   margin:
//                                   const EdgeInsets.fromLTRB(18, 56, 18, 24),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                           Strings.sign,
//                                           style: GoogleFonts.poppins(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 20),
//                                         ),
//                                         addHeight(5),
//                                         Text(
//                                           Strings.signToYourAc,
//                                           style: GoogleFonts.poppins(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 20),
//                                         ),
//
//                                         addHeight(24),
//                                         TextFormField(
//                                           controller: firstName,
//                                           validator: (value) {
//                                             if (value.toString().trim().isEmpty) {
//                                               return "First name is required";
//                                             } else {
//                                               return null;
//                                             }
//                                           },
//                                           keyboardType: TextInputType.name,
//                                           autovalidateMode:
//                                           AutovalidateMode.onUserInteraction,
//                                           textInputAction: TextInputAction.next,
//                                           decoration: InputDecoration(
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(10),
//                                                   borderSide: BorderSide(
//                                                       color: Colors.grey
//                                                           .withOpacity(.3))),
//                                               contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   horizontal: 14),
//                                               enabled: true,
//                                               enabledBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(10),
//                                                   borderSide: BorderSide(
//                                                       color: Colors.grey
//                                                           .withOpacity(.3))),
//                                               hintText: 'First Name *',
//                                               hintStyle: GoogleFonts.poppins(
//                                                   fontSize: 14,
//                                                   color: Colors.grey)),
//                                         ),
//                                         const SizedBox(
//                                           height: 18,
//                                         ),
//                                         TextFormField(
//                                           controller: lastName,
//                                           validator: (value) {
//                                             if (value.toString().trim().isEmpty) {
//                                               return "Last name is required";
//                                             } else {
//                                               return null;
//                                             }
//                                           },
//                                           keyboardType: TextInputType.name,
//                                           autovalidateMode:
//                                           AutovalidateMode.onUserInteraction,
//                                           textInputAction: TextInputAction.next,
//                                           decoration: InputDecoration(
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(10),
//                                                   borderSide: BorderSide(
//                                                       color: Colors.grey
//                                                           .withOpacity(.3))),
//                                               contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   horizontal: 14),
//                                               enabled: true,
//                                               enabledBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(10),
//                                                   borderSide: BorderSide(
//                                                       color: Colors.grey
//                                                           .withOpacity(.3))),
//                                               hintText: 'last Name *',
//                                               hintStyle: GoogleFonts.poppins(
//                                                   fontSize: 14,
//                                                   color: Colors.grey)),
//                                         ),
//                                         const SizedBox(
//                                           height: 16,
//                                         ),
//                                         CustomIntlPhoneField(
//                                           controller: mobileController,
//                                           dropdownIconPosition:
//                                           IconPosition.trailing,
//                                           dropdownTextStyle: GoogleFonts.poppins(
//                                               color: Colors.black),
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter.digitsOnly
//                                           ],
//                                           keyboardType: TextInputType.number,
//                                           decoration: InputDecoration(
//                                             labelText: 'Your Phone Number',
//                                             labelStyle: GoogleFonts.poppins(
//                                                 color:
//                                                 Colors.grey.withOpacity(.9)),
//                                             counterText: "",
//                                             enabled: true,
//                                             contentPadding:
//                                             const EdgeInsets.symmetric(
//                                                 horizontal: 10, vertical: 10),
//                                             focusedBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(10),
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey
//                                                         .withOpacity(.3),
//                                                     width: 1.5)),
//                                             enabledBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(15),
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey
//                                                         .withOpacity(.3),
//                                                     width: 1.2)),
//                                             border: OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(15),
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey
//                                                         .withOpacity(.3),
//                                                     width: 1.2)),
//                                           ),
//                                           initialCountryCode: initialCountryCode.isEmpty ?'LB' : initialCountryCode,
//                                           onCountryChanged: (value) {
//                                             countryCode = value.dialCode;
//                                             initialCountryCode = value.code;
//                                             if (kDebugMode) {
//                                               print(countryCode);
//                                               print(initialCountryCode);
//                                             }
//                                           },
//                                           onChanged: (phone) {
//                                             countryCode = phone.countryCode;
//                                             initialCountryCode = phone.countryISOCode;
//                                             if (kDebugMode) {
//                                               print(countryCode);
//                                               print(initialCountryCode);
//                                             }
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           height: 10,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Checkbox(
//                                               shape:
//                                               const RoundedRectangleBorder(),
//                                               side: BorderSide(
//                                                   color: showValidation
//                                                       ? Theme.of(context)
//                                                       .colorScheme
//                                                       .error
//                                                       : Colors.grey,
//                                                   width: 2),
//                                               value: _checkbox,
//                                               onChanged: (value) {
//                                                 if (mounted) {
//                                                   setState(() {
//                                                     _checkbox = !_checkbox;
//                                                     showValidation = false;
//                                                   });
//                                                 }
//                                               },
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Column(
//                                                   children: [
//                                                     Padding(
//                                                       padding:
//                                                       const EdgeInsets.only(
//                                                           top: 10),
//                                                       child: Column(
//                                                         children: [
//                                                           RichText(
//                                                             text: TextSpan(
//                                                               text:
//                                                               'I read and agree to the \n',
//                                                               style: GoogleFonts.poppins(
//                                                                   color: showValidation
//                                                                       ? Theme.of(
//                                                                       context)
//                                                                       .colorScheme
//                                                                       .error
//                                                                       : Colors
//                                                                       .grey,
//                                                                   height: 1.5),
//                                                               children: [
//                                                                 TextSpan(
//                                                                     text:
//                                                                     'Terms & Conditions',
//                                                                     style: GoogleFonts
//                                                                         .poppins(
//                                                                       decoration:
//                                                                       TextDecoration
//                                                                           .underline,
//                                                                       height: 1.3,
//                                                                       color: showValidation
//                                                                           ? Theme.of(context)
//                                                                           .colorScheme
//                                                                           .error
//                                                                           : Colors
//                                                                           .grey,
//                                                                     ),
//                                                                     recognizer:
//                                                                     TapGestureRecognizer()
//                                                                       ..onTap =
//                                                                           () {
//                                                                         Get.toNamed(
//                                                                             MyRouter.term);
//                                                                       }),
//                                                                 TextSpan(
//                                                                   text: '  and  ',
//                                                                   style:
//                                                                   GoogleFonts
//                                                                       .poppins(
//                                                                     color: showValidation
//                                                                         ? Theme.of(
//                                                                         context)
//                                                                         .colorScheme
//                                                                         .error
//                                                                         : Colors
//                                                                         .grey,
//                                                                   ),
//                                                                 ),
//                                                                 TextSpan(
//                                                                     text:
//                                                                     'Privacy Policy',
//                                                                     style: GoogleFonts
//                                                                         .poppins(
//                                                                       decoration:
//                                                                       TextDecoration
//                                                                           .underline,
//                                                                       color: showValidation
//                                                                           ? Theme.of(context)
//                                                                           .colorScheme
//                                                                           .error
//                                                                           : Colors
//                                                                           .grey,
//                                                                     ),
//                                                                     recognizer:
//                                                                     TapGestureRecognizer()
//                                                                       ..onTap =
//                                                                           () {
//                                                                         Get.toNamed(
//                                                                             MyRouter.privacypolicy);
//                                                                       })
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                         addHeight(26),
//                                         CommonButton(
//                                           buttonHeight: 6.5,
//                                           buttonWidth: 95,
//                                           mainGradient:
//                                           AppTheme.primaryGradientColor,
//                                           text: Strings.buttonSign,
//                                           textColor: Colors.white,
//                                           onTap: () {
//                                             showValidation = true;
//                                             if (mounted) {
//                                               setState(() {});
//                                             }
//                                             if (formKey.currentState!
//                                                 .validate()) {
//                                               if (_checkbox == false) {
//                                                 return;
//                                               } else {
//                                                 showValidation = false;
//                                                 signUpUser();
//                                               }
//                                             }
//                                           },
//                                         ),
//                                         /*addHeight(16),
//                                     Row(
//                                       children: [
//                                         Expanded(child: Divider()),
//                                         Text('  or  '),
//                                         Expanded(child: Divider()),
//                                       ],
//                                     ),*/
//                                         addHeight(16),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   )),
//               Positioned(
//                   top: 40,
//                   left: 10,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: const Color(0xffEAEAEA),
//                             )),
//                         child: InkWell(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: const Icon(
//                             Icons.arrow_back,
//                             color: Color(0xffEAEAEA),
//                           ),
//                         )),
//                   )),
//               // Positioned(
//               //     bottom: 20,
//               //     child: Theme(
//               //       data: ThemeData(
//               //           primaryColor: Colors.red, primarySwatch: Colors.red),
//               //       child: SizedBox(
//               //         width: screenSize.width,
//               //         child: Form(
//               //           key: formKey,
//               //           child: Column(
//               //             children: [
//               //               Card(
//               //                 elevation: 5,
//               //                 color: Colors.white,
//               //                 shape: RoundedRectangleBorder(
//               //                   borderRadius: BorderRadius.circular(10.0),
//               //                 ),
//               //                 margin:
//               //                 const EdgeInsets.fromLTRB(18, 56, 18, 24),
//               //                 child: Padding(
//               //                   padding: const EdgeInsets.all(16.0),
//               //                   child: Column(
//               //                     children: [
//               //                       Text(
//               //                       Strings.sign,
//               //                           style: GoogleFonts.poppins(
//               //                               color: Colors.black,
//               //                               fontWeight: FontWeight.w600,
//               //                               fontSize: 20),
//               //                       ),
//               //                       addHeight(5),
//               //                       Text(
//               //                         Strings.signToYourAc,
//               //                         style: GoogleFonts.poppins(
//               //                             color: Colors.black,
//               //                             fontWeight: FontWeight.w600,
//               //                             fontSize: 20),
//               //                       ),
//               //
//               //                       addHeight(24),
//               //                       TextFormField(
//               //                         controller: firstName,
//               //                         validator: (value) {
//               //                           if (value.toString().trim().isEmpty) {
//               //                             return "First name is required";
//               //                           } else {
//               //                             return null;
//               //                           }
//               //                         },
//               //                         keyboardType: TextInputType.name,
//               //                         autovalidateMode:
//               //                         AutovalidateMode.onUserInteraction,
//               //                         textInputAction: TextInputAction.next,
//               //                         decoration: InputDecoration(
//               //                             border: OutlineInputBorder(
//               //                                 borderRadius:
//               //                                 BorderRadius.circular(10),
//               //                                 borderSide: BorderSide(
//               //                                     color: Colors.grey
//               //                                         .withOpacity(.3))),
//               //                             contentPadding:
//               //                             const EdgeInsets.symmetric(
//               //                                 horizontal: 14),
//               //                             enabled: true,
//               //                             enabledBorder: OutlineInputBorder(
//               //                                 borderRadius:
//               //                                 BorderRadius.circular(10),
//               //                                 borderSide: BorderSide(
//               //                                     color: Colors.grey
//               //                                         .withOpacity(.3))),
//               //                             hintText: 'First Name *',
//               //                             hintStyle: GoogleFonts.poppins(
//               //                                 fontSize: 14,
//               //                                 color: Colors.grey)),
//               //                       ),
//               //                       const SizedBox(
//               //                         height: 18,
//               //                       ),
//               //                       TextFormField(
//               //                         controller: lastName,
//               //                         validator: (value) {
//               //                           if (value.toString().trim().isEmpty) {
//               //                             return "Last name is required";
//               //                           } else {
//               //                             return null;
//               //                           }
//               //                         },
//               //                         keyboardType: TextInputType.name,
//               //                         autovalidateMode:
//               //                         AutovalidateMode.onUserInteraction,
//               //                         textInputAction: TextInputAction.next,
//               //                         decoration: InputDecoration(
//               //                             border: OutlineInputBorder(
//               //                                 borderRadius:
//               //                                 BorderRadius.circular(10),
//               //                                 borderSide: BorderSide(
//               //                                     color: Colors.grey
//               //                                         .withOpacity(.3))),
//               //                             contentPadding:
//               //                             const EdgeInsets.symmetric(
//               //                                 horizontal: 14),
//               //                             enabled: true,
//               //                             enabledBorder: OutlineInputBorder(
//               //                                 borderRadius:
//               //                                 BorderRadius.circular(10),
//               //                                 borderSide: BorderSide(
//               //                                     color: Colors.grey
//               //                                         .withOpacity(.3))),
//               //                             hintText: 'last Name *',
//               //                             hintStyle: GoogleFonts.poppins(
//               //                                 fontSize: 14,
//               //                                 color: Colors.grey)),
//               //                       ),
//               //                       const SizedBox(
//               //                         height: 16,
//               //                       ),
//               //                       CustomIntlPhoneField(
//               //                         controller: mobileController,
//               //                         dropdownIconPosition:
//               //                         IconPosition.trailing,
//               //                         dropdownTextStyle: GoogleFonts.poppins(
//               //                             color: Colors.black),
//               //                         inputFormatters: [
//               //                           FilteringTextInputFormatter.digitsOnly
//               //                         ],
//               //                         keyboardType: TextInputType.number,
//               //                         decoration: InputDecoration(
//               //                           labelText: 'Your Phone Number',
//               //                           labelStyle: GoogleFonts.poppins(
//               //                               color:
//               //                               Colors.grey.withOpacity(.9)),
//               //                           counterText: "",
//               //                           enabled: true,
//               //                           contentPadding:
//               //                           const EdgeInsets.symmetric(
//               //                               horizontal: 10, vertical: 10),
//               //                           focusedBorder: OutlineInputBorder(
//               //                               borderRadius:
//               //                               BorderRadius.circular(10),
//               //                               borderSide: BorderSide(
//               //                                   color: Colors.grey
//               //                                       .withOpacity(.3),
//               //                                   width: 1.5)),
//               //                           enabledBorder: OutlineInputBorder(
//               //                               borderRadius:
//               //                               BorderRadius.circular(15),
//               //                               borderSide: BorderSide(
//               //                                   color: Colors.grey
//               //                                       .withOpacity(.3),
//               //                                   width: 1.2)),
//               //                           border: OutlineInputBorder(
//               //                               borderRadius:
//               //                               BorderRadius.circular(15),
//               //                               borderSide: BorderSide(
//               //                                   color: Colors.grey
//               //                                       .withOpacity(.3),
//               //                                   width: 1.2)),
//               //                         ),
//               //                         initialCountryCode: initialCountryCode.isEmpty ?'LB' : initialCountryCode,
//               //                         onCountryChanged: (value) {
//               //                           countryCode = value.dialCode;
//               //                           initialCountryCode = value.code;
//               //                           if (kDebugMode) {
//               //                             print(countryCode);
//               //                             print(initialCountryCode);
//               //                           }
//               //                         },
//               //                         onChanged: (phone) {
//               //                           countryCode = phone.countryCode;
//               //                           initialCountryCode = phone.countryISOCode;
//               //                           if (kDebugMode) {
//               //                             print(countryCode);
//               //                             print(initialCountryCode);
//               //                           }
//               //                         },
//               //                       ),
//               //                       const SizedBox(
//               //                         height: 10,
//               //                       ),
//               //                       Row(
//               //                         mainAxisAlignment:
//               //                         MainAxisAlignment.start,
//               //                         crossAxisAlignment:
//               //                         CrossAxisAlignment.start,
//               //                         children: [
//               //                           Checkbox(
//               //                             shape:
//               //                             const RoundedRectangleBorder(),
//               //                             side: BorderSide(
//               //                                 color: showValidation
//               //                                     ? Theme.of(context)
//               //                                     .colorScheme
//               //                                     .error
//               //                                     : Colors.grey,
//               //                                 width: 2),
//               //                             value: _checkbox,
//               //                             onChanged: (value) {
//               //                               if (mounted) {
//               //                                 setState(() {
//               //                                   _checkbox = !_checkbox;
//               //                                   showValidation = false;
//               //                                 });
//               //                               }
//               //                             },
//               //                           ),
//               //                           Row(
//               //                             children: [
//               //                               Column(
//               //                                 children: [
//               //                                   Padding(
//               //                                     padding:
//               //                                     const EdgeInsets.only(
//               //                                         top: 10),
//               //                                     child: Column(
//               //                                       children: [
//               //                                         RichText(
//               //                                           text: TextSpan(
//               //                                             text:
//               //                                             'I read and agree to the \n',
//               //                                             style: GoogleFonts.poppins(
//               //                                                 color: showValidation
//               //                                                     ? Theme.of(
//               //                                                     context)
//               //                                                     .colorScheme
//               //                                                     .error
//               //                                                     : Colors
//               //                                                     .grey,
//               //                                                 height: 1.5),
//               //                                             children: [
//               //                                               TextSpan(
//               //                                                   text:
//               //                                                   'Terms & Conditions',
//               //                                                   style: GoogleFonts
//               //                                                       .poppins(
//               //                                                     decoration:
//               //                                                     TextDecoration
//               //                                                         .underline,
//               //                                                     height: 1.3,
//               //                                                     color: showValidation
//               //                                                         ? Theme.of(context)
//               //                                                         .colorScheme
//               //                                                         .error
//               //                                                         : Colors
//               //                                                         .grey,
//               //                                                   ),
//               //                                                   recognizer:
//               //                                                   TapGestureRecognizer()
//               //                                                     ..onTap =
//               //                                                         () {
//               //                                                       Get.toNamed(
//               //                                                           MyRouter.term);
//               //                                                     }),
//               //                                               TextSpan(
//               //                                                 text: '  and  ',
//               //                                                 style:
//               //                                                 GoogleFonts
//               //                                                     .poppins(
//               //                                                   color: showValidation
//               //                                                       ? Theme.of(
//               //                                                       context)
//               //                                                       .colorScheme
//               //                                                       .error
//               //                                                       : Colors
//               //                                                       .grey,
//               //                                                 ),
//               //                                               ),
//               //                                               TextSpan(
//               //                                                   text:
//               //                                                   'Privacy Policy',
//               //                                                   style: GoogleFonts
//               //                                                       .poppins(
//               //                                                     decoration:
//               //                                                     TextDecoration
//               //                                                         .underline,
//               //                                                     color: showValidation
//               //                                                         ? Theme.of(context)
//               //                                                         .colorScheme
//               //                                                         .error
//               //                                                         : Colors
//               //                                                         .grey,
//               //                                                   ),
//               //                                                   recognizer:
//               //                                                   TapGestureRecognizer()
//               //                                                     ..onTap =
//               //                                                         () {
//               //                                                       Get.toNamed(
//               //                                                           MyRouter.privacypolicy);
//               //                                                     })
//               //                                             ],
//               //                                           ),
//               //                                         ),
//               //                                       ],
//               //                                     ),
//               //                                   ),
//               //                                 ],
//               //                               ),
//               //                             ],
//               //                           )
//               //                         ],
//               //                       ),
//               //                       addHeight(26),
//               //                       CommonButton(
//               //                         buttonHeight: 6.5,
//               //                         buttonWidth: 95,
//               //                         mainGradient:
//               //                         AppTheme.primaryGradientColor,
//               //                         text: Strings.buttonSign,
//               //                         textColor: Colors.white,
//               //                         onTap: () {
//               //                           showValidation = true;
//               //                           if (mounted) {
//               //                             setState(() {});
//               //                           }
//               //                           if (formKey.currentState!
//               //                               .validate()) {
//               //                             if (_checkbox == false) {
//               //                               return;
//               //                             } else {
//               //                               showValidation = false;
//               //                               signUpUser();
//               //                             }
//               //                           }
//               //                         },
//               //                       ),
//               //                       /*addHeight(16),
//               //                       Row(
//               //                         children: [
//               //                           Expanded(child: Divider()),
//               //                           Text('  or  '),
//               //                           Expanded(child: Divider()),
//               //                         ],
//               //                       ),*/
//               //                       addHeight(16),
//               //                     ],
//               //                   ),
//               //                 ),
//               //               ),
//               //             ],
//               //           ),
//               //         ),
//               //       ),
//               //     )),
//               Positioned(
//                 bottom: 10,
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: RichText(
//                           text: TextSpan(
//                               text: Strings.signIn,
//                               style: GoogleFonts.poppins(
//                                   fontSize: 16, color: const Color(0xFFE02020)),
//                               children: [
//                                 TextSpan(
//                                     text: Strings.signInNow,
//                                     recognizer: TapGestureRecognizer(),
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 16,
//                                       color: const Color(0xFFE02020),
//                                       fontWeight: FontWeight.w600,
//                                     )),
//                               ]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
