import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controllerEmail,
            decoration: InputDecoration(
              hintText: "email",
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              sendEmail();
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Color(0xffffac30),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 17,
                  )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

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
