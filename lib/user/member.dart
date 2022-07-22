import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:responsive_admin_dashboard/user/constants/util.dart';

import '../shop/constants/util.dart';

class member extends StatefulWidget {
  //const EditUser({Key? key}) : super(key: key);
  String memberId;
  String username;
  String email;
  String image;
  String phone;
  String firstName;
  String lastName;
  String address;
  List membre;

  member(
      {required this.memberId,
      required this.username,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.image,
      required this.membre});

  @override
  State<member> createState() => _memberState();
}

class _memberState extends State<member> {
  // final TextEditingController _controllerUserName = new TextEditingController();
  // final TextEditingController _controllerEmail = new TextEditingController();
  // final TextEditingController _controllerphone = new TextEditingController();
  // final TextEditingController _controllerfirstName =
  //     new TextEditingController();
  // final TextEditingController _controllerlastName = new TextEditingController();
  // final TextEditingController _controlleraddress = new TextEditingController();
  String memberId = '';

  String image = '';
  bool isImageSelected = false;
  List members = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      memberId = widget.memberId;
      // _controllerUserName.text = widget.username;
      // _controllerEmail.text = widget.email;
      // _controllerphone.text = widget.phone;
      // _controllerlastName.text = widget.lastName;
      // _controllerfirstName.text = widget.firstName;
      // _controlleraddress.text = widget.address;
      image = widget.image;
    });

    print(widget.memberId);
    print(widget.username);
    print(widget.email);
    print(widget.image);
    print(widget.phone);
    print(widget.lastName);
    print(widget.firstName);
    print(widget.address);
    print("hello imen");
    print(widget.membre);
    print("users  ");
    var name = widget.membre.length;

    print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // Text(
                //   "Users",
                //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  child: Row(children: [
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Feather.search,
                      ),
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "search for contacts"),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 9,
              child: ListView.builder(
                  itemCount: widget.membre.length,
                  itemBuilder: (context, index) {
                    return cardItem(widget.membre[index]);
                  }))
        ],
      ),
    );
  }

  Widget cardItem(item) {
    var username = item['username'];
    var email = item['email'];
    var image = item['image'];
    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 204, 200, 200)
                                  .withOpacity(0.15),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 1))
                        ],
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(33)),
                    child: Row(children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: Colors.black)),
                        child: Center(
                            child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  image: NetworkImage(image.toString()),
                                  fit: BoxFit.cover)),
                        )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(username.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              email.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Color(0xff16F8FA),
                      icon: Icons.edit,
                      onTap: () {},
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Color(0xffFA1645),
                      icon: Icons.delete,
                      onTap: () {},
                      //  => showDeleteAlert(context, item)
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
