import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex/AllScreens/aboutScreen.dart';
import 'package:codex/AllScreens/helpScreen.dart';
import 'package:codex/AllScreens/loginScreen.dart';
import 'package:codex/AllScreens/personalDetails.dart';
import 'package:codex/AllScreens/registerScreen.dart';
import 'package:codex/Models/directionDetails.dart';
import 'package:codex/Notifications/pushNotificationService.dart';
import 'package:codex/Services/database.dart';
import 'package:codex/Utilities/permissions.dart';
import 'package:codex/Widgets/cachedImage.dart';
import 'package:codex/Widgets/divider.dart';
import 'package:codex/Widgets/photoViewPage.dart';
import 'package:codex/configMaps.dart';
import 'package:codex/constants.dart';
import 'package:codex/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../sizeConfig.dart';

class HomePage extends StatefulWidget {
  static const String screenId = "homePage";

  final String? uid;
  final String? name;
  final String? phone;
  final String? email;
  final String? userPic;
  const HomePage(
      {Key? key, this.uid, this.name, this.phone, this.email, this.userPic})
      : super(key: key);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.369719, 32.659309),
    zoom: 14.4746,
  );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    locatePosition();
    getCurrentDriverInfo();
    final PushNotificationService pushNotificationService =
        PushNotificationService();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("check ${message.data.entries.first.value}");
      pushNotificationService.retrieveRideRequestInfo(
          pushNotificationService.getRideRequestId(message.data), context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("check");
      pushNotificationService.retrieveRideRequestInfo(
          pushNotificationService.getRideRequestId(message.data), context);
    });
    super.initState();
  }

  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? newGoogleMapController;

  DirectionDetails? tripDirectionDetails;
  String driverStatus = "Offline now, Go Live";
  Color driverStatusColor = Colors.green[300]!;
  bool? isDriverAvailable;

  var geoLocator = Geolocator();
  double leftRightPadding = 20 * SizeConfig.widthMultiplier!;

  getRatings() {
    QuerySnapshot driverSnap;
    DatabaseMethods().getDriverByUid(currentDriver!.uid).then((val) {
      driverSnap = val;

      if (driverSnap.docs[0].get("ratings") != null) {
        Map<dynamic, dynamic> ratingsMap = driverSnap.docs[0].get("ratings");
        int ratingPeople = int.parse(ratingsMap['people']);
        double percentage = double.parse(ratingsMap['percentage']);
        double val = 0;
        setState(() {
          val = percentage;
          people = ratingPeople;
        });

        if (val <= 5) {
          setState(() {
            starCounter = 1;
            title = "Very Bad Driver";
          });
          return;
        }
        if (val <= 25) {
          setState(() {
            starCounter = 2;
            title = "Bad Driver";
          });
          return;
        }
        if (val <= 50) {
          setState(() {
            starCounter = 3;
            title = "Good Driver";
          });
          return;
        }
        if (val <= 75) {
          setState(() {
            starCounter = 4;
            title = "Very Good Driver";
          });
          return;
        }
        if (val <= 100) {
          setState(() {
            starCounter = 5;
            title = "Excellent Driver";
          });
          return;
        }
      }
    });
  }

  Future locatePosition() async {
    Permissions.locationPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    print("we are here 123");
  }

  Future getCurrentDriverInfo() async {
    PushNotificationService pushNotificationService = PushNotificationService();

    await pushNotificationService.initialize(context);
    await pushNotificationService.getToken(context);

    getRatings();
  }

  Future<void> _onBackPressed() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit the app?"),
        actions: <Widget>[
          ElevatedButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text("Yes"),
            onPressed: () {
              if (isDriverAvailable == true) {
                makeDriverOfflineNow();
                setState(() {
                  leftRightPadding = 20 * SizeConfig.widthMultiplier!;
                  driverStatusColor = Colors.green[300]!;
                  driverStatus = "Offline now, Go Live";
                  isDriverAvailable = false;
                });
              }
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        await _onBackPressed();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          title: Text(
            "Ambulance",
            style:
                TextStyle(fontFamily: "Brand Bold", color: Color(0xFFa81845)),
          ),
        ),
        drawer: Container(
          width: 65 * SizeConfig.widthMultiplier!,
          child: Drawer(
            elevation: 0,
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradientColor,
                  ),
                  child: Row(
                    children: <Widget>[
                      CachedImage(
                        imageUrl: widget.userPic,
                        isRound: true,
                        radius: 70,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier!),
                      Container(
                        height: 10 * SizeConfig.heightMultiplier!,
                        width: 36 * SizeConfig.widthMultiplier!,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Spacer(),
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 3 * SizeConfig.heightMultiplier!,
                                  width: 36 * SizeConfig.widthMultiplier!,
                                  child: Text(
                                    widget.name!,
                                    style: TextStyle(
                                      fontSize:
                                          2.3 * SizeConfig.textMultiplier!,
                                      fontFamily: "Brand Bold",
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 2 * SizeConfig.heightMultiplier!,
                                  width: 36 * SizeConfig.widthMultiplier!,
                                  child: Text(
                                    widget.email!,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Brand-Regular",
                                      fontSize:
                                          1.5 * SizeConfig.textMultiplier!,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DividerWidget(),
                SizedBox(
                  height: 12.0,
                ),
                //Drawer body controller
                GestureDetector(
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
                  child: ListTile(
                    leading: Container(
                      height: 5 * SizeConfig.heightMultiplier!,
                      width: 10 * SizeConfig.widthMultiplier!,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradientColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.person_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpScreen(),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 5 * SizeConfig.heightMultiplier!,
                      width: 10 * SizeConfig.widthMultiplier!,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradientColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.question_circle_fill,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      "Help",
                      style: TextStyle(
                          fontSize: 15.0, fontFamily: "Brand-Regular"),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutScreen(),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 5 * SizeConfig.heightMultiplier!,
                      width: 10 * SizeConfig.widthMultiplier!,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradientColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      "About",
                      style: TextStyle(
                          fontSize: 15.0, fontFamily: "Brand-Regular"),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Geofire.removeLocation(currentDriver!.uid);
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: ListTile(
                    leading: Container(
                      height: 5 * SizeConfig.heightMultiplier!,
                      width: 10 * SizeConfig.widthMultiplier!,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradientColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      "Log Out",
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Color(0xFFa81845),
                          fontFamily: "Brand Bold"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: Stack(
            children: <Widget>[
              Container(
                clipBehavior: Clip.hardEdge,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                child: GoogleMap(
                  padding: EdgeInsets.only(
                    top: 1.3 * SizeConfig.heightMultiplier!,
                  ),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: HomePage._kGooglePlex,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _googleMapController.complete(controller);
                    newGoogleMapController = controller;
                    locatePosition();
                  },
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 10, top: 15),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => profilePicView(
                                myName: widget.name!,
                                imageUrl: widget.userPic!,
                                context: context,
                                isSender: true,
                                chatRoomId: ""),
                            child: CachedImage(
                              imageUrl: widget.userPic,
                              isRound: true,
                              radius: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 5 * SizeConfig.widthMultiplier!,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 0,
                                child: Container(
                                  width: 60 * SizeConfig.widthMultiplier!,
                                  child: Wrap(
                                    children: [
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
                                TimeOfDay.now().hour >= 12 &&
                                        TimeOfDay.now().hour < 16
                                    ? "Good Afternoon!"
                                    : TimeOfDay.now().hour >= 16
                                        ? "Good Evening!"
                                        : "Good Morning!",
                                style: TextStyle(
                                  color: Color(0xFFa81845).withOpacity(0.6),
                                  fontSize: 2.2 * SizeConfig.textMultiplier!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                curve: Curves.fastOutSlowIn,
                duration: new Duration(milliseconds: 400),
                top: 10 * SizeConfig.heightMultiplier!,
                left: leftRightPadding,
                right: leftRightPadding,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2 * SizeConfig.widthMultiplier!,
                  ),
                  child: ElevatedButton(
                    clipBehavior: Clip.hardEdge,
                    // padding: EdgeInsets.zero,
                    // elevation: 10,
                    onPressed: () {
                      if (isDriverAvailable != true) {
                        makeDriverOnlineNow();
                        getLocationLiveUpdates();
                        setState(() {
                          leftRightPadding = 30 * SizeConfig.widthMultiplier!;
                          driverStatusColor = Color(0xFFa81845);
                          driverStatus = "Online Now";
                          isDriverAvailable = true;
                        });
                        displaySnackBar(
                            message: "You are online now",
                            context: context,
                            label: "OK");
                      } else {
                        makeDriverOfflineNow();
                        setState(() {
                          leftRightPadding = 20 * SizeConfig.widthMultiplier!;
                          driverStatusColor = Colors.green[300]!;
                          driverStatus = "Offline now, Go Live";
                          isDriverAvailable = false;
                        });
                        displaySnackBar(
                            message: "You are offline now",
                            context: context,
                            label: "OK");
                      }
                    },
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10)),
                    // color: driverStatusColor,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              driverStatus,
                              style: TextStyle(
                                fontSize: 2.5 * SizeConfig.textMultiplier!,
                                color: Colors.white,
                                fontFamily: "Brand Bold",
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 8 * SizeConfig.imageSizeMultiplier!,
                          ),
                        ],
                      ),
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

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentDriver!.uid, currentPosition!.latitude,
        currentPosition!.longitude);

    Map<String, dynamic> update = {"newRide": "searching"};
    await databaseMethods.updateDriverDocField(update, currentDriver!.uid);
  }

  void getLocationLiveUpdates() async {
    homePageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      print("locations $position");
      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentDriver!.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOfflineNow() async {
    Geofire.removeLocation(currentDriver!.uid);
    await databaseMethods.deleteDriverDocField("newRide", currentDriver!.uid);
  }
}

Future<dynamic> profilePicView(
    {required String imageUrl,
    required BuildContext context,
    required bool isSender,
    required String chatRoomId,
    required String myName}) {
  return showDialog(
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(top: 100, left: 50, right: 50, bottom: 350),
      child: Builder(
        builder: (context) => Container(
          height: 10 * SizeConfig.heightMultiplier!,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoViewPage(
                          myName: myName,
                          message: imageUrl,
                          isSender: isSender,
                          chatRoomId: chatRoomId!,
                        ),
                      ));
                },
                child: CachedImage(
                  height: 33 * SizeConfig.heightMultiplier!,
                  width: 90 * SizeConfig.widthMultiplier!,
                  imageUrl: imageUrl,
                  radius: 10,
                  fit: BoxFit.cover,
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 4 * SizeConfig.widthMultiplier!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradientColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: FocusedMenuHolder(
                        blurSize: 0,
                        duration: Duration(milliseconds: 500),
                        menuWidth: MediaQuery.of(context).size.width * 0.3,
                        menuItemExtent: 40,
                        onPressed: () {
                          displayToastMessage(
                              "Tap & Hold to make selection", context);
                        },
                        menuItems: <FocusedMenuItem>[
                          FocusedMenuItem(
                            title: Text(
                              "Gallery",
                              style: TextStyle(
                                  color: Color(0xFFa81845),
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () async => await Permissions
                                    .cameraAndMicrophonePermissionsGranted()
                                ? pickImage(
                                        source: ImageSource.gallery,
                                        context: context,
                                        databaseMethods: databaseMethods)
                                    .then((val) async {
                                    String profilePic = val;
                                    if (profilePic == null ||
                                        profilePic == "") {
                                    } else {
                                      await databaseMethods
                                          .updateDriverDocField(
                                              {"profile_photo": profilePic},
                                              currentDriver!.uid);
                                      Navigator.pop(context);
                                      displaySnackBar(
                                          message:
                                              "Changes will be seen next time you open the app",
                                          label: "OK",
                                          context: context);
                                    }
                                  })
                                : {},
                            trailingIcon: Icon(
                              Icons.photo_library_outlined,
                              color: Color(0xFFa81845),
                            ),
                          ),
                          FocusedMenuItem(
                            title: Text(
                              "Capture",
                              style: TextStyle(
                                  color: Color(0xFFa81845),
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () async => await Permissions
                                    .cameraAndMicrophonePermissionsGranted()
                                ? pickImage(
                                        source: ImageSource.camera,
                                        context: context,
                                        databaseMethods: databaseMethods)
                                    .then((val) async {
                                    String profilePic = val;
                                    if (profilePic == null ||
                                        profilePic == "") {
                                    } else {
                                      await databaseMethods
                                          .updateDriverDocField(
                                              {"profile_photo": profilePic},
                                              currentDriver!.uid);
                                      Navigator.pop(context);
                                      displaySnackBar(
                                          message:
                                              "Changes will be seen next time you open the app",
                                          label: "OK",
                                          context: context);
                                    }
                                  })
                                : {},
                            trailingIcon: Icon(
                              Icons.camera,
                              color: Color(0xFFa81845),
                            ),
                          ),
                        ],
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                CupertinoIcons.pencil,
                                color: Colors.white,
                              ),
                              Text(
                                "Edit Profile Picture",
                                style: TextStyle(
                                  fontFamily: "Brand Bold",
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage("images/logo.png"),
                      width: 12 * SizeConfig.widthMultiplier!,
                      height: 5 * SizeConfig.heightMultiplier!,
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    ),
  );
}
