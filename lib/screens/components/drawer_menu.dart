import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/screens/components/drawer_list_tile.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(appPadding),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: (50),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo1.png'))),
                    ),
                    Text(
                      'MyWallet',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 30,
                        //color: Colors.white
                      ),
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DrawerListTile(
              title: 'Users', svgSrc: 'assets/icons/Dashboard.svg', tap: () {}),
          DrawerListTile(
              title: 'Shops', svgSrc: 'assets/icons/BlogPost.svg', tap: () {}),
          DrawerListTile(
              title: 'Message', svgSrc: 'assets/icons/Message.svg', tap: () {}),
          DrawerListTile(
              title: 'Products',
              svgSrc: 'assets/icons/Statistics.svg',
              tap: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: grey,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
              title: 'Settings',
              svgSrc: 'assets/icons/Setting.svg',
              tap: () {}),
          DrawerListTile(
              title: 'Logout', svgSrc: 'assets/icons/Logout.svg', tap: () {}),
        ],
      ),
    );
  }
}



//  Expanded(
//                   child: Container(
//                     margin: EdgeInsets.only(top: 100, right: 100),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 70,
//                             width: 70,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image:
//                                         AssetImage('assets/images/logo1.png'))),
//                           ),
//                           Text(
//                             'MyWallet',
//                             style: TextStyle(
//                               fontFamily: 'Ubuntu',
//                               fontSize: 30,
//                             ),
//                           ),
//                         ]),
//                   ),
//                 ),