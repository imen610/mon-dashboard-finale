import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/screens/components/analytic_cards.dart';
import 'package:responsive_admin_dashboard/screens/components/custom_appbar.dart';
import 'package:responsive_admin_dashboard/screens/components/top_referals.dart';
import 'package:responsive_admin_dashboard/screens/components/users.dart';
import 'package:responsive_admin_dashboard/screens/components/users_by_device.dart';
import 'package:responsive_admin_dashboard/screens/components/viewers.dart';

import 'discussions.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(),
            SizedBox(
              height: appPadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          AnalyticCards(),
                          SizedBox(
                            height: appPadding,
                          ),
                          Viewers(),
                            SizedBox(
                              height: appPadding,
                            ),
                           Discussions(),
                        ],
                      ),
                    ),
                   
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: appPadding,
                          ),
                          Row(
                            children: [
                             
                              Expanded(
                                flex: 5,
                                child: Users(),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          SizedBox(
                            height: appPadding,
                          ),
                            SizedBox(
                              height: appPadding,
                            ),
                          TopReferals(),
                            SizedBox(
                              height: appPadding,
                            ),
                           UsersByDevice(),
                        ],
                      ),
                    ),
                   
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
