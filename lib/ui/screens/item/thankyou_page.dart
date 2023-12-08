import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dinelah/ui/screens/bottom_nav_bar.dart';
import 'package:dinelah/utils/price_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/new_controllers/cart_controller.dart';
import '../../../models/new_models/create_order_model.dart';

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({Key? key}) : super(key: key);

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  // final cartController = Get.put(CartController());
  ModelCreateOrderResponse model = ModelCreateOrderResponse();
  final cartController = Get.put(CartController());
  // int total = cartController.model.value.data!.items!.map((e) => double.tryParse(e.totalPrice.toString() != "0" ? e.totalPrice.toString() : (int.parse(e.product!.price.toString()) * int.parse(e.quantity.toString())).toString()) ?? 0).toList().sum.toInt();
  void initState() {
    super.initState();
    model = Get.arguments;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * .2,
            ),
            Center(
                child: InkWell(
                    onTap: () {
                      log(jsonEncode(model));
                    },
                    child: Image.asset(
                      'assets/images/thankyou.png',
                    ))),
            Center(
                child: Text('Thank You!',
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF0F2F62),
                        fontSize: 49,
                        fontWeight: FontWeight.w600))),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: Text("Order Id: ",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF686A81),
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(model.orderId.toString(),
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF686A81),
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: Text("Basket Total: ",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF686A81),
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: formatPrice2(
                            model.total, model.data!.currencySymbol,
                            GoogleFonts.poppins(
                                color: const Color(0xFF686A81),
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: Text("Delivery Fees: ",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF686A81),
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: formatPrice2(
                            model.data!.shippingTotal,
                            model.data!.currencySymbol,
                            GoogleFonts.poppins(
                                color: const Color(0xFF686A81),
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                  Row(

                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: Text(
                          'Total Amount',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF686A81),
                                fontSize: 18,
                                fontWeight: FontWeight.w400)
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: formatPrice2(
                          '${double.parse(model.total.toString()) + double.parse(model.data!.shippingTotal.toString())} ',
                            // model.data!.total.toString(),
                             model.data!.currencySymbol ?? '',
                          GoogleFonts.poppins(
                              color: const Color(0xFF686A81),
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      )],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: Text("Payment Method: ",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF686A81),
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(model.data!.paymentMethod.toString(),
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF686A81),
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                ]),
            SizedBox(
              height: size.height * .10,
            ),
            InkWell(
              onTap: () {
                Get.offAll(const MainHomeScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xffE50019),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Text(
                      'Go To Home',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    ));
  }
}

