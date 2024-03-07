import 'dart:developer';

import 'package:dinelah/res/app_assets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
  FirebaseMessaging.onMessage.listen((message) {
    log("fgdjg"+message.data.toString());
    RemoteNotification? notification = message.notification ;
    AndroidNotification? android = message.notification!.android ;

    if (kDebugMode) {
      print("notifications title:${notification!.title}");
      print("notifications body:${notification.body}");
      print('count:${android!.count}');
      print('data:${message.data.toString()}');
    }
  });
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        body: Image.asset(
          AppAssets.splashBg,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
