import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension DeviceSizes on BuildContext{
  Size get getDeviceSize{
    return MediaQuery.of(this).size;
  }
}
extension CustomeSizedBox on int{
  SizedBox get slideX{
    return SizedBox(
      width: toDouble(),
    );
  }
}

extension PaddedWidget on Widget{
  Widget padded({EdgeInsetsGeometry? givePadding}){
    return Padding(
        padding: givePadding ?? EdgeInsets.zero,
        child: this,);
  }
  Widget get toAppIcon{
    return SvgPicture.asset(
        'assets/icons/chicken.svg',
        width: 20,
        height: 20,
      );
  }
  Widget get toAppIconLarge{
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: SvgPicture.asset(
          'assets/icons/chicken.svg',
          width: double.maxFinite,
          height: double.maxFinite,
        fit: BoxFit.contain,
        ),
    );
  }
  Widget get toLargeAppIcon => SvgPicture.asset(
    'assets/icons/logo_and_name.svg',
    width: 280,
  );
}

extension LatlongCheck on LatLng{
  LatLng get checkLatLong{
    return this == const LatLng(0,0) ? const LatLng(33.888630,35.495480) : this;
  }
}

extension CheckNullOrEmpty on String{
  bool get isNull{
    return (this == "" || this == "[]" || this == "null");
  }
}
