import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:responsive_admin_dashboard/simpleUser/main_page/data/json.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../product/constants/base_api.dart';
import '../../shop/index.dart';
import 'addblockProductPage.dart';

class userProductBlocked extends StatefulWidget {
  // const userProductBlocked({Key? key}) : super(key: key);
  String memberId;
  List prod_block;
  userProductBlocked({required this.memberId, required this.prod_block});

  @override
  State<userProductBlocked> createState() => _userProductBlockedState();
}

class _userProductBlockedState extends State<userProductBlocked> {
  List productsOnSearch = [];
  var prodId;
  List blocked = [];
  List<int> deletedIndexs = [];
  TextEditingController? _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    blocked = widget.prod_block;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.memberId);
    print(blocked);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "products block",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context, deletedIndexs);
          },
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addblockProductPage(
                            memberId: widget.memberId,
                            blockprod: blocked))).then((value) {
                  if (value != null) {
                    Map<String, dynamic> returnedValues =
                        value as Map<String, dynamic>;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userProductBlocked(
                                  memberId: returnedValues.values.first,
                                  prod_block: returnedValues.values.last,
                                )));
                  }
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.black,
              ))
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  child: Row(children: [
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Feather.search,
                      ),
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _textEditingController,
                        onChanged: (value) {
                          setState(() {
                            productsOnSearch = blocked
                                .where((product) => product['name_product']
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "search for products"),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 9,
              child: _textEditingController!.text.isNotEmpty &&
                      productsOnSearch.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                          ),
                          Text(
                            'No results found',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _textEditingController!.text.isNotEmpty
                          ? productsOnSearch.length
                          : blocked.length,
                      itemBuilder: (context, index) {
                        return _textEditingController!.text.isNotEmpty
                            ? cardItem(productsOnSearch[index], index)
                            : cardItem(blocked[index], index);
                      }))
        ],
      ),
    );
  }

  Widget cardItem(item, int position) {
    var nameProd = item['name_product'];
    var image = item['image_product'];
    var id = item['id'];

    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(right: 20),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 204, 200, 200)
                              .withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 1))
                    ],
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(33)),
                child: Row(children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                        child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: (image.substring(0, 4).toString() == "http")
                              ? DecorationImage(
                                  image: NetworkImage(image.toString()),
                                  fit: BoxFit.cover)
                              : DecorationImage(
                                  image: NetworkImage(
                                      'http://192.168.11.105:8000' +
                                          image.toString()),
                                  fit: BoxFit.cover)),
                    )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(nameProd.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                            Spacer(),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  prodId = id;
                                });
                                unblock(position);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.block,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> unblock(int position) async {
    var url = BASE_API + "RemoveblockedProducts/${widget.memberId}/";
    // print(url);

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json ; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${access_data.getString('access_token')}'
        },
        body: (jsonEncode({"id": prodId})));

     print(response.body);
    if (response.statusCode == 200) {
      //var items = jsonDecode(response.body);
      setState(() {
        deletedIndexs.add(position);
        blocked.removeAt(position);
      });
      print('hello salma _____${blocked}');
    }
  }
}
