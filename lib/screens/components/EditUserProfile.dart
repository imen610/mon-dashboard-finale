import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_admin_dashboard/addMember.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../pages/home.dart';
import '../../shop/constants/base_api.dart';
import '../../shop/constants/util.dart';
import '../../simpleUser/main_page/theme/colors.dart';

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

  FocusNode _focusNode = new FocusNode();

  bool isAnimating = true;
  bool isFocused = false;
  List members = [];
  var user;
  var id;
  bool isSelected = false;
  bool progress = false;
  @override
  void initState() {
    _focusNode.addListener(onFocusChanged);

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
      _controllerphone.text = widget.phone;
      image = widget.image.toString();
    });
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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Container(
              height: 90,
              padding: EdgeInsets.only(left: 15, right: 20, top: 5),
              decoration: BoxDecoration(
                  color: appBgColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                        color: shadowColor.withOpacity(0.1),
                        blurRadius: .5,
                        spreadRadius: .5,
                        offset: Offset(0, 1))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: IconButton(
                      icon: new Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(
                    width: 175,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/logo1.png'))),
                          ),
                          Text(
                            'MyWallet',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 20,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            )),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            // width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                FadeInDown(
                  from: 100,
                  duration: Duration(milliseconds: 1000),
                  child: Stack(children: [
                    Container(
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
                                image: NetworkImage('http://127.0.0.1:8000' +
                                    widget.image.toString()),
                                fit: BoxFit.cover)),
                      )),
                    ),
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
                                color: Color.fromARGB(255, 252, 193, 75)),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            )))
                  ]),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _controllerUserName,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: "username",
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 10,
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
                TextField(
                  controller: _controlleraddress,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      hintText: "Address",
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _controllerphone,
                  decoration: InputDecoration(
                      labelText: 'Phone',
                      hintText: "Phone",
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
            editUser();
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
