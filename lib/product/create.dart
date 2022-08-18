import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/product/theme/theme_colors.dart';
import 'constants/base_api.dart';
import 'constants/util.dart';

class createproduct extends StatefulWidget {
  const createproduct({Key? key}) : super(key: key);

  @override
  State<createproduct> createState() => _createproductState();
}

class _createproductState extends State<createproduct> {
  final TextEditingController _controllerproductName =
      new TextEditingController();
  final TextEditingController _controllerAddress =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('creating product')),
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
          controller: _controllerproductName,
          decoration: InputDecoration(
            hintText: "productname",
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
              CreateNewproduct();
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

  CreateNewproduct() async {
    var productName = _controllerproductName.text;
    var address = _controllerAddress.text;
    // print('productName : ${productName.text}');
    // print('productPrice: ${productPrice.text}');

    if (productName.isNotEmpty && address.isNotEmpty) {
      var url = BASE_API + "products/";
      var bodyData = json.encode({
        "name_product": productName,
        "address_product": address,
      });
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: bodyData);
      print(response.statusCode);
      print(response.body);
      var pro = json.decode(response.body)['productname'];
      print(pro);

      if (response.statusCode == 200) {
        setState(() {
          var messageSuccess = "";
          showMessage(context, messageSuccess);

          _controllerproductName.text = "";
          _controllerAddress.text = "";
        });
      } else {
        var message = 'success';
       showMessage(context, message);
      }
    }
  }
}
