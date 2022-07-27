import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/models/analytic_info_model.dart';
import 'package:responsive_admin_dashboard/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../shop/constants/base_api.dart';

class AnalyticInfoCard extends StatefulWidget {
  const AnalyticInfoCard({Key? key, required this.info}) : super(key: key);

  final AnalyticInfo info;

  @override
  State<AnalyticInfoCard> createState() => _AnalyticInfoCardState();
}

class _AnalyticInfoCardState extends State<AnalyticInfoCard> {
  bool hovered = false;
  List users = [];
  bool isLoading = false;
  List shops = [];

  @override
  void initState() {
    super.initState();
    this.fetchShop();
    this.fetchUsers();
    this.fetchtransactions();
  }

  fetchShop() async {
    setState(() {
      isLoading = false;
    });
    var url = BASE_API + "shops/";
    print(url);
    var response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(items);
      setState(() {
        shops = items;
        isLoading = false;
      });
      return;
    } else {
      setState(() {
        shops = [];
        isLoading = true;
      });
    }
  }

  fetchUsers() async {
    String? token;
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        isLoading = false;
        token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);
        // print('Bearer $token');
        // print(token);
      });
    });

    var url = BASE_API + "users/";
    //String? token;
    print(url);
    SharedPreferences access_data = await SharedPreferences.getInstance();

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}',
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);

      setState(() {
        users = items;

        isLoading = false;
      });

      return;
    } else {
      setState(() {
        users = [];
        isLoading = true;
      });
    }
  }

  List list_transactions = [];
  List list_members = [];
  fetchtransactions() async {
    String? token;
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        isLoading = false;
        token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);
      });
    });

    var url = BASE_API + "transactions/";

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      print(' voici la liste des transactions $items');
      setState(() {
        list_transactions = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.info.title.toString() == 'Users') {
      setState(() {
        widget.info.count = users.length;
      });
    } else if (widget.info.title.toString() == 'shops') {
      widget.info.count = shops.length;
    } else if (widget.info.title.toString() == 'transactions') {
      widget.info.count = shops.length;
    }
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
        child: InkWell(
          onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => widget.info.route))
          },
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
      ),
    );
  }
}
