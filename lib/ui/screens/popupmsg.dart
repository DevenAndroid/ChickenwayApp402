import 'dart:convert';

import 'package:dinelah/controller/new_controllers/address_controller.dart';
import 'package:dinelah/models/model_response_common.dart';
import 'package:dinelah/repositories/new_common_repo/repository.dart';
import 'package:dinelah/utils/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class PopUPScreen extends StatefulWidget {
  const PopUPScreen({Key? key}) : super(key: key);

  @override
  State<PopUPScreen> createState() => _PopUPScreenState();
}

class _PopUPScreenState extends State<PopUPScreen> {
  final Repositories repositories = Repositories();
  final addressController = Get.put(AddressController());

  deleteAddress({id, userid}){
    repositories.postApi(url: ApiUrls.deleteAddress,mapData: {"id" : addressController.id, "userid" : addressController.userId},context: context).then((value){
      ModelResponseCommon model = ModelResponseCommon.fromJson(jsonDecode(value));
      showToast(model.message.toString());
      Get.back();
      Get.back();
      addressController.getAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },

                    child: Container(



                      padding: const EdgeInsets.all(8),
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(

                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
                child: Text(
                  "Are you sure you want to delete this address from the addresses list?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 16,height: 1.5,fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(onTap: (){
                    Get.back();
                  },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 50,width: 130,
                      child: Center(
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      deleteAddress();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 50,width: 130,
                      child: Center(
                        child: Text(
                          'Delete',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
            ]),
      ),
    );
  }
}
