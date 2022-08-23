import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/addMember.dart';
import 'package:responsive_admin_dashboard/shop/theme/theme_colors.dart';
import 'constants/base_api.dart';
import 'constants/util.dart';

class createshop extends StatefulWidget {
  const createshop({Key? key}) : super(key: key);

  @override
  State<createshop> createState() => _createshopState();
}

class _createshopState extends State<createshop> {
  final TextEditingController _controllershopName = new TextEditingController();
  final TextEditingController _controllerAddress = new TextEditingController();
  final TextEditingController _controllerEmail = new TextEditingController();
  String userId = '';
  String image = '';
  String userName = '';
  bool isImageSelected = false;
  bool isLoading = true;

  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  TextEditingController ToController = new TextEditingController();
  bool isAnimating = true;
  bool isFocused = false;
  List members = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.CreateNewshop();
    _focusNode.addListener(onFocusChanged);
  }

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
                TextField(
                  controller: _controllershopName,
                  decoration: InputDecoration(
                    hintText: "shopname",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _controllerAddress,
                  decoration: InputDecoration(
                    hintText: "address",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
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
          'Add',
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
            CreateNewshop();
          });
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            state = ButtonState.init;
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

  CreateNewshop() async {
    var shopName = _controllershopName.text;
    var address = _controllerAddress.text;
    var email = _controllerEmail.text;

    if (shopName.isNotEmpty && address.isNotEmpty) {
      var url = BASE_API + "shops/";
      print('url =============> $url');
      var bodyData = json.encode({
        "name_shop": shopName,
        "address_shop": address,
        "email_shop": email,
      });
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: bodyData);
      print(response.statusCode);
      // print(response.body);
      var pro = json.decode(response.body)['shopname'];
      // print(pro);

      if (response.statusCode == 200) {
        setState(() {
          var messageSuccess = "";
          showMessage(context, messageSuccess);

          _controllershopName.text = "";
          _controllerAddress.text = "";
        });
      } else {
        var message = 'success';
        showMessage(context, message);
      }
    }
  }
}
