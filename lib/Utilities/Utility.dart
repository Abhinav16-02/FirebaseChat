import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';


class Utility {

  static final _shared = Utility.init();
  Utility.init();
  factory Utility() => _shared;

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenWidth(BuildContext context,{double multipliedBy = 1}) {
    return screenSize(context).width * multipliedBy;
  }

  double screenHeight(BuildContext context,{double multipliedBy = 1}) {
    return screenSize(context).height * multipliedBy;
  }
  String changeTimeFormat(Timestamp timeStamp){
  DateTime msgDate = DateTime.fromMillisecondsSinceEpoch(
        timeStamp.millisecondsSinceEpoch,
        isUtc: true);
    return formatDate(msgDate.toLocal(), [hh, ':', nn , " " ,am]);
  }
}
