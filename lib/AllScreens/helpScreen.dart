import 'package:codex/Widgets/divider.dart';
import 'package:codex/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          "Help",
          style: TextStyle(fontFamily: "Brand Bold", color: Color(0xFFa81845)),
        ),
        backgroundColor: Colors.grey[100],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[100],
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 2 * SizeConfig.heightMultiplier!,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "WE ARE HAPPY TO HELP",
                    style: TextStyle(
                      fontSize: 2 * SizeConfig.textMultiplier!,
                      fontFamily: "Brand Bold",
                      fontWeight: FontWeight.w900,
                      color: Colors.black54,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 2 * SizeConfig.heightMultiplier!,
              ),
              Container(
                height: 28 * SizeConfig.heightMultiplier!,
                width: 95 * SizeConfig.widthMultiplier!,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    children: <Widget>[
                      _tiles(
                          onTap: () {},
                          icon: CupertinoIcons.phone_circle,
                          message: "Call Help Line",
                          color: Color(0xFFa81845)),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier!,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier!,
                      ),
                      _tiles(
                          onTap: () {},
                          icon: CupertinoIcons.exclamationmark_triangle,
                          message: "Report a Problem",
                          color: Color(0xFFa81845)),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier!,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier!,
                      ),
                      _tiles(
                          onTap: () {},
                          icon: CupertinoIcons.ellipses_bubble,
                          message: "Send Feedback",
                          color: Color(0xFFa81845)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tiles(
      {IconData? icon, String? message, Color? color, Function? onTap}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Color(0xFFa81845).withOpacity(0.6),
        highlightColor: Colors.grey.withOpacity(0.1),
        radius: 800,
        borderRadius: BorderRadius.circular(10),
        onTap: onTap as VoidCallback,
        child: Container(
          height: 7 * SizeConfig.heightMultiplier!,
          width: 93 * SizeConfig.widthMultiplier!,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: color,
                size: 6 * SizeConfig.imageSizeMultiplier!,
              ),
              SizedBox(
                width: 3 * SizeConfig.widthMultiplier!,
              ),
              Text(
                message!,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: color,
                  fontFamily: "Brand-Regular",
                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
