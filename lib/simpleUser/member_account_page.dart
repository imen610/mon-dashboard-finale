import 'dart:convert';

import 'package:badges/badges.dart';

import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/data/json.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/widgets/transaction_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../shop/constants/base_api.dart';

import 'main_page/theme/colors.dart';
import 'main_page/widgets/balance_card.dart';

class MemberAccount extends StatefulWidget {
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

  MemberAccount(
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
  _MemberAccountState createState() => _MemberAccountState();
}

class _MemberAccountState extends State<MemberAccount> {
  var list_members = [];

  String image = '';
  bool isImageSelected = false;
  List members = [];
  var wallet;
  var user;
  @override
  void initState() {
    super.initState();
    this.getMembers();
    this.fetchwallet();
    this.getTransaction();
    setState(() {
      // _controllerUserName.text = widget.username;
      // _controllerEmail.text = widget.email;
      // _controllerphone.text = widget.phone;
      // _controllerlastName.text = widget.lastName;
      // _controllerfirstName.text = widget.firstName;
      // _controlleraddress.text = widget.address;
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
          SizedBox(
            width: 90,
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
                                'http://127.0.0.1:8000' +
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
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  getBalanceCard(),
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
          // Padding(
          //   padding: EdgeInsets.only(left: 15),
          //   child: getRecentUsers(),
          // ),
          SizedBox(
            height: 25,
          ),
          Container(
              padding: EdgeInsets.only(left: 20, right: 15),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transactions",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Today",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ))),
                  Icon(Icons.expand_more_rounded),
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
                                    fontSize: 15, fontWeight: FontWeight.w600)))
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Text('date',
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

    // print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      print(items);

      setState(() {
        list_members = items;
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
            //
            color: Color.fromARGB(255, 157, 244, 245),
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
