// import 'dart:async';
//
// import 'package:dinelah/routers/my_router.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// class DeliveryLocationn extends StatefulWidget {
//   const DeliveryLocationn({Key? key}) : super(key: key);
//
//   @override
//   State<DeliveryLocationn> createState() => _DeliveryLocationnState();
// }
//
// class _DeliveryLocationnState extends State<DeliveryLocationn> {
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
//                       // Get.toNamed(MyRouter.addaddressScreen);
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
// }
