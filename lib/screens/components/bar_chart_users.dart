import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../shop/constants/base_api.dart';

class BarChartUsers extends StatefulWidget {
  const BarChartUsers({Key? key}) : super(key: key);

  @override
  State<BarChartUsers> createState() => _BarChartUsersState();
}

class _BarChartUsersState extends State<BarChartUsers> {
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

    var url = BASE_API + "stat/";

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

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Center(
            child: CircularProgressIndicator(color: Colors.black),
          )
        : BarChart(BarChartData(
            borderData: FlBorderData(border: Border.all(width: 0)),
            groupsSpace: 15,
            titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) => const TextStyle(
                          color: lightTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                    margin: appPadding,
                    getTitles: (double value) {
                      if (value == 1) {
                        return 'jan ';
                      }
                      if (value == 2) {
                        return 'fev ';
                      }
                      if (value == 3) {
                        return 'mar';
                      }
                      if (value == 4) {
                        return 'avr';
                      }
                      if (value == 5) {
                        return 'mai';
                      }
                      if (value == 6) {
                        return 'jui';
                      }
                      if (value == 7) {
                        return 'juil';
                      }
                      if (value == 8) {
                        return 'aou';
                      }
                      if (value == 9) {
                        return 'sep';
                      }
                      if (value == 10) {
                        return 'oct';
                      }
                      if (value == 11) {
                        return 'nov';
                      }
                      if (value == 12) {
                        return 'dec';
                      } else {
                        return '';
                      }
                    }),
                leftTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) => const TextStyle(
                          color: lightTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                    margin: appPadding,
                    getTitles: (double value) {
                      if (value == 2) {
                        return '1K';
                      }
                      if (value == 6) {
                        return '2K';
                      }
                      if (value == 10) {
                        return '3K';
                      }
                      if (value == 14) {
                        return '4K';
                      } else {
                        return '';
                      }
                    })),
            barGroups: [
                BarChartGroupData(x: stats[0]["month"], barRods: [
                  BarChartRodData(
                      y: stats[0]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[1]["month"], barRods: [
                  BarChartRodData(
                      y: stats[1]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[2]["month"], barRods: [
                  BarChartRodData(
                      y: stats[2]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[3]["month"], barRods: [
                  BarChartRodData(
                      y: stats[3]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[4]["month"], barRods: [
                  BarChartRodData(
                      y: stats[4]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[5]["month"], barRods: [
                  BarChartRodData(
                      y: stats[5]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[6]["month"], barRods: [
                  BarChartRodData(
                      y: stats[6]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[7]["month"], barRods: [
                  BarChartRodData(
                      y: stats[7]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[8]["month"], barRods: [
                  BarChartRodData(
                      y: stats[8]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[9]["month"], barRods: [
                  BarChartRodData(
                      y: stats[9]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[10]["month"], barRods: [
                  BarChartRodData(
                      y: stats[10]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
                BarChartGroupData(x: stats[11]["month"], barRods: [
                  BarChartRodData(
                      y: stats[11]["count"],
                      width: 15,
                      colors: [primaryColor],
                      borderRadius: BorderRadius.circular(5))
                ]),
              ]));
  }
}
