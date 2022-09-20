import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:responsive_admin_dashboard/product/constants/base_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'addProd.dart';

class addblockProductPage extends StatefulWidget {
  // const addblockProductPage({Key? key}) : super(key: key);
  String memberId;
  List blockprod;
  addblockProductPage({required this.memberId, required this.blockprod});
  @override
  State<addblockProductPage> createState() => _addblockProductPageState();
}

class _addblockProductPageState extends State<addblockProductPage> {
  List products = [];
  List shopsOnSearch = [];
  bool isLoading = false;
  // List blockprod = [];
  TextEditingController? _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.fetchproducts();
  }

  fetchproducts() async {
    setState(() {
      isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Products",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (isLoading || products.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
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
                            shopsOnSearch = products
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
                            hintText: "search for contacts"),
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
                      shopsOnSearch.isEmpty
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
                          ? shopsOnSearch.length
                          : products.length,
                      itemBuilder: (context, index) {
                        return _textEditingController!.text.isNotEmpty
                            ? cardItem(shopsOnSearch[index])
                            : cardItem(products[index]);
                      }))
        ],
      ),
    );
  }

  Widget cardItem(item) {
    var name_product = item['name_product'];
    var price_product = item['price_product'];

    var image_product = item['image_product'];
    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print('hello');
                  addProduct(item);
                },
                child: Container(
                  child: Container(
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
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "http://192.168.43.61:8000" +
                                          image_product.toString()),
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
                            Text(name_product.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              price_product.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  addProduct(item) {
    var idUser = widget.memberId.toString();
    var idprod = item['id'].toString();
    var image_product = item['image_product'].toString();
    var name_product = item['name_product'].toString();
    var blockprod = widget.blockprod;

    print(idUser);
    print(idprod);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => addProd(
                idUser: idUser,
                idprod: idprod,
                image_product: image_product,
                name_product: name_product,
                blockprod: blockprod))).then((value) {
      if (value != null) {
        Navigator.pop(context, value);
      }
    });
  }

  // Future<void> Getblock() async {
  //   var url = BASE_API + "AddblockedProducts/${widget.memberId}/";
  //   // print(url);

  //   SharedPreferences access_data = await SharedPreferences.getInstance();
  //   var response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json ; charset=UTF-8',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer ${access_data.getString('access_token')}'
  //     },
  //   );
  //   // print(userName);

  //   // print(response.body[0]);
  //   if (response.statusCode == 200) {
  //     var items = jsonDecode(response.body);
  //     setState(() {
  //       blockprod = items;
  //     });
  //   }
  // }
}
