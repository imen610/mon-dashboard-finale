import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/user/theme/theme_colors.dart';
import '../screens/components/addProd.dart';
import '../shop/constants/base_api.dart';
import '../simpleUser/main_page/theme/colors.dart';
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
  final TextEditingController _controllerphone = new TextEditingController();
  final TextEditingController _controllerfirstName =
      new TextEditingController();
  final TextEditingController _controllerlastName = new TextEditingController();
  final TextEditingController _controlleraddress = new TextEditingController();
  bool isObscuredPassword = true;
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
                                image: NetworkImage(
                                    'http://192.168.43.61:8000/images/1053244.png'),
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
            CreateNewuser();
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

  CreateNewuser() async {
    var userName = _controllerUserName.text;
    var useremail = _controllerEmail.text;
    var firstName = _controllerfirstName.text;
    var lastName = _controllerlastName.text;
    var phone = _controllerphone.text;
    var address = _controlleraddress.text;
    // print('userName : ${userName.text}');
    // print('userPrice: ${userPrice.text}');

    if (userName.isNotEmpty && useremail.isNotEmpty) {
      var url = BASE_API + "users/";
      var bodyData = json.encode({
        "username": userName,
        "email": useremail,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "address": address,
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
      // print(response.body);
      // var pro = json.decode(response.body)['username'];
      // print(pro);

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
