import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/user/constants/util.dart';
import 'package:responsive_admin_dashboard/user/create.dart';
import 'package:responsive_admin_dashboard/user/member.dart';
import 'package:responsive_admin_dashboard/user/theme/theme_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/components/UserAccountDash.dart';
import '../screens/components/UserBlockedProducts.dart';
import '../shop/constants/base_api.dart';
import 'edit.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List users = [];
  List usersOnSearch = [];
  List superuser = [];
  bool isLoading = false;
  TextEditingController? _textEditingController = TextEditingController();
  bool status = false;
  bool wstat = false;
  var id_user;
  @override
  void initState() {
    super.initState();
    this.fetchUsers();
  }

  fetchUsers() async {
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
        final superusers = users.where((user) {
          return (user['is_membre'] == false && user['is_admin'] == false);
        }).toList();
        superuser = superusers;
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
        leading: BackButton(
          color: Colors.black,
        ),
        actions: <Widget>[
          TextButton(
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
    if (isLoading || superuser.length == 0) {
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
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
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
                        controller: _textEditingController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "search for contacts"),
                        onChanged: (value) {
                          setState(() {
                            usersOnSearch = superuser
                                .where((user) => user['username']
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 9,
              child: _textEditingController!.text.isNotEmpty &&
                      usersOnSearch.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                          ),
                          Text(
                            'No results found',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _textEditingController!.text.isNotEmpty
                          ? usersOnSearch.length
                          : superuser.length,
                      itemBuilder: (context, index) {
                        return _textEditingController!.text.isNotEmpty
                            ? cardItem(usersOnSearch[index])
                            : cardItem(superuser[index]);
                      }))
        ],
      ),
    );
  }

  Widget cardItem(item) {
    var username = item['username'];
    var email = item['email'];
    var image = 'http://192.168.11.105:8000' + item['image'];
    print('<<<<<<<<<<<<<$image');
    var mem_length = item['membre'];
    List memL = item['membre'];
    var status_wallet = item['wallet_blocked'];
    // setState(() {
    //   id_user = item['id'];
    // });
    // print('useeeeeeeeeeeeeeeeeeeeeeeeeeer $id_user');

    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                              border: (status_wallet)
                                  ? Border.all(color: Colors.red)
                                  : Border.all(color: Colors.black)),
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
                              Row(
                                children: [
                                  Text(username.toString(),
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                  Spacer(),
                                  Container(
                                    margin: EdgeInsets.only(left: 80),
                                    child: FlutterSwitch(
                                      activeColor: Colors.red,
                                      width: 50.0,
                                      height: 25.0,
                                      valueFontSize: 20.0,
                                      toggleSize: 20.0,
                                      value: status_wallet,
                                      borderRadius: 20.0,
                                      padding: 4.0,
                                      // showOnOff: true,
                                      onToggle: (val) {
                                        setState(() {
                                          status_wallet = val;
                                          print('ggggggggggggg$val');
                                          wstat = val;
                                        });
                                        ppstWalletStatus(item['id']);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        email.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                // margin: EdgeInsets.only(),
                                child: Text(
                                  ' ${memL.length.toString()}  members',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 97, 95, 91)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            child: popUpMen(
                          menuList: [
                            PopupMenuItem(
                                child: InkWell(
                              onTap: () => editUser(item),
                              child: ListTile(
                                leading: Icon(
                                  Icons.edit,
                                  color: Color(0xff16F8FA),
                                ),
                                title: Text(
                                  'edit',
                                  style: TextStyle(
                                    color: Color(0xff16F8FA),
                                  ),
                                ),
                              ),
                            )),
                            PopupMenuItem(
                                child: InkWell(
                              onTap: () {
                                print("hello salma");
                                showDeleteAlert(context, item);
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.delete,
                                  color: Color(0xffFA1645),
                                ),
                                title: Text('delete',
                                    style: TextStyle(
                                      color: Color(0xffFA1645),
                                    )),
                              ),
                            )),
                            PopupMenuItem(
                                child: InkWell(
                              onTap: () => getaccount(item),
                              child: ListTile(
                                leading: Icon(
                                  Icons.account_balance_wallet,
                                  color: Color.fromARGB(255, 255, 206, 43),
                                ),
                                title: Text('account_view',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 206, 43),
                                    )),
                              ),
                            )),
                            PopupMenuItem(
                                child: InkWell(
                              onTap: () => getproductBlocked(item),
                              child: ListTile(
                                leading: Icon(
                                  Icons.block,
                                  color: Color.fromARGB(255, 255, 93, 43),
                                ),
                                title: Text('products block',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 93, 43),
                                    )),
                              ),
                            )),
                          ],
                          icon: Icon(
                            Icons.more_vert_rounded,
                            size: 30,
                          ),
                        ))
                      ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getproductBlocked(item) {
    var memberId = item['id'].toString();

    print(memberId);

    List prod_block = item['prod_block'];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => userProductBlocked(
                  memberId: memberId,
                  prod_block: prod_block,
                ))).then((value) {
      if (value != null && (value as List<int>).isNotEmpty) {
        (value as List<int>).forEach(
          (element) {
            prod_block.removeAt(element);
          },
        );
        setState(() {});
      }
    });
  }

  getaccount(item) {
    var memberId = item['id'].toString();

    print(memberId);

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
            builder: (context) => userAccountDash(
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
                ))).then((value) => fetchUsers());
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
      this.fetchUsers();
      // Navigator.of(context).pop();
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => IndexPage()),
      //     (Route<dynamic> route) => false);
    }
  }

  showDeleteAlert(BuildContext context, item) {
    // set up the buttons
    Widget noButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: primary),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => IndexPage()),
            (Route<dynamic> route) => false);
      },
    );

    Widget yesButton = TextButton(
      child: Text("Yes", style: TextStyle(color: primary)),
      onPressed: () {
        fetchUsers();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => IndexPage()),
            (Route<dynamic> route) => false);
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

  ppstWalletStatus(userId) async {
    var url = BASE_API + "UpdateWalletStatus/$userId/";

    SharedPreferences access_data = await SharedPreferences.getInstance();

    var response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json ; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${access_data.getString('access_token')}',
        },
        body: (jsonEncode({
          "is_disabled": wstat.toString(),
        })));
    print('$wstat');
    print('::::::::::::::::::::::::::::::::::');
    if (response.statusCode != 200) {
      fetchUsers();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("okk !!")));
    }
  }
}

class popUpMen extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;
  const popUpMen({Key? key, required this.menuList, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: ((context) => menuList), icon: icon);
  }
}
