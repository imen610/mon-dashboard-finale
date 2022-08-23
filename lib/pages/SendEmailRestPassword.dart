import 'dart:convert';
import 'dart:html';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/addMember.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

import '../simpleUser/main_page/theme/colors.dart';
import 'login.dart';

class sendMailPage extends StatefulWidget {
  sendMailPage({Key? key}) : super(key: key);

  @override
  State<sendMailPage> createState() => _sendMailPageState();
}

// http://127.0.0.1:8000/auth/request-reset-email/
class _sendMailPageState extends State<sendMailPage> {
  TextEditingController _controllerEmail = TextEditingController();

  Future<void> sendEmail() async {
    if (_controllerEmail.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse("http://127.0.0.1:8000/auth/request-reset-email/"),
          headers: {"Content-Type": "application/json"},
          body: (jsonEncode({
            "email": _controllerEmail.text,
          })));
      var access_token = json.decode(response.body);
      String? token;
      print('hello');
      // print('----------->${response.body}');

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString(
          appConstants.KEY_ACCESS_TOKEN, access_token['access'].toString());
      SharedPreferences.getInstance().then((sharedPrefValue) {
        setState(() {
          token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);
          // print('token  $token');
        });
      });
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("invalid")));
      } else {
        showMessage(context,
            '"success":"we have sent you a link to reset yourpassword"');
        // Navigator.push(
        //     //  home() ===> admin
        //     // and DrawerPage() =====> simple user
        //     context,
        //     MaterialPageRoute(builder: (context) => login()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("black field not allowed")));
    }
  }

  bool isFocused = false;
  FocusNode _focusNode = new FocusNode();
  @override
  void initState() {
    _focusNode.addListener(onFocusChanged);

    // TODO: implement initState
    super.initState();
  }

  ButtonState state = ButtonState.init;
  bool isAnimating = true;
  bool progress = false;
  void onFocusChanged() {
    setState(() {
      isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.75;

    final isDone = state == ButtonState.done;
    final isStretched = state == ButtonState.init;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: BackButton(
                color: Colors.black,
              ),
            )),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            // width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/logo1.png'))),
                        ),
                        Text(
                          'MyWallet',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 35,
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 60,
                ),
                TextField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: "Email",
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 10,
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
          'done',
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
            sendEmail();
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         TextField(
  //           controller: _controllerEmail,
  //           decoration: InputDecoration(
  //             hintText: "email",
  //           ),
  //         ),
  //         SizedBox(
  //           height: 30,
  //         ),
  //         InkWell(
  //           onTap: () {
  //             sendEmail();
  //           },
  //           child: Container(
  //             padding: EdgeInsets.all(15),
  //             decoration: BoxDecoration(
  //                 color: Color(0xffffac30),
  //                 borderRadius: BorderRadius.circular(20)),
  //             child: Center(
  //                 child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Send',
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 Icon(
  //                   Icons.arrow_forward,
  //                   size: 17,
  //                 )
  //               ],
  //             )),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  showMessage(BuildContext context, String contentMessage) {
    // set up the buttons
    var primary;

    Widget yesButton = FlatButton(
      child: Text("ok", style: TextStyle(color: primary)),
      onPressed: () {
        Navigator.pop(context);
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => sendMoneyDash()),
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
