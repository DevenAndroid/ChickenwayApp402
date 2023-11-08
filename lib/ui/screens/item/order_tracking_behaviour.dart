import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/model_single_order.dart';

class TrackingOrderBhehviour extends StatefulWidget {
  const TrackingOrderBhehviour({Key? key}) : super(key: key);

  @override
  State<TrackingOrderBhehviour> createState() => _TrackingOrderBhehviourState();
}

class _TrackingOrderBhehviourState extends State<TrackingOrderBhehviour> {
  List<String> orderStatus = [
    "confirming-order",
    "preparing/processing",
    "driver-assigned",
    "completed",
  ];

  int indicatorStep = 0;

  SingleOrderModel model = SingleOrderModel();
  @override
  void initState() {
    super.initState();
    model = Get.arguments;
    for(var i = 0; i < orderStatus.length; i++){
      if(orderStatus[i].contains(model.data!.status.toString())){
        indicatorStep = i;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFBE00),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.red,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        'Order Tracking Behavior',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFFE02020),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFF40A815)),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: indicatorStep >= 1 ? const Color(0xFF40A815) : Colors.white),
                            child: Icon(
                              indicatorStep >= 1 ? Icons.check : Icons.password_rounded,
                              color: indicatorStep >= 1 ? Colors.white : Colors.black,
                              size: 20,
                            )),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        indicatorStep >= 2 ?
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFF40A815)),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ) :  Image.asset('assets/images/driver.png'),
                         Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                         Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                         Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                         Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                         Text(
                          '|',
                          style:
                              GoogleFonts.poppins(color: const Color(0xFFD5D5D5), fontSize: 7),
                        ),
                        indicatorStep == 3 ?
                        Container(
                          padding:  const EdgeInsets.all(7),
                          decoration:  const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFF40A815)),
                          child:  const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ) :  Image.asset('assets/images/Road.png'),
                      ],
                    ),
                     const SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding:  const EdgeInsets.all(7.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           const SizedBox(
                            height: 5,
                          ),
                          Text(
                            orderStatus[0].toString().replaceAll("-", " ").capitalize!,
                            style:  GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                           const SizedBox(
                            height: 10,
                          ),
                           Text(
                            'ICON LINK',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                           Text(
                            'https://lottiefiles.com/119869-searching',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                           const SizedBox(
                            height: 20,
                          ),
                          Text(
                            orderStatus[1].replaceAll("-", " ").capitalize!,
                            style:  GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                           const SizedBox(
                            height: 10,
                          ),
                           Text(
                            'ICON LINK',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                           Text(
                            'https://lottiefiles.com/119869-searching',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                           const SizedBox(
                            height: 20,
                          ),
                          Text(
                            orderStatus[2].replaceAll("-", " ").capitalize!,
                            style:  GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                           const SizedBox(
                            height: 10,
                          ),
                           Text(
                            'ICON LINK',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                           Text(
                            'https://lottiefiles.com/119869-searching',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                           const SizedBox(
                            height: 20,
                          ),
                          Text(
                            orderStatus[3].replaceAll("-", " ").capitalize!,
                            style:  GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                           const SizedBox(
                            height: 10,
                          ),
                           Text(
                            'ICON LINK',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                           Text(
                            'https://lottiefiles.com/119869-searching',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFE02020),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                 const SizedBox(
                  height: 50,
                ),
                 Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Steps done: https://lottiefiles.com/21052-checking',
                    style: GoogleFonts.poppins(
                        color: const Color(0xFFE02020),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
