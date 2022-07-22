import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/shop/theme/theme_colors.dart';
import 'constants/base_api.dart';
import 'constants/util.dart';

class createshop extends StatefulWidget {
  const createshop({Key? key}) : super(key: key);

  @override
  State<createshop> createState() => _createshopState();
}

class _createshopState extends State<createshop> {
  final TextEditingController _controllershopName =
      new TextEditingController();
  final TextEditingController _controllerAddress =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('creating shop')),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      padding: EdgeInsets.all(30),
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllershopName,
          decoration: InputDecoration(
            hintText: "shopname",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerAddress,
          decoration: InputDecoration(
            hintText: "address",
          ),
        ),
        SizedBox(
          height: 40,
        ),
        FlatButton(
            color: primary,
            onPressed: () {
              CreateNewshop();
            },
            child: Text(
              "done",
              style: TextStyle(
                color: white,
              ),
            ))
      ],
    );
  }

  CreateNewshop() async {
    var shopName = _controllershopName.text;
    var address = _controllerAddress.text;
    // print('shopName : ${shopName.text}');
    // print('shopPrice: ${shopPrice.text}');

    if (shopName.isNotEmpty && address.isNotEmpty) {
      var url = BASE_API + "shops/";
      var bodyData = json.encode({
        "name_shop": shopName,
        "address_shop": address,
      });
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: bodyData);
      print(response.statusCode);
      print(response.body);
      var pro = json.decode(response.body)['shopname'];
      print(pro);

      if (response.statusCode == 200) {
        setState(() {
          var messageSuccess = "";
          showMessage(context, messageSuccess);

          _controllershopName.text = "";
          _controllerAddress.text = "";
        });
      } else {
        var message = 'success';
       showMessage(context, message);
      }
    }
  }
}
