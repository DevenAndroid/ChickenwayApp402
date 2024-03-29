import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinelah/controller/profile_controller.dart';
import 'package:dinelah/controller/new_controllers/cart_controller.dart';
import 'package:dinelah/repositories/new_common_repo/repository.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/ui/screens/address/address_screen.dart';
import 'package:dinelah/ui/screens/bottom_nav_bar.dart';
import 'package:dinelah/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/menu_controller.dart';
import '../../controller/new_controllers/address_controller.dart';
import '../../controller/orders_controller.dart';
import '../../controller/wishlist_controller.dart';
import '../../helper/helper.dart';
import '../../models/model_response_common.dart';
import '../../repositories/delete_user_repo.dart';
import '../../routers/my_router.dart';
import '../../utils/api_constant.dart';
import '../screens/checkout_screen.dart';
import '../screens/item/popup_msg.dart';
import '../screens/menu_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final orderController = Get.put(OrderController());
  final wishList = Get.put(WishlistController());
  final CartController cartController = Get.put(CartController());
  final profileController = Get.put(ProfileController());
  final addressController = Get.put(AddressController());
  final menuController = Get.put(ProductsMenuController());
  final ProfileController _profileController = Get.put(ProfileController());
  final Repositories repositories = Repositories();


  Rx<ModelResponseCommon> modelDelete = ModelResponseCommon().obs;

  Rx<RxStatus> statusOfDelete = RxStatus.empty().obs;

  Rx<ModelResponseCommon> modelPrivacy = ModelResponseCommon().obs;
  Rx<RxStatus> statusOfDeleteUser= RxStatus.empty().obs;

  checkUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('user_details') != null) {
      userLoggedIn = true;
    } else {
      userLoggedIn = false;
    }
    if (mounted) {
      setState(() {});
    }
  }
  showDialog1() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: 40,

                          decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.red),
                          child: Icon(Icons.close,color: Colors.white,),
                          ),
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Text(
                      'Would You Like To Delete This Account?'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                            color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                                onPressed: () {

                                    // Map<String, dynamic> map = {};

                                    repositories.postApi(url: ApiUrls.deleteUser, mapData: {}).then((value) async {
                                      modelPrivacy.value = ModelResponseCommon.fromJson(jsonDecode(value));
                                      if (modelPrivacy.value.status!) {
                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                        await pref.clear();
                                        Get.offAllNamed(MyRouter.logInScreen);
                                        statusOfDeleteUser.value = RxStatus.success();
                                      } else {
                                        statusOfDeleteUser.value = RxStatus.error();
                                      }
                                    });

                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, elevation: 0, minimumSize: Size(80, 40)),
                                child: FittedBox(
                                  child: Text('Yes, Delete This Account'.tr,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: width * .02,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                              child: Center(
                                  child: Text('Cancel'.tr,
                                      style:
                                      TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red))),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool userLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: Obx(() {
        if (_profileController.refreshInt.value > 0) {}
        if (cartController.refreshInt.value > 0) {}
        checkUser();
        return Drawer(
          child: Container(
            color: const Color(0xFFF5F5F5),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 18,
                                ),
                                child: Icon(
                                  Icons.clear,
                                  size: 35,
                                  color: Color(0xff333333),
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(MyRouter.profileScreen);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                addWidth(10),
                                if (_profileController.model.value.data != null)
                                  Card(
                                    shape: const CircleBorder(),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: const ShapeDecoration(
                                          shape: CircleBorder(),
                                          color: Colors.white,
                                        ),
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: _profileController
                                                      .model.value.data !=
                                                  null
                                              ? Text(
                                                  _profileController.model.value
                                                      .data!.firstName
                                                      .toString()
                                                      .substring(0, 1)
                                                      .toUpperCase(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    color:
                                                        const Color(0xFF292323),
                                                    fontWeight: FontWeight.w600,
                                                  ))
                                              : const SizedBox(),
                                        )),
                                  ),
                                addWidth(10),
                                _profileController.model.value.data != null
                                    ? Text(
                                        "${_profileController.model.value.data!.firstName} ${_profileController.model.value.data!.lastName}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: const Color(0xFF292323),
                                          fontWeight: FontWeight.w600,
                                        ))
                                    : Text(
                                        userLoggedIn == false
                                            ? "Welcome To ChickenWay App"
                                            : "",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: const Color(0xFF292323),
                                          fontWeight: FontWeight.w600,
                                        )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _drawerTile(
                              active: true,
                              title: 'HOME',
                              icon: "home",
                              onTap: () {
                                Get.back();
                              }),
                          const SizedBox(
                            height: 3,
                          ),
                          _drawerTile(
                              active: true,
                              title: 'MENU',
                              icon: "menu",
                              onTap: () {
                                Get.toNamed(MenuScreen.route);
                              }),
                          const SizedBox(
                            height: 3,
                          ),
                          if (userLoggedIn)
                            _drawerTile(
                                active: true,
                                icon: "order",
                                title: 'YOUR ORDERS',
                                onTap: () {
                                  Get.toNamed(MyRouter.yourorder);
                                }),
                          const SizedBox(
                            height: 3,
                          ),
                          if (userLoggedIn)
                            _drawerTile(
                                active: true,
                                icon: "profile",
                                title: 'MY PROFILE',
                                onTap: () {
                                  Get.toNamed(MyRouter.profileScreen);
                                }),
                          const SizedBox(
                            height: 3,
                          ),
                          if (userLoggedIn)
                            _drawerTile(
                                active: true,
                                icon: "location",
                                title: 'ADDRESSES',
                                onTap: () {
                                  selectAddressForOrder = false;
                                  Get.toNamed(AddressScreenn.route);
                                }),
                          const SizedBox(
                            height: 3,
                          ),
                          _drawerTile(
                              active: true,
                              icon: "support",
                              title: 'SUPPORT',
                              onTap: () {
                                Get.toNamed(MyRouter.support);
                              }),
                          if (userLoggedIn)
                            if( wishList.model.value.data! .isNotEmpty)
                            _drawerTile(
                                active: true,
                                icon: "fav",
                                title: 'Favorites',
                                onTap: () {
                                  Get.toNamed(MyRouter.addwhishlist);
                                }),
                          const SizedBox(
                            height: 3,
                          ),
                          _drawerTile(
                              active: true,
                              icon: "about",
                              title: 'ABOUT APP',
                              onTap: () {
                                Get.toNamed(MyRouter.aboutapp);
                              }),
                          const SizedBox(
                            height: 3,
                          ),
                          _drawerTile(
                              active: true,
                              icon: "privacy",
                              title: 'PRIVACY POLICY',
                              onTap: () {
                                Get.toNamed(MyRouter.privacypolicy);
                              }),
                          const SizedBox(
                            height: 3,
                          ),
                          _drawerTile(
                              active: true,
                              icon: "terms",
                              title: 'TERMS CONDITIONS',
                              onTap: () {
                                Get.toNamed(MyRouter.term);
                              }),
                          const SizedBox(
                            height: 3,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     showDialog1();
                          //   },
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.delete_outline_sharp),
                          //       SizedBox(
                          //         width: screenSize.width * .04,
                          //       ),
                          //       Text('Delete User'.tr,
                          //           style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.w400,
                          //             fontFamily: "Regular",
                          //             color: Color(0xFF363636),
                          //           )),
                          //       Spacer(),
                          //       Icon(
                          //         Icons.keyboard_arrow_right,
                          //         color: Color(0xFF616A75),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          if(userLoggedIn)
                          _drawerTile(
                              active: true,
                              icon: "==",
                              title: 'Delete User',
                              onTap: () {
                                showDialog1() ;
                              }),
                          const SizedBox(
                            height: 3,
                          ),
                          _drawerTile(
                              active: true,
                              icon: "share",
                              title: 'Share The App',
                              onTap: () {
                                if (Platform.isAndroid) {
                                  Share.share(
                                      'https://play.google.com/store/apps/details?id=com.chickenway.moka');
                                }
                                if (Platform.isIOS) {
                                  Share.share(
                                      'https://apps.apple.com/us/app/chickenway/id6450103488');
                                  // https://apps.apple.com/us/app/chickenway/id6450103488
                                }
                              }),
                          if (userLoggedIn)
                            _drawerTile(
                                active: true,
                                icon: "out",
                                title: 'SIGN OUT',
                                onTap: () {
                                  showDialogue14(context);
                                }),
                          const SizedBox(
                            height: 3,
                          ),
                          if (!userLoggedIn)
                            _drawerTile(
                                active: true,
                                icon: "==",
                                title: 'SIGN IN',
                                onTap: () async {
                                  Get.back();
                                  Get.toNamed(MyRouter.logInScreen);
                                }),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              if (modelSiteUrl.data != []) {
                                launchUrlToWeb(
                                    modelSiteUrl.data!.first.mokaUrl);
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 25),
                              child: Center(
                                child: CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  ),
                                  imageUrl:
                                      modelSiteUrl.data!.first.mokaLogo ?? '',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _drawerTile({
    required bool active,
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
      dense: true,
      selectedTileColor: AppTheme.etBgColor,
      minLeadingWidth: 26,
      leading: icon != "=="
          ? SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset("assets/menu_icons/$icon.svg"))
          : Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.login_rounded,
                color: AppTheme.primaryColor,
                size: 20,
              )),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xFF292323),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: active ? onTap : null,
    );
  }

  showDialogue14(context) {
    showDialog(
        context: context,
        builder: (context) {
          return const PopUpSignOut();
        });
  }
}
