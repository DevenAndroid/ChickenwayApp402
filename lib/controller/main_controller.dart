// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get.dart';
// import '../ui/screens/single_product_screen.dart';
//
//
// class MainHomeController extends GetxController {
//   RxInt currentIndex = 0.obs;
//   RxBool internetConnection = true.obs;
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
//
//   onItemTap(int value) {
//     currentIndex.value = value;
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     FirebaseMessaging.onMessage.listen((event) {
//       log("Push Notification received ...........     ${event.data}");
//     });
//     // FirebaseMessaging.onBackgroundMessage((event) async {
//     //   log('Notification issss  ${event.data.toString()}');
//     //   if(event.data['screen_type'] =='post_or_product_update'){
//     //     Get.to(()=>SingleProductScreen(id1: event.data['p_id']));
//     //   }
//     // });
//   }
// }
