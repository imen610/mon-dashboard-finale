import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:responsive_admin_dashboard/user/constants/util.dart';

import '../shop/theme/theme_colors.dart';
import 'constants/base_api.dart';
import 'member.dart';

class ListMember extends StatefulWidget {
  //const EditUser({Key? key}) : super(key: key);
  String userId;
  String username;
  String email;
  String image;
  String phone;
  String firstName;
  String lastName;
  String address;

  ListMember(
      {required this.userId,
      required this.username,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.image});

  @override
  State<ListMember> createState() => _ListMemberState();
}

class _ListMemberState extends State<ListMember> {
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
    this.fetchmember();
    setState(() {
      userId = widget.userId;
    });

    // print(widget.userId);
    // print(widget.username);
    // print(widget.email);
    // print(widget.image);
    // print(widget.phone);
    // print(widget.lastName);
    // print(widget.firstName);
    // print(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff89e6f5),
          flexibleSpace: SafeArea(
              child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                picPicker(isImageSelected, image, (file) {
                  setState(() {
                    image = file.path;
                    isImageSelected = true;
                  });
                }),
                Text(
                  widget.username,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )),
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (isLoading || members.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
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
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return cardItem(members[index]);
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
                        onTap: () => showDeleteAlert(context, item)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // getmember(item) {
  //   var memberId = item['id'].toString();
  //   var username = item['username'].toString();
  //   var email = item['email'].toString();
  //   var image = item['image'].toString();
  //   var firstName = item['first_name'].toString();
  //   var lastName = item['last_name'].toString();
  //   var phone = item['phone'].toString();
  //   var address = item['address'].toString();
  //   var membre = item['membre'];
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => member(
  //                 memberId: memberId,
  //                 username: username,
  //                 email: email,
  //                 phone: phone,
  //                 firstName: firstName,
  //                 lastName: lastName,
  //                 address: address,
  //                 image: image,
  //                 membre: membre,
  //               )));
  // }

  // EditUser() async {
  //   var url = BASE_API + "users/$userId/";
  //   print(url);
  //   var username = _controllerUserName.text;
  //   var email = _controllerEmail.text;
  //   var firstName = _controllerfirstName.text;
  //   var lastName = _controllerlastName.text;
  //   var phone = _controllerphone.text;
  //   var address = _controlleraddress.text;
  //   if (username.isNotEmpty && email.isNotEmpty) {
  //     var bodyData = json.encode({
  //       "username": username,
  //       "email": email,
  //       // "image": image,
  //       "first_name": firstName,
  //       "last_name": lastName,
  //       "phone": int.parse(phone),
  //       "address": address,
  //       // "image_User": null
  //     });
  //     var response = await http.put(Uri.parse(url),
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Accept": "application/json",
  //         },
  //         body: bodyData);
  //     print(url);
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       var messageSuccess = "success";
  //       showMessage(context, messageSuccess);
  //     } else {
  //       var messageError = "Error";
  //       showMessage(context, messageError);
  //     }
  //   }
  // }

  List members = [];
  bool isLoading = false;

  fetchmember() async {
    setState(() {
      isLoading = false;
    });
    var url = BASE_API + "usermem/$userId/";
    print(url);
    var response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      // print(items);
      setState(() {
        members = items;
        isLoading = false;
      });
      return;
    } else {
      setState(() {
        members = [];
        isLoading = true;
      });
    }
  }

  static Widget picPicker(
    bool isFileSelected,
    String fileName,
    Function onFilePicked,
  ) {
    Future<XFile?> _imageFile;
    ImagePicker _picker = ImagePicker();
    return Column(
      children: [
        fileName.isNotEmpty
            ? isFileSelected
                ? Image.file(
                    File(fileName),
                    height: 200,
                  )
                : SizedBox(
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                          child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                                image: NetworkImage(fileName),
                                fit: BoxFit.cover)),
                      )),
                    ),
                    // child: Image.network(
                    //   fileName,
                    //   width: 20,
                    //   height: 20,
                    //   fit: BoxFit.scaleDown,),
                  )
            : SizedBox(
                child: Image.network(
                  'http://127.0.0.1:8000/images/2af5edae259d0d57fc410682e0338b14_y2DfKqW.jpg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.scaleDown,
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35.0,
              width: 35.0,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.image,
                  size: 15,
                ),
                onPressed: () {
                  _imageFile = _picker.pickImage(source: ImageSource.gallery);
                  _imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
            SizedBox(
              height: 35.0,
              width: 35.0,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.camera,
                  size: 15,
                ),
                onPressed: () {
                  _imageFile = _picker.pickImage(source: ImageSource.camera);
                  _imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            )
          ],
        )
      ],
    );
  }

  showDeleteAlert(BuildContext context, item) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(color: primary),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Yes", style: TextStyle(color: primary)),
      onPressed: () {
        Navigator.pop(context);

        //deleteUser(item['id']);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Would you like to delete this user?"),
      actions: [
        noButton,
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
