
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/app_bar.dart';
class LocationDelivery extends StatefulWidget {
   const LocationDelivery({Key? key}) : super(key: key);

  @override
  State<LocationDelivery> createState() => _LocationDeliveryState();
}

class _LocationDeliveryState extends State<LocationDelivery> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  const Color(0xffF5F5F5),
        appBar: commonAppBar(
            title: "DELIVERY LOCATION", showCart: false, backGround: Colors.white),
      body: SingleChildScrollView(
        child: SafeArea(


          child: Column(
            children: [
const SizedBox(height: 180,),

              Padding(

                      padding:  const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: (){

                          },
                          child: Container(



                              padding:  const EdgeInsets.all(16),
                              decoration:  const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 1,
                                        offset: Offset(1, 1)),
                                  ]),
                              child: SingleChildScrollView(
                                  child: Material(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                             const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:  const EdgeInsets.all(7),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: const Color(0xffEAEAEA)),
                                                      shape: BoxShape.circle),
                                                  child:  const Icon(
                                                    Icons.location_on,
                                                    color: Color(0xFFE02020),
                                                  ),
                                                ),
                                                 const SizedBox(
                                                  width: 15,
                                                ),

                                                 Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    'Delivery Address',
                                                    style: GoogleFonts.poppins(
                                                        color: const Color(0xFF333333),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ),

                                              ],
                                            ),
                                            Padding(
                                              padding:  const EdgeInsets.only(left: 55),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                   Text("MOKA'S Home",
                                                    style: GoogleFonts.poppins(
                                                        color: const Color(0xFF333333),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500),),
                                                   const SizedBox(height: 2,),
                                                   Padding(
                                                     padding: const EdgeInsets.only(right: 10),
                                                     child: Text(
                                                      'Baabda, Haret Hureik, Moawad St. Mobile number: +9613785380',
                                                      style: GoogleFonts.poppins(
                                                          color: const Color(0xFF666666),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500),
                                                  ),
                                                   ),
                                                  const SizedBox(height: 12,),
                                                ],
                                              ),
                                            ),
                                              Divider(thickness: 0,color: const Color(0xff7E7E7E).withOpacity(.3),),
                                            const SizedBox(height: 20,),
                                             Padding(
                                              padding: const EdgeInsets.only(left: 50),
                                              child: Text('Order Tracking',
                                                style: GoogleFonts.poppins(
                                                    color: const Color(0xFF333333),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600),),
                                            ),
                                             const SizedBox(height: 30,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      padding:  const EdgeInsets.all(8),
                                                      decoration:  const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Color(0xFF40A815)
                                                      ),
                                                      child:  const Icon(Icons.check,color: Colors.white,size: 20,),
                                                    ),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                    Container(
                                                        padding:  const EdgeInsets.all(8),
                                                        decoration:  const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Color(0xFF40A815)
                                                        ),
                                                        child:  const Icon(Icons.check,color: Colors.white,size: 20,)),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                    Container(
                                                        padding:  const EdgeInsets.all(8),
                                                        decoration:  const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Color(0xFF40A815)
                                                        ),
                                                        child:  const Icon(Icons.person,color: Colors.white,size: 20,)),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                     Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                    Container(
                                                        padding:  const EdgeInsets.all(8),
                                                        decoration:  const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Color(0xFF40A815)
                                                        ),
                                                        child:  const Icon(Icons.delivery_dining_sharp,color: Colors.white,size: 20,)),

                                                  ],
                                                ),
                                                 const SizedBox(width: 5,),
                                                Expanded(
                                                  child: Padding(
                                                    padding:  const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                         Text('Confirming your order',style: GoogleFonts.poppins(color: const Color(0xFF2C2B30),fontSize: 15,fontWeight: FontWeight.w600),),
                                                         const SizedBox(height: 8,),
                                                         Text('Cancel order',style: GoogleFonts.poppins(color: const Color(0xFF7E7E7E),fontSize: 13.5,fontWeight: FontWeight.w500),),
                                                         const SizedBox(height: 55,),
                                                         Text(

                                                          'Preparing your food',style: GoogleFonts.poppins(color: const Color(0xFF2C2B30),fontSize: 15,fontWeight: FontWeight.w600),),
                                                         const SizedBox(height: 8,),
                                                         Text('Be Patient, we are confirming your order',style: GoogleFonts.poppins(color: const Color(0xFF7E7E7E),fontSize: 13.5,fontWeight: FontWeight.w500),),
                                                         const SizedBox(height: 58,),
                                                         Text(

                                                          'Assigning Driver',style: GoogleFonts.poppins(color: const Color(0xFF2C2B30),fontSize: 15,fontWeight: FontWeight.w600),),
                                                         const SizedBox(height: 8,),
                                                         Text('The Driver’s name will serve your food to your doortrutuu6rur6tu',style: GoogleFonts.poppins(color: const Color(0xFF7E7E7E),fontSize: 13.5,fontWeight: FontWeight.w500),),
                                                         const SizedBox(height: 43,),
                                                         Text(

                                                          'Delivering your food',style: GoogleFonts.poppins(color: const Color(0xFF2C2B30),fontSize: 15,fontWeight: FontWeight.w600),),
                                                         const SizedBox(height: 8,),
                                                         Text('Be patient we are delivering your food',style: GoogleFonts.poppins(color: const Color(0xFF7E7E7E),fontSize: 13.5,fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),)))))

            ],
          ),
                ),
      )
            );

  }
  showBottomDialog(BuildContext context) {
    showGeneralDialog(
        barrierLabel: "showGeneralDialog",
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration:  const Duration(milliseconds: 400),
        context: context,
        pageBuilder: (context, _, __) {
          return Align(
              alignment: Alignment.bottomCenter,
              child: IntrinsicHeight(
                  child: Container(
                      width: double.maxFinite,
                      height: 400,
                      clipBehavior: Clip.antiAlias,
                      padding:  const EdgeInsets.all(16),
                      decoration:  const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 2,
                                offset: Offset(2, 2)),
                          ]),
                      child: SingleChildScrollView(
                          child: Material(
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:  const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  shape: BoxShape.circle),
                                              child:  const Icon(
                                                Icons.location_on,
                                                color: Color(0xFFE02020),
                                              ),
                                            ),
                                             const SizedBox(
                                              width: 15,
                                            ),
                                             Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                'Delivery Address',
                                                style: GoogleFonts.poppins(
                                                    color: const Color(0xFF333333),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),

                                          ],
                                        ),
                                        Padding(
                                          padding:  const EdgeInsets.only(left: 50),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                               Text('Mokas home',
                                                style: GoogleFonts.poppins(
                                                    color: const Color(0xFF666666),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500),),
                                               Text(
                                                'Baabda, Haret Hureik, Moawad St. Mobile number: +9613785380',
                                                style: GoogleFonts.poppins(
                                                    color: const Color(0xFF666666),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                         const Divider(thickness: 0,color: Colors.grey,),
                                         Padding(
                                          padding: const EdgeInsets.only(left: 50),
                                          child: Text('Order Tracking',
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFF333333),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),),
                                        ),
                                         const SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  padding:  const EdgeInsets.all(8),
                                                  decoration:  const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFF40A815)
                                                  ),
                                                  child:  const Icon(Icons.check,color: Colors.white,size: 20,),
                                                ),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                Container(
                                                    padding:  const EdgeInsets.all(8),
                                                    decoration:  const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xFF40A815)
                                                    ),
                                                    child:  const Icon(Icons.check,color: Colors.white,size: 20,)),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                Container(
                                                    padding:  const EdgeInsets.all(8),
                                                    decoration:  const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xFF40A815)
                                                    ),
                                                    child:  const Icon(Icons.person,color: Colors.white,size: 20,)),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                 Text('|',style: GoogleFonts.poppins(color: const Color(0xFFD5D5D5),fontSize: 10),),
                                                Container(
                                                    padding:  const EdgeInsets.all(8),
                                                    decoration:  const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xFF40A815)
                                                    ),
                                                    child:  const Icon(Icons.delivery_dining_sharp,color: Colors.white,size: 20,)),

                                              ],
                                            ),
                                             const SizedBox(width: 5,),
                                            Padding(
                                              padding:  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                   Text('Confirming your order',style: GoogleFonts.poppins(color: const Color(0xFF2C2B30),fontSize: 14,fontWeight: FontWeight.w600),),
                                                   const SizedBox(height: 5,),
                                                   Text('Cancel order',style: GoogleFonts.poppins(color: const Color(0xFF7E7E7E),fontSize: 12,fontWeight: FontWeight.w500),),
                                                   const SizedBox(height: 55,),
                                                   Text(

                                                    'Preparing your food',style: GoogleFonts.poppins(color: const Color(0xFF2C2B30),fontSize: 14,fontWeight: FontWeight.w600),),
                                                   const SizedBox(height: 5,),
                                                   Text('Be Patient, we are confirming your order',style: GoogleFonts.poppins(color: const Color(0xFF7E7E7E),fontSize: 12,fontWeight: FontWeight.w500),),
                                                   const SizedBox(height: 55,),
                                                   Text(

                                                    'Assigning Driver',style: GoogleFonts.poppins(color: const Color(0xFF2C2B30),fontSize: 14,fontWeight: FontWeight.w600),),
                                                   const SizedBox(height: 5,),
                                                   Text('The Driver’s name will serve \nyour food to your door',style: GoogleFonts.poppins(color: const Color(0xFF7E7E7E),fontSize: 12,fontWeight: FontWeight.w500),),
                                                   const SizedBox(height: 55,),
                                                   Text(

                                                    'Delivering your food',style: GoogleFonts.poppins(color: const Color(0xFF2C2B30),fontSize: 14,fontWeight: FontWeight.w600),),
                                                   const SizedBox(height: 5,),
                                                   Text('Be patient we are delivering your food',style: GoogleFonts.poppins(color: const Color(0xFF7E7E7E),fontSize: 12,fontWeight: FontWeight.w500),),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),)))));});


  }
}
