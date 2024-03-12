import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../models/model_about_app.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../utils/api_constant.dart';
import '../../widgets/circular_progressindicator.dart';
import '../../widgets/common_error_widget.dart';
import '../widget/app_bar.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  Rx<ModelAboutApp> modelAboutapp = ModelAboutApp().obs;
  Rx<RxStatus> statusOfAbout = RxStatus.empty().obs;
  final Repositories repositories = Repositories();
  aboutApp() {
    // Map<String, dynamic> map = {};

    repositories.getApi(url: ApiUrls.aboutUs, mapData: {}).then((value) {
      modelAboutapp.value = ModelAboutApp.fromJson(jsonDecode(value));
      if (modelAboutapp.value.status!) {
        statusOfAbout.value = RxStatus.success();
      } else {
        statusOfAbout.value = RxStatus.error();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    aboutApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: commonAppBar(
          title: "ABOUT APP",
          showCart: false,
          backGround: Colors.white,
          elevation: 1),
      body: Obx(
        () {
          return statusOfAbout.value.isSuccess
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child:Text(modelAboutapp.value.data!.aboutApp!.name.toString(),style: TextStyle(
                          color: Colors.black,fontWeight: FontWeight.w500,
                          fontSize: 20
                        ),)


                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: modelAboutapp.value.data!.aboutApp!.content.toString(),
                        ),
                      ),
                    ],
                  ),
                )
              : statusOfAbout.value.isError
                  ? CommonErrorWidget(
                      errorText: modelAboutapp.value.message.toString(),
                      onTap: () {
                        aboutApp();
                      },
                    )
                  : const CommonProgressIndicator();
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       backgroundColor: const Color(0xffF5F5F5),
  //       appBar: commonAppBar(
  //           title: "ABOUT APP",
  //           showCart: false,
  //           backGround: Colors.white,
  //           elevation: 1),
  //       body: Obx(() {
  //         return statusOfAbout.value.isSuccess
  //             ? SingleChildScrollView(
  //                 child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: ListView.builder(
  //                         itemCount: modelAboutapp.value.data!.aboutApp!.length,
  //                         shrinkWrap: true,
  //                         padding: EdgeInsets.zero,
  //                         physics: const NeverScrollableScrollPhysics(),
  //                         itemBuilder: (context, index) {
  //                           return Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 const SizedBox(
  //                                   height: 30,
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(left: 10),
  //                                   child: Text(
  //                                       modelAboutapp
  //                                           .value.data!.aboutApp![index].name
  //                                           .toString(),
  //                                       style: GoogleFonts.poppins(
  //                                           color: const Color(0xFF333333),
  //                                           fontSize: 18,
  //                                           fontWeight: FontWeight.w600)),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 10,
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                     left: 10,
  //                                   ),
  //                                   child: Text(
  //                                       modelAboutapp.value.data!
  //                                           .aboutApp![index].content
  //                                           .toString(),
  //                                       style: GoogleFonts.poppins(
  //                                           height: 2,
  //                                           color: const Color(0xFF999999),
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w400)),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 30,
  //                                 ),
  //                               ]);
  //                         })))
  //             : statusOfAbout.value.isError
  //                 ? CommonErrorWidget(
  //                     errorText: modelAboutapp.value.message.toString(),
  //                     onTap: () {
  //                       aboutApp();
  //                     },
  //                   )
  //                 : const CommonProgressIndicator();
  //       }));
  // }
}
