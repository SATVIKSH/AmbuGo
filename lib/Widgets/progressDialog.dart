import 'package:codex/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class ProgressDialog extends StatelessWidget {
  String? message;
  ProgressDialog({this.message});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      insetPadding: EdgeInsets.zero,
      elevation: 10,
      child: Container(
        width: 5 * SizeConfig.widthMultiplier!,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 6.0,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFa81845)),
              ),
              SizedBox(
                width: 2 * SizeConfig.widthMultiplier!,
              ),
              Container(
                child: Text(
                  message!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Color(0xFFa81845),
                    fontSize: 1.8 * SizeConfig.textMultiplier!,
                    fontFamily: "Brand-Regular",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
