import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/pages/home_page.dart';

import '../theme/colors.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int activeTab = 0;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appBgColor.withOpacity(.95),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: getBottomBar(),
          floatingActionButton: getHomeButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          body: getBarPage()),
    );
  }

  Widget getHomeButton() {
    return Container(
      margin: EdgeInsets.only(top: 35),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bottomBarColor,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            activeTab = 2;
          });
        },
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            )),
      ),
    );
  }

  Widget getBottomBar() {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: bottomBarColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(0.1),
                blurRadius: .5,
                spreadRadius: .5,
                offset: Offset(0, 1))
          ]),
      child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [])),
    );
  }

  Widget getBarPage() {
    return IndexedStack(
      index: activeTab,
      children: <Widget>[
        HomePage(),
      ],
    );
  }
}
