import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../user/constants/util.dart';

class ViewLineChart extends StatefulWidget {
  const ViewLineChart({Key? key}) : super(key: key);

  @override
  _ViewLineChartState createState() => _ViewLineChartState();
}

class _ViewLineChartState extends State<ViewLineChart> {
  List<Color> gradientColors = [
    primaryColor,
    secondaryColor,
  ];
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
        isLoading = false;
        token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);
      });
    });

    var url = BASE_API + "statisticsTransactions/";

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
        print('fffffffffffffffffffffffff$stats');
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        appPadding,
        appPadding * 1.5,
        appPadding,
        appPadding,
      ),
      child: LineChart(LineChartData(
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTextStyles: (value) => TextStyle(
                        color: lightTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                  getTitles: (value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Mon';
                      case 1:
                        return 'Tue';
                      case 2:
                        return 'Wed';
                      case 3:
                        return 'Thr';
                      case 4:
                        return 'Fri';
                      case 5:
                        return 'Sat';
                      case 6:
                        return 'Sun';
                    }
                    return '';
                  }),
              leftTitles: SideTitles(
                showTitles: false,
              )),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: 7,
          maxY: 10,
          minY: -1,
          lineBarsData: [
            LineChartBarData(
                spots: [
                  FlSpot(0, stats[0]["count"]),
                  FlSpot(1, stats[1]["count"]),
                  FlSpot(2, stats[2]["count"]),
                  FlSpot(3, stats[3]["count"]),
                  FlSpot(4, stats[4]["count"]),
                  FlSpot(5, stats[5]["count"]),
                  FlSpot(6, stats[6]["count"]),
                ],
                //  FlSpot(stats[0]["jour"], stats[0]["count"]),
                //   FlSpot(stats[1]["jour"], stats[1]["count"]),
                //   FlSpot(stats[2]["jour"], stats[2]["count"]),
                //   FlSpot(stats[3]["jour"], stats[3]["count"]),
                //   FlSpot(stats[4]["jour"], stats[4]["count"]),
                //   FlSpot(stats[5]["jour"], stats[5]["count"]),
                //   FlSpot(stats[6]["jour"], stats[6]["count"]),
                isCurved: true,
                colors: [primaryColor],
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                    show: true,
                    colors:
                        gradientColors.map((e) => e.withOpacity(0.3)).toList(),
                    gradientFrom: Offset(0, 0),
                    gradientTo: Offset(0, 1.75)))
          ])),
    );
  }
}
