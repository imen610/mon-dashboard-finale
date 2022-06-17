import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/models/analytic_info_model.dart';

class AnalyticInfoCard extends StatefulWidget {
  const AnalyticInfoCard({Key? key, required this.info}) : super(key: key);

  final AnalyticInfo info;

  @override
  State<AnalyticInfoCard> createState() => _AnalyticInfoCardState();
}

class _AnalyticInfoCardState extends State<AnalyticInfoCard> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (value) {
        setState(() {
          hovered = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 275),
        height: hovered ? 160.0 : 155.0,
        width: hovered ? 200.0 : 195.0,
        padding: EdgeInsets.symmetric(
          horizontal: appPadding,
          vertical: appPadding / 2,
        ),
        decoration: BoxDecoration(
            color: hovered ? widget.info.color : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(31, 91, 90, 90),
                blurRadius: 4.0,
                spreadRadius: 2.0,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.info.count}",
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                    color: hovered ? Colors.white : textColor,
                    fontSize: 18,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(appPadding / 2),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: hovered
                          ? Colors.white
                          : widget.info.color!.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    widget.info.svgSrc!,
                    color: widget.info.color,
                  ),
                )
              ],
            ),
            Text(
              widget.info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500,
                color: hovered ? Colors.white : textColor,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
