import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinelah/ui/widget/app_bar.dart';
import 'package:dinelah/utils/price_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import '../../controller/wishlist_controller.dart';
import '../../controller/new_controllers/cart_controller.dart';
import '../../models/model_response_common.dart';
import '../../models/model_food_menu.dart';
import '../../utils/api_constant.dart';
import 'bottom_nav_bar.dart';
import 'single_product_screen.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final cartController = Get.put(CartController());
  final wishListController = Get.put(WishlistController());
  Rx<ModelResponseCommon> modelAddToCart = ModelResponseCommon().obs;
  Rx<ModelFoodMenuProducts> menuItems = ModelFoodMenuProducts().obs;

  addToWishlist(id) {
    Map<String, dynamic> map = {};

    map['product_id'] = id;
    wishListController.repositories
        .postApi(url: ApiUrls.addToWishlist, mapData: map, context: context)
        .then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  addToCart(id) {
    Map<String, dynamic> map = {};

    map['quantity'] = '1';
    map['product_id'] = id;
    wishListController.repositories
        .postApi(url: ApiUrls.addToCart, mapData: map, context: context)
        .then((value) {
      modelAddToCart.value = ModelResponseCommon.fromJson(jsonDecode(value));
      if (mounted) {
        setState(() {
          cartController.getData();
        });
      }
      if (modelAddToCart.value.status!) {
        showToast(modelAddToCart.value.message.toString().split("'").first);
      } else {
        showToast(modelAddToCart.value.message.toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    wishListController.getWishListData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: commonAppBar(
            title: 'FAVOURITES', elevation: 2, backGround: Colors.white),
        body: Obx(() {
          if (wishListController.refreshInt.value > 0) {}
          return wishListController.loaded.value
              ? ListView.builder(
                  itemCount: wishListController.model.value.data!.length,
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final product = wishListController.model.value.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(
                            SingleProductScreen.route,
                            arguments: [
                              product.id.toString(),
                              product.imageUrl ?? "Product ${product.id}",
                              product.name ?? "Product ${product.id}"
                            ],
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(() {
                                          if (cartController.refreshInt.value >
                                              0) {}
                                          return Row(
                                            children: [
                                              if (cartController.productsMap[
                                                      product.id.toString()] !=
                                                  null)
                                                Text(
                                                  "${cartController.productsMap[product.id.toString()]} x ",
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xFFE02020),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              Expanded(
                                                child: Text(
                                                  product.name ??
                                                      "Product ${product.id}",
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xFF292323),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            log(jsonEncode(product));
                                          },
                                          child: Text(
                                            "${product.shortDescription ?? ""}\n\n\n\n",
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFF444444),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'CUSTOMIZE',
                                              style: GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xFF203EE0),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                              height: 5,
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/Group 672.svg',
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                            width: size.width * .5,
                                            child: const Divider(
                                              thickness: 0,
                                              color: Colors.grey,
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: formatPrice2(
                                              product.price!,
                                              product.currencySymbol!,
                                              GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xFF444444),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Hero(
                                    tag: product.imageUrl ??
                                        "Product ${product.id}",
                                    child: Material(
                                      color: Colors.transparent,
                                      child: SizedBox(
                                        height: 60,
                                        width: 130,
                                        child: CachedNetworkImage(
                                          imageUrl: product.imageUrl ??
                                              "Product ${product.id}",
                                          errorWidget: (_, __, ___) =>
                                              const SizedBox(
                                            height: 142,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                right: 8,
                                top: 8,
                                child: buildPositioned(
                                    product.id.toString(), context)),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    onTap: () {
                                      addToCart(product.id.toString());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 30),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE02020),
                                      ),
                                      child: Text(
                                        'ADD TO CART',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFFFFFFFF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                );
        }));
  }
}
