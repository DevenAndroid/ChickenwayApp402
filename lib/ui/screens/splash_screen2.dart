import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinelah/helper/new_helper.dart';
import 'package:dinelah/res/app_assets.dart';
import 'package:dinelah/routers/my_router.dart';
import 'package:dinelah/ui/screens/update_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/splash_screen_controller.dart';
import '../../models/match_apk_model.dart';
import '../../models/splash_model.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../utils/api_constant.dart';
import 'bottom_nav_bar.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  // final splashController = Get.put(SplashScreenController());

  Rx<SplashModel> modelSplash = SplashModel().obs;
  final Repositories repositories = Repositories();
  Rx<RxStatus> statusOfSplash = RxStatus
      .empty()
      .obs;


  String image = "";
  bool animatedStarted = false;
  RxBool animate = true.obs;

  Future startAnimation() async {
    if (animatedStarted) return;
    animatedStarted = true;
    await Future.delayed(const Duration(milliseconds: 100));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    animate.value = false;
    await Future.delayed(const Duration(milliseconds: 900));

    Get.offAll(() => const MainHomeScreen());
  }

  splash() async {
    image = (await getImageUrl()) ?? "";
    if (image.isNotEmpty) {
      statusOfSplash.value = RxStatus.success();
      setState(() {});
      // startAnimation();
    }
    repositories
        .getApi(
      url: ApiUrls.splashScreenUrl,
    )
        .then((value) {
          print("log print ");
      modelSplash.value = SplashModel.fromJson(jsonDecode(value));
      if (modelSplash.value.status!) {
        statusOfSplash.value = RxStatus.success();
        image = modelSplash.value.data!.splashScreen.toString();
        saveImageToSharedPrefrence(image);
      } else {
        statusOfSplash.value = RxStatus.error();
      }
      setState(() {});
    });
  }

  saveImageToSharedPrefrence(String url) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("splash_image", url);
  }

  Future<String?> getImageUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("splash_image");
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    splash();
    });
  }

  @override
  Widget build(BuildContext context) {
    log("ghjgjh$image");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return AnimatedOpacity(
          opacity: animate.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: statusOfSplash.value.isSuccess
              ? SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (_, __, ___) {
                startAnimation();
                return Center(child: CircularProgressIndicator(
                  color: Colors.white,
                ))
                ;
              },
            ),
          )
              : Center(child: const Center(child: CircularProgressIndicator(
            color: Colors.red,
          ))),
        );
      }),
    );
  }
}
