import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/shop/constants/base_api.dart';
import 'package:responsive_admin_dashboard/shop/create.dart';
import 'package:responsive_admin_dashboard/shop/productsPage.dart';
import 'package:responsive_admin_dashboard/shop/theme/theme_colors.dart';

import 'edit.dart';

class IndexPageShop extends StatefulWidget {
  const IndexPageShop({Key? key}) : super(key: key);

  @override
  State<IndexPageShop> createState() => _IndexPageShopState();
}

class _IndexPageShopState extends State<IndexPageShop> {
  List shops = [];
  List shopsOnSearch = [];
  bool isLoading = false;
  TextEditingController? _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.fetchShop();
  }

  fetchShop() async {
    setState(() {
      isLoading = false;
    });
    var url = BASE_API + "shops/";
    print(url);
    var response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(items);
      setState(() {
        shops = items;

        isLoading = false;
      });
      return;
    } else {
      setState(() {
        shops = [];
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
          "shops",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => createshop()));
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
    if (isLoading || shops.length == 0) {
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
                            shopsOnSearch = shops
                                .where((shop) => shop['name_shop']
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
                          : shops.length,
                      itemBuilder: (context, index) {
                        return _textEditingController!.text.isNotEmpty
                            ? cardItem(shopsOnSearch[index])
                            : cardItem(shops[index]);
                      }))
        ],
      ),
    );
  }

  Widget cardItem(item) {
    var name_shop = item['name_shop'];
    var email_shop = item['email_shop'];
    var address_shop = item['address_shop'];
    var products = item['products'];
    var image_shop = item['image_shop'];
    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => getproducts(item),
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
                  child: Flexible(
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
                                      "http://192.168.11.105:8000" +
                                          image_shop.toString()),
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
                            Text(name_shop.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              address_shop.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                          child: popUpMen(
                        menuList: [
                          PopupMenuItem(
                              child: InkWell(
                            onTap: () => editShop(item),
                            child: ListTile(
                              leading: Icon(
                                Icons.edit,
                                color: Color(0xff16F8FA),
                              ),
                              title: Text(
                                'edit',
                                style: TextStyle(
                                  color: Color(0xff16F8FA),
                                ),
                              ),
                            ),
                          )),
                          PopupMenuItem(
                              child: InkWell(
                            onTap: () => showDeleteAlert(context, item),
                            child: ListTile(
                              leading: Icon(
                                Icons.delete,
                                color: Color(0xffFA1645),
                              ),
                              title: Text('delete',
                                  style: TextStyle(
                                    color: Color(0xffFA1645),
                                  )),
                            ),
                          )),
                        ],
                        icon: Icon(
                          Icons.more_vert_rounded,
                          size: 23,
                        ),
                      ))
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

  getproducts(item) {
    var shopId = item['id'].toString();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => products(
                  shopId: shopId,
                )));
  }

  editShop(item) {
    var shopId = item['id'].toString();
    var name_shop = item['name_shop'].toString();
    var email_shop = item['email_shop'].toString();
    var address_shop = item['address_shop'].toString();
    var image_shop = item['image_shop'].toString();
    var products = item['products'];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditShop(
                  shopId: shopId,
                  ShopName: name_shop,
                  ShopEmail: email_shop,
                  ShopAddress: address_shop,
                  ShopImage: image_shop,
                  products: products,
                )));
  }

  deleteProduct(shopId) async {
    print(shopId);
    var url = BASE_API + "shops/$shopId/";
    var response = await http.delete(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      this.fetchShop();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => IndexPageShop()),
          (Route<dynamic> route) => false);
    }
  }

  showDeleteAlert(BuildContext context, item) {
    // set up the buttons
    Widget noButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: primary),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget yesButton = TextButton(
      child: Text("Yes", style: TextStyle(color: primary)),
      onPressed: () {
        Navigator.pop(context);

        deleteProduct(item['id']);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Would you like to delete this user?"),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class popUpMen extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;
  const popUpMen({Key? key, required this.menuList, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: ((context) => menuList), icon: icon);
  }
}
