import 'dart:convert';
import 'dart:developer';

import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/repositories/new_common_repo/repository.dart';
import 'package:dinelah/res/size_config.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/routers/my_router.dart';
import 'package:dinelah/ui/screens/notification_service.dart';
import 'package:dinelah/ui/screens/update_Screen.dart';
import 'package:dinelah/utils/api_constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upgrader/upgrader.dart';

import 'models/match_apk_model.dart';

String initialCountryCode = "";

Rx<ModelResponseCommon> modelAboutapp = ModelResponseCommon().obs;
Rx<MatchApkModel> matchApkVersion = MatchApkModel().obs;
Rx<RxStatus> statusOfAbout = RxStatus.empty().obs;
Rx<RxStatus> statusOfMatch = RxStatus.empty().obs;
final Repositories repositories = Repositories();



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // runApp(const MyApp());
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission(
    // alert: true,
    // announcement: true,
      badge: true,
      // carPlay: true,
      // criticalAlert: true,
      // provisional: true,
      sound: true);
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appVersion = packageInfo.version;
  print('app version is${appVersion.toString()}');


    repositories.postApi(url: ApiUrls.apkVersion, mapData: {
      "apk_version":appVersion.toString()
    }).then((value) {
      modelAboutapp.value = ModelResponseCommon.fromJson(jsonDecode(value));
      if (modelAboutapp.value.status!) {
        statusOfAbout.value = RxStatus.success();
      } else {
        statusOfAbout.value = RxStatus.error();
      }
    });


  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  NotificationService().initializeNotification();
  // await Permission.notification.isDenied.then((value) {
  //   if (value) {
  //     Permission.notification.request();
  //   }
  // });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  //Remove this method to stop OneSignal Debugging
//
//
//
//
//
// // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//   OneSignal.Notifications.requestPermission(true);
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,

//     provisional: false,
//     sound: true,
//   );

  // if (kDebugMode) {
  //   print('User granted permission: ${settings.authorizationStatus}');
  // }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // initPlatformState();
  }

  static const String oneSignalAppId = "84319630-f6ed-490f-ac1a-99a868a02a2f";

  Future<void> initPlatformState() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);



     // OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.initialize(oneSignalAppId);
    OneSignal.Notifications.addClickListener((event) {
      log('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
     setState(() {});
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      log('NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
      event.preventDefault();
      event.notification.display();


      setState(() {});
    });
  }

  var theme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: const Color(0xffF5F5F5),
    cardTheme: const CardTheme(surfaceTintColor: Colors.white, color: Colors.white),
    primaryColor: AppTheme.primaryColor,
    dialogTheme: const DialogTheme(backgroundColor: Colors.white, surfaceTintColor: Colors.white),
    primarySwatch: Colors.red,

  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return GetMaterialApp(
          title: "Chickenway",
          // home: UpgradeAlert(
          //   upgrader: Upgrader(
          //     canDismissDialog: false,
          //     showIgnore: false,showLater: false,showReleaseNotes: false,
          //
          //   ),
          // ),
          darkTheme: theme,
          debugShowCheckedModeBanner: false,
          getPages: MyRouter.route,
          theme: theme,


        );


      }

      );

    }

    );
  }
}
