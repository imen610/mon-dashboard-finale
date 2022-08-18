import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:responsive_admin_dashboard/pages/home.dart';

import 'login.dart';

class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  void sigup(String email, username, password, phone) async {
    try {
      Response response =
          await post(Uri.parse('http://127.0.0.1:8000/auth/sign-up/'), body: {
        'email': email,
        'username': username,
        'password': password,
        'phone_number': int.parse(phone).toString()
      });
      print(response.statusCode);
      print(response.body);

      if (response.statusCode != 302) {
        var data = jsonDecode(response.body.toString());
        print(data);
        //print(data['token']);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => home()));

        print('account created successfully');
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => home()));
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/sideImg.png'),
                    fit: BoxFit.cover)),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('h:mm a').format(DateTime.now()),
                        // DateTime.now().toString(),
                        // "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: 'avenir',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.black)),
                    Expanded(child: Container()),
                  ],
                ),
                Row(
                  children: [
                    Text(
                        DateFormat('EEE, MMM d, ' 'yyyy')
                            .format(DateTime.now()),
                        // DateTime.now().toString(),
                        // "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'avenir',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey)),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 60, right: 80),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/logo1.png'))),
                          ),
                          Text(
                            'MyWallet',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 30,
                            ),
                          ),
                        ]),
                  ),
                ),
                Container(
                    width: 700,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromARGB(255, 217, 213, 213)),
                    child: TextField(
                      controller: usernameController,
                      cursorColor: Color.fromARGB(255, 187, 181, 181),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 160, 157, 155),
                            size: 20,
                          ),
                          hintText: 'username',
                          border: InputBorder.none),
                    )),
                Container(
                    width: 700,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromARGB(255, 217, 213, 213)),
                    child: TextField(
                      controller: emailController,
                      cursorColor: Color.fromARGB(255, 187, 181, 181),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 160, 157, 155),
                            size: 20,
                          ),
                          hintText: 'email',
                          border: InputBorder.none),
                    )),
                Container(
                    width: 700,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromARGB(255, 217, 213, 213)),
                    child: TextField(
                      controller: phoneNumberController,
                      cursorColor: Color.fromARGB(255, 187, 181, 181),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 160, 157, 155),
                            size: 20,
                          ),
                          hintText: 'phone',
                          border: InputBorder.none),
                    )),
                Container(
                    width: 700,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromARGB(255, 217, 213, 213)),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      cursorColor: Color.fromARGB(255, 187, 181, 181),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.key,
                            color: Color.fromARGB(255, 160, 157, 155),
                            size: 20,
                          ),
                          hintText: 'password',
                          border: InputBorder.none),
                    )),
                InkWell(
                  onTap: () {
                    sigup(
                        emailController.text.toString(),
                        usernameController.text.toString(),
                        passwordController.text.toString(),
                        phoneNumberController.text.toString());
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
                          'Sign up',
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
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'I have an account ! ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 56, 56, 54),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => login()))
                      },
                      child: Text(
                        'Login now',
                        style: TextStyle(
                            color: Color(0xffffac30),
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
                Container(
                  width: 100,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
