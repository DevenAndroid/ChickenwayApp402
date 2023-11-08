import 'dart:convert';

import 'package:dinelah/ui/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/model_support_screen.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../utils/api_constant.dart';
import '../../widgets/circular_progressindicator.dart';
import '../../widgets/common_error_widget.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  Rx<ModelSupportScreen> modelSupport = ModelSupportScreen().obs;
  Rx<RxStatus> statusOfsupport = RxStatus.empty().obs;
  final Repositories repositories = Repositories();

  void whatsAppOpen() async {
    await FlutterLaunch.launchWhatsapp(
        phone: "5534992016545", message: "Hello");
  }

  supportScreen() {
    // Map<String, dynamic> map = {};

    repositories.postApi(url: ApiUrls.supportScreen, mapData: {}).then((value) {
      modelSupport.value = ModelSupportScreen.fromJson(jsonDecode(value));
      if (modelSupport.value.status!) {
        statusOfsupport.value = RxStatus.success();
      } else {
        statusOfsupport.value = RxStatus.error();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    whatsAppOpen();
    supportScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: commonAppBar(
            title: "SUPPORT", elevation: 2, backGround: Colors.white),
        body: Obx(() {
          return statusOfsupport.value.isSuccess
              ? SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 18),
                      child: ListView.builder(
                          itemCount:
                              modelSupport.value.data!.supportScreen!.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text('How can we help?',
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF333333),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  getItem(index, 1),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  getItem(index, 2),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  getItem(index, 3),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  getItem(index, 4),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  getItem(index, 5),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  getItem(index, 6),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  getItem(index, 7),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  getItem(index, 8),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  getItem(index, 9),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  getItem(index, 10),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey[350],
                                    endIndent: 20,
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Text('Didn’t find your answer? Contact Us',
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Uri phoneno = Uri.parse(
                                          'tel:${modelSupport.value.data!.supportScreen![index].phoneNumber.toString()}');
                                      if (await launchUrl(phoneno)) {
                                        //dialer opened
                                      } else {
                                        //dailer is not opened
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Group 787.svg',
                                          width: 40,
                                          height: 40,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                            modelSupport
                                                .value
                                                .data!
                                                .supportScreen![index]
                                                .phoneNumber
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFF333333),
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      String phone = modelSupport.value.data!
                                          .supportScreen![index].phoneNumber
                                          .toString();
                                      var url =
                                          "https://wa.me/$phone/?text=hello";
                                      if (await launchUrl(Uri(path: url))) {
                                        await canLaunchUrl(Uri(path: url));
                                      } else {
                                        // showError('there is no WhatsApp installed');
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Group 798.svg',
                                          width: 40,
                                          height: 40,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                            modelSupport
                                                .value
                                                .data!
                                                .supportScreen![index]
                                                .whatsappLink
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFF333333),
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Group 799.svg',
                                          width: 40,
                                          height: 40,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                            modelSupport
                                                .value
                                                .data!
                                                .supportScreen![index]
                                                .emailField
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFF333333),
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ]);
                          })))
              : statusOfsupport.value.isError
                  ? CommonErrorWidget(
                      errorText: modelSupport.value.message.toString(),
                      onTap: () {
                        supportScreen();
                      },
                    )
                  : const CommonProgressIndicator();
        }));
  }

  getItem(int index, int i) {
    String iconUrl = '';
    String question = '';
    String answer = '';

    switch (i) {
      case 1:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl1.toString();
        question =
            modelSupport.value.data!.supportScreen![index].question1.toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer1.toString();
        break;
      case 2:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl2.toString();
        question =
            modelSupport.value.data!.supportScreen![index].question2.toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer2.toString();
        break;
      case 3:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl3.toString();
        question =
            modelSupport.value.data!.supportScreen![index].question3.toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer3.toString();
        break;
      case 4:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl4.toString();
        question =
            modelSupport.value.data!.supportScreen![index].question4.toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer4.toString();
        break;
      case 5:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl5.toString();
        question =
            modelSupport.value.data!.supportScreen![index].question5.toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer5.toString();
        break;
      case 6:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl6.toString();
        question =
            modelSupport.value.data!.supportScreen![index].question6.toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer6.toString();
        break;
      case 7:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl7.toString();
        question =
            modelSupport.value.data!.supportScreen![index].question7.toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer7.toString();
        break;
      case 8:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl8.toString();
        question =
            modelSupport.value.data!.supportScreen![index].question8.toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer8.toString();
        break;
      case 9:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl9.toString();
        question =
            modelSupport.value.data!.supportScreen![index].question9.toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer9.toString();
        break;
      case 10:
        iconUrl =
            modelSupport.value.data!.supportScreen![index].iconUrl10.toString();
        question = modelSupport.value.data!.supportScreen![index].question10
            .toString();
        answer =
            modelSupport.value.data!.supportScreen![index].answer10.toString();
        break;
      default:
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(right: 20, left: 0),
        backgroundColor: const Color(0xFFFCFBFA),
        iconColor: const Color(0xFFE02020),
        collapsedIconColor: const Color(0xFFE02020),
        childrenPadding: const EdgeInsets.all(1),
        title: Row(
          children: [
            Image.network(
              iconUrl,
              width: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              question,
              style: GoogleFonts.poppins(
                color: const Color(0xFF333333),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: <Widget>[
          ListTile(
            iconColor: const Color(0xFFE02020),
            isThreeLine: true,
            subtitle: Text(
              answer,
              style: GoogleFonts.poppins(
                color: const Color(0xFF999999),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            dense: true,
          ),
        ],
      ),
    );
  }
}
