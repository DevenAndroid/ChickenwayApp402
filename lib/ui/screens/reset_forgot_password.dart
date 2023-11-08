
import 'package:dinelah/res/app_assets.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/helper.dart';
import '../widget/common_button.dart';

class ResetForgotPassword extends StatefulWidget {
  const ResetForgotPassword({Key? key}) : super(key: key);

  @override
  State<ResetForgotPassword> createState() => _ResetForgotPasswordState();
}

class _ResetForgotPasswordState extends State<ResetForgotPassword> {
  var email= "";

  @override
  void initState() {
    super.initState();
    if(mounted) {
      setState(() {
        email = Get.arguments[0].toString();
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController newPassword = TextEditingController();
  bool obscure1 = true;
  bool obscure2 = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(AppAssets.forgotBg),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      color: const Color(0xFFC33D18),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: AddSize.size45,
          leading: InkWell(
            child: Container(
                padding: EdgeInsets.only(left: AddSize.padding15),
                alignment: Alignment.centerLeft,
                // child: Icon(Icons.arrow_back)
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(AppAssets.backIcon),
              ),
            ),
            onTap:() {
              Get.back();
            },
          ),
          title: Text(
            'Create new password',
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AddSize.padding16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  addHeight(screenSize.height * .05),
                  Center(
                      child: Image.asset(
                    AppAssets.forgotLogo,
                    height: 180,
                    width: 180,
                  )),
                   Text(
                    'Change your password',
                    style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                  addHeight(15),
                   Text(
                    'Your new password must be diffrent \n from previously Used Password',
                    style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: AddSize.padding10 * 1.8,
                        top: AddSize.padding15),
                    child: TextFormField(
                      controller: newPassword,
                      style: GoogleFonts.poppins(color: AppTheme.textColorGray),
                      // validator: MultiValidator([
                      //   RequiredValidator(
                      //     errorText: 'Password required',
                      //   ),
                      //   MinLengthValidator(6,
                      //       errorText:
                      //           'Password must contain minimum 6 characters'),
                      // ]),

                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter your password'),
                        MinLengthValidator(8,
                            errorText: 'Password must be at least 8 characters,with 1 special character & 1 numerical'),
                        PatternValidator(
                            r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                            errorText: "Password must be at least with 1 special character & 1 numerical"),
                      ]),
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        fillColor: AppTheme.colorWhite,
                        focusColor: AppTheme.primaryColor,
                        filled: true,
                        errorStyle: GoogleFonts.poppins(color: Colors.white),
                        hintText: 'New Password',
                        contentPadding: EdgeInsets.only(
                            left: AddSize.padding10 * 2,
                            top: AddSize.padding10 * 2,
                            bottom: AddSize.padding10 * 2),
                        hintStyle: GoogleFonts.poppins(
                            color: AppTheme.textColorGray, fontSize: AddSize.font14),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white54),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColorVariant),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppTheme.primaryColor, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0)),
                        suffixIcon: InkWell(
                          onTap: () {
    if(mounted) {
      setState(() {
        obscure1 = !obscure1;
      });
    }
                          },
                          child: obscure1
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  size: AddSize.size10 * 1.8,
                                  color: AppTheme.textColorGray,
                                )
                              : Icon(
                                  Icons.visibility_outlined,
                                  size: AddSize.size10 * 1.8,
                                  color: AppTheme.textColorGray,
                                ),
                        ),
                      ),
                      obscureText: obscure1,
                    ),
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Confirm password required';
                      }
                      return MatchValidator(
                              errorText: 'Password does not matching')
                          .validateMatch(val, newPassword.text);
                    },
                    style: GoogleFonts.poppins(
                      color: AppTheme.textColorGray,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.colorWhite,
                      focusColor: AppTheme.primaryColor,
                      hintText: 'Confirm Password',
                      errorStyle: GoogleFonts.poppins(color: Colors.white),
                      contentPadding: EdgeInsets.only(
                          left: AddSize.padding10 * 2,
                          top: AddSize.padding10 * 2,
                          bottom: AddSize.padding10 * 2),
                      hintStyle: GoogleFonts.poppins(
                          color: AppTheme.textColorGray, fontSize: AddSize.font14),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white54),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppTheme.primaryColorVariant),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppTheme.primaryColor, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0)),
                      suffixIcon: InkWell(
                        onTap: () {
    if(mounted) {
      setState(() {
        obscure2 = !obscure2;
      });
    }
                        },
                        child: obscure2
                            ? Icon(
                                Icons.visibility_off_outlined,
                                size: AddSize.size10 * 1.8,
                                color: AppTheme.textColorGray,
                              )
                            : Icon(
                                Icons.visibility_outlined,
                                size: AddSize.size10 * 1.8,
                                color:AppTheme.textColorGray,
                              ),
                      ),
                    ),
                    obscureText: obscure2,
                  ),
                  addHeight(screenSize.width * .08),
                  CommonButton(
                    buttonHeight: 6,
                    buttonWidth: 100,
                    mainGradient: AppTheme.primaryGradientColor,
                    text: 'SAVE',
                    isDataLoading: true,
                    textColor: AppTheme.colorWhite,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // updatePassword(email, newPassword.text,
                        //         newPassword.text, context)
                        //     .then((value) {
                        //   showToast(value.message);
                        //   if (value.status) {
                        //     Get.offAllNamed(MyRouter.logInScreen, arguments: ['mainScreen']);
                        //   }
                        //   return null;
                        // });
                      }
                    },
                    btnColor: AppTheme.newButton,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
