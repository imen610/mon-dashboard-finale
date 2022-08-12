import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_admin_dashboard/simpleUser/ui/screen/drawer_page.dart';

import 'package:responsive_admin_dashboard/user/constants/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_page/pages/home_page.dart';

class SendMoney extends StatefulWidget {
  //const EditUser({Key? key}) : super(key: key);
  String userId;
  String username;
  String email;
  String image;
  String phone;
  String firstName;
  String lastName;
  String address;

  SendMoney(
      {required this.userId,
      required this.username,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.image});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  String userId = '';
  String image = '';
  String userName = '';
  bool isImageSelected = false;

  var amount = TextEditingController(text: "0.00");
  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  TextEditingController ToController = new TextEditingController();

  bool isFocused = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.fetchmember();
    _focusNode.addListener(onFocusChanged);
    setState(() {
      userId = widget.userId;
      image = 'http://127.0.0.1:8000' + widget.image.toString();
      userName = widget.username;
    });

    print(widget.userId);
    print(widget.username);
    print(widget.email);
    print(widget.image);
    print(widget.phone);
    print(widget.lastName);
    print(widget.firstName);
    print(widget.address);
  }

  void onFocusChanged() {
    setState(() {
      isFocused = _focusNode.hasFocus;
    });

    print('focus changed.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 244, 238, 238),
          elevation: 0,
          title: Text(
            'Send Money',
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
                  // child: Container(
                  //   width: 130,
                  //   height: 130,
                  //   padding: EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(100),
                  //   ),
                  //   child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(50),
                  //       child:
                  //           Image.network(image.toString(), fit: BoxFit.cover)),
                  // ),
                ),
                SizedBox(
                  height: 50,
                ),
                FadeInUp(
                    from: 60,
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "Send Money To",
                      style: TextStyle(color: Colors.grey),
                    )),
                SizedBox(
                  height: 10,
                ),
                FadeInUp(
                    from: 30,
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      widget.username,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 20,
                ),
                FadeInUp(
                  from: 40,
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextField(
                      controller: amount,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      onSubmitted: (value) {
                        setState(() {
                          amount.text = "\$" + value + ".00";
                        });
                      },
                      onTap: () {
                        setState(() {
                          if (amount.text == "0.00") {
                            amount.text = "";
                          } else {
                            amount.text =
                                amount.text.replaceAll(RegExp(r'.00'), '');
                          }
                        });
                      },
                      // inputFormatters: [
                      //   ThousandsFormatter()
                      // ],
                      decoration: InputDecoration(
                          hintText: "Enter Amount",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                ),
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 252, 193, 75),
                      child: MaterialButton(
                        onPressed: () {
                          SendMoneyToMember();
                        },
                        minWidth: double.infinity,
                        height: 50,
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> SendMoneyToMember() async {
    var url = BASE_API + "pay/";
    print(url);
    print(userName);
    // ToController = userName;
    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json ; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${access_data.getString('access_token')}'
        },
        body: (jsonEncode({"amount": amount.text, "to_acct": userName})));
    print(userName);

    print(response.body[0]);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      if (items['account status'] == 'Rblocked') {
        showMessage(context, items['message']);
      } else if (items['account status'] == 'Sblocked') {
        showMessage(context, items['message']);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DrawerPage()));

        print(items['account status']);
      }

      // setState(() {
      //   //wallet = items;
      // });
    } else if (response.statusCode == 406) {
      showMessage(
          context, 'You do not have enough funds to complete the transfer...');
    }
  }

  showMessage(BuildContext context, String contentMessage) {
    // set up the buttons
    var primary;

    Widget yesButton = FlatButton(
      child: Text("ok", style: TextStyle(color: primary)),
      onPressed: () {
        Navigator.pop(context);
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => HomePage()),
        //     (Route<dynamic> route) => false);
        // deleteUser(item['id']);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text(contentMessage),
      actions: [
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
