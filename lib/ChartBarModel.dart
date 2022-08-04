// To parse this JSON data, do
//
//     final statChartBar = statChartBarFromJson(jsonString);

import 'dart:convert';

List<StatChartBar> statChartBarFromJson(String str) => List<StatChartBar>.from(json.decode(str).map((x) => StatChartBar.fromJson(x)));

String statChartBarToJson(List<StatChartBar> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatChartBar {
    StatChartBar({
        required this.month,
       required this.count,
    });

    int month;
    int count;

    factory StatChartBar.fromJson(Map<String, dynamic> json) => StatChartBar(
        month: json["month"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "month": month,
        "count": count,
    };
}
