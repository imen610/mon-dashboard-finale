import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/pages/home.dart';
import 'package:responsive_admin_dashboard/pages/login.dart';
import 'package:responsive_admin_dashboard/product/constants/base_api.dart';
import 'package:responsive_admin_dashboard/simpleUser/ui/screen/drawer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: email == null ? login() : MyApp()));
  // runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  var user;
  var id;
  bool progress = false;
  @override
  void initState() {
    this.fetchUSER();
    progress = true;
    super.initState();
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

      setState(() {
        user = items;
        progress = false;
      });
    } else {
      setState(() {
        user = [];
        progress = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (progress)
        ? Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : MaterialApp(
            routes: {
              '/home': (context) => home(),
            },
            debugShowCheckedModeBanner: false,
            home: (user['is_admin'] == null)
                ? login()
                : (user['is_admin'])
                    ? home()
                    : DrawerPage(),
          );
  }
}
