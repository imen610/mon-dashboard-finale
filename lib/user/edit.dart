import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:responsive_admin_dashboard/user/constants/util.dart';

import '../shop/constants/base_api.dart';
import 'constants/base_api.dart';

class EditUser extends StatefulWidget {
  //const EditUser({Key? key}) : super(key: key);
  String userId;
  String username;
  String email;
  String image;
  String phone;
  String firstName;
  String lastName;
  String address;

  EditUser(
      {required this.userId,
      required this.username,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.image});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
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
      image = 'http://192.168.11.105:8000' + widget.image.toString();
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(240),
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
                    _imageFile = file;
                    isImageSelected = true;
                  });
                  print("rrrr" + image);
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
          height: 30,
        ),
        TextField(
          controller: _controllerfirstName,
          decoration: InputDecoration(
            hintText: "FirstName",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerlastName,
          decoration: InputDecoration(
            hintText: "lastName",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerphone,
          decoration: InputDecoration(
            hintText: "phone",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controlleraddress,
          decoration: InputDecoration(
            hintText: "address",
          ),
        ),
        SizedBox(
          height: 40,
        ),
        TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
              Color(0xff89e6f5),
            )),
            onPressed: () {
           //   print("zzzz" + _imageFile!.path);

              editUser();
            },
            child: Text(
              "done",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ))
      ],
    );
  }

  editUser() async {
    var url = BASE_API + "users/$userId/";
    print(url);
    var username = _controllerUserName.text;
    var email = _controllerEmail.text;
    var firstName = _controllerfirstName.text;
    var lastName = _controllerlastName.text;
    var phone = _controllerphone.text;
    var address = _controlleraddress.text;
    if (username.isNotEmpty && email.isNotEmpty) {
      print("ffff" + image);
      var bodyData = {
        "username": username,
        "email": email,
        "image": File(image),
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "address": address,
        // "image_User": null
      };
      multiPart(
        body: bodyData,
        multipart: false,
        files: [File(image)],
      );

      //   var response = await http.put(Uri.parse(url),
      //       headers: {
      //         "Content-Type": "application/json",
      //         "Accept": "application/json",
      //       },
      //       body: bodyData);
      //   print(url);
      //   print(response.statusCode);
      //   if (response.statusCode == 200) {
      //     var messageSuccess = "success";
      //     showMessage(context, messageSuccess);
      //   } else {
      //     var messageError = "Error";
      //     showMessage(context, messageError);
      //   }
    }
  }

  XFile? _imageFile;

  Widget picPicker(
    bool isFileSelected,
    String fileName,
    Function onFilePicked,
  ) {
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
                      width: 135,
                      height: 135,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                          child: Container(
                        width: 130,
                        height: 130,
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
                  'http://192.168.11.105:8000/images/2af5edae259d0d57fc410682e0338b14_y2DfKqW.jpg',
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
                onPressed: () async {
                  _imageFile = await _picker
                      .pickImage(source: ImageSource.gallery)
                      .then((value) {
                    print("aaaaaaaaa" + value!.path);
                    setState(() {
                      _imageFile = value;
                    });
                    onFilePicked(value);
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
                onPressed: () async {
                  _imageFile = await _picker
                      .pickImage(source: ImageSource.camera)
                      .then((value) => onFilePicked(value));
                  // _imageFile?.then((file) async {
                  //   onFilePicked(file);
                  // });
                },
              ),
            )
          ],
        )
      ],
    );
  }

  Future<http.Response> multiPart(
      {String action = "PUT",
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      bool multipart = true,
      Map<String, File> namedFiles = const {},
      List<File> files = const []}) async {
    String url = BASE_API + "users/$userId/";
    Uri uri = Uri.parse(url);

    var request = http.MultipartRequest(action, uri);

    request.headers.addAll(headers ?? {});

    if (multipart) {
      request.headers[HttpHeaders.contentTypeHeader] =
          'multipart/form-data;charset=utf-8;application/json';
    }

    body?.forEach((key, value) {
      if (value != null) request.fields[key] = value.toString();
    });

    print('yyyyyyyyyyyy' + request.fields.toString());

    for (var file in files) {
      final image = await http.MultipartFile.fromPath("image", file.path);
      request.files.add(image);
    }

    namedFiles.forEach((key, mfile) async {
      print('bbbbbbbbbbbbb' + key.toString());

      final file = await http.MultipartFile.fromPath(key, mfile.path);
      request.files.add(file);
    });

    return request.send().then((http.StreamedResponse value) {
      return value.stream.bytesToString().then((body) {
        print(body);
        return Future.value(http.Response(body, value.statusCode));
      });
    });
  }
}
