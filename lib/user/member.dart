import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:responsive_admin_dashboard/user/Untitled-1.dart';
import 'dart:io';
import 'package:responsive_admin_dashboard/constants/constants.dart';

import 'package:responsive_admin_dashboard/user/constants/util.dart';
import 'package:responsive_admin_dashboard/user/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product/theme/theme_colors.dart';
import '../screens/components/AddMember.dart';
import '../screens/components/UserAccountDash.dart';
import '../shop/constants/util.dart';

class member extends StatefulWidget {
  //const EditUser({Key? key}) : super(key: key);
  String memberId;
  String username;
  String email;
  String image;
  String phone;
  String firstName;
  String lastName;
  String address;
  List membre;

  member(
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
  State<member> createState() => _memberState();
}

class _memberState extends State<member> {
  // final TextEditingController _controllerUserName = new TextEditingController();
  // final TextEditingController _controllerEmail = new TextEditingController();
  // final TextEditingController _controllerphone = new TextEditingController();
  // final TextEditingController _controllerfirstName =
  //     new TextEditingController();
  // final TextEditingController _controllerlastName = new TextEditingController();
  // final TextEditingController _controlleraddress = new TextEditingController();
  String memberId = '';
  var id;
  bool isLoading = false;
  String image = '';
  bool isImageSelected = false;
  List members = [];
  List membersOnSearch = [];
  bool status = false;
  bool wstat = false;
  TextEditingController? _textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      memberId = widget.memberId;

      // _controllerUserName.text = widget.username;
      // _controllerEmail.text = widget.email;
      // _controllerphone.text = widget.phone;
      // _controllerlastName.text = widget.lastName;
      // _controllerfirstName.text = widget.firstName;
      // _controlleraddress.text = widget.address;
      image = widget.image;
      print(
          '::::::::::::::::::::::::::::::::::${image.substring(0, 4).toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Members",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMemberPage(id: memberId)))
                    .then((value) {
                  if (value != null) {
                    Map<String, dynamic> returnedValues =
                        value as Map<String, dynamic>;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => member(
                                  memberId: returnedValues.values.first,
                                  username: returnedValues.values.elementAt(1),
                                  email: returnedValues.values.elementAt(2),
                                  image: returnedValues.values.elementAt(3),
                                  phone: returnedValues.values.elementAt(4),
                                  firstName: returnedValues.values.elementAt(5),
                                  lastName: returnedValues.values.elementAt(6),
                                  address: returnedValues.values.elementAt(7),
                                  membre: returnedValues.values.last,
                                )));
                  }
                });
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
                        controller: _textEditingController,
                        onChanged: (value) {
                          setState(() {
                            membersOnSearch = widget.membre
                                .where((member) => member['username']
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
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
              child: _textEditingController!.text.isNotEmpty &&
                      membersOnSearch.isEmpty
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
                          ? membersOnSearch.length
                          : widget.membre.length,
                      itemBuilder: (context, index) {
                        return _textEditingController!.text.isNotEmpty
                            ? cardItem(membersOnSearch[index])
                            : cardItem(widget.membre[index]);
                      }))
        ],
      ),
    );
  }

  Widget cardItem(item) {
    var username = item['username'];
    var email = item['email'];
    var image = item['image'];
    var status_wallet = item['wallet_blocked'];

    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
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
                          image: (image.substring(0, 4).toString() == "http")
                              ? DecorationImage(
                                  image: NetworkImage(image.toString()),
                                  fit: BoxFit.cover)
                              : DecorationImage(
                                  image: NetworkImage('http://127.0.0.1:8000' +
                                      image.toString()),
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
                        Text(
                          email.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.5)),
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
                        onTap: () => showDeleteAlert(context, item),
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
                    ],
                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: 30,
                    ),
                  ))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getaccount(item) {
    var memberId = item['id'].toString();

    // print(memberId);

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

    if (response.statusCode != 200) {
      fetchUsers();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("okk !!")));
    }
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

  fetchUsers() async {
    String? token;
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        isLoading = false;
        token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);
      });
    });
    List users = [];
    var url = BASE_API + "users/";

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
      });

      return;
    } else {
      setState(() {
        users = [];
        isLoading = true;
      });
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
