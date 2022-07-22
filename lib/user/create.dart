import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/user/theme/theme_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/base_api.dart';
import 'constants/util.dart';

class createuser extends StatefulWidget {
  const createuser({Key? key}) : super(key: key);

  @override
  State<createuser> createState() => _createuserState();
}

class _createuserState extends State<createuser> {
  final TextEditingController _controllerUserName = new TextEditingController();
  final TextEditingController _controllerEmail = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('creating user')),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      padding: EdgeInsets.all(30),
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerUserName,
          decoration: InputDecoration(
            hintText: "username",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerEmail,
          decoration: InputDecoration(
            hintText: "email",
          ),
        ),
        SizedBox(
          height: 40,
        ),
        FlatButton(
            color: primary,
            onPressed: () {
              CreateNewuser();
            },
            child: Text(
              "done",
              style: TextStyle(
                color: white,
              ),
            ))
      ],
    );
  }

  CreateNewuser() async {
    var userName = _controllerUserName.text;
    var useremail = _controllerEmail.text;
    // print('userName : ${userName.text}');
    // print('userPrice: ${userPrice.text}');

    if (userName.isNotEmpty && useremail.isNotEmpty) {
      var url = BASE_API + "users/";
      var bodyData = json.encode({
        "username": userName,
        "email": useremail,
      });
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            // 'Authorization':
            //     'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjU4MTUwMDY4LCJqdGkiOiJhM2U3NjIwMmRmM2Y0YTM1OWM3Y2VkNWQ0Y2ZjNmE0ZiIsInVzZXJfaWQiOjl9.0oI_NxGL6Mu_voUy9su_qrEy9FFdL_m_tJXs6RTil-I',
          },
          body: bodyData);
      // String? token;
      print(response.statusCode);
      print(response.body);
      var pro = json.decode(response.body)['username'];
      print(pro);
     
      if (response.statusCode == 200) {
        setState(() {
          var messageSuccess = "";
          showMessage(context, messageSuccess);

          _controllerUserName.text = "";
          _controllerEmail.text = "";
        });
      } else {
        var message = 'success';
        showMessage(context, message);
      }
    }
  }
}
