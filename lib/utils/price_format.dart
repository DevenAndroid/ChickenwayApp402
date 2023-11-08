import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatPrice3(dynamic value) {
  final formatter = NumberFormat.decimalPattern('en_us');
  return formatter.format(double.parse(value.toString()));
}

Row formatPrice2(dynamic value, String currencySymbol, TextStyle textStyle,
    {TextAlign? textAlign}) {
  double number = double.parse(value.toString()).roundToDouble();

  final formatter = NumberFormat.decimalPattern('en_us');

  String result = '';
  String lastThree = '';

  if (number >= 1000) {
    String str = number.toInt().toString();
    str = str.substring(0, str.length - 3);

    lastThree = number.toInt().toString().substring(number.toInt().toString().length - 3);

    result = '${formatter.format(int.parse(str))},';
  } else {
    result = formatter.format(number);
  }

  return Row(
    children: [
      Text(
        result,
        style: textStyle,
      ),
      if (number >= 1000)
        Text(
          lastThree,
          style: textStyle.copyWith(fontSize: 10),
        ),
      Text(
        currencySymbol,
        style: textStyle,
        textAlign: textAlign,
      )
    ],
  );
}
