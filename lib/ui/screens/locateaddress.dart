// import 'dart:async';
//
// import 'package:dinelah/routers/my_router.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// class DeliveryLocation extends StatefulWidget {
//   const DeliveryLocation({Key? key}) : super(key: key);
//
//   @override
//   State<DeliveryLocation> createState() => _DeliveryLocationState();
// }
//
// class _DeliveryLocationState extends State<DeliveryLocation> {
//   final Completer<GoogleMapController> _controller =
//   Completer<GoogleMapController>();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 10.4746,
//   );
//
//   static const CameraPosition _KParks = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         shadowColor: Colors.grey,
//         backgroundColor: Colors.white,
//         leading: SizedBox(
//           height: 10,
//           width: 10,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: InkWell(
//               child: Container(
//                   margin: EdgeInsets.zero,
//                   padding: EdgeInsets.zero,
//
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.grey)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.grey,
//                     ),
//                   )),
//             ),
//           ),
//         ),
//         centerTitle: true,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/cock.png',height: 23,),
//             const Text(
//               'DELIVERY LOCATION',
//               style: GoogleFonts.poppins(
//                   color: Color(0xFF292323),
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600),
//             ),
//             Image.asset('assets/images/cock.png',height: 23,),
//           ],
//         ),
//       ),
//       body: SafeArea(
//
//
//         child: Stack(
//             children:[ GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: _kGooglePlex,
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//             ),
//
//               Positioned(
//                 top: 20,
//                 child: Padding(
//
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//
//
//                     width: size.width*.95,
//                     padding: const EdgeInsets.all(0),
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         shape: BoxShape.rectangle,
//                         boxShadow: const [
//                           BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 1,
//                               offset: Offset(1, 1))
//                         ]),
//                     child: TextFormField(
//
//                       decoration: const InputDecoration(
//                           prefixIcon: Icon(Icons.search_rounded),
//                           border: InputBorder.none,
//                           hintText: 'Search Here..'
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 20,
//                 child: Padding(
//
//                   padding: const EdgeInsets.all(8.0),
//                   child: InkWell(
//                     onTap: (){
//                     // Get.toNamed(MyRouter.addaddressScreen);
//                     },
//                     child: Container(
//
//                         height: 50,
//                         width: size.width*.95,
//                         padding: const EdgeInsets.all(0),
//                         decoration: BoxDecoration(
//                             color: const Color(0xFFE02020),
//                             borderRadius: BorderRadius.circular(10),
//                             shape: BoxShape.rectangle,
//                             boxShadow: const [
//                               BoxShadow(
//                                   color: Colors.black26,
//                                   blurRadius: 1,
//                                   offset: Offset(1, 1))
//                             ]),
//                         child: const Center(child: Text('Confirm',style: GoogleFonts.poppins(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),))
//                     ),
//                   ),
//                 ),
//               )
//             ]),
//       ),);
//   }
//   showBottomDialog(BuildContext context) {
//     showGeneralDialog(
//         barrierLabel: "showGeneralDialog",
//         barrierDismissible: true,
//         barrierColor: Colors.transparent,
//         transitionDuration: const Duration(milliseconds: 400),
//         context: context,
//         pageBuilder: (context, _, __) {
//           return Align(
//               alignment: Alignment.bottomCenter,
//               child: IntrinsicHeight(
//                   child: Container(
//                       width: double.maxFinite,
//                       height: 400,
//                       clipBehavior: Clip.antiAlias,
//                       padding: const EdgeInsets.all(16),
//                       decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(30),
//                               topRight: Radius.circular(30)),
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.black38,
//                                 blurRadius: 2,
//                                 offset: Offset(2, 2)),
//                           ]),
//                       child: SingleChildScrollView(
//                           child: Material(
//                             color: Colors.white,
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SingleChildScrollView(
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         const SizedBox(
//                                           height: 8,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               padding: const EdgeInsets.all(6),
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(color: Colors.grey),
//                                                   shape: BoxShape.circle),
//                                               child: const Icon(
//                                                 Icons.location_on,
//                                                 color: Color(0xFFE02020),
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 15,
//                                             ),
//                                             const Padding(
//                                               padding: EdgeInsets.only(top: 8.0),
//                                               child: Text(
//                                                 'Delivery Address',
//                                                 style: GoogleFonts.poppins(
//                                                     color: Color(0xFF333333),
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.w600),
//                                               ),
//                                             ),
//
//                                           ],
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(left: 50),
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               const Text('Mokas home',
//                                                 style: GoogleFonts.poppins(
//                                                     color: Color(0xFF666666),
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w500),),
//                                               const Text(
//                                                 'Baabda, Haret Hureik, Moawad St. Mobile number: +9613785380',
//                                                 style: GoogleFonts.poppins(
//                                                     color: Color(0xFF666666),
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w500),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         const Divider(thickness: 0,color: Colors.grey,),
//                                         const Padding(
//                                           padding: EdgeInsets.only(left: 50),
//                                           child: Text('Order Tracking',
//                                             style: GoogleFonts.poppins(
//                                                 color: Color(0xFF333333),
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.w600),),
//                                         ),
//                                         const SizedBox(height: 20,),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 Container(
//                                                   padding: const EdgeInsets.all(8),
//                                                   decoration: const BoxDecoration(
//                                                       shape: BoxShape.circle,
//                                                       color: Color(0xFF40A815)
//                                                   ),
//                                                   child: const Icon(Icons.check,color: Colors.white,size: 20,),
//                                                 ),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 Container(
//                                                     padding: const EdgeInsets.all(8),
//                                                     decoration: const BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: Color(0xFF40A815)
//                                                     ),
//                                                     child: const Icon(Icons.check,color: Colors.white,size: 20,)),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 Container(
//                                                     padding: const EdgeInsets.all(8),
//                                                     decoration: const BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: Color(0xFF40A815)
//                                                     ),
//                                                     child: const Icon(Icons.person,color: Colors.white,size: 20,)),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 const Text('|',style: GoogleFonts.poppins(color: Color(0xFFD5D5D5),fontSize: 10),),
//                                                 Container(
//                                                     padding: const EdgeInsets.all(8),
//                                                     decoration: const BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: Color(0xFF40A815)
//                                                     ),
//                                                     child: const Icon(Icons.delivery_dining_sharp,color: Colors.white,size: 20,)),
//
//                                               ],
//                                             ),
//                                             const SizedBox(width: 5,),
//                                             Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Column(
//                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   const Text('Confirming your order',style: GoogleFonts.poppins(color: Color(0xFF2C2B30),fontSize: 14,fontWeight: FontWeight.w600),),
//                                                   const SizedBox(height: 5,),
//                                                   const Text('Cancel order',style: GoogleFonts.poppins(color: Color(0xFF7E7E7E),fontSize: 12,fontWeight: FontWeight.w500),),
//                                                   const SizedBox(height: 55,),
//                                                   const Text(
//
//                                                     'Preparing your food',style: GoogleFonts.poppins(color: Color(0xFF2C2B30),fontSize: 14,fontWeight: FontWeight.w600),),
//                                                   const SizedBox(height: 5,),
//                                                   const Text('Be Patient, we are confirming your order',style: GoogleFonts.poppins(color: Color(0xFF7E7E7E),fontSize: 12,fontWeight: FontWeight.w500),),
//                                                   const SizedBox(height: 55,),
//                                                   const Text(
//
//                                                     'Assigning Driver',style: GoogleFonts.poppins(color: Color(0xFF2C2B30),fontSize: 14,fontWeight: FontWeight.w600),),
//                                                   const SizedBox(height: 5,),
//                                                   const Text('The Driver’s name will serve \nyour food to your door',style: GoogleFonts.poppins(color: Color(0xFF7E7E7E),fontSize: 12,fontWeight: FontWeight.w500),),
//                                                   const SizedBox(height: 55,),
//                                                   const Text(
//
//                                                     'Delivering your food',style: GoogleFonts.poppins(color: Color(0xFF2C2B30),fontSize: 14,fontWeight: FontWeight.w600),),
//                                                   const SizedBox(height: 5,),
//                                                   const Text('Be patient we are delivering your food',style: GoogleFonts.poppins(color: Color(0xFF7E7E7E),fontSize: 12,fontWeight: FontWeight.w500),),
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),)))));});
//
//
//     Future<void> _goToTheParks() async {
//       final GoogleMapController controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newCameraPosition(_KParks));
//     }
//   }}
