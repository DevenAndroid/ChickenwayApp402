import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/chicken/model_home.dart';
import '../../res/theme/theme.dart';

class TimerWidgetScreen extends StatefulWidget {
  const TimerWidgetScreen({Key? key, required this.time, required this.adsUrl, required this.timeBannerAd}) : super(key: key);
  final String time;
  final String adsUrl;
  final TimeBannerAd timeBannerAd;
  @override
  State<TimerWidgetScreen> createState() => _TimerWidgetScreenState();
}

class _TimerWidgetScreenState extends State<TimerWidgetScreen> {

  late Timer timer;
  DateTime? futureDate;

  updateTimer(){
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    try {
      futureDate = DateTime.parse(widget.time);
    } catch(e){}
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      updateTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    Duration? kk;
    String time = "";
    if(futureDate != null){
    kk = DateTime.now().difference(futureDate!);
    if(futureDate!.isBefore(DateTime.now())){
      time = "Expired";
      //time = '${kk.abs().toString().split('.').first.padLeft(8, "0")}';
    } else{
      time = '${kk.abs().toString().split('.').first.padLeft(8, "0")}';
    }
    print(kk);
    }
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 10).copyWith(top: 0,bottom: 0),
      margin: const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF37C666).withOpacity(0.15),
            offset: const Offset(.1, .1,
            ),
            blurRadius: 20.0,
            spreadRadius: 1.0,
          ),
        ],
        // image: DecorationImage(
        //     image: NetworkImage(
        //     widget.adsUrl),
        //     fit: BoxFit.contain),
      ),
      //height: 100,
       // width:  120,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(

                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10),topLeft: Radius.circular(10)),
                    child: SizedBox(
                        width: 180,
// height: 130,
                        child: Image.network(widget.adsUrl))),
                // CachedNetworkImage(imageUrl: widget.adsUrl,),
                Positioned(
                  top: 18,
                    left: 40,
                    child: Column(

                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 5),
                    //   child: Text(
                    //     "hrs: min : sec",
                    //     style: GoogleFonts.poppins(
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 14,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 15,
                    ),

                    time != "" ?
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(125)),
                      padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child:
                      // Obx(() {
                      //   return
                      Text(
                        // difference.toString(),
                        time,
                        // time.value,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      // }),
                    ) : const SizedBox(),
                  ],
                ) )
              ],
            ),


        SizedBox(width: 25,),
        Expanded(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.timeBannerAd.adsTitle.toString().toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    // "Hey you got htis fofeer ti this price",
                    widget.timeBannerAd.adsSubtitle.toString().capitalizeFirst.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: const Color(0xff656565),
                    ),
                  ),
                ),
                // Text(
                //   reverseDate.toString(),
                //   style: GoogleFonts.poppins(
                //     fontWeight: FontWeight.w400,
                //     fontSize: 13,
                //     color: const Color(0xff656565),
                //   ),
                // )
              ]),
        )
      ]),
    );
  }
}
