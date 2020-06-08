import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final String imageUrl;
  final double borderRadius;
  final double width;
  RoundedImage(this.imageUrl,this.borderRadius,this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width ,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        image: DecorationImage(
          image: imageUrl != ""
              ? Image.network(imageUrl).image
              : Image.asset("icons/user_profilr_pic@3x.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
