import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/shop/constants/base_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../theme/colors.dart';
import 'avatar_image.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem(this.data, {Key? key, this.onTap}) : super(key: key);
  final data;
  final GestureTapCallback? onTap;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  List list_transactions = [];
  @override
  void initState() {
    super.initState();
    this.getTransaction();
  }

  getTransaction() async {
    var url = BASE_API + "transactions/";

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      print(' voici la liste des transactions $items');

      setState(() {
        list_transactions = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvatarImage(
                  widget.data['image'],
                  isSVG: false,
                  width: 35,
                  height: 35,
                  radius: 50,
                ),
                SizedBox(width: 20),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                child: Text(widget.data['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)))),
                        SizedBox(width: 5),
                        Container(
                            child: Text(widget.data['price'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)))
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Text(widget.data['date'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey))),
                        Container(
                            child: widget.data['type'] == 1
                                ? Icon(
                                    Icons.download_rounded,
                                    color: green,
                                  )
                                : Icon(
                                    Icons.upload_rounded,
                                    color: red,
                                  )),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
