import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:responsive_admin_dashboard/product/index.dart';
import 'dart:io';

import '../user/constants/base_api.dart';
import 'constants/base_api.dart';

class Editproduct extends StatefulWidget {
  // const Editproduct({Key? key}) : super(key: key);

  String productId;
  String productName;
  String productPrice;

  String productImage;

  Editproduct({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });

  @override
  State<Editproduct> createState() => _EditproductState();
}

class _EditproductState extends State<Editproduct> {
  final TextEditingController _controllerproductName =
      new TextEditingController();
  final TextEditingController _controllerproductprice =
      new TextEditingController();
  final TextEditingController _controllerproductAddress =
      new TextEditingController();
  String productId = '';
  String productImage = '';
  bool isImageSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      productId = widget.productId;
      _controllerproductName.text = widget.productName;
      _controllerproductprice.text = widget.productPrice;

      productImage = widget.productImage;
    });
    print(widget.productName);

    print(widget.productImage);
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
                    "http://127.0.0.1:8000" + productImage.toString(), (file) {
                  setState(() {
                    productImage = file.path;
                    isImageSelected = true;
                  });
                }),
                Text(
                  widget.productName,
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
          controller: _controllerproductName,
          decoration: InputDecoration(
            hintText: "productName",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerproductprice,
          decoration: InputDecoration(
            hintText: "price",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 30,
        ),
        FlatButton(
            color: Color.fromARGB(255, 233, 181, 38),
            onPressed: () {
              editproduct();
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

  editproduct() async {
    var url = BASE_API + "products/$productId/";
    print(url);
    var productName = _controllerproductName.text;
    var productprice = _controllerproductprice.text;
    var productAddress = _controllerproductAddress.text;

    if (productName.isNotEmpty && productprice.isNotEmpty) {
      var bodyData = json.encode({
        "name_product": productName,
        "price_product": productprice,
        // "image": image,
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
        showMessageProd(context, messageSuccess);
      } else {
        var messageError = "Error";
        showMessageProd(context, messageError);
      }
    }
  }

  showMessageProd(BuildContext context, String contentMessage) {
    // set up the buttons
    var primary;

    Widget yesButton = FlatButton(
      child: Text("ok", style: TextStyle(color: primary)),
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => IndexPageProduct()),
            (Route<dynamic> route) => false);
        // deleteUser(item['id']);
      },
    );
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
