import 'package:badges/badges.dart';
import 'package:dinelah/helper/new_helper.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/new_controllers/cart_controller.dart';
import 'package:collection/collection.dart';

import '../screens/cart_screen.dart';

AppBar commonAppBar({
  String? title,
  bool? showCart = true,
  bool? showMenu = false,
  onTap,
  Color? backGround = Colors.transparent,
  double? elevation = 0,
}) {
  final cartController = Get.put(CartController());
  return AppBar(
    backgroundColor: backGround,
    surfaceTintColor: backGround,
    shadowColor: Colors.grey.shade200,
    elevation: elevation,
    leading: !showMenu!
        ? SizedBox(
            height: 5,
            width: 5,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // width: 5,
                  // height: 5,
                  // padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)),
                  child: const Icon(Icons.arrow_back, color: Colors.grey),
                ),
              ),
            ),
          )
        : IconButton(
            padding: const EdgeInsets.only(left: 5.0),
            icon: IconButton(
              icon: Image.asset(
                'assets/images/drawer_icon.png',
                width: 25,
                height: 16,
              ),
              onPressed: onTap,
            ),
            onPressed: () {}),
    centerTitle: true,
    title: title != null
        ? Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Image.asset(
                      'assets/images/cock.png',
                      height: 23,
                    ).toAppIcon,
                  ),
                  const TextSpan(text: '  '),
                  TextSpan(
                    text: title,
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF292323),
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: '  '),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/images/cock.png',
                      height: 23,
                    ).toAppIcon,
                  ),
                ],
              ),
            ),
          )
        : null,
    actions: [
      if (showCart!)
        Padding(
          padding: const EdgeInsets.only(right: 24.0, top: 15),
          child: Obx(() {
            if (cartController.refreshInt.value > 0) {}
            return InkWell(
              onTap: () {
                Get.toNamed(CartScreen.route);
              },
              child: (cartController.isDataLoading.value &&
                      cartController.model.value.data != null &&
                      cartController.model.value.data!.items!.isNotEmpty)
                  ? Badge(
                      // badgeColor: Colors.black,
                      badgeStyle: const BadgeStyle(badgeColor: Colors.black),
                      badgeContent: Text(
                        cartController.model.value.data!.items!
                            .map((e) => int.parse((e.quantity ?? 0).toString()))
                            .toList()
                            .sum
                            .toString(),
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 10),
                      ),
                      child: Image.asset(
                        'assets/images/cooking_icon.png',
                        width: 26,
                        height: 26,
                      ))
                  : Image.asset(
                      'assets/images/cooking_icon.png',
                      width: 26,
                      height: 26,
                    ),
            );
          }),
        )
    ],
  );
}
