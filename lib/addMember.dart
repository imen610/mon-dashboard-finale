import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

import 'package:responsive_admin_dashboard/shop/constants/base_api.dart';
import 'package:responsive_admin_dashboard/user/member.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class addMember extends StatefulWidget {
  // addMember({Key? key}) : super(key: key);
  String userId;
  String Id;
  String username;
  String email;
  String image;
  String phone;
  String firstName;
  String lastName;
  String address;
  List membre;

  addMember(
      {required this.userId,
      required this.Id,
      required this.username,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.membre,
      required this.image});
  @override
  State<addMember> createState() => _addMemberState();
}

enum ButtonState { init, loading, done }

class _addMemberState extends State<addMember> {
  String userId = '';
  String image = '';
  String userName = '';
  bool isImageSelected = false;
  bool isLoading = true;
  var mId;
  var mname;
  var memail;
  var mimage;
  var mfirstName;
  var mlastName;
  var mphone;
  var maddress;
  var mmembre;

  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  TextEditingController ToController = new TextEditingController();
  bool isAnimating = true;
  bool isFocused = false;
  List members = [];
  List list = [];
  @override
  void initState() {
    // this.GetMembers();
    this.addMemberToUser();
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(onFocusChanged);
    setState(() {
      userId = widget.userId;
      image = widget.image.toString();
      userName = widget.username;
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
                SizedBox(
                  height: 50,
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
                  height: 10,
                ),
                FadeInUp(
                    from: 60,
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      widget.email,
                      style: TextStyle(color: Colors.grey),
                    )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  // width: width,
                  // height: 70,
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
            addMemberToUser();
            this.GetMembers();
          });
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            state = ButtonState.init;
            // GetMembers();
            print('xxxxxxxxxxxxxxxx');
            print('xxxxxxxxxxxxxxxx');
            print('xxxxxxxxxxxxxxxx');
            print(widget.membre);
            print(list);
            Map<String, dynamic> params = {};
            params.putIfAbsent('id', () => widget.Id);
            params.putIfAbsent('username', () => widget.username);
            params.putIfAbsent('email', () => widget.email);
            params.putIfAbsent('image', () => widget.image);
            params.putIfAbsent('phone', () => widget.phone);
            params.putIfAbsent('firstName', () => widget.firstName);
            params.putIfAbsent('lastName', () => widget.lastName);
            params.putIfAbsent('address', () => widget.address);
            params.putIfAbsent('members', () => members);
            Navigator.pop(
              context, params
            );
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => member(
            //               memberId: widget.Id,
            //               username: widget.username,
            //               email: widget.email,
            //               image: widget.image,
            //               phone: widget.phone,
            //               firstName: widget.firstName,
            //               lastName: widget.lastName,
            //               address: widget.address,
            //               membre: members,
            //             )),
            //     ModalRoute.withName('/'));
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

  Future<void> addMemberToUser() async {
    var url = BASE_API + "usermem/${widget.Id}/";
    // print(url);

    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json ; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${access_data.getString('access_token')}'
        },
        body: (jsonEncode({"id": userId})));
    // print(userName);

    // print(response.body[0]);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      this.GetMembers();
    }
  }

  Future<void> GetMembers() async {
    String? token;
    SharedPreferences.getInstance().then((sharedPrefValue) {
      setState(() {
        isLoading = false;
        token = sharedPrefValue.getString(appConstants.KEY_ACCESS_TOKEN);
      });
    });

    var url = BASE_API + "usermem/${widget.Id}/";
    print("<<<<<<<<<<<<<");
    print(url);

    print(widget.Id);
    print(widget.userId);
    SharedPreferences access_data = await SharedPreferences.getInstance();

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}',
    });
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);

      setState(() {
        members = items;
      });
      for (var item in members) {
        print('qqqqqqqqqqqqqqqqqqqq');
        print('${item['username']}');
        list.add(item['id']);
      }
      list.add(widget.userId);
      print(list);
      print('qqqqqqqqqqqqqqqqqqqq');
      print('qqqqqqqqqqqqqqqqqqqq');
      print('qqqqqqqqqqqqqqqqqqqq');
      return;
    } else {
      setState(() {
        members = [];
        isLoading = true;
      });
    }
  }
}
