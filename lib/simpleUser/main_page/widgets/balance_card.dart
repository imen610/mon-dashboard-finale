import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/shop/constants/base_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../theme/colors.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  var wallet;
  var user;
  var list_members = [];
  var user_id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchwallet();
  
  }

  fetchwallet() async {
    var url = BASE_API + "my-wallet/";
    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      print(items['balance']);
      setState(() {
        wallet = items;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            //
            color: Color.fromARGB(255, 252, 193, 75),
            borderRadius: BorderRadius.circular(30),
            // boxShadow: [
            //   BoxShadow(
            //     color: shadowColor.withOpacity(0.1),
            //     spreadRadius: 1,
            //     blurRadius: 1,
            //     offset: Offset(1, 1), // changes position of shadow
            //   ),
            // ],
            // image: DecorationImage(
            //   colorFilter: new ColorFilter.mode(
            //       Colors.black.withOpacity(0.2), BlendMode.dstATop),
            //   image: AssetImage(""),
            // )
          ),
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                "Your Balance",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${wallet['balance']} DT",
                style: TextStyle(
                    color: secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: secondary,
                    shape: BoxShape.circle,
                    border: Border.all()),
                child: Icon(Icons.add)))
      ],
    );
  }
}
