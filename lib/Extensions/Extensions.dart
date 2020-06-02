import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

extension Style on TextStyle {
  TextStyle getStyleBody1(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1;
  }

  TextStyle getStyleBody2(BuildContext context) {
    return Theme.of(context).textTheme.bodyText2;
  }

  TextStyle getStyleButton(BuildContext context) {
    return Theme.of(context).textTheme.button;
  }
}

extension CachedImage on Image {
  CachedNetworkImage getImageFrom(String stringUrl,{double width=40,double height=40}) {
   return  CachedNetworkImage(
      //placeholder: (context,url) => CircularProgressIndicator(),
      imageUrl: stringUrl,
      width: width,
      height:height
    );
  }
}
