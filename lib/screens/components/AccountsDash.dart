import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/screens/components/UserAccountDash.dart';
import 'package:responsive_admin_dashboard/user/constants/util.dart';
import 'package:responsive_admin_dashboard/user/create.dart';
import 'package:responsive_admin_dashboard/user/theme/theme_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../user/edit.dart';

// import 'edit.dart';

class AccountsDashPage extends StatefulWidget {
  const AccountsDashPage({Key? key}) : super(key: key);

  @override
  State<AccountsDashPage> createState() => _AccountsDashPageState();
}

class _AccountsDashPageState extends State<AccountsDashPage> {
  List members = [];
  var wallet;
  bool isLoading = false;
  var memberId = '';
  bool status = false;
  bool wstat = false;
  @override
  void initState() {
    super.initState();
    this.fetchMembers();
    isLoading = true;
  }

  fetchMembers() async {
    SharedPreferences ID_USER = await SharedPreferences.getInstance();
    var x = ID_USER.getString('user_id');
    print('id get from constant $x');
    var url = BASE_API + "users/";
    print(x);

    String? token;
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        isLoading = false;
        token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);

      });
    });

    
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
        members = items;
        isLoading = false;
      });

      return;
    } else {
      setState(() {
        members = [];
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
          "members ",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
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
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : getBody(),
    );
  }

  Widget getBody() {
    if (isLoading || members.length == 0) {
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
                          hintText: "search for contacts",
                        ),
                        onChanged: searchMember,
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
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return cardItem(members[index]);
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
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => getaccount(item),
                child: Container(
                 
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
                                  Container(
                                    margin: EdgeInsets.only(left: 80),
                                    child: FlutterSwitch(
                                      activeColor: Colors.red,
                                      width: 70.0,
                                      height: 35.0,
                                      valueFontSize: 30.0,
                                      toggleSize: 30.0,
                                      value: status_wallet,
                                      borderRadius: 30.0,
                                      padding: 4.0,
                                      // showOnOff: true,
                                      onToggle: (val) {
                                        setState(() {
                                          status_wallet = val;
                                          print('ggggggggggggg$val');
                                          wstat = val;

                                          // item['is_disabled'] = val;
                                          // print(item['is_disabled']);
                                        });
                                        ppstWalletStatus(item['id']);
                                      },
                                    ),
                                  ),
                                ],
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
                  
                
                ),
              )
            ],
          ),
        ),
      ),
    );
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
      var items = jsonDecode(response.body);
      print(items);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AccountsDashPage()),
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

  void searchMember(String query) {
    print(query);
    final suggestions = members.where((user) {
      final username = user['username'].toString().toLowerCase();
      final input = query.toLowerCase();
      return username.contains(input);
    }).toList();
    print(suggestions);
    if (suggestions != []) {
      setState(() {
        members = suggestions;
      });
    } else {
      setState(() {
        members = members;
      });
    }
  }

  getwalletStatus(userId) async {
    var url = BASE_API + "my-wallet/$userId/";

    print('____________________________');
    print(userId);
    print('____________________________');

    SharedPreferences access_data = await SharedPreferences.getInstance();

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}',
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);

      setState(() {
        wallet = items;
        isLoading = false;
        print(wallet['is_disabled']);
        status = wallet['is_disabled'];
      });

      return;
    } else {
      setState(() {
        wallet = [];
        isLoading = true;
      });
    }
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("okk !!")));
    }
  }
}
