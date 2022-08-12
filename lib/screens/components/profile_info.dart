import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../shop/constants/base_api.dart';
import 'EditUserProfile.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  var user;
  @override
  void initState() {
    super.initState();
    this.fetchUSER();
  }

  fetchUSER() async {
    var url = BASE_API + "current/";
    SharedPreferences access_data = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json ; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${access_data.getString('access_token')}'
    });

    // print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      print(items['username']);
      print(items['image']);
      print('http://127.0.0.1:8000' + items['image'].toString());
      setState(() {
        user = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(appPadding),
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/icons/Bell.svg",
                height: 25,
                color: textColor.withOpacity(0.8),
              ),
              Positioned(
                right: 0,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: red,
                  ),
                ),
              )
            ],
          ),
        ),
        getItems(user)
      ],
    );
  }

  Widget getItems(items) {
    return Container(
      margin: EdgeInsets.only(left: appPadding),
      padding: EdgeInsets.symmetric(
        horizontal: appPadding,
        vertical: appPadding / 2,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => getUserItem()))
            },
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.black)),
              child: Center(
                  child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: NetworkImage(
                          'http://127.0.0.1:8000' + items['image'].toString(),
                        ),
                        fit: BoxFit.cover)),
              )),
            ),
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding / 2),
              child: Text(
                'Hii, ${items['username']}',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
        ],
      ),
    );
  }
  getUserItem(){
    var userId = user['id'].toString();
    var username = user['username'].toString();
    var email = user['email'].toString();
    var image = user['image'].toString();
    var firstName = user['first_name'].toString();
    var lastName = user['last_name'].toString();
    var phone = user['phone'].toString();
    var address = user['address'].toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(
                  userId: userId,
                  username: username,
                  email: email,
                  phone: phone,
                  firstName: firstName,
                  lastName: lastName,
                  address: address,
                  image: image,
                )));
  }
}
