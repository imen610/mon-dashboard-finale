import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import '../shop/constants/base_api.dart';
import 'package:http/http.dart' as http;

import 'list_product_paied.dart';
import 'main_page/theme/colors.dart';

class paymentsPage extends StatefulWidget {
  const paymentsPage({Key? key}) : super(key: key);

  @override
  State<paymentsPage> createState() => _paymentsPageState();
}

class _paymentsPageState extends State<paymentsPage> {
  bool isLoading = true;
  bool isLoading2 = true;
  bool isLoading3 = true;

  @override
  void initState() {
    super.initState();
    this.fetchpayments();
    this.getShops();
    this.fetchUSER();
  }

  var user;
  List list_payments = [];
  List list_shops = [];
  fetchpayments() async {
    String? token;
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        isLoading = false;
        token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);
      });
    });

    var url = BASE_API + "transactionsShop/";

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(' voici la liste des payments $items');
      setState(() {
        list_payments = items;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: getAppBar(),
      body: (isLoading || isLoading2 || isLoading3)
          ? Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : getBody(),
    );
  }

  getAppBar() {
    return Container(
      height: 100,
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
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
            width: 135,
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 227, 219, 219).withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            // child: Icon(Icons.notifications_rounded)
            child: Container(
              padding: EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user['username'].toString()}",
                            style: TextStyle(
                                color: Color.fromARGB(255, 34, 33, 33),
                                fontSize: 13),
                          )
                        ]),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                        child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image: NetworkImage(
                                'http://127.0.0.1:8000' +
                                    user['image'].toString(),
                              ),
                              fit: BoxFit.cover)),
                    )),
                  ),
                ],
              ),
            ),
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
                      "payments",
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

  getproducts(item) {
    String listId = list_payments[item]['product']['id'].toString();
    print(listId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => listProducts(
                  listId: listId,
                )));
  }

  Widget TransactionItems(item) {
    String img = list_payments[item]['account']['image_shop'].toString();
    String name = list_payments[item]['account']['name_shop'];
    String amount = list_payments[item]['amount'];
    String type = list_payments[item]['type'];
    String name2 = list_payments[item]['to'];

    print(type);
    var result = [
      for (var shop in list_shops)
        if (shop["name_shop"] == name2) shop['image_shop']
    ];
    print(result);
    print(result);
    String image2 = result.isEmpty ? null : result.first;
    print('wwwwwwwwwwwwwwwwwwww${list_payments[item]['product']['product']}');
    return GestureDetector(
      // onTap: widget.onTap,
      child: Container(
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
        child: InkWell(
          onTap: () => getproducts(item),
          child: Column(
            children: [
              SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: type == 'Inflow'
                        ? Container(
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
                                      image: NetworkImage(
                                          'http://127.0.0.1:8000' + img),
                                      fit: BoxFit.cover)),
                            )),
                          )
                        : Container(
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
                                      image: NetworkImage(
                                          'http://127.0.0.1:8000' + image2),
                                      fit: BoxFit.cover)),
                            )),
                          ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                  child: type == 'Inflow'
                                      ? Text(name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700))
                                      : Text(name2,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)))),
                          SizedBox(width: 5),
                          Container(
                              child: Text(amount,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)))
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              child: Text(
                                  '${DateFormat.yMd().add_jm().format(DateTime.tryParse(list_payments[item]['timestamp']))}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey))),
                          Container(
                              child: type == 'Inflow'
                                  ? Icon(
                                      Icons.download_rounded,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.upload_rounded,
                                      color: Colors.red,
                                    )),
                        ],
                      ),
                    ],
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getShops() async {
    SharedPreferences ID_USER = await SharedPreferences.getInstance();
    var x = ID_USER.getString('user_id');
    // print('id get from constant $x');
    var url2 = BASE_API + "shops/";
    // print(x);
    print(url2);

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url2), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });

    // print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      print(items);

      setState(() {
        list_shops = items;
        isLoading2 = false;
      });
    }
  }

  fetchUSER() async {
    var url = BASE_API + "current/";
    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(items['username']);

      setState(() {
        user = items;
        isLoading3 = false;
      });
    }
  }
}
