import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/new_controllers/cart_controller.dart';

class PopUpSignOut extends StatefulWidget {
  const PopUpSignOut({Key? key}) : super(key: key);

  @override
  State<PopUpSignOut> createState() => _PopUpSignOutState();
}

class _PopUpSignOutState extends State<PopUpSignOut> {
  final cartController = Get.put(CartController());
  checkuser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('user_details') != null) {
      isuserloggedin = true;
    } else {
      isuserloggedin = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  bool isuserloggedin = false;
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
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 20,
              ),
              Builder(builder: (context) {
                return Center(
                  child: Text(
                    "Are you sure sign out account?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      Get.back();
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.clear();
                      preferences.setString("initial_dialog", "done");
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                      final cartController = Get.put(CartController());
                      cartController.resetAll();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 50,
                      width: 130,
                      child: Center(
                        child: Text(
                          'Yes',
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
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 50,
                      width: 130,
                      child: Center(
                        child: Text(
                          'cancel',
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
              const SizedBox(
                height: 20,
              ),
            ]),
      ),
    );
  }
}
