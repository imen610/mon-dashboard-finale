import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/screens/components/drawer_list_tile.dart';
import 'package:responsive_admin_dashboard/screens/components/paymentsDash%20.dart';
import 'package:responsive_admin_dashboard/screens/components/send_moneyDash.dart';
import 'package:responsive_admin_dashboard/screens/components/transactionsDash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/login.dart';
import '../../product/index.dart';
import '../../shop/index.dart';
import '../../user/index.dart';

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
            title: 'Users',
            svgSrc: 'assets/icons/groups_black_24dp.svg',
            tap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => IndexPage()))
            },
          ),
          DrawerListTile(
            title: 'charge the wristband',
            svgSrc: 'assets/icons/input_black_24dp.svg',
            tap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => sendMoneyDash()))
            },
          ),
          DrawerListTile(
            title: 'Shops',
            svgSrc: 'assets/icons/storefront_black_24dp.svg',
            tap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => IndexPageShop()))
            },
          ),
          DrawerListTile(
            title: 'Transactions',
            svgSrc: 'assets/icons/currency_exchange_black_24dp.svg',
            tap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => transactionsDashPage()))
            },
          ),
          DrawerListTile(
            title: 'Payments',
            svgSrc: 'assets/icons/payments_black_24dp.svg',
            tap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentsDashPage()))
            },
          ),
          // DrawerListTile(
          //   title: 'Products',
          //   svgSrc: 'assets/icons/Statistics.svg',
          //   tap: () => {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => IndexPageProduct()))
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: grey,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
              title: 'Settings',
              svgSrc: 'assets/icons/settings_black_24dp.svg',
              tap: () {}),
          DrawerListTile(
              title: 'Logout',
              svgSrc: 'assets/icons/logout_black_24dp.svg',
              tap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext ctx) => login()));
              }),
        ],
      ),
    );
  }
}
