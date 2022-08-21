import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/screens/components/radial_painter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_admin_dashboard/shop/constants/base_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UsersByDevice extends StatefulWidget {
  @override
  State<UsersByDevice> createState() => _UsersByDeviceState();
}

class _UsersByDeviceState extends State<UsersByDevice> {
  // const UsersByDevice({Key? key}) : super(key: key);
  // final dataMap = <String, double>{
  //   "Flutter": 5,
  //   "dart": 2,
  //   "django": 2,
  //   "python": 3,

  // };

  List stats = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchstats();
    isLoading = true;
  }

  fetchstats() async {
    String? token;
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        // isLoading = false;
        token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);
      });
    });

    var url = BASE_API + "TopFourShops/";

    print(url);
    SharedPreferences access_data = await SharedPreferences.getInstance();

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ${access_data.getString('access_token')}',
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);

      setState(() {
        stats = items;
        print(
            '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::$stats');
        isLoading = false;
      });

      return;
    } else {
      setState(() {
        stats = [];
        isLoading = true;
      });
    }
  }

  final colorList = <Color>[
    Color.fromARGB(255, 240, 192, 33),
    Color.fromARGB(255, 235, 235, 40),
    Color.fromARGB(255, 238, 213, 71),
    Color.fromARGB(255, 236, 224, 110),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: appPadding),
      child: (isLoading)
          ? Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : Container(
              height: 350,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(appPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top shops',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 70),
                    child: PieChart(
                      dataMap: {
                        stats[0][0]: stats[0][1],
                        stats[1][0]: stats[1][1],
                        stats[2][0]: stats[2][1],
                        stats[3][0]: stats[3][1],
                      },
                      chartType: ChartType.ring,
                      baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                      colorList: colorList,
                      chartValuesOptions: ChartValuesOptions(
                        showChartValuesInPercentage: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
