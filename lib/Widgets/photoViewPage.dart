import 'package:codex/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
/*
* Created by Mujuzi Moses
*/

class PhotoViewPage extends StatelessWidget {
  final String? message;
  final bool? isSender;
  final String? chatRoomId;
  final String? doctorsName;
  final String? myName;
  const PhotoViewPage(
      {Key? key,
      this.message,
      this.isSender,
      this.chatRoomId,
      this.doctorsName,
      @required this.myName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String sender = chatRoomId
        .toString()
        .replaceAll("_", "")
        .replaceAll(myName as Pattern, "");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        titleSpacing: 0,
        title: isSender!
            ? Text(
                "You",
                style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Color(0xFFa81845),
                ),
              )
            : Text(
                chatRoomId != null ? sender : "Dr. " + doctorsName!,
                style: TextStyle(
                    fontFamily: "Brand Bold", color: Color(0xFFa81845)),
              ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: message != null
            ? PhotoView(
                imageProvider: NetworkImage(
                  message!,
                ),
                maxScale: PhotoViewComputedScale.covered * 2,
                minScale: PhotoViewComputedScale.contained,
                initialScale: PhotoViewComputedScale.contained,
                enableRotation: false,
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFa81845)),
                  ),
                ),
              )
            : Container(
                color: Colors.black,
                child: Center(
                  child: Image.asset("images/user_icon.png"),
                ),
              ),
      ),
    );
  }
}
