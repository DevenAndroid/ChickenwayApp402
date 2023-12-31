import 'package:dinelah/res/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonButtonWhite extends StatelessWidget {
  final double buttonWidth;
  final Gradient? mainGradient;
  final Color btnColor;
  final Color textColor;
  final String text;
  final bool isDataLoading;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;
  final double buttonHeight;

  const CommonButtonWhite(
      {Key? key, required this.buttonHeight,
      required this.buttonWidth,
      this.btnColor = Colors.white,
      this.textColor = Colors.black87,
      this.isDataLoading = false,
      this.margin,
      required this.text,
      required this.onTap,
       this.mainGradient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffE02020)),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: MaterialButton(
        onPressed: onTap,
        color: btnColor,
        elevation: 0,
        minWidth: SizeConfig.widthMultiplier! * buttonWidth,
        // : SpinKitRing(
        //     color: textColor,
        //     lineWidth: 3,
        //     size: 26,
        //   ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // height: SizeConfig.heightMultiplier! * buttonHeight,
        child:
            // !isDataLoading ?
        Text(
          'Add items',
          style: GoogleFonts.poppins(
              color: const Color(0xffE02020), fontWeight: FontWeight.w600, fontSize: 16),
        ),

      ),
    );
  }
}
