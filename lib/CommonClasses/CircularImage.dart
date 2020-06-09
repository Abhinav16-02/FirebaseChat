import 'package:flutter/material.dart';
import 'package:firbase_chat/Extensions/Extensions.dart';

class RoundedImage extends StatelessWidget {
  final String imageUrl;
  final double borderRadius;
  final double width;
  final bool showLoader;
  RoundedImage(this.imageUrl,this.borderRadius,this.width,{this.showLoader=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width ,
      width: width,
      child: imageUrl != "" 
               ? ClipRRect(child: Image.asset("icons/user_profilr_pic@3x.png").getImageFrom(imageUrl,showLoader: showLoader),
               borderRadius: BorderRadius.circular(borderRadius),) : 
               Image.asset("icons/user_profilr_pic@3x.png"),
      );
  }
}
