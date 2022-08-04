import 'dart:convert';

import 'package:badges/badges.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/data/json.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/widgets/transaction_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../shop/constants/base_api.dart';
import '../../send_money.dart';
import '../theme/colors.dart';
import '../widgets/action_box.dart';
import '../widgets/avatar_image.dart';
import '../widgets/balance_card.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var list_members = [];
  bool isLoading2 = false;
  bool isLoading3 = false;
  @override
  void initState() {
    super.initState();
    this.getMembers();
    this.getTransaction();
    isLoading2 = true;
    isLoading3 = true;
  }

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
      print(' voici la liste des transactions $items');
      // print(items['timestamp'].toString());
      // var formatter = new DateFormat('yyyy-MM-dd');
      // String formatted = formatter.format(items['timestamp']);
      // print('formatted $formatted');
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
      // appBar: getAppBar(),
      body: (isLoading2 == true && isLoading3 == true)
          ? Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : getBody(),
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
            width: 160,
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
            child: Badge(
                padding: EdgeInsets.all(3),
                position: BadgePosition.topEnd(top: -5, end: 2),
                badgeContent: Text(
                  '',
                  style: TextStyle(color: Colors.white),
                ),
                child: Icon(Icons.notifications_rounded)),
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
                  BalanceCard(),
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
                  SizedBox(
                    width: 160,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        "payments",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    //  Container(
                    //     alignment: Alignment.centerRight,
                    //     child: Text(
                    //       "Today",
                    //       style: TextStyle(
                    //           fontSize: 14, fontWeight: FontWeight.w500),
                    //     ))
                  ),
                  // Icon(Icons.expand_more_rounded),
                ],
              )),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: (list_transactions.length != 0 || isLoading2 == false)
                ? getTransanctions()
                : Center(child: Text('No Transactions')),
          ),
        ],
      ),
    );
  }

  getActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 15,
        ),
        Expanded(
            child: ActionBox(
          title: "Send",
          icon: Icons.send_rounded,
          bgColor: green,
        )),
        SizedBox(
          width: 15,
        ),
        Expanded(
            child: ActionBox(
                title: "Request",
                icon: Icons.arrow_circle_down_rounded,
                bgColor: yellow)),
        SizedBox(
          width: 15,
        ),
        Expanded(
            child: ActionBox(
                title: "More", icon: Icons.widgets_rounded, bgColor: purple)),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }

  getRecentUsers() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 5),
      scrollDirection: Axis.horizontal,
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
    );
  }

  Widget getmemberitems(item) {
    String image = list_members[item]['image'].toString();
    String URL_image = 'http://127.0.0.1:8000' + image;
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
                      image: NetworkImage('http://127.0.0.1:8000' + image),
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

    print(
        'timestamp___________________________ ${list_transactions[item]['timestamp']}');
    print(DateFormat.yMMMd()
        .format(DateTime.tryParse(list_transactions[item]['timestamp'])));
    // var x =
    //     DateFormat("dd-MM-yyyy").parse(list_transactions[item]['timestamp']);
    // print('xxxxxxxx___________________________$x');
    // var formatter = new DateFormat('yyyy-MM-dd');
    // String formatted = formatter.format(list_transactions[item]['timestamp']);
    // print('formatted $formatted');
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
                                    color: green,
                                  )
                                : Icon(
                                    Icons.upload_rounded,
                                    color: red,
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
    print(image);
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
