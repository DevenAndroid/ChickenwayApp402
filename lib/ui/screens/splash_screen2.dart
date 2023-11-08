import 'dart:convert';
import 'dart:developer';

import 'package:dinelah/res/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/splash_screen_controller.dart';
import '../../models/splash_model.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../utils/api_constant.dart';
import 'bottom_nav_bar.dart';

class SplashScreen2 extends StatefulWidget {
  SplashScreen2({Key? key}) : super(key: key);

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  final splashController = Get.put(SplashScreenController());

  Rx<SplashModel> modelSplash = SplashModel().obs;

  Rx<RxStatus> statusOfSplash= RxStatus.empty().obs;

  final Repositories repositories = Repositories();
String image="";
  RxBool animate = false.obs;
  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 3000));
    animate.value = false;
    await Future.delayed(const Duration(milliseconds: 900));
    Get.offAll(const MainHomeScreen());
  }
  splash() {
    repositories.getApi(url: ApiUrls.splashScreenUrl,).then((value) {
      modelSplash.value = SplashModel.fromJson(jsonDecode(value));
      if (modelSplash.value.status!) {
        statusOfSplash.value = RxStatus.success();
        image = modelSplash.value.data!.splashScreen.toString();
        startAnimation();
      } else {
        statusOfSplash.value = RxStatus.error();
      }
      setState(() {

      });
    });
  }

  @override
  void initState() {
    super.initState();
    splash();
  }

  @override
  Widget build(BuildContext context) {
    log("ghjgjh$image");
    return
      statusOfSplash.value.isSuccess?
      Container(
      color: Colors.white,
      child: Obx(
        () => AnimatedOpacity(
          opacity: splashController.animate.value ? 1.0 : 0.0,
          duration: const Duration(minutes: 1),
          child:Image.network(image, fit: BoxFit.cover),
        ),
      ),
    ):const Center(child: CircularProgressIndicator());
  }
}
