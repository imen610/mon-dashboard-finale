import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../user/constants/base_api.dart';
import 'constants/base_api.dart';

class EditShop extends StatefulWidget {
  // const EditShop({Key? key}) : super(key: key);

  String shopId;
  String ShopName;
  String ShopEmail;
  String ShopAddress;
  String ShopImage;
  List products;

  EditShop(
      {required this.shopId,
      required this.ShopName,
      required this.ShopEmail,
      required this.ShopImage,
      required this.products,
      required this.ShopAddress});

  @override
  State<EditShop> createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> {
  final TextEditingController _controllerShopName = new TextEditingController();
  final TextEditingController _controllerShopEmail =
      new TextEditingController();
  final TextEditingController _controllerShopAddress =
      new TextEditingController();
  String shopId = '';
  String ShopImage = '';
  bool isImageSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      shopId = widget.shopId;
      _controllerShopName.text = widget.ShopName;
      _controllerShopEmail.text = widget.ShopEmail;
      _controllerShopAddress.text = widget.ShopAddress;
      ShopImage = widget.ShopImage;
    });
    print(widget.ShopName);
    print(widget.ShopEmail);
    print(widget.ShopAddress);
    print(widget.ShopImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 233, 181, 38),
          flexibleSpace: SafeArea(
              child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                picPicker(isImageSelected,
                    "http://127.0.0.1:8000" + ShopImage.toString(), (file) {
                  setState(() {
                    ShopImage = file.path;
                    isImageSelected = true;
                  });
                }),
                Text(
                  widget.ShopName,
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
          controller: _controllerShopName,
          decoration: InputDecoration(
            hintText: "shopName",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerShopEmail,
          decoration: InputDecoration(
            hintText: "email",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerShopAddress,
          decoration: InputDecoration(
            hintText: "Address",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FlatButton(
            color: Color.fromARGB(255, 233, 181, 38),
            onPressed: () {
              EditShop();
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

  EditShop() async {
    var url = BASE_API + "shops/$shopId/";
    print(url);
    var ShopName = _controllerShopName.text;
    var ShopEmail = _controllerShopEmail.text;
    var ShopAddress = _controllerShopAddress.text;

    if (ShopName.isNotEmpty && ShopEmail.isNotEmpty) {
      var bodyData = json.encode({
        "name_shop": ShopName,
        "email_shop": ShopEmail,
        // "image": image,
        "address_shop": ShopAddress,
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
        showMessage(context, messageSuccess);
      } else {
        var messageError = "Error";
        showMessage(context, messageError);
      }
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
}
