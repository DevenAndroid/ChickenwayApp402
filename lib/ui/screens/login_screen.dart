import 'dart:convert';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/models/model_login.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/res/app_assets.dart';
import 'package:dinelah/res/strings.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/routers/my_router.dart';
import 'package:dinelah/ui/widget/common_button.dart';
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
import '../widget/phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart' as sha;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginFormKey = GlobalKey<FormState>();
  var phoneNumber = TextEditingController();
  String countryCode = "";
  final Repositories repositories = Repositories();

  loginUser() async {
    Map<String, dynamic> map = {};
    map["country_code"] = countryCode;
    map["phone"] = phoneNumber.text.trim();

    repositories
        .postApi(url: ApiUrls.loginUrl, context: context, mapData: map)
        .then((value) {
      ModelResponseCommon model =
          ModelResponseCommon.fromJson(jsonDecode(value));
      if (model.status!) {
        // showToast(model.message.toString().split("'").first);
        // Get.toNamed(OTPVerification.route, arguments: phoneNumber.text.trim());
        if (model.message.toString().split(" ").length >= 5) {
          verifyOtp(model.message.toString().split(" ")[5]);
        }
      } else {
        showToast(model.message.toString());
      }
    });
  }

  verifyOtp(otp) async {
    Map<String, dynamic> map = {};
    map["phone"] = phoneNumber.text;
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
                top: 130,
                left: 20,
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
                    top: 30,
                    left: 20,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
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
                bottom: 100,
                child: Stack(
                  children: [
                    Theme(
                      data: ThemeData(
                          primaryColor: Colors.red, primarySwatch: Colors.red),
                      child: SizedBox(
                        width: screenSize.width,
                        child: Form(
                          key: loginFormKey,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, right: 18),
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin:
                                      const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Column(
                                      children: [
                                        addHeight(screenSize.height * .01),
                                        Text(
                                          Strings.login,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          Strings.loginToYourAc,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        CustomIntlPhoneField(
                                          controller: phoneNumber,
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
                                            labelText: 'Your Phone Number',
                                            labelStyle: GoogleFonts.poppins(
                                                color: Colors.grey
                                                    .withOpacity(.9)),
                                            hintText: '+ 961  71 234 567',
                                            counterText: "",
                                            enabled: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(.3),
                                                    width: 1.5)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(.3),
                                                    width: 1.2)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                        addHeight(50),
                                        CommonButton(
                                          buttonHeight: 6.7,
                                          buttonWidth: 95,
                                          mainGradient:
                                              AppTheme.primaryGradientColor,
                                          margin: const EdgeInsets.all(3),
                                          text: Strings.buttonLogins,
                                          textColor: Colors.white,
                                          onTap: () {
                                            if (loginFormKey.currentState!
                                                .validate()) {
                                              loginUser();
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
                                        addHeight(20),
                                      ],
                                    ),
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
              bottom: 30,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: Strings.signUp,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFFE02020),
                              fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                                text: Strings.signUpNow,
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => Get.toNamed(MyRouter.signUpScreen),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: const Color(0xFFE02020),
                                  fontWeight: FontWeight.w600,
                                )),
                          ]),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// signInWithGoogle() async {
//   await GoogleSignIn().signOut();
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   final GoogleSignInAuthentication googleAuth =
//       await googleUser!.authentication;
//   final credential = GoogleAuthProvider.credential(
//     idToken: googleAuth.idToken,
//     accessToken: googleAuth.accessToken,
//   );
//
//   // showToast(googleUser.id.toString());
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   pref.setString('socialLoginId', googleUser.id.toString());
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var deviceId = prefs.getString('deviceId');
//
//   final value = await FirebaseAuth.instance.signInWithCredential(credential);
//   log("Firebase response.... ${value.toString()}");
//   print(await FirebaseMessaging.instance.getToken());
//   getSocialLogin(
//           context,
//           value.user!.uid.toString(),
//           "google",
//           deviceId,
//           value.user!.email.toString(),
//           await FirebaseMessaging.instance.getToken())
//       .then((value1) async {
//     showToast(value1.message);
//     if (value1.status) {
//       // showToast(value.message.toString());
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       pref.setString('user', jsonEncode(value1.data));
//       Get.offAllNamed(MyRouter.customBottomBar);
//     }
//     // else {
//     //   // showToast(value.message.toString());
//     //   Get.offAndToNamed(MyRouter.signUpScreen, arguments: [
//     //     googleUser.id.toString(),
//     //     googleUser.email.toString(),
//     //     googleUser.displayName.toString(),
//     //     'google'
//     //   ]);
//     // }
//   });
// }

// signInFaceBook() async {
//   final LoginResult loginResult = await FacebookAuth.instance
//       .login(permissions: ["public_profile", "email"]);
//
//   final OAuthCredential oAuthCredential =
//       FacebookAuthProvider.credential(loginResult.accessToken!.token);
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var deviceId = prefs.getString('deviceId');
//   final value = await FirebaseAuth.instance
//       .signInWithCredential(oAuthCredential)
//       .then((value) async {
//     log("Facebook login response.....   $value");
//     print(await FirebaseMessaging.instance.getToken());
//     getSocialLogin(
//             context,
//             value.user!.uid.toString(),
//             "facebook",
//             deviceId,
//             value.additionalUserInfo!.profile!["email"] ??
//                 "${value.user!.uid}@gmail.com",
//             await FirebaseMessaging.instance.getToken())
//         .then((value1) async {
//       showToast(value1.message);
//       if (value1.status) {
//         SharedPreferences pref = await SharedPreferences.getInstance();
//         pref.setString('user', jsonEncode(value1.data));
//         Get.offAllNamed(MyRouter.customBottomBar);
//       }
//     });
//   }).catchError((FirebaseAuthException? e) {
//     showToast(e.toString());
//     throw Exception(e!.message);
//   });
//   log("Firebase response.... ${value.toString()}");
//   // if (value.user!.email != null) {
//
//   // }
// }

//  signInApple() async {
//   final appleProvider = AppleAuthProvider().addScope("email").addScope("fullName");
//
//   if(kIsWeb){
//     await FirebaseAuth.instance.signInWithPopup(appleProvider).then((value) {
//
//     });
//   } else {
//     await FirebaseAuth.instance.signInWithProvider(appleProvider).then((value) {
//
//
//     });
//   }
// }
}





// import 'dart:convert';
//
// import 'package:dinelah/models/model_response_common.dart';
// import 'package:dinelah/res/app_assets.dart';
// import 'package:dinelah/res/strings.dart';
// import 'package:dinelah/res/theme/theme.dart';
// import 'package:dinelah/routers/my_router.dart';
// import 'package:dinelah/ui/screens/verify_otp_sign_up_password.dart';
// import 'package:dinelah/ui/widget/common_button.dart';
// import 'package:dinelah/utils/api_constant.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
//
// import '../../helper/helper.dart';
// import '../../main.dart';
// import '../../repositories/new_common_repo/repository.dart';
// import '../widget/phone_field.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final loginFormKey = GlobalKey<FormState>();
//   var phoneNumber = TextEditingController();
//   String countryCode = "";
//   final Repositories repositories = Repositories();
//
//   loginUser() async {
//     Map<String, dynamic> map = {};
//     map["country_code"] = countryCode;
//     map["phone"] = phoneNumber.text.trim();
//
//     repositories.postApi(url: ApiUrls.loginUrl,context: context, mapData: map).then((value) {
//       ModelResponseCommon model = ModelResponseCommon.fromJson(jsonDecode(value));
//       if(model.status!){
//         showToast(model.message.toString().split("'").first);
//         Get.toNamed(
//             OTPVerification.route,arguments: phoneNumber.text.trim());
//       } else {
//         showToast(model.message.toString());
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//               AppAssets.logInBg,
//             ),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//                 top: 170,
//                 left: 20,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 13),
//                   child: Text(
//                     'Glad to \nmeet you.',
//                     style: GoogleFonts.poppins(
//
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 36,
//                     ),
//                   ),
//                 )),
//             Stack(
//               children: [
//                 Positioned(
//                     top: 30,
//                     left: 10,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 3.0),
//                       child: Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: const Color(0xffEAEAEA),
//                               )),
//                           child: InkWell(
//                             onTap: () {
//                               Get.back();
//                             },
//                             child: const Icon(
//                               Icons.arrow_back,
//                               color: Color(0xffEAEAEA),
//                             ),
//                           )),
//                     ))
//               ],
//             ),
//             Positioned(
//                 bottom: 100,
//                 child: Stack(
//                   children: [
//                     Theme(
//                       data: ThemeData(
//                           primaryColor: Colors.red, primarySwatch: Colors.red),
//                       child: SizedBox(
//                         width: screenSize.width,
//                         child: Form(
//                           key: loginFormKey,
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 18,right: 18),
//                                 child: Card(
//                                   elevation: 5,
//                                   color: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   margin:
//                                       const EdgeInsets.fromLTRB(12,12, 12, 12),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(13.0),
//                                     child: Column(
//                                       children: [
//                                         addHeight(screenSize.height * .01),
//                                         Text(
//                                           Strings.login,
//                                           style: GoogleFonts.poppins(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 20),
//                                         ),
//
//                                         Text(
//                                           Strings.loginToYourAc,
//                                           style: GoogleFonts.poppins(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 20,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 20,
//                                         ),
//                                         const SizedBox(
//                                           height: 16,
//                                         ),
//                                         CustomIntlPhoneField(
//                                           controller: phoneNumber,
//                                           dropdownIconPosition:
//                                               IconPosition.trailing,
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
//                                                     Colors.grey.withOpacity(.9)),
//                                             hintText: '+ 961  71 234 567',
//                                             counterText: "",
//                                             enabled: true,
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     horizontal: 10, vertical: 10),
//                                             focusedBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey
//                                                         .withOpacity(.3),
//                                                     width: 1.5)),
//                                             enabledBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey
//                                                         .withOpacity(.3),
//                                                     width: 1.2)),
//                                             border: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey
//                                                         .withOpacity(.3),
//                                                     width: 1.2)),
//                                           ),
//                                           initialCountryCode: initialCountryCode.isEmpty ? 'LB' : initialCountryCode,
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
//                                         addHeight(50),
//                                         CommonButton(
//                                           buttonHeight: 6.7,
//                                           buttonWidth: 95,
//
//
//
//                                           mainGradient:
//                                               AppTheme.primaryGradientColor,
//                                           margin: const EdgeInsets.all(3),
//                                           text: Strings.buttonLogins,
//                                           textColor: Colors.white,
//                                           onTap: () {
//                                             if(loginFormKey.currentState!.validate()) {
//                                               loginUser();
//                                             }
//                                           },
//                                         ),
//                                         /*addHeight(16),
//                                         Row(
//                                           children: [
//                                             Expanded(child: Divider()),
//                                             Text('  or  '),
//                                             Expanded(child: Divider()),
//                                           ],
//                                         ),*/
//                                         addHeight(20),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//             Positioned(
//               bottom: 30,
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                           text: Strings.signUp,
//                           style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               color: const Color(0xFFE02020),
//                               fontWeight: FontWeight.w500),
//                           children: [
//                             TextSpan(
//                                 text: Strings.signUpNow,
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap =
//                                       () => Get.toNamed(MyRouter.signUpScreen),
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 16,
//                                   color: const Color(0xFFE02020),
//                                   fontWeight: FontWeight.w600,
//                                 )),
//                           ]),
//                     ),
//                     const SizedBox(
//                       height: 80,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // signInWithGoogle() async {
//   //   await GoogleSignIn().signOut();
//   //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   //   final GoogleSignInAuthentication googleAuth =
//   //       await googleUser!.authentication;
//   //   final credential = GoogleAuthProvider.credential(
//   //     idToken: googleAuth.idToken,
//   //     accessToken: googleAuth.accessToken,
//   //   );
//   //
//   //   // showToast(googleUser.id.toString());
//   //   SharedPreferences pref = await SharedPreferences.getInstance();
//   //   pref.setString('socialLoginId', googleUser.id.toString());
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   var deviceId = prefs.getString('deviceId');
//   //
//   //   final value = await FirebaseAuth.instance.signInWithCredential(credential);
//   //   log("Firebase response.... ${value.toString()}");
//   //   print(await FirebaseMessaging.instance.getToken());
//   //   getSocialLogin(
//   //           context,
//   //           value.user!.uid.toString(),
//   //           "google",
//   //           deviceId,
//   //           value.user!.email.toString(),
//   //           await FirebaseMessaging.instance.getToken())
//   //       .then((value1) async {
//   //     showToast(value1.message);
//   //     if (value1.status) {
//   //       // showToast(value.message.toString());
//   //       SharedPreferences pref = await SharedPreferences.getInstance();
//   //       pref.setString('user', jsonEncode(value1.data));
//   //       Get.offAllNamed(MyRouter.customBottomBar);
//   //     }
//   //     // else {
//   //     //   // showToast(value.message.toString());
//   //     //   Get.offAndToNamed(MyRouter.signUpScreen, arguments: [
//   //     //     googleUser.id.toString(),
//   //     //     googleUser.email.toString(),
//   //     //     googleUser.displayName.toString(),
//   //     //     'google'
//   //     //   ]);
//   //     // }
//   //   });
//   // }
//
//   // signInFaceBook() async {
//   //   final LoginResult loginResult = await FacebookAuth.instance
//   //       .login(permissions: ["public_profile", "email"]);
//   //
//   //   final OAuthCredential oAuthCredential =
//   //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   var deviceId = prefs.getString('deviceId');
//   //   final value = await FirebaseAuth.instance
//   //       .signInWithCredential(oAuthCredential)
//   //       .then((value) async {
//   //     log("Facebook login response.....   $value");
//   //     print(await FirebaseMessaging.instance.getToken());
//   //     getSocialLogin(
//   //             context,
//   //             value.user!.uid.toString(),
//   //             "facebook",
//   //             deviceId,
//   //             value.additionalUserInfo!.profile!["email"] ??
//   //                 "${value.user!.uid}@gmail.com",
//   //             await FirebaseMessaging.instance.getToken())
//   //         .then((value1) async {
//   //       showToast(value1.message);
//   //       if (value1.status) {
//   //         SharedPreferences pref = await SharedPreferences.getInstance();
//   //         pref.setString('user', jsonEncode(value1.data));
//   //         Get.offAllNamed(MyRouter.customBottomBar);
//   //       }
//   //     });
//   //   }).catchError((FirebaseAuthException? e) {
//   //     showToast(e.toString());
//   //     throw Exception(e!.message);
//   //   });
//   //   log("Firebase response.... ${value.toString()}");
//   //   // if (value.user!.email != null) {
//   //
//   //   // }
//   // }
//
// //  signInApple() async {
// //   final appleProvider = AppleAuthProvider().addScope("email").addScope("fullName");
// //
// //   if(kIsWeb){
// //     await FirebaseAuth.instance.signInWithPopup(appleProvider).then((value) {
// //
// //     });
// //   } else {
// //     await FirebaseAuth.instance.signInWithProvider(appleProvider).then((value) {
// //
// //
// //     });
// //   }
// // }
// }
