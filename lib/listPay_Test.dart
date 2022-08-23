import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import '../../shop/constants/base_api.dart';
import 'package:http/http.dart' as http;

import '../../simpleUser/main_page/theme/colors.dart';

class listPay_Interface extends StatefulWidget {
  listPay_Interface({Key? key}) : super(key: key);

  @override
  State<listPay_Interface> createState() => _listPay_InterfaceState();
}

class _listPay_InterfaceState extends State<listPay_Interface> {
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading3 = false;

  @override
  void initState() {
    super.initState();
    this.fetchtransactions();
    this.getusers();
    this.getShops();
    // isLoading1 = true;
    // isLoading2 = true;
  }

  var user;

  List list_shops = [];
  List list_payments = [];
  List list_users = [];
  fetchtransactions() async {
    String? token;
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        isLoading1 = false;
        token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);
      });
    });

    var url = BASE_API + "PaymentShopsAdminDashView/";

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(' voici la liste des transactions $items');
      setState(() {
        list_payments = items;
      });
    }
  }

  getusers() async {
    // SharedPreferences ID_USER = await SharedPreferences.getInstance();
    // var x = ID_USER.getString('user_id');
    // print('id get from constant $x');
    var url2 = BASE_API + "users/";
    // print(x);
    // print(url2);

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url2), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });

    // print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(items);

      setState(() {
        list_users = items;
        isLoading2 = false;
      });
    }
  }

  getShops() async {
    SharedPreferences ID_USER = await SharedPreferences.getInstance();
    var x = ID_USER.getString('user_id');
    // print('id get from constant $x');
    var url2 = BASE_API + "shops/";
    // print(x);
    // print(url2);

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url2), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });

    // print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(items);

      setState(() {
        list_shops = items;
        isLoading2 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: getAppBar(),
      body: getBody(),
    );
  }

  getAppBar() {
    return Container(
      height: 90,
      padding: EdgeInsets.only(left: 15, right: 20, top: 5),
      decoration: BoxDecoration(
          color: appBgColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(0.1),
                blurRadius: .5,
                spreadRadius: .5,
                offset: Offset(0, 1))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: new Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SizedBox(
            width: 175,
          ),
          Container(
            margin: EdgeInsets.only(right: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo1.png'))),
              ),
              Text(
                'MyWallet',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 20,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          getAppBar(),
          SizedBox(
            height: 25,
          ),
          Container(
              padding: EdgeInsets.only(left: 20, right: 15),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Transactions",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: getTransanctions(),
          ),
        ],
      ),
    );
  }

  getTransanctions() {
    return Column(
        children: List.generate(
            list_payments.length,
            (index) => Container(
                margin: const EdgeInsets.only(right: 15),
                child: TransactionItems(index))));
  }

  Widget TransactionItems(item) {
    String img = list_payments[item]['account']['image'].toString();
    String name = list_payments[item]['account']['username'];
    String amount = list_payments[item]['amount'];
    String type = list_payments[item]['type'];
    String name2 = list_payments[item]['to'];
    // print('xxxxxxxxxxxxxxxxxxxxx${list_payments[item]['list_products_id']}');

    var result = [
      for (var user in list_shops)
        if (user["name_shop"] == name2) user['image_shop']
    ];
    print(result);
    String image2 = result.isEmpty ? null : result.first;
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.black)),
              child: Center(
                  child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: NetworkImage('http://127.0.0.1:8000' + img),
                        fit: BoxFit.cover)),
              )),
            ),
            SizedBox(
              width: 7,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(
                      width: 3,
                    ),
                    Icon(
                      Icons.fast_forward_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(name2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                Container(
                    child: Text(
                        '${DateFormat.yMd().add_jm().format(DateTime.tryParse(list_payments[item]['timestamp']))}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey))),
              ],
            ),
            SizedBox(
              width: 7,
            ),
            Container(
              margin: EdgeInsets.only(top: 3),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.black)),
              child: Center(
                  child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: NetworkImage('http://127.0.0.1:8000' + image2),
                        fit: BoxFit.cover)),
              )),
            ),
            SizedBox(
              width: 7,
            ),
            Container(
                child: Text(amount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))
          ],
        ));
  }
}
