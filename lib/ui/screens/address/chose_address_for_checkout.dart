// import 'dart:async';
// import 'dart:developer';
// import 'dart:ui' as ui;
// import 'package:dinelah/helper/new_helper.dart';
// import 'package:dinelah/ui/widget/app_bar.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../../controller/new_controllers/cart_controller.dart';
// import '../../../models/new_models/model_my_addresses.dart';
// import '../../../res/theme/theme.dart';
// import '../../../utils/dimensions.dart';
// import 'package:geolocator/geolocator.dart';
//
// class ChoseAddressForCheckout extends StatefulWidget {
//   const ChoseAddressForCheckout({Key? key}) : super(key: key);
//   static var route = "/ChoseAddressForCheckout";
//
//   @override
//   State<ChoseAddressForCheckout> createState() =>
//       _ChoseAddressForCheckoutState();
// }
//
// class _ChoseAddressForCheckoutState extends State<ChoseAddressForCheckout> {
//   final Completer<GoogleMapController> googleMapController = Completer();
//
//   final cartController = Get.put(CartController());
//   GoogleMapController? mapController;
//   String? _address = "";
//
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled().then((value) {
//       if (!value) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text(
//                 'Location services are disabled. Please enable the services')));
//       }
//       return value;
//     });
//     if (!serviceEnabled) {
//       return false;
//     }
//     permission = await Geolocator.checkPermission().then((value) {
//       if (value == LocationPermission.deniedForever) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text(
//                 'Location permissions are permanently denied, we cannot request permissions.')));
//       }
//       return value;
//     });
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission().then((value) {
//         if (value == LocationPermission.denied) {
//           ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Location permissions are denied')));
//         }
//         return value;
//       });
//       if (permission == LocationPermission.denied) {
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return false;
//     }
//     return true;
//   }
//
//   Future<void> _getCurrentPosition() async {
//     await Permission.locationWhenInUse.request();
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return;
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//         .then((Position position) async {
//       await _getAddressFromLatLng(
//           LatLng(position.latitude, position.longitude).checkLatLong);
//       mapController!.animateCamera(CameraUpdate.newCameraPosition(
//           CameraPosition(
//               target:
//                   LatLng(position.latitude, position.longitude).checkLatLong,
//               zoom: 15)));
//       _onAddMarkerButtonPressed(
//           LatLng(position.latitude, position.longitude).checkLatLong, _address!,
//           allowAnimation: true);
//       setState(() {});
//     }).catchError((e) {
//       debugPrint(e);
//     });
//   }
//
//   Placemark place = Placemark();
//
//   Future<String> _getAddressFromLatLng(LatLng latLong) async {
//     await placemarkFromCoordinates(latLong.latitude, latLong.longitude)
//         .then((List<Placemark> placemarks) {
//       place = placemarks[0];
//       if (mounted) {
//         setState(() {
//           _address =
//               '${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
//         });
//       }
//     }).catchError((e) {
//       debugPrint(e.toString());
//       _address = "";
//     });
//     if (kDebugMode) {}
//     return _address!;
//   }
//
//   final TextEditingController otherController = TextEditingController();
//
//   String googleApikey = "AIzaSyC5tFkn_TyR_8n-CiMiA047gfq4tJ8jBO8";
//   GoogleMapController? mapController1;
//   CameraPosition? cameraPosition;
//   String location = "Search Location";
//   final Set<Marker> markers = {};
//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }
//
//   Future<void> _onAddMarkerButtonPressed(LatLng lastMapPosition, markerTitle,
//       {allowZoomIn = true, allowAnimation = true}) async {
//     markers.clear();
//     markers.add(Marker(
//         markerId: MarkerId(lastMapPosition.toString()),
//         position: lastMapPosition,
//         infoWindow: InfoWindow(
//           title: markerTitle,
//         ),
//         draggable: true,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
//     if (allowAnimation) {
//       mapController!.animateCamera(CameraUpdate.newCameraPosition(
//           CameraPosition(
//               target: lastMapPosition, zoom: allowZoomIn ? 14 : 11)));
//       if (kDebugMode) {
//         print("sdakjsbdsajkdhajsdhakjsdhakshdaksjdhakdhakdhs");
//       }
//     }
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   Future<void> _updatePosition(CameraPosition position,
//       {allowFetch = true}) async {
//     if (allowFetch) {
//       _onAddMarkerButtonPressed(
//         position.target,
//         await _getAddressFromLatLng(position.target.checkLatLong),
//         allowAnimation: false,
//       );
//     } else {
//       _onAddMarkerButtonPressed(
//         position.target,
//         "Marker Location",
//         allowAnimation: false,
//       );
//     }
//   }
//
//   Timer? _debounce;
//
//   onSearchChanged() {
//     if (_debounce?.isActive ?? false) {
//       _debounce!.cancel();
//       _debounce = null;
//     }
//     _debounce = Timer(const Duration(seconds: 3), () {
//       if(_debounce != null) {
//         _debounce!.cancel();
//         _debounce = null;
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (Get.arguments == null) {
//       _getCurrentPosition();
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     if (_debounce != null) {
//       _debounce!.cancel();
//       _debounce = null;
//     }
//     if (mapController != null) {
//       mapController!.dispose();
//     }
//   }
//
//   bool loaded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         mapController!.dispose();
//         return true;
//       },
//       child: Scaffold(
//           appBar: commonAppBar(
//               title: "Choose Address", backGround: Colors.white, elevation: 1),
//           body: Stack(
//             children: [
//               GoogleMap(
//                 zoomGesturesEnabled: true,
//                 initialCameraPosition: CameraPosition(
//                   target: const LatLng(0, 0).checkLatLong,
//                   zoom: 14.0,
//                 ),
//                 mapType: MapType.normal,
//                 onMapCreated: (controller) async {
//                   mapController = controller;
//                   if (loaded == false) {
//                     loaded = true;
//                     LatLng ll = LatLng(
//                             double.tryParse(cartController
//                                     .deliveryAddress.value.lat
//                                     .toString()) ??
//                                 0,
//                             double.tryParse(cartController
//                                     .deliveryAddress.value.longitute
//                                     .toString()) ??
//                                 0)
//                         .checkLatLong;
//                     _onAddMarkerButtonPressed(ll, "Selected Location");
//                   }
//                 },
//                 markers: markers,
//                 onCameraMove: (CameraPosition cameraPositions) {
//                   cameraPosition = cameraPositions;
//                   _updatePosition(cameraPositions, allowFetch: false);
//                 },
//                 onCameraIdle: () async {
//                   if (mapController != null && cameraPosition != null) {
//                     _updatePosition(cameraPosition!);
//                   }
//                 },
//               ),
//               Positioned(
//                   top: 10,
//                   child: InkWell(
//                       onTap: () async {
//                         var place = await PlacesAutocomplete.show(
//                             context: context,
//                             apiKey: googleApikey,
//                             mode: Mode.overlay,
//                             types: [],
//                             strictbounds: false,
//                             // components: [
//                             //   Component(Component.country, 'np')
//                             // ],
//                             onError: (err) {
//                               log("error.....   ${err.errorMessage}");
//                             });
//                         if (place != null) {
//                           onSearchChanged();
//                           if (mounted) {
//                             setState(() {
//                               _address = place.description.toString();
//                             });
//                           }
//                           final plist = GoogleMapsPlaces(
//                             apiKey: googleApikey,
//                             apiHeaders:
//                                 await const GoogleApiHeaders().getHeaders(),
//                           );
//                           if (kDebugMode) {
//                             print(plist);
//                           }
//                           String placeid = place.placeId ?? "0";
//                           final detail =
//                               await plist.getDetailsByPlaceId(placeid);
//                           final geometry = detail.result.geometry!;
//                           final lat = geometry.location.lat;
//                           final lang = geometry.location.lng;
//                           var newlatlang = LatLng(lat, lang).checkLatLong;
//                           if (mounted) {
//                             setState(() {
//                               _address = place.description.toString();
//                               _onAddMarkerButtonPressed(
//                                   LatLng(lat, lang).checkLatLong,
//                                   place.description);
//                             });
//                           }
//                           mapController?.animateCamera(
//                               CameraUpdate.newCameraPosition(CameraPosition(
//                                   target: newlatlang, zoom: 17)));
//                           if (mounted) {
//                             setState(() {});
//                           }
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(15),
//                         child: Card(
//                           color: Colors.white,
//                           child: Container(
//                               padding: const EdgeInsets.all(0),
//                               width: MediaQuery.of(context).size.width - 40,
//                               child: ListTile(
//                                 leading: const Icon(
//                                   Icons.location_on_rounded,
//                                   color: AppTheme.primaryColor,
//                                 ),
//                                 title: Text(
//                                   "Search Location",
//                                   style: GoogleFonts.poppins(
//                                       fontSize: AddSize.font14),
//                                 ),
//                                 trailing: const Icon(Icons.search),
//                                 dense: true,
//                               )),
//                         ),
//                       ))),
//               Positioned(
//                   bottom: 0,
//                   child: Container(
//                     height: AddSize.size200,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20))),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: AddSize.padding16,
//                         vertical: AddSize.padding10,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Card(
//                             child: ListTile(
//                               minLeadingWidth: 10,
//                               title: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.location_on,
//                                     color: AppTheme.primaryColor,
//                                     size: 25,
//                                   ),
//                                   SizedBox(
//                                     width: AddSize.size12,
//                                   ),
//                                   Expanded(
//                                     child: Text(
//                                       _address.toString(),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineSmall!
//                                           .copyWith(
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: AddSize.font16),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: AddSize.size30,
//                           ),
//                           ElevatedButton(
//                               onPressed: () {
//                                 if(_debounce == null) {
//                                   cartController.deliveryAddress.value =
//                                       UserAddress(
//                                         address: '${place.subLocality},'
//                                             ' ${place.subAdministrativeArea},'
//                                             ' ${place.postalCode}',
//                                         building: place.name,
//                                         countryCode: cartController
//                                             .deliveryAddress.value.countryCode,
//                                         phoneNo: cartController
//                                             .deliveryAddress.value.phoneNo,
//                                         lat: cameraPosition!.target.latitude
//                                             .toString(),
//                                         longitute: cameraPosition!.target
//                                             .longitude
//                                             .toString(),
//                                         floor: cartController
//                                             .deliveryAddress.value.floor,
//                                         home: place.subLocality,
//                                       );
//                                   cartController.allowNavigation = false;
//                                   cartController.refreshInt.value =
//                                       DateTime
//                                           .now()
//                                           .millisecondsSinceEpoch;
//                                   Get.back();
//                                   Future.delayed(const Duration(seconds: 2))
//                                       .then((value) {
//                                     cartController.allowNavigation = false;
//                                     cartController.refreshInt.value =
//                                         DateTime
//                                             .now()
//                                             .millisecondsSinceEpoch;
//                                   });
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: const Size(double.maxFinite, 60),
//                                 backgroundColor: AppTheme.primaryColor,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                               child: Text(
//                                 "Confirm",
//                                 style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 18),
//                               )),
//                         ],
//                       ),
//                     ),
//                   ))
//             ],
//           )),
//     );
//   }
// }
