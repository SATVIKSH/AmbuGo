import 'package:codex/AllScreens/aboutScreen.dart';
import 'package:codex/AllScreens/helpScreen.dart';
import 'package:codex/AllScreens/loginScreen.dart';
import 'package:codex/AllScreens/personalDetails.dart';
import 'package:codex/Widgets//cachedImage.dart';
import 'package:codex/Widgets/divider.dart';
import 'package:codex/Widgets/photoViewPage.dart';
import 'package:codex/main.dart';
import 'package:codex/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class UserAccount extends StatefulWidget {
  static const String screenId = "userAccount";

  final String? name;
  final String? userPic;
  final String? email;
  final String? phone;
  UserAccount({Key? key, this.name, this.userPic, this.email, this.phone})
      : super(key: key);
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  Future<bool> _onBackPressed() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: custom(
          body: _userAccBody(context),
          imageUrl: widget.userPic,
          doctorsName: widget.name,
          context: context,
        ),
      ),
    );
  }

  Widget _userAccBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          15 * SizeConfig.heightMultiplier!,
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 2 * SizeConfig.heightMultiplier!,
                left: 2 * SizeConfig.widthMultiplier!,
                right: 2 * SizeConfig.widthMultiplier!,
              ),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalDetails(
                      name: widget.name!,
                      phone: widget.phone!,
                      userPic: widget.userPic!,
                      email: widget.email!,
                    ),
                  ),
                ),
                child: Container(
                  height: 12 * SizeConfig.heightMultiplier!,
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
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      splashColor: Color(0xFFa81845).withOpacity(0.6),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      radius: 800,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalDetails(
                            name: widget.name!,
                            phone: widget.phone!,
                            userPic: widget.userPic!,
                            email: widget.email!,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: <Widget>[
                            CachedImage(
                              imageUrl: widget.userPic,
                              isRound: true,
                              radius: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: 5 * SizeConfig.widthMultiplier!,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Spacer(),
                                Expanded(
                                  flex: 0,
                                  child: Container(
                                    width: 50 * SizeConfig.widthMultiplier!,
                                    child: Wrap(
                                      children: <Widget>[
                                        Text(
                                          widget.name!,
                                          style: TextStyle(
                                            color: Color(0xFFa81845),
                                            fontFamily: "Brand Bold",
                                            fontSize:
                                                3 * SizeConfig.textMultiplier!,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.5 * SizeConfig.heightMultiplier!,
                                ),
                                Text(
                                  widget.phone!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 2.2 * SizeConfig.textMultiplier!,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                            Container(
                              height: 10 * SizeConfig.heightMultiplier!,
                              width: 6 * SizeConfig.widthMultiplier!,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonalDetails(
                                      name: widget.name!,
                                      phone: widget.phone!,
                                      userPic: widget.userPic!,
                                      email: widget.email!,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Color(0xFFa81845),
                                    size: 4 * SizeConfig.imageSizeMultiplier!,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier!,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.widthMultiplier!,
                right: 2 * SizeConfig.widthMultiplier!,
                bottom: 2 * SizeConfig.heightMultiplier!,
              ),
              child: Container(
                height: 28 * SizeConfig.heightMultiplier!,
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
                      _tiles(
                        icon: CupertinoIcons.question_circle,
                        message: "Help",
                        color: Color(0xFFa81845),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpScreen(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier!,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier!,
                      ),
                      _tiles(
                        icon: CupertinoIcons.info_circle,
                        message: "About",
                        color: Color(0xFFa81845),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutScreen(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier!,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier!,
                      ),
                      _tiles(
                        icon: Icons.logout,
                        message: "Log out",
                        color: Color(0xFFa81845),
                        onTap: () {
                          Geofire.removeLocation(currentDriver!.uid);
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier!,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.widthMultiplier!,
                right: 2 * SizeConfig.widthMultiplier!,
                bottom: 2 * SizeConfig.heightMultiplier!,
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("images/logo.png"),
                      width: 14 * SizeConfig.widthMultiplier!,
                      height: 8 * SizeConfig.heightMultiplier!,
                    ),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        Text(
                          "Version:",
                          style: TextStyle(
                            fontSize: 2 * SizeConfig.textMultiplier!,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Brand Bold",
                            color: Color(0xFFa81845),
                          ),
                        ),
                        Text(
                          " 1.0.0",
                          style: TextStyle(
                            fontSize: 2 * SizeConfig.textMultiplier!,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Brand-Regular",
                            color: Color(0xFFa81845).withOpacity(0.6),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
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
      {IconData? icon, String? message, Function? onTap, Color? color}) {
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
          width: 84 * SizeConfig.widthMultiplier!,
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
              Container(
                height: 5 * SizeConfig.heightMultiplier!,
                width: 6 * SizeConfig.widthMultiplier!,
                child: GestureDetector(
                  onTap: onTap,
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: color,
                      size: 4 * SizeConfig.imageSizeMultiplier!,
                    ),
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

Widget custom(
    {required Widget body,
    String? doctorsName,
    imageUrl,
    BuildContext? context}) {
  return CustomScrollView(
    slivers: <Widget>[
      SliverAppBar(
        backgroundColor: Colors.grey[100],
        expandedHeight: 350,
        floating: false,
        pinned: true,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                doctorsName!,
                style: TextStyle(
                  color: Color(0xFFa81845),
                  fontFamily: "Brand Bold",
                  fontSize: 2.5 * SizeConfig.textMultiplier!,
                ),
              ),
            ),
          ),
          background: GestureDetector(
            onTap: () => Navigator.push(
                context!,
                MaterialPageRoute(
                  builder: (context) => PhotoViewPage(
                    myName: doctorsName,
                    message: imageUrl,
                    isSender: true,
                    doctorsName: doctorsName,
                  ),
                )),
            child: CachedImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              isRound: false,
              radius: 0,
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Center(
          child: body,
        ),
      ),
    ],
  );
}
