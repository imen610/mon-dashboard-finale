import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_admin_dashboard/addMember.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

import '../product/constants/base_api.dart';
import '../simpleUser/main_page/theme/colors.dart';
import 'member_account_page.dart';

class AmountAllowedPage extends StatefulWidget {
  // AmountAllowedPage({Key? key}) : super(key: key);
  String id;
  String username;
  String email;
  String image;
  String phone;
  String firstName;
  String lastName;
  String address;
  List membre;
  AmountAllowedPage(
      {required this.id,
      required this.username,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.image,
      required this.membre});

  @override
  State<AmountAllowedPage> createState() => _AmountAllowedPageState();
}

class _AmountAllowedPageState extends State<AmountAllowedPage> {
  TextEditingController _controllerMaxAmount = TextEditingController();
  var id;
  var username;
  var email;
  var phone;
  var firstName;
  var lastName;
  var address;
  var image;
  var membre;

  Future<void> Upadateamount() async {
    setState(() {
      id = widget.id;
      username = widget.username;
      email = widget.email;
      phone = widget.phone;
      firstName = widget.firstName;
      lastName = widget.lastName;
      address = widget.address;
      image = widget.image;
      membre = widget.membre;
    });
    print(image);
    print(image);
    print(image);
    print(image);
    print(image);
    print(image);
    print(image);
    print(image);
    if (_controllerMaxAmount.text.isNotEmpty) {
      var response =
          await http.post(Uri.parse(BASE_API + "MaxAmountView/${widget.id}/"),
              headers: {"Content-Type": "application/json"},
              body: (jsonEncode({
                "maxAmount": _controllerMaxAmount.text,
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
  var result;

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
                  controller: _controllerMaxAmount,
                  decoration: InputDecoration(
                      labelText: 'Amount Allowed',
                      hintText: "Amount Allowed",
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
            Upadateamount();
          });
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            state = ButtonState.init;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MemberAccount(
                        memberId: id,
                        username: username,
                        email: email,
                        image: image.substring(21).toString(),
                        phone: phone,
                        firstName: firstName,
                        lastName: lastName,
                        address: address,
                        membre: membre)));
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

  showMessage(BuildContext context, String contentMessage) {
    // set up the buttons
    var primary;

    Widget yesButton = TextButton(
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
