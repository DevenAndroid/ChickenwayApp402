import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/privacy_policy_model.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../utils/api_constant.dart';
import '../../widgets/circular_progressindicator.dart';
import '../../widgets/common_error_widget.dart';
import '../widget/app_bar.dart';

class PrivacyPolicy extends StatefulWidget {
  String? id;
   PrivacyPolicy({Key? key,this.id}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  Rx<ModelPrivacyPolicy> modelPrivacy = ModelPrivacyPolicy().obs;
  Rx<RxStatus> statusOfprivacy = RxStatus.empty().obs;
  final Repositories repositories = Repositories();
  privacyPolicy() {
    // Map<String, dynamic> map = {};

    repositories.postApi(url: ApiUrls.privicyPolicy, mapData: {}).then((value) {
      modelPrivacy.value = ModelPrivacyPolicy.fromJson(jsonDecode(value));
      if (modelPrivacy.value.status!) {
        statusOfprivacy.value = RxStatus.success();
      } else {
        statusOfprivacy.value = RxStatus.error();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    privacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: commonAppBar(
            title: "PRIVACY POLICY", showCart: false, backGround: Colors.white),
        body: Obx(() {
          return statusOfprivacy.value.isSuccess
              ? SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: modelPrivacy
                              .value.data!.privacyPolicyScreen!.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                        modelPrivacy.value.data!
                                            .privacyPolicyScreen![index].name
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF333333),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                        modelPrivacy.value.data!
                                            .privacyPolicyScreen![index].content
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            height: 1.5,
                                            color: const Color(0xFF999999),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ]);
                          })))
              : statusOfprivacy.value.isError
                  ? CommonErrorWidget(
                      errorText: modelPrivacy.value.message.toString(),
                      onTap: () {
                        privacyPolicy();
                      },
                    )
                  : const CommonProgressIndicator();
        }));
  }
}
