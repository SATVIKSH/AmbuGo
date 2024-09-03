import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex/Assistants/assistantMethods.dart';
import 'package:codex/Assistants/mapKitAssistant.dart';
import 'package:codex/Models/rideRequest.dart';
import 'package:codex/Services/database.dart';
import 'package:codex/Widgets/progressDialog.dart';
import 'package:codex/Widgets/tripEndedDialog.dart';
import 'package:codex/constants.dart';
import 'package:codex/main.dart';
import 'package:codex/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NewRideScreen extends StatefulWidget {
  final RideDetails? rideDetails;
  const NewRideScreen({Key? key, this.rideDetails}) : super(key: key);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.369719, 32.659309),
    zoom: 14.4746,
  );

  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen>
    with TickerProviderStateMixin {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Completer<GoogleMapController> _googleMapController = Completer();
  late GoogleMapController newRideGoogleMapController;
  Set<Marker> markerSet = {};
  Set<Polyline> polylineSet = {};
  Set<Circle> circleSet = {};
  List<LatLng> polyLineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Position? currentPosition;
  double bottomPaddingOfMap = 30 * SizeConfig.heightMultiplier!;
  double rideDetailsContainerHeight = 30 * SizeConfig.heightMultiplier!;
  var geoLocator = Geolocator();

  // var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor? animatingMarkerIcon;
  Position? myPosition;
  String status = "accepted";
  String durationRide = "";
  bool isRequestingDirection = false;
  String btnTitle = "Arrived";
  Color btnColor = Color(0xFFa81845);
  Timer? timer;
  int durationCounter = 0;

  @override
  void initState() {
    super.initState();
    acceptRideRequest();
  }

  void createIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "images/ambulance_icon.png")
          .then((val) {
        animatingMarkerIcon = val;
      });
    }
  }

  void getRideLiveLocationUpdates() {
    LatLng oldPos = LatLng(0, 0);

    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
      currentPosition = position;
      myPosition = position;
      LatLng nPosition = LatLng(position.latitude, position.longitude);

      var rot = MapKitAssistant.getMarkerRotation(oldPos.latitude,
          oldPos.longitude, myPosition!.latitude, myPosition!.longitude);

      Marker animatingMarker = Marker(
        markerId: MarkerId("animating"),
        position: nPosition,
        icon: animatingMarkerIcon!,
        rotation: rot,
        infoWindow: InfoWindow(title: "Current Location"),
      );

      setState(() {
        CameraPosition cameraPosition =
            new CameraPosition(target: nPosition, zoom: 17);
        newRideGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markerSet.removeWhere((marker) => marker.markerId.value == "animating");
        markerSet.add(animatingMarker);
      });
      oldPos = nPosition;
      updaterideDetails();

      String rideRequestId = widget.rideDetails!.rideRequestId!;
      Map<String, dynamic> locMap = {
        "latitude": currentPosition!.latitude.toString(),
        "longitude": currentPosition!.longitude.toString(),
      };
      Map<String, dynamic> update = {
        "driver_location": locMap,
      };
      await databaseMethods.updateRideRequestDocField(update, rideRequestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    createIconMarker();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.grey[100],
        title: Text(
          "New Ride",
          style: TextStyle(
            color: Color(0xFFa81845),
            fontFamily: "Brand Bold",
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(
              bottom: bottomPaddingOfMap,
            ),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            polylines: polylineSet,
            markers: markerSet,
            circles: circleSet,
            onMapCreated: (GoogleMapController controller) async {
              _googleMapController.complete(controller);
              newRideGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 30 * SizeConfig.heightMultiplier!;
              });
              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
              currentPosition = position;
              var currentLatLng =
                  LatLng(currentPosition!.latitude, currentPosition!.longitude);
              var pickUpLatLng = widget.rideDetails!.pickUp;

              await getPlaceDirections(currentLatLng, pickUpLatLng!);
              getRideLiveLocationUpdates();
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              // vsync: this,
              curve: Curves.bounceOut,
              duration: Duration(milliseconds: 800),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                    right: 10,
                  ),
                  child: Container(
                    height: rideDetailsContainerHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(18)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFa81845),
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Text(
                              durationRide,
                              style: TextStyle(
                                fontSize: 2 * SizeConfig.textMultiplier!,
                                fontFamily: "Band Bold",
                                color: Color(0xFFa81845),
                              ),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier!,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                right: 4 * SizeConfig.widthMultiplier!,
                                left: 4 * SizeConfig.widthMultiplier!,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      widget.rideDetails!.riderName!,
                                      style: TextStyle(
                                        fontFamily: "Band Bold",
                                        fontSize:
                                            2.5 * SizeConfig.textMultiplier!,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () => launch(
                                          ('tel:${widget.rideDetails!.riderPhone}')),
                                      child: Container(
                                        height:
                                            4 * SizeConfig.heightMultiplier!,
                                        width: 15 * SizeConfig.widthMultiplier!,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 1),
                                              spreadRadius: 0.5,
                                              blurRadius: 2,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ],
                                          color: Colors.green[300],
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Icon(
                                          Icons.phone_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 0.5 * SizeConfig.heightMultiplier!,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2, right: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      spreadRadius: 0.5,
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "images/pickicon.png",
                                            height: 2 *
                                                SizeConfig.heightMultiplier!,
                                            width:
                                                4 * SizeConfig.widthMultiplier!,
                                          ),
                                          SizedBox(
                                            width:
                                                2 * SizeConfig.widthMultiplier!,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                widget.rideDetails!
                                                    .pickUpAddress!,
                                                style: TextStyle(
                                                  fontSize: 2.5 *
                                                      SizeConfig
                                                          .textMultiplier!,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            2 * SizeConfig.heightMultiplier!,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Image.asset(
                                            "images/desticon.png",
                                            height: 2 *
                                                SizeConfig.heightMultiplier!,
                                            width:
                                                4 * SizeConfig.widthMultiplier!,
                                          ),
                                          SizedBox(
                                            width:
                                                2 * SizeConfig.widthMultiplier!,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                widget.rideDetails!
                                                    .dropOffAddress!,
                                                style: TextStyle(
                                                  fontSize: 2 *
                                                      SizeConfig
                                                          .textMultiplier!,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        ],
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
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: ElevatedButton(
                                clipBehavior: Clip.hardEdge,
                                onPressed: () async {
                                  if (status == "accepted") {
                                    status = "arrived";
                                    String rideRequestId =
                                        widget.rideDetails!.rideRequestId!;
                                    await databaseMethods
                                        .updateRideRequestDocField(
                                            {"status": status}, rideRequestId);

                                    setState(() {
                                      btnTitle = "Start Trip";
                                      btnColor = Colors.green[300]!;
                                    });

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => ProgressDialog(
                                          message: "Please Wait..."),
                                    );

                                    await getPlaceDirections(
                                        widget.rideDetails!.pickUp!,
                                        widget.rideDetails!.dropOff!);

                                    Navigator.pop(context);
                                  } else if (status == "arrived") {
                                    status = "enRoute";
                                    String rideRequestId =
                                        widget.rideDetails!.rideRequestId!;
                                    await databaseMethods
                                        .updateRideRequestDocField(
                                            {"status": status}, rideRequestId);

                                    setState(() {
                                      btnTitle = "End Trip";
                                    });
                                    initTimer();
                                  } else if (status == "enRoute") {
                                    endTrip();
                                  }
                                },
                                child: Container(
                                  width: 100 * SizeConfig.widthMultiplier!,
                                  height: 6 * SizeConfig.heightMultiplier!,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 6.0,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7, 0.7),
                                      ),
                                    ],
                                    gradient: kPrimaryGradientColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(17.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          btnTitle.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier!,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.ambulance,
                                          color: Colors.white,
                                          size: 6 *
                                              SizeConfig.imageSizeMultiplier!,
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirections(
      LatLng pickUpLatLng, LatLng dropOffLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(message: "Please wait..."),
    );

    var details = await AssistantMethods()
        .obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolylinePointResults =
        polylinePoints.decodePolyline(details!.encodePoints!);

    polyLineCoordinates.clear();

    if (decodePolylinePointResults.isNotEmpty) {
      decodePolylinePointResults.forEach((PointLatLng pointLatLng) {
        polyLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Color(0xFFa81845),
        polylineId: PolylineId("PolylineId"),
        jointType: JointType.round,
        points: polyLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(
          dropOffLatLng.latitude,
          pickUpLatLng.longitude,
        ),
      );
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(
          pickUpLatLng.latitude,
          dropOffLatLng.longitude,
        ),
      );
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }
    newRideGoogleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        latLngBounds,
        70,
      ),
    );

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow:
          InfoWindow(title: "Your Location", snippet: "This is your location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
          title: status == "enRoute" ? "DropOff Location" : "PickUp Location",
          snippet: status == "enRoute"
              ? "This is the Hospital you are taking the Rider"
              : "This is the location of the Rider"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markerSet.add(pickUpLocMarker);
      markerSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Color(0xFFa81845),
      center: pickUpLatLng,
      radius: 5,
      strokeWidth: 2,
      strokeColor: Color(0xFFa81845).withOpacity(0.6),
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.green[900]!,
      center: dropOffLatLng,
      radius: 5,
      strokeWidth: 2,
      strokeColor: Colors.green[400]!,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }

  void acceptRideRequest() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    QuerySnapshot querySnapshot;
    Map<String, dynamic> update;
    String rideRequestId = widget.rideDetails!.rideRequestId!;
    Map<String, dynamic> locMap = {
      "latitude": currentPosition!.latitude.toString(),
      "longitude": currentPosition!.longitude.toString(),
    };

    await databaseMethods.getDriverByUid(currentDriver!.uid).then((val) async {
      querySnapshot = val;
      update = {
        "status": "accepted",
        "driver_name": querySnapshot.docs[0].get("name"),
        "driver_phone": querySnapshot.docs[0].get("phone"),
        "driver_pic": querySnapshot.docs[0].get("profile_photo"),
        "driver_id": querySnapshot.docs[0].get("uid"),
        "car_details": querySnapshot.docs[0].get("licence_plate"),
        "driver_location": locMap,
        "hospital": querySnapshot.docs[0].get("hospital"),
      };
      await databaseMethods.updateRideRequestDocField(update, rideRequestId);
    });

    databaseMethods.getDriverByUid(currentDriver!.uid).then((val) async {
      QuerySnapshot snap = val;
      if (snap.docs[0].get("history") != null) {
        Map histMap = snap.docs[0].get("history");
        Map<String, dynamic> update = {
          rideRequestId: true,
        };
        histMap.addAll(update);
        await databaseMethods
            .updateDriverDocField({"history": histMap}, currentDriver!.uid);
      } else {
        Map<String, dynamic> histMap = {
          rideRequestId: true,
        };
        await databaseMethods
            .updateDriverDocField({"history": histMap}, currentDriver!.uid);
      }
    });
  }

  Future<void> updaterideDetails() async {
    if (isRequestingDirection == false) {
      isRequestingDirection = true;
      if (myPosition == null) {
        return;
      }

      var posLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);
      LatLng destinationLatLng;

      if (status == "accepted") {
        destinationLatLng = widget.rideDetails!.pickUp!;
      } else {
        destinationLatLng = widget.rideDetails!.dropOff!;
      }

      var directionDetails = await AssistantMethods()
          .obtainPlaceDirectionDetails(posLatLng, destinationLatLng);

      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText!;
        });
      }
      isRequestingDirection = false;
    }
  }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter + 1;
    });
  }

  endTrip() async {
    timer!.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    Navigator.pop(context);

    String rideRequestId = widget.rideDetails!.rideRequestId!;
    await databaseMethods
        .updateRideRequestDocField({"status": "ended"}, rideRequestId);
    rideStreamSubscription!.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TripEndedDialog(),
    );
  }
}
