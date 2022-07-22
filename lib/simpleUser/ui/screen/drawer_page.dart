import 'dart:convert';
import 'package:responsive_admin_dashboard/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/data/json.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shop/constants/base_api.dart';
import '../../../user/index.dart';
import '../../main_page/pages/home.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with TickerProviderStateMixin {
  bool sideBarActive = false;
  late AnimationController rotationController;
  @override
  var user;
  var id;
  bool isSelected = false;
  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    super.initState();
    this.fetchUSER();
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
      print(items['username']);
      
      SharedPreferences sharedPreferencesUserId =
          await SharedPreferences.getInstance();
      sharedPreferencesUserId.setString(
          appConstants.USER_ID, items['id'].toString());
      SharedPreferences.getInstance().then((sharedPrefValue) {
        setState(() {
          id = sharedPrefValue.getString(appConstants.USER_ID);
          print('token  $id');
        });
      });

      setState(() {
        user = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 223, 218, 218),
                              blurRadius: 0.2,
                              spreadRadius: 0.3)
                        ],
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(60)),
                        color: Colors.white),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello ${user['username']}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Welcome Back!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    navigatorTitle("Home", isSelected)
                    // navigatorTitle("Accounts", isSelected),
                    // navigatorTitle("Profile", isSelected),
                    // navigatorTitle("Transactions", isSelected),
                    // navigatorTitle("Stats", isSelected),
                    // navigatorTitle("Settings", isSelected),
                    // navigatorTitle("Help", isSelected),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.power_settings_new,
                      size: 24,
                      color: Theme.of(context).iconTheme.color,
                      // color: sideBarActive ? Colors.black : Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Logout",
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: (sideBarActive) ? MediaQuery.of(context).size.width * 0.6 : 0,
            top: (sideBarActive) ? MediaQuery.of(context).size.height * 0.2 : 0,
            child: RotationTransition(
              turns: (sideBarActive)
                  ? Tween(begin: -0.05, end: 0.0).animate(rotationController)
                  : Tween(begin: 0.0, end: -0.05).animate(rotationController),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: (sideBarActive)
                    ? MediaQuery.of(context).size.height * 0.7
                    : MediaQuery.of(context).size.height,
                width: (sideBarActive)
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: sideBarActive
                      ? const BorderRadius.all(Radius.circular(40))
                      : const BorderRadius.all(Radius.circular(0)),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: sideBarActive
                      ? const BorderRadius.all(Radius.circular(40))
                      : const BorderRadius.all(Radius.circular(0)),
                  child: const Home(),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 20,
            child: (sideBarActive)
                ? IconButton(
                    padding: const EdgeInsets.all(30),
                    onPressed: closeSideBar,
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).iconTheme.color,
                      size: 30,
                    ),
                  )
                : InkWell(
                    onTap: openSideBar,
                    child: Container(
                      margin: const EdgeInsets.all(17),
                      height: 30,
                      width: 30,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Row navigatorTitle(String name, bool isSelected) {
    return Row(
      children: [
// exemple*******************************************
        GestureDetector(
          onTap: () => {
            select(),
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => IndexPage()))
          },
          child: Row(
            children: [
              (isSelected)
                  ? Container(
                      width: 5,
                      height: 40,
                      color: const Color(0xffffac30),
                    )
                  : const SizedBox(
                      width: 5,
                      height: 40,
                    ),
              const SizedBox(
                width: 10,
                height: 45,
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 16,
                      fontWeight:
                          (isSelected) ? FontWeight.w700 : FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void closeSideBar() {
    sideBarActive = false;
    setState(() {});
  }

  void openSideBar() {
    sideBarActive = true;
    setState(() {});
  }

  void select() {
    isSelected = true;
    setState(() {});
  }
}
