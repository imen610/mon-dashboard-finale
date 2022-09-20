import 'dart:convert';

import 'package:badges/badges.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/data/json.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/widgets/transaction_item.dart';
import 'package:responsive_admin_dashboard/simpleUser/send_money.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../shop/constants/base_api.dart';

import '../../simpleUser/AmountAllowedpage.dart';
import '../../simpleUser/list_product_paied.dart';
import '../../simpleUser/main_page/theme/colors.dart';
import '../../simpleUser/main_page/widgets/balance_card.dart';

class userAccountDash extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);
  String memberId;
  String username;
  String email;
  String image;
  String phone;
  String firstName;
  String lastName;
  String address;
  List membre;

  userAccountDash(
      {required this.memberId,
      required this.username,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.image,
      required this.membre});

  @override
  _userAccountDashState createState() => _userAccountDashState();
}

class _userAccountDashState extends State<userAccountDash> {
  var list_members = [];

  String image = '';
  bool isImageSelected = false;
  List members = [];
  var wallet;
  var user;
  List list_shops = [];

  bool pay = false;
  bool trans = false;
  bool isLoading = false;
  List list_payments = [];
  @override
  void initState() {
    super.initState();
    this.getShops();

    this.getMembers();
    this.fetchwallet();
    this.getTransaction();
    this.fetchpayments();

    isLoading1 = true;
    isLoading2 = true;
    isLoading3 = true;
    setState(() {
      image = widget.image;
    });
    print(widget.memberId);
    print(widget.username);
    print(widget.email);
    print(widget.image);
    print(widget.phone);
    print(widget.lastName);
    print(widget.firstName);
    print(widget.address);
    print("hello ACCOUNT MEMBER YEAAAH !!!!!");
    print(widget.membre);
    print("users  ");
    var name = widget.membre.length;

    print(name);
  }

  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
  List list_transactions = [];
  fetchwallet() async {
    var url = BASE_API + "my-wallet/${widget.memberId}/";
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
        isLoading1 = false;
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

    var url = BASE_API + "payments/${widget.memberId}/${widget.username}/";

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

  getTransaction() async {
    var url = BASE_API + "transactions/${widget.memberId}/${widget.username}/";
    print('this is our url');
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
        isLoading2 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(330.0), // here the desired height
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
                width: 120,
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
                                "${widget.username}",
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
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: Colors.black)),
                        child: Center(
                            child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    widget.image.toString(),
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
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                getBalanceCard(),
                // Positioned(
                //     top: 100,
                //     left: 0,
                //     right: 0,
                //     child: Container(
                //         padding: EdgeInsets.all(5),
                //         decoration: BoxDecoration(
                //             color: secondary,
                //             shape: BoxShape.circle,
                //             border: Border.all()),
                //         child: Icon(Icons.add)))
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
          height: 20,
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
            ))
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

  getSearchBox() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 238, 235, 235),
              shape: BoxShape.circle),
          child: Icon(Icons.search_rounded),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Search",
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

    print(type);
    print(name2);
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
                                    image: NetworkImage(image2),
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
    var url2 = BASE_API + "users/";
    print(x);
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
        list_members = items;
        isLoading3 = false;
      });
    }
  }

  getBalanceCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 157, 244, 245),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
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
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AmountAllowedPage(
                              id: widget.memberId,
                              username: widget.username,
                              email: widget.email,
                              image: widget.image,
                              phone: widget.phone,
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                              address: widget.address,
                              membre: widget.membre)))
                },
                //  {
                //   print('hello');
                //   AmountAllowedPage(id: widget.memberId);
                // },
                child: Text(
                  "Amount allowed",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${wallet['maxAmount']} DT",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        // Positioned(
        //     top: 100,
        //     left: 0,
        //     right: 0,
        //     child: Container(
        //         padding: EdgeInsets.all(5),
        //         decoration: BoxDecoration(
        //             color: secondary,
        //             shape: BoxShape.circle,
        //             border: Border.all()),
        //         child: InkWell(
        //           onTap: () {},
        //           child: Icon(Icons.add),
        //         )))
      ],
    );
  }
}
