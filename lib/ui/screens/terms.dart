import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/model_terms.dart';
import '../../repositories/new_common_repo/repository.dart';
import '../../utils/api_constant.dart';
import '../../widgets/circular_progressindicator.dart';
import '../../widgets/common_error_widget.dart';
import '../widget/app_bar.dart';

class TermAndCondition extends StatefulWidget {
  const TermAndCondition({Key? key}) : super(key: key);

  @override
  State<TermAndCondition> createState() => _TermAndConditionState();
}

class _TermAndConditionState extends State<TermAndCondition> {
  Rx<ModelTermsAndCondition> modelTermsAndCondition =
      ModelTermsAndCondition().obs;
  Rx<RxStatus> statusOfTerms = RxStatus.empty().obs;
  final Repositories repositories = Repositories();
  termsAndCondition() {
    // Map<String, dynamic> map = {};

    repositories.postApi(url: ApiUrls.termCondition, mapData: {}).then((value) {
      modelTermsAndCondition.value =
          ModelTermsAndCondition.fromJson(jsonDecode(value));
      if (modelTermsAndCondition.value.status!) {
        statusOfTerms.value = RxStatus.success();
      } else {
        statusOfTerms.value = RxStatus.error();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    termsAndCondition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: commonAppBar(
            title: "TERMS & CONDITIONS",
            showCart: false,
            backGround: Colors.white),
        body: Obx(() {
          return statusOfTerms.value.isSuccess
              ? SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: modelTermsAndCondition
                              .value.data!.termsAndConditions!.length,
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
                                        modelTermsAndCondition.value.data!
                                            .termsAndConditions![index].name
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
                                        modelTermsAndCondition.value.data!
                                            .termsAndConditions![index].content
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            height: 1.5,
                                            color: const Color(0xFF999999),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ]);
                          })))
              : statusOfTerms.value.isError
                  ? CommonErrorWidget(
                      errorText:
                          modelTermsAndCondition.value.message.toString(),
                      onTap: () {
                        termsAndCondition();
                      },
                    )
                  : const CommonProgressIndicator();
        }));
  }
}
