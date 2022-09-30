import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/data/data.dart';
import 'package:http/http.dart' as http;
import '../../shop/constants/base_api.dart';

class TopReferals extends StatefulWidget {
  const TopReferals({Key? key}) : super(key: key);

  @override
  State<TopReferals> createState() => _TopReferalsState();
}

class _TopReferalsState extends State<TopReferals> {
  bool isLoading = false;
  List products = [];
  List topProd = [];
  @override
  void initState() {
    this.fetchTopProducts();
    this.fetchproducts();
    super.initState();
  }

  fetchproducts() async {
    setState(() {
      // isLoading = false;
    });
    var url = BASE_API + "products/";
    print(url);
    var response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(items);
      setState(() {
        products = items;
        print('<<<<<<<<<<<<<$products');

        isLoading = false;
      });
      return;
    } else {
      setState(() {
        products = [];
        isLoading = true;
      });
    }
  }

  fetchTopProducts() async {
    setState(() {
      // isLoading = false;
    });
    var url = "http://192.168.11.105:8000/auth/TopProdcuts/";
    print(url);
    var response = await http.get(Uri.parse(url));
    print(response.statusCode);

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(items);
      setState(() {
        topProd = items;
        print(">>>>>>>>>>>>$topProd");

        isLoading = false;
      });
      return;
    } else {
      setState(() {
        topProd = [];
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top products',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              // Text(
              //   'View All',
              //   style: TextStyle(
              //     fontSize: 13,
              //     fontWeight: FontWeight.bold,
              //     color: textColor.withOpacity(0.5),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: appPadding,
          ),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: topProd.length,
              itemBuilder: (context, index) => ReferalInfoDetail(index),
            ),
          )
        ],
      ),
    );
  }

  Widget ReferalInfoDetail(item) {
    var result = [
      for (var prod in products)
        if (prod["name_product"] == topProd[item][0]) prod['image_product']
    ];
    print(result);
    String image2 = result.isEmpty ? null : result.first;
    print(topProd[item][0]);
    print("oooooooooooooooo");
    print(image2);
    return Container(
      margin: EdgeInsets.only(top: appPadding),
      padding: EdgeInsets.all(appPadding / 2),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.black)),
            child: Center(
                child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: NetworkImage('http://192.168.11.105:8000' + image2),
                      fit: BoxFit.cover)),
            )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    topProd[item][0],
                    // widget.info.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                  Text(
                      '${((topProd[item][1] * 100) / topProd.length).toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
