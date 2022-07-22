import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Discussions extends StatefulWidget {
  const Discussions({Key? key}) : super(key: key);

  @override
  State<Discussions> createState() => _DiscussionsState();
}

class _DiscussionsState extends State<Discussions> {
  List shops = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchShop();
  }

  fetchShop() async {
    var url = Uri.parse("http://127.0.0.1:8000/auth/shops/");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        shops = items;
      });
    } else {
      setState(() {
        shops = [];
      });
    }
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 540,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shops',
                style: GoogleFonts.quicksand(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(
            height: appPadding,
          ),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: shops.length,
              itemBuilder: (context, index) => getCard(shops[index]),
            ),
          )
        ],
      ),
    );
  }

  Widget getCard(index) {
    var name_shop = index['name_shop'];
    var email_shop = index['email_shop'];
    var image_shop = index['image_shop'];
    var address_shop = index['address_shop'];
    return Container(
      margin: EdgeInsets.only(top: appPadding),
      padding: EdgeInsets.all(appPadding / 2),
      child: Row(
        children: [
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
                      image: NetworkImage(
                        "http://127.0.0.1:8000" + image_shop.toString(),
                      ),
                      fit: BoxFit.cover)),
            )),
          ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(40),
          //   child: Image.network(
          //     "http://127.0.0.1:8000" + image_shop.toString(),
          //     height: 38,
          //     width: 38,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name_shop.toString(),
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    address_shop.toString(),
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.more_vert_rounded,
            color: textColor.withOpacity(0.5),
            size: 18,
          )
        ],
      ),
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class IndexPage extends StatefulWidget {
//   const IndexPage({Key? key}) : super(key: key);

//   @override
//   State<IndexPage> createState() => _IndexPageState();
// }

// class _IndexPageState extends State<IndexPage> {
//   List users = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     this.fetchUser();
//   }

//   fetchUser() async {
//     var url = Uri.parse("http://127.0.0.1:8000/auth/shops/");
//     var response = await http.get(url);
//     if (response.statusCode == 200) {
//       var items = json.decode(response.body);
//       setState(() {
//         users = items;
//       });
//     } else {
//       setState(() {
//         users = [];
//       });
//     }
//     print(response.body);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Listing Users"),
//       ),
//       body: getBody(),
//     );
//   }

//   Widget getBody() {
//     List items = ["", ""];
//     return ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           return getCard(users[index]);
//         });
//   }

//   Widget getCard(index) {
//     var name_shop = index['name_shop'];
//     var email_shop = index['email_shop'];
//     var image_shop = index['image_shop'];
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Card(
//         child: ListTile(
//             title: Row(
//           children: <Widget>[
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                   color: Colors.purple,
//                   borderRadius: BorderRadius.circular(60),
//                   image: DecorationImage(
//                       image: NetworkImage(
//                           "http://127.0.0.1:8000" + image_shop.toString()),
//                       fit: BoxFit.cover)),
//             ),
//             SizedBox(
//               width: 20,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(name_shop.toString(), style: TextStyle(fontSize: 17)),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(email_shop.toString(),
//                     style: TextStyle(fontSize: 12, color: Colors.grey))
//               ],
//             )
//           ],
//         )),
//       ),
//     );
//   }
// }
