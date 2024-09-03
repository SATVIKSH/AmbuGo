import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final bool? isRound;
  final double? radius;
  final double? height;
  final double? width;
  final BoxFit? fit;

  CachedImage(
      {Key? key,
      this.imageUrl,
      this.isRound = false,
      this.radius,
      this.height,
      this.width,
      this.fit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        height: isRound! ? radius : height,
        width: isRound! ? radius : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isRound! ? 50 : radius!),
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: fit,
                  placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFa81845)),
                  )),
                  errorWidget: (context, url, error) =>
                      Image.asset("images/user_icon.png"),
                )
              : Image.asset("images/user_icon.png"),
        ),
      );
    } catch (e) {
      print("CachedImage Error ::: " + e.toString());
      return Image.asset("images/user_icon.png");
    }
  }
}
