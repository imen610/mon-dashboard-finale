import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/screens/components/radial_painter.dart';
import 'package:pie_chart/pie_chart.dart';

class UsersByDevice extends StatelessWidget {
  // const UsersByDevice({Key? key}) : super(key: key);
  final dataMap = <String, double>{
    "Flutter": 5,
    "dart": 2,
    "django": 2,
    "python": 3,
    "php": 2,
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: appPadding),
      child: Container(
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
              'Users by device',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              margin: EdgeInsets.all(appPadding),
              padding: EdgeInsets.all(appPadding),
              height: 230,
              child: PieChart(
                chartRadius: 1000,
                dataMap: dataMap,
                chartType: ChartType.ring,
                baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                colorList: [
                  Color.fromARGB(255, 243, 205, 33),
                  Color.fromARGB(255, 248, 208, 86),
                  Color.fromARGB(255, 222, 224, 107),
                  Color.fromARGB(255, 214, 202, 25),
                  Colors.orange,
                  Colors.yellow,
                  Color.fromARGB(255, 241, 229, 157),
                ],
                chartValuesOptions: ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
                totalValue: 20,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: appPadding),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.circle,
            //             color: primaryColor,
            //             size: 10,
            //           ),
            //           SizedBox(
            //             width: appPadding / 2,
            //           ),
            //           Text(
            //             'Desktop',
            //             style: TextStyle(
            //               color: textColor.withOpacity(0.5),
            //               fontWeight: FontWeight.bold,
            //             ),
            //           )
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.circle,
            //             color: textColor.withOpacity(0.2),
            //             size: 10,
            //           ),
            //           SizedBox(
            //             width: appPadding / 2,
            //           ),
            //           Text(
            //             'Mobile',
            //             style: TextStyle(
            //               color: textColor.withOpacity(0.5),
            //               fontWeight: FontWeight.bold,
            //             ),
            //           )
            //         ],
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
