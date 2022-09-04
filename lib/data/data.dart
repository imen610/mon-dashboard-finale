import 'package:responsive_admin_dashboard/bracelet.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/membre.dart';
import 'package:responsive_admin_dashboard/models/analytic_info_model.dart';
import 'package:responsive_admin_dashboard/models/discussions_info_model.dart';
import 'package:responsive_admin_dashboard/models/referal_info_model.dart';

import '../shop/index.dart';
import '../user/index.dart';

List analyticData = [
  AnalyticInfo(
      title: "Users",
      count: 720,
      svgSrc: "assets/icons/Subscribers.svg",
      color: primaryColor,
      route: IndexPage()),
  AnalyticInfo(
    title: "shops",
    count: 820,
    svgSrc: "assets/icons/Post.svg",
    color: purple,
    route: IndexPageShop(),
  ),
  AnalyticInfo(
      title: "payments",
      count: 920,
      svgSrc: "assets/icons/Pages.svg",
      color: orange,
      route: membre()),
  AnalyticInfo(
      title: "transactions",
      count: 920,
      svgSrc: "assets/icons/Comments.svg",
      color: green,
      route: bracelet()),
];

List referalData = [
  ReferalInfoModel(
    title: "Facebook",
    count: 234,
    svgSrc: "assets/icons/Facebook.svg",
    color: primaryColor,
  ),
  ReferalInfoModel(
    title: "Twitter",
    count: 234,
    svgSrc: "assets/icons/Twitter.svg",
    color: primaryColor,
  ),
  ReferalInfoModel(
    title: "Linkedin",
    count: 234,
    svgSrc: "assets/icons/Linkedin.svg",
    color: primaryColor,
  ),
  ReferalInfoModel(
    title: "Dribble",
    count: 234,
    svgSrc: "assets/icons/Dribbble.svg",
    color: red,
  ),
];
