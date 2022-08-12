import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../pages/home.dart';
import '../../shop/constants/base_api.dart';
import '../../shop/constants/util.dart';

class EditProfilePage extends StatefulWidget {
  // const EditProfilePage({Key? key}) : super(key: key);
  String userId;
  String username;
  String email;
  String image;
  String phone;
  String firstName;
  String lastName;
  String address;

  EditProfilePage(
      {required this.userId,
      required this.username,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.image});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isObscuredPassword = true;
  final TextEditingController _controllerUserName = new TextEditingController();
  final TextEditingController _controllerEmail = new TextEditingController();
  final TextEditingController _controllerphone = new TextEditingController();
  final TextEditingController _controllerfirstName =
      new TextEditingController();
  final TextEditingController _controllerlastName = new TextEditingController();
  final TextEditingController _controlleraddress = new TextEditingController();

  String userId = '';
  String image = '';
  bool isImageSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.fetchmember();
    setState(() {
      userId = widget.userId;
      _controllerUserName.text = widget.username;
      _controllerEmail.text = widget.email;
      _controllerphone.text = widget.phone;
      _controllerlastName.text = widget.lastName;
      _controllerfirstName.text = widget.firstName;
      _controlleraddress.text = widget.address;
      image = widget.image.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // IconButton(
          //   // icon: Icon(Icons.CupertinoIcons.moon_stars),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 10, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                        child: Container(
                      width: 135,
                      height: 135,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image:
                                  NetworkImage("http://127.0.0.1:8000" + image),
                              fit: BoxFit.cover)),
                    )),
                  ),
                  // Container(
                  //     width: 130,
                  //     height: 130,
                  //     decoration: BoxDecoration(
                  //         border: Border.all(width: 4, color: Colors.white),
                  //         boxShadow: [
                  //           BoxShadow(
                  //               spreadRadius: 2,
                  //               blurRadius: 10,
                  //               color: Colors.black.withOpacity(0.1))
                  //         ],
                  //         shape: BoxShape.circle,
                  //         image: DecorationImage(
                  //             fit: BoxFit.cover,
                  //             image: NetworkImage(
                  //                 "http://127.0.0.1:8000/images/2af5edae259d0d57fc410682e0338b14_y2DfKqW.jpg")))),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                              color: Colors.amber),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          )))
                ]),
              ),
              SizedBox(
                height: 30,
              ),
              BuildTextField(_controllerUserName, 'Full Name', false),
              BuildTextField(_controllerEmail, 'Email', false),
              // BuildTextField('************', 'Password', true),
              BuildTextField(_controllerphone, 'Phone Number', false),
              BuildTextField(_controlleraddress, 'Location', false),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ))),
                  ElevatedButton(
                    onPressed: editUser,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildTextField(TextEditingController Controller, String placeholder,
      bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: Controller,
        obscureText: isPasswordTextField ? isObscuredPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey))
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }

  editUser() async {
    SharedPreferences ID_USER = await SharedPreferences.getInstance();
    var x = ID_USER.getString('user_id');
    print('id get from constant $x');

    var url = BASE_API + "users/$userId/";
    print(url);
    var username = _controllerUserName.text;
    var email = _controllerEmail.text;
    var firstName = _controllerfirstName.text;
    var lastName = _controllerlastName.text;
    var phone = _controllerphone.text;
    var address = _controlleraddress.text;
    if (username.isNotEmpty && email.isNotEmpty) {
      var bodyData = json.encode({
        "username": username,
        "email": email,
        // "image": image,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "address": address,
        // "image_User": null
      });
      var response = await http.put(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: bodyData);
      print(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var messageSuccess = "success";
        showMsg(context, messageSuccess);
      } else {
        var messageError = "Error";
        showMsg(context, messageError);
      }
    }
  }

  showMsg(BuildContext context, String contentMessage) {
    // set up the buttons
    var primary;

    Widget yesButton = FlatButton(
      child: Text("ok", style: TextStyle(color: primary)),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => home()));
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
