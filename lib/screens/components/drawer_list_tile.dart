import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

import '../../constants/constants.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key, required this.title, required this.svgSrc, required this.tap})
      : super(key: key);

  final String title, svgSrc;
  final VoidCallback tap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tap,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Color.fromARGB(255, 93, 84, 84),
        height: 23,
      ),
      title: Text(
        title,
        style: GoogleFonts.quicksand(
            color: Color.fromARGB(255, 93, 84, 84),
            fontWeight: FontWeight.w500,
            fontSize: 15.0),
      ),
    );
  }
}
