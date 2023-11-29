import 'package:dinelah/controller/orders_controller.dart';
import 'package:dinelah/ui/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/dimensions.dart';
import 'orderdetails.dart';

class YourOrderScreen extends StatefulWidget {
  const YourOrderScreen({Key? key}) : super(key: key);

  @override
  State<YourOrderScreen> createState() => _YourOrderScreenState();
}

class _YourOrderScreenState extends State<YourOrderScreen> {
  final orderController = Get.put(OrderController());
  buildShimmer({
    required double height,
    required double width,
    required double border,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14), color: Colors.white),
      ),
    );
  }
  buildShimmerCircle({
    required double size,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.white,
      child: Container(
        width: size,
        height: size,
        decoration:
        const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    orderController.yourOrder().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppBar(
            title: 'YOUR ORDER', elevation: 2, backGround: Colors.white,),
        body: Obx(() {
          return orderController.order.value.isSuccess
              ? RefreshIndicator(
                  onRefresh: () async {
                    await orderController.yourOrder();
                  },
                  child: ListView.builder(
                      padding: const EdgeInsets.all(25),
                      itemCount:
                          orderController.model.value.data!.orders!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final order = orderController.model.value.data!.orders![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10, left: 5),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(OrderDetails.route, arguments: [
                                orderController
                                    .model.value.data!.orders![index].id
                                    .toString(),
                              ]);
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    order.lineItems != null && order.lineItems!.isNotEmpty ?
                                    order.lineItems![0].name
                                        .toString() : "",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF333333),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    order.status
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                        color: order.status
                                            .toString().trim().toLowerCase()== "completed" ? Colors.green :order.status
                                            .toString().trim().toLowerCase() == "cancelled"  || order.status
                                            .toString().trim().toLowerCase() == "on-hold"?  Colors.red : const Color(0xFFFFBE00),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          order.dateCreated
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xFFD7E0E7),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Order Id: ${order.id}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  if(order.commentData == null)
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/Group 794@2x.png',
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Rate the Order',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF555555),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: order.commentData == null ? 10 : 6,
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: 0,
                                    color: Colors.grey.shade300,
                                  )
                                ]),
                          ),
                        );
                      }),
                )
              :
       ListView.builder(
         itemCount:   orderController.model.value.data!.orders!.length
         ,itemBuilder: (context, index) {
         return SingleChildScrollView(
             child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(padding: const EdgeInsets.only(left: 20).copyWith(top: 40),
                     child: buildShimmer(
                       border: 1,
                       width: AddSize.screenWidth*.50,
                       height: 40,
                     )),
                 Padding(padding: const EdgeInsets.only(left: 20).copyWith(top: 10),
                     child: buildShimmer(
                       border: 0,
                       width: AddSize.screenWidth*.3,
                       height: 30,
                     )),
                 Padding(padding: const EdgeInsets.only(left: 20).copyWith(top: 10),
                     child: buildShimmer(
                       border: 15,
                       width: AddSize.screenWidth*.40,
                       height: 20,
                     )),
                 Padding(padding: const EdgeInsets.only(left: 20).copyWith(top: 10),
                     child: buildShimmer(
                       border: 15,
                       width: AddSize.screenWidth*.40,
                       height: 20,
                     )),
                 Row(
                   children: [
                     Padding(padding: const EdgeInsets.all(20).copyWith(top: 13),
                         child:  buildShimmerCircle(size: 30

                         )),
                     buildShimmer(
                       border: 15,
                       width: AddSize.screenWidth*.30,
                       height: 25,

                     ),
                   ],
                 ),
                 const SizedBox(height: 15,),
                 Divider(
                   thickness: 1,
                   height: 0,
                   color: Colors.grey.shade300,
                 )
               ],
             ),


         );
       },



        );}));
  }
}
