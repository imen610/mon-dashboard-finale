import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_admin_dashboard/product/constants/base_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class addProd extends StatefulWidget {
  // const addProd({Key? key}) : super(key: key);
  String idUser;
  String idprod;
  String image_product;
  String name_product;
  List blockprod;
  addProd(
      {required this.idUser,
      required this.idprod,
      required this.image_product,
      required this.name_product,
      required this.blockprod});

  @override
  State<addProd> createState() => _addProdState();
}

enum ButtonState { init, loading, done }

class _addProdState extends State<addProd> {
  var userid;
  var image;
  var name;
  var prodId;
  List users = [];
  var User;
  @override
  void initState() {
    // TODO: implement initState
    this.fetchUsers();
    super.initState();
    setState(() {
      userid = widget.idUser;
      image = widget.image_product;
      prodId = widget.idprod;
      name = widget.name_product;
      print(userid);
      print(prodId);
      print(image);
      print(name);
    });
  }

  bool isImageSelected = false;
  bool isLoading = true;

  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  TextEditingController ToController = new TextEditingController();
  bool isAnimating = true;
  bool isFocused = false;
  List members = [];
  List list = [];

  void onFocusChanged() {
    setState(() {
      isFocused = _focusNode.hasFocus;
    });

    print('focus changed.');
  }

  ButtonState state = ButtonState.init;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.75;

    final isDone = state == ButtonState.done;
    final isStretched = state == ButtonState.init;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 244, 238, 238),
          elevation: 0,
          title: Text(
            '',
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                FadeInDown(
                  from: 100,
                  duration: Duration(milliseconds: 1000),
                  child: Container(
                    width: 135,
                    height: 135,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                        child: Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: NetworkImage(image.toString()),
                              fit: BoxFit.cover)),
                    )),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                FadeInUp(
                    from: 30,
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      widget.name_product,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                // SizedBox(
                //   height: 10,
                // ),
                // FadeInUp(
                //     from: 60,
                //     delay: Duration(milliseconds: 500),
                //     duration: Duration(milliseconds: 1000),
                //     child: Text(
                //       widget.email,
                //       style: TextStyle(color: Colors.grey),
                //     )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  // width: width,
                  // height: 70,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(32),
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      width: state == ButtonState.init ? width : 70,
                      onEnd: () => setState(() {
                            isAnimating != isAnimating;
                          }),
                      height: 70,
                      child: isStretched
                          ? buildButton()
                          : buildSmallButton(isDone)),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            minimumSize: Size.fromHeight(72),
            side: BorderSide(
              width: 2,
              color: Color.fromARGB(255, 252, 193, 75),
            )),
        child: Text(
          'block',
          style: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 252, 193, 75),
              letterSpacing: 2,
              fontWeight: FontWeight.w600),
        ),
        onPressed: () async {
          setState(() {
            state = ButtonState.loading;
          });
          await Future.delayed(Duration(seconds: 2));

          setState(() {
            state = ButtonState.done;
            block();
            // this.GetMembers();
          });
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            state = ButtonState.init;
            // // GetMembers();
            this.fetchUsers();
            // print(widget.membre);
            // print(list);
            Map<String, dynamic> params = {};
            params.putIfAbsent('idUser', () => widget.idUser);
            params.putIfAbsent('idprod', () => widget.idprod);
            params.putIfAbsent('image_product', () => widget.image_product);
            params.putIfAbsent('name_product', () => widget.name_product);
            params.putIfAbsent('blockprod', () => widget.blockprod);
            Navigator.pop(context, params);
          });
        });
  }

  Widget buildSmallButton(bool isDone) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? Colors.green : Color.fromARGB(255, 252, 193, 75),
      ),
      child: Center(
          child: isDone
              ? Icon(
                  Icons.done,
                  size: 52,
                  color: Colors.white,
                )
              : CircularProgressIndicator(color: Colors.white)),
    );
  }

  Future<void> block() async {
    var url = BASE_API + "AddblockedProducts/$userid/";
    // print(url);

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json ; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${access_data.getString('access_token')}'
        },
        body: (jsonEncode({"id": prodId})));
    // print(userName);

    // print(response.body[0]);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      fetchUsers();
    }
  }

  fetchUsers() async {
    var url = BASE_API + "users/${widget.idUser}/";
    //String? token;
    print(url);
    SharedPreferences access_data = await SharedPreferences.getInstance();

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}',
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);

      setState(() {
        users = items;
        final user_ = users.where((user) {
          return user['id'] == widget.idUser;
        }).toList();
        User = user_;
      });
      print("hello");
      print(User);
    }
  }
}
