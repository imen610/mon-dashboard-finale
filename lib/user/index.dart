import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/user/Listmembers.dart';
import 'package:responsive_admin_dashboard/user/constants/util.dart';
import 'package:responsive_admin_dashboard/user/create.dart';
import 'package:responsive_admin_dashboard/user/member.dart';
import 'package:responsive_admin_dashboard/user/theme/theme_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchProduct();
  }

  fetchProduct() async {
    final client = Dio();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Users",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => createuser()));
              },
              child: Icon(
                Icons.add,
                color: Colors.black,
              ))
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (isLoading || users.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // Text(
                //   "Users",
                //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  child: Row(children: [
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Feather.search,
                      ),
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "search for contacts"),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 9,
              child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return cardItem(users[index]);
                  })
                  )
        ],
      ),
    );
  }

  Widget cardItem(item) {
    var username = item['username'];
    var email = item['email'];
    var image = item['image'];
    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => getmember(item),
                child: Container(
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 204, 200, 200)
                                    .withOpacity(0.15),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 1))
                          ],
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(33)),
                      child: Row(children: [
                        SizedBox(
                          width: 20,
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
                                    image: NetworkImage(image.toString()),
                                    fit: BoxFit.cover)),
                          )),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(username.toString(),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                email.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: Color(0xff16F8FA),
                        icon: Icons.edit,
                        onTap: () => editUser(item),
                      ),
                      IconSlideAction(
                          caption: 'Delete',
                          color: Color(0xffFA1645),
                          icon: Icons.delete,
                          onTap: () => showDeleteAlert(context, item)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getmember(item) {
    var memberId = item['id'].toString();
    var username = item['username'].toString();
    var email = item['email'].toString();
    var image = item['image'].toString();
    var firstName = item['first_name'].toString();
    var lastName = item['last_name'].toString();
    var phone = item['phone'].toString();
    var address = item['address'].toString();
    var membre = item['membre'];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => member(
                  memberId: memberId,
                  username: username,
                  email: email,
                  phone: phone,
                  firstName: firstName,
                  lastName: lastName,
                  address: address,
                  image: image,
                  membre: membre,
                )));
  }

  editUser(item) {
    var userId = item['id'].toString();
    var username = item['username'].toString();
    var email = item['email'].toString();
    var image = item['image'].toString();
    var firstName = item['first_name'].toString();
    var lastName = item['last_name'].toString();
    var phone = item['phone'].toString();
    var address = item['address'].toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditUser(
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

  deleteUser(userId) async {
    print(userId);
    var url = BASE_API + "users/$userId/";
    var response = await http.delete(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      this.fetchProduct();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => IndexPage()),
          (Route<dynamic> route) => false);
    }
  }

  showDeleteAlert(BuildContext context, item) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(color: primary),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Yes", style: TextStyle(color: primary)),
      onPressed: () {
        Navigator.pop(context);

        deleteUser(item['id']);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Would you like to delete this user?"),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
