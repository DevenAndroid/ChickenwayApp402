import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class CommonErrorWidget extends StatelessWidget {
  final String errorText;
  final VoidCallback onTap;
  const CommonErrorWidget({Key? key, required this.errorText, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorText,
          ),
          const SizedBox(
            height: 20,
          ),

          InkWell(
            onTap: (){
              onTap;
            },
            child: Container(
              width: 50,
              height: 40,
              color: Colors.white,
              child:
              Text('Refresh',style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
            ),
          )


        ],
      ),
    );
  }
}
