// import 'dart:async';
// import 'package:dinelah/res/app_assets.dart';
// import 'package:dinelah/res/theme/theme.dart';
// import 'package:dinelah/ui/widget/common_widget.dart';
// import 'package:dinelah/utils/dimensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import '../widget/common_button.dart';
//
// class VerifyOTPForgotPassword extends StatefulWidget {
//   const VerifyOTPForgotPassword({Key? key}) : super(key: key);
//
//   @override
//   State<VerifyOTPForgotPassword> createState() =>
//       _VerifyOTPForgotPasswordState();
// }
//
// class _VerifyOTPForgotPasswordState extends State<VerifyOTPForgotPassword> {
//   final _formKey = GlobalKey<FormState>();
//   final otpController = TextEditingController();
//
//   late Timer _timer;
//   var resendText = 'Resend OTP';
//
//   void startTimer() {
//     int start = 30;
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (start == 0) {
//           if(mounted) {
//             setState(() {
//               resendText = 'Resend OTP';
//               timer.cancel();
//             });
//           }
//         } else {
//           if(mounted) {
//             setState(() {
//               resendText = 'Resend OTP $start';
//               start--;
//             });
//           }
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Container(
//       // decoration: const BoxDecoration(
//       //   image: DecorationImage(
//       //     image: AssetImage(AppAssets.forgotBg),
//       //     fit: BoxFit.cover,
//       //   ),
//       // ),
//      color: const Color(0xFFC33D18),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: AddSize.padding10 * 3),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   addHeight(screenSize.height * .05),
//                   Row(
//                     children: [
//                       // addWidth(4),
//                       InkWell(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: Container(
//                           alignment: Alignment.centerLeft,
//                           width: 30,
//                             height: 30,
//                           child: Image.asset(AppAssets.backIcon),
//                         ),
//                         // child: const Icon(
//                         //   Icons.arrow_back_sharp,
//                         //   color: Colors.white54,
//                         //   size: 26,
//                         // ),
//                       ),
//                       addWidth(12),
//                       Text(
//                         'Verify your mail',
//                         style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                   addHeight(screenSize.height * .08),
//                   Center(
//                       child: Image.asset(
//                     AppAssets.forgotLogo,
//                     height: 180,
//                     width: 180,
//                   )),
//                   Container(
//                     padding: EdgeInsets.only(
//                         top: AddSize.padding10 * 2.5,
//                         bottom: AddSize.padding10 * .5),
//                     child: Text(
//                       'You will get OTP via Email',
//                       style: GoogleFonts.poppins(
//                           color: Colors.white, fontSize: AddSize.font16),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   addHeight(screenSize.height * .02),
//                   Center(
//                     child: Text(
//                       'Forgot Password OTP has been sent on ${Get.arguments == null ? '' : Get.arguments[0].toString()}',
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(
//                           top: AddSize.padding10 * 3.5,
//                           bottom: AddSize.padding12,
//                         ),
//                         child: Text('Enter your OTP Code',
//                             style: GoogleFonts.poppins(
//                                 fontSize: AddSize.font14,
//                                 color: Colors.white54,
//                                 fontWeight: FontWeight.w600)),
//                       ),
//
//                       Theme(
//                         data: ThemeData(
//                           colorScheme: ColorScheme(error: Colors.white),
//                      ),
//                         child: PinCodeTextField(
//                           appContext: context,
//                           errorTextMargin: const EdgeInsets.only(top: 45),
//                           textStyle: GoogleFonts.poppins(color: Colors.white),
//                           controller: otpController,
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                           ],
//
//                           pastedTextStyle: GoogleFonts.poppins(
//                             color: Colors.green.shade600,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           animationType: AnimationType.fade,
//                           validator: (v) {
//                             if (v!.isEmpty) {
//                               return "OTP code Required";
//                             } else if (v.length != 6) {
//                               return "Enter complete OTP code";
//                             }
//                             return null;
//                           },
//                           length: 6,
//                           pinTheme: PinTheme(
//                             shape: PinCodeFieldShape.box,
//                             borderRadius: BorderRadius.circular(5),
//                             fieldWidth: 40,
//                             fieldHeight: 40,
//                             activeColor: Colors.white,
//                             inactiveColor: Colors.white,
//                             inactiveFillColor: Colors.amber,
//                             errorBorderColor: Colors.limeAccent,
//                           ),
//                           cursorColor: Colors.white,
//                           keyboardType: TextInputType.number,
//                           onChanged: (v) {
//     if(mounted) {
//       setState(() {
//         // currentText = v;
//       });
//     }
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 10,),
//                       InkWell(
//                         onTap: resendText == 'Resend OTP'
//                             ? () {
//                                 // resendOtp(Get.arguments[0], context)
//                                 //     .then((value) {
//                                 //   showToast(value.message);
//                                 //   return null;
//                                 // });
//                                 startTimer();
//                               }
//                             : null,
//                         child: Container(
//                           padding: EdgeInsets.only(
//                             top: AddSize.padding10 * .8,
//                             bottom: AddSize.padding10 * .8,
//                           ),
//                           child: Text(resendText,
//                               style: GoogleFonts.poppins(
//                                   fontSize: AddSize.font14,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600)),
//                         ),
//                       ),
//                     ],
//                   ),
//                   addHeight(screenSize.width * .08),
//                   CommonButton(
//                     buttonHeight: 6,
//                     buttonWidth: 100,
//                     mainGradient: AppTheme.primaryGradientColor,
//                     text: 'VERIFY',
//                     isDataLoading: true,
//                     textColor: AppTheme.colorWhite,
//                     onTap: () {
//                       // Get.toNamed(MyRouter.resetForgotPasswordScreen,
//                       //     arguments: [Get.arguments[0]]);
//                       if (_formKey.currentState!.validate()) {
//                         // verifyOTPPassword(
//                         //         Get.arguments[0], otpController.text, context)
//                         //     .then((value) {
//                         //   showToast(value.message);
//                         //   if (value.status!) {
//                         //     Get.toNamed(MyRouter.resetForgotPasswordScreen,
//                         //         arguments: [Get.arguments[0]]);
//                         //   }
//                         // });
//                       }
//                     },
//                     btnColor: const Color(0xFF1C2550),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
