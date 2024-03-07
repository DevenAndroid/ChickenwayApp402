import 'package:dinelah/res/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VersionUpdate extends StatefulWidget {

  const VersionUpdate({Key? key}) : super(key: key);

  @override
  State<VersionUpdate> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<VersionUpdate> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: InkWell(

                onTap: (){

                },
                child: Text("Update Available")))
          ],
        ));
  }
}
