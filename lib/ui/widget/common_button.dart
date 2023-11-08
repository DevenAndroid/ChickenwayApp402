import 'package:dinelah/res/size_config.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonButton extends StatelessWidget {
  final double buttonWidth;
  final Gradient? mainGradient;
  final Color btnColor;
  final Color textColor;
  final String text;
  final bool isDataLoading;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;
  final double buttonHeight;

    const CommonButton(
      {Key? key, required this.buttonHeight,
      required this.buttonWidth,
      this.btnColor = AppTheme.primaryColor,
      this.textColor = Colors.white,
      this.isDataLoading = true,
      this.margin,
      required this.text,
      required this.onTap,
      this.mainGradient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: margin,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: btnColor,
          // gradient: mainGradient,
          // boxShadow: const [
          //   BoxShadow(
          //     color: AppTheme.etBgColor,
          //     offset: Offset(0.0, 1.5),
          //     blurRadius: 1.5,
          //   ),
          //]
      ),
      child: MaterialButton(
        onPressed: onTap,
         color: btnColor,
        elevation: 0,
        minWidth: SizeConfig.widthMultiplier! * buttonWidth,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // height: SizeConfig.heightMultiplier! * buttonHeight,
        child:  Text(
          text,
          style:  GoogleFonts.poppins(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: .2),
        ),
      ),
    );
  }
}
