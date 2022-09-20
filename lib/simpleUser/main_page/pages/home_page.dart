import 'dart:convert';

import 'package:badges/badges.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/data/json.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/widgets/transaction_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../shop/constants/base_api.dart';
import '../../list_product_paied.dart';
import '../../send_money.dart';
import '../theme/colors.dart';

import '../widgets/action_box.dart';
import '../widgets/avatar_image.dart';
import '../widgets/balance_card.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var list_members = [];
  var list_products = [];
  bool isLoading2 = false;
  bool isLoading3 = false;
  bool pay = false;
  bool trans = false;
  @override
  void initState() {
    super.initState();
    this.getShops();
    this.getMembers();
    this.getTransaction();
    this.fetchpayments();
    isLoading2 = true;
    isLoading3 = true;
  }

  bool isLoading = false;
  List list_payments = [];
  List list_shops = [];
  List list_transactions = [];

  getTransaction() async {
    var url = BASE_API + "transactions/";

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);

      setState(() {
        list_transactions = items;
        isLoading2 = false;
      });
    }
  }

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(445.0), // here the desired height
        child: getAppBar(),
      ),
      body: (isLoading2 == true && isLoading3 == true)
          ? Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : getBody(),
    );
  }

  getAppBar() {
    return Column(
      children: [
        Container(
          height: 100,
          padding: EdgeInsets.only(left: 30, right: 20, top: 20),
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
              SizedBox(
                width: 160,
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 227, 219, 219).withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.fiber_smart_record_rounded,
                    size: 35,
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                BalanceCard(),
              ],
            )),
        Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            )),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: getRecentUsers(),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 15),
            alignment: Alignment.centerLeft,
            child: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        pay = false;
                        trans = true;
                      });
                    },
                    child: Text(
                      "Transactions",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        pay = true;
                        trans = false;
                      });
                    },
                    child: Text(
                      "payments",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          (trans == true || pay == false)
              ? Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: (list_transactions.length != 0 || isLoading2 == false)
                      ? getTransanctions()
                      : Center(child: Text('No Transactions')),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: (list_payments.length != 0)
                      ? getPayments()
                      : Center(child: Text('No Transactions')),
                ),
        ],
      ),
    );
  }

  getproducts(item) {
    String listId = list_payments[item]['product']['id'].toString();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => listProducts(
                  listId: listId,
                )));
  }

  getPayments() {
    return Column(
        children: List.generate(
            list_payments.length,
            (index) => Container(
                margin: const EdgeInsets.only(right: 15),
                child: PaymentsItems(index))));
  }

  Widget PaymentsItems(item) {
    String img1 = list_payments[item]['account']['image_shop'].toString();
    String name1 = list_payments[item]['account']['name_shop'];
    String amount = list_payments[item]['amount'];
    String type = list_payments[item]['type'];
    String name2 = list_payments[item]['to'];

    var result = [
      for (var shop in list_shops)
        if (shop["name_shop"] == name2) shop['image_shop']
    ];

    String image2 = result.isEmpty ? null : result.first;
    return GestureDetector(
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
                                          'http://192.168.43.61:8000' + img1),
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
                                          'http://192.168.43.61:8000' + image2),
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
                                      ? Text(name1,
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
    var url2 = BASE_API + "shops/";

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url2), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);

      setState(() {
        list_shops = items;
        isLoading2 = false;
      });
    }
  }

  getRecentUsers() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 5),
      scrollDirection: Axis.horizontal,
      child: Flexible(
        child: Row(
            children: List.generate(
                list_members.length,
                (index) => index == 0
                    ? Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            child: getSearchBox(),
                          ),
                          Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: getmemberitems(index))
                        ],
                      )
                    : Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: getmemberitems(index)))),
      ),
    );
  }

  Widget getmemberitems(item) {
    String image = list_members[item]['image'].toString();
    String URL_image = 'http://192.168.43.61:8000' + image;
    print(URL_image);
    var username = list_members[item]['username'];
    print('hello_hello_hello $username');
    return Column(
      children: [
        InkWell(
          onTap: () => send(list_members[item]),
          child: Container(
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
                      image: NetworkImage('http://192.168.43.61:8000' + image),
                      fit: BoxFit.cover)),
            )),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          username,
          style: TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  getSearchBox() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 238, 235, 235),
              shape: BoxShape.circle),
          child: Icon(Icons.arrow_forward),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "send_money",
          style: TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  getTransanctions() {
    return Column(
        children: List.generate(
            list_transactions.length,
            (index) => Container(
                margin: const EdgeInsets.only(right: 15),
                child: TransactionItems(index))));
  }

  Widget TransactionItems(item) {
    String img = list_transactions[item]['account']['image'].toString();
    String name = list_transactions[item]['account']['username'];
    String amount = list_transactions[item]['amount'];
    String type = list_transactions[item]['type'];
    String name2 = list_transactions[item]['to'];

    var result = [
      for (var member in list_members)
        if (member["username"] == name2) member['image']
    ];
    String image2 = result.isEmpty ? null : result.first;
    print(image2);
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
                                        'http://192.168.43.61:8000' + img),
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
                                        'http://192.168.43.61:8000' + image2),
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
                                    fontSize: 15, fontWeight: FontWeight.w600)))
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Text(
                                '${DateFormat.yMd().add_jm().format(DateTime.tryParse(list_transactions[item]['timestamp']))}',
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
    );
  }

  getMembers() async {
    SharedPreferences ID_USER = await SharedPreferences.getInstance();
    var x = ID_USER.getString('user_id');
    print('id get from constant $x');
    var url2 = BASE_API + "usermem/$x/";
    print(x);
    print(url2);

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url2), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);

      setState(() {
        list_members = items;
        // print('wwwwwwwwwwwwwwwwwwwwwwwww${list_members}');
        isLoading3 = false;
      });
    }
  }

  send(index) {
    var userId = index['id'].toString();
    print('the last $userId');
    var username = index['username'].toString();
    var email = index['email'].toString();
    var image = index['image'].toString();
    var firstName = index['first_name'].toString();
    var lastName = index['last_name'].toString();
    var phone = index['phone'].toString();
    var address = index['address'].toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SendMoney(
                  userId: userId,
                  username: username,
                  email: email,
                  phone: phone,
                  firstName: firstName,
                  lastName: lastName,
                  address: address,
                  image: image,
                )));
  }
}
