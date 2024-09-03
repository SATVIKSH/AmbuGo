import 'package:codex/Provider/userProvider.dart';
import 'package:codex/Widgets/cachedImage.dart';
import 'package:codex/Widgets/divider.dart';
import 'package:codex/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalDetails extends StatelessWidget {
  final String name;
  final String userPic;
  final String email;
  final String phone;
  PersonalDetails(
      {Key? key,
      required this.name,
      required this.userPic,
      required this.email,
      required this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          "Personal Details",
          style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845),
          ),
        ),
        backgroundColor: Colors.grey[100],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Container(
              height: 20 * SizeConfig.heightMultiplier!,
              child: Center(
                child: Container(
                  height: 15 * SizeConfig.heightMultiplier!,
                  width: 30 * SizeConfig.widthMultiplier!,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    border: Border.all(
                        color: Color(0xFFa81845),
                        style: BorderStyle.solid,
                        width: 2),
                  ),
                  child: userPic == null
                      ? Image.asset("images/user_icon.png")
                      : CachedImage(
                          imageUrl: userPic,
                          isRound: true,
                          radius: 10,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Text(
              "Driver",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 2.5 * SizeConfig.textMultiplier!,
                fontFamily: "Brand Bold",
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier!,
            ),
            Container(
              height: 37 * SizeConfig.heightMultiplier!,
              width: 88 * SizeConfig.widthMultiplier!,
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
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    _tiles(title: "Name", message: name, color: Colors.black54),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier!,
                    ),
                    DividerWidget(),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier!,
                    ),
                    _tiles(
                        title: "Email", message: email, color: Colors.black54),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier!,
                    ),
                    DividerWidget(),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier!,
                    ),
                    _tiles(
                        title: "Phone Number",
                        message: phone,
                        color: Colors.black54),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier!,
                    ),
                    DividerWidget(),
                    SizedBox(
                      height: 1 * SizeConfig.heightMultiplier!,
                    ),
                    _tiles(
                        title: "Licence Plate",
                        message: Provider.of<UserProvider>(context)
                            .getUser!
                            .licencePlate!,
                        color: Colors.black54),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tiles(
      {required String title, required String message, required Color color}) {
    return Container(
      height: 7 * SizeConfig.heightMultiplier!,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: "Brand Bold",
                  fontSize: 3 * SizeConfig.textMultiplier!,
                ),
              ),
              Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: color,
                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                ),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
