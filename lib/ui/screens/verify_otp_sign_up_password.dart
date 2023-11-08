import 'dart:convert';
import 'package:dinelah/res/app_assets.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/utils/api_constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../controller/new_controllers/cart_controller.dart';
import '../../helper/helper.dart';
import '../../models/model_login.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../res/strings.dart';
import '../widget/common_button.dart';
import 'package:shared_preferences/shared_preferences.dart' as sha;

class OTP2Verification extends StatefulWidget {
  const OTP2Verification({Key? key}) : super(key: key);
  static const String route = "/OTPVerification";

  @override
  State<OTP2Verification> createState() => _OTP2VerificationState();
}

class _OTP2VerificationState extends State<OTP2Verification> {
  final _formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  final Repositories repositories = Repositories();

  verifyOtp() async {
    Map<String, dynamic> map = {};
    map["phone"] = phoneNumber;
    map["otp"] = otpController.text.trim();
    map["fcm_token"] = await FirebaseMessaging.instance.getToken();
    repositories
        .postApi(
      url: ApiUrls.verifySignIn,
      mapData: map,
    )
        .then((value) async {
      ModelLoginResponse model = ModelLoginResponse.fromJson(jsonDecode(value));
      showToast(model.message ?? "Something went wrong");
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

  String phoneNumber = "";

  @override
  void initState() {
    super.initState();
    phoneNumber = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: const Color(0xFFC33D18),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
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
                top: 160,
                left: 30,
                child: Text(
                  'Glad to \nmeet you.',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 36,
                  ),
                ),
              ),
              Stack(
                children: [
                  Positioned(
                      top: 30,
                      left: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey,
                                )),
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.grey,
                              ),
                            )),
                      ))
                ],
              ),
              Positioned(
                  bottom: 80,
                  child: Stack(
                    children: [
                      Theme(
                        data: ThemeData(
                            primaryColor: Colors.red,
                            primarySwatch: Colors.red),
                        child: SizedBox(
                          width: screenSize.width,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Card(
                                  elevation: 5,
                                  color: Colors.white.withOpacity(0.88),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin:
                                      const EdgeInsets.fromLTRB(32, 56, 32, 24),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          Strings.otp,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          Strings.otpToYourAc,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                        addHeight(14),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Enter your OTP code here',
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        addHeight(15),
                                        PinCodeTextField(
                                          enablePinAutofill: true,
                                          appContext: context,
                                          textStyle: GoogleFonts.poppins(
                                              color: Colors.black),
                                          controller: otpController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
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
                                            disabledColor:
                                                const Color(0xffD8D8D8),
                                            selectedColor:
                                                const Color(0xffD8D8D8),
                                            activeFillColor:
                                                const Color(0xffD8D8D8),
                                            inactiveFillColor:
                                                const Color(0xffD8D8D8),
                                            fieldWidth: 60,
                                            borderWidth: 4,
                                            fieldHeight: 60,
                                            activeColor:
                                                const Color(0xffD8D8D8),
                                            inactiveColor:
                                                const Color(0xffD8D8D8),
                                            selectedFillColor:
                                                const Color(0xffD8D8D8),
                                            errorBorderColor:
                                                const Color(0xffD8D8D8),
                                          ),
                                          cursorColor: Colors.white,
                                          keyboardType: TextInputType.number,
                                          onSubmitted: (v) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              verifyOtp();
                                            }
                                          },
                                          onChanged: (String value) {
                                            if (value.length == 4) {
                                              verifyOtp();
                                            }
                                          },
                                        ),
                                        addHeight(24),
                                        CommonButton(
                                          buttonHeight: 6.5,
                                          buttonWidth: 95,
                                          mainGradient:
                                              AppTheme.primaryGradientColor,
                                          text: Strings.buttonLogins,
                                          textColor: Colors.white,
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              verifyOtp();
                                            }
                                            // Get.toNamed(MyRouter.checkoutscreen);
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        // body: SingleChildScrollView(
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: AddSize.padding10 * 3),
        //     child: Form(
        //       key: _formKey,
        //       child: Column(
        //         children: [
        //           addHeight(screenSize.height * .05),
        //           Row(
        //             children: [
        //               // addWidth(4),
        //               InkWell(
        //                 onTap: () {
        //                   Get.back();
        //                 },
        //                 child: Container(
        //                   width: 30,
        //                     height: 30,
        //                     child: Image.asset(AppAssets.backIcon)),
        //               ),
        //               addWidth(10),
        //               const Text(
        //                 'Verify your mail',
        //                 style: GoogleFonts.poppins(
        //                     color: Colors.white,
        //                     fontSize: 18,
        //                     fontWeight: FontWeight.w600),
        //               ),
        //             ],
        //           ),
        //           addHeight(screenSize.height * .08),
        //           Center(
        //               child: Image.asset(
        //             AppAssets.forgotLogo,
        //             height: 180,
        //             width: 180,
        //           )),
        //           Container(
        //             padding: EdgeInsets.only(
        //                 top: AddSize.padding10 * 2.5,
        //                 bottom: AddSize.padding10 * .5),
        //             child: Text(
        //               'You will get OTP via Email',
        //               style: GoogleFonts.poppins(
        //                   color: Colors.white, fontSize: AddSize.font16),
        //               textAlign: TextAlign.center,
        //             ),
        //           ),
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Container(
        //                 padding: EdgeInsets.only(
        //                   top: AddSize.padding10 * 3.5,
        //                   bottom: AddSize.padding12,
        //                 ),
        //                 child: Text('Enter your OTP Code',
        //                     style: GoogleFonts.poppins(
        //                         fontSize: AddSize.font14,
        //                         color: Colors.white54,
        //                         fontWeight: FontWeight.w600)),
        //               ),
        //
        //               Theme(
        //                 data: ThemeData(
        //                   errorColor: Colors.white,),
        //                 child: PinCodeTextField(
        //
        //                   appContext: context,
        //                   GoogleFonts.poppins: const GoogleFonts.poppins(color: Colors.white),
        //                   controller: otpController,
        //                   inputFormatters: [
        //                     FilteringTextInputFormatter.digitsOnly,
        //                   ],
        //                   pastedGoogleFonts.poppins: GoogleFonts.poppins(
        //                     color: Colors.green.shade600,
        //                     fontWeight: FontWeight.w600,
        //                   ),
        //                   animationType: AnimationType.fade,
        //                   validator: (v) {
        //                     if (v!.isEmpty) {
        //                       return "OTP code Required";
        //                     } else if (v.length != 6) {
        //                       return "Enter complete OTP code";
        //                     }
        //                     return null;
        //                   },
        //                   length: 6,
        //                   pinTheme: PinTheme(
        //                     shape: PinCodeFieldShape.box,
        //                     borderRadius: BorderRadius.circular(5),
        //                     fieldWidth: 40,
        //                     fieldHeight: 40,
        //                     activeColor: Colors.white,
        //                     inactiveColor: Colors.white,
        //                     selectedFillColor: Colors.white,
        //                     errorBorderColor: Colors.white,
        //                   ),
        //                   cursorColor: Colors.white,
        //                   keyboardType: TextInputType.number,
        //                   onChanged: (v) {
        //                     setState(() {
        //                       // currentText = v;
        //                     });
        //                   },
        //                 ),
        //               ),
        //               InkWell(
        //                 onTap: resendText == 'Resend OTP'
        //                     ? () {
        //                   resendOtp(Get.arguments[0], context)
        //                       .then((value) {
        //                     showToast(value.message);
        //                     return null;
        //                   });
        //                   startTimer();
        //                 }
        //                     : null,
        //                 child: Container(
        //                   padding: EdgeInsets.only(
        //                     top: AddSize.padding10 * .8,
        //                     bottom: AddSize.padding10 * .8,
        //                   ),
        //                   child: Text(resendText,
        //                       style: GoogleFonts.poppins(
        //                           fontSize: AddSize.font14,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w600)),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           addHeight(screenSize.width * .08),
        //           CommonButton(
        //             buttonHeight: 6,
        //             buttonWidth: 100,
        //             btnColor : Color(0xFF1C2550),
        //             // mainGradient: AppTheme.primaryGradientColor,
        //             text: 'SUBMIT',
        //             isDataLoading: true,
        //             textColor: Colors.white,
        //             onTap: () {
        //               // Get.toNamed(MyRouter.resetForgotPasswordScreen,
        //               //     arguments: [Get.arguments[0]]);
        //               if (_formKey.currentState!.validate()) {
        //                 verifySignUpOtp(
        //                         Get.arguments[0], otpController.text, context)
        //                     .then((value) {
        //                   showToast(value.message);
        //                   if (value.status!) {
        //                     Get.offAllNamed(MyRouter.logInScreen,
        //                         arguments: ['mainScreen']);
        //                   }
        //                 });
        //               }
        //             },
        //             // btnColor: Colors.white,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
