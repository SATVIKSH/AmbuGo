// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:portfolio_amb_app/Models/rideRequest.dart';
// import 'package:portfolio_amb_app/Notifications/notificationDialog.dart';
// import 'package:portfolio_amb_app/main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'dart:io' show Platform;

// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class PushNotificationService{

//   late FirebaseMessaging firebaseMessaging;

//   Future initialize(BuildContext context) async {
  
//     firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         retrieveRideRequestInfo(getRideRequestId(message), context);
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         retrieveRideRequestInfo(getRideRequestId(message), context);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         retrieveRideRequestInfo(getRideRequestId(message), context);
//       },
//     );
//   }

//   Future<String> getToken() async {
//     String token = await firebaseMessaging.getToken();
//     await databaseMethods.updateDriverDocField({"token": token}, currentDriver.uid);
//     firebaseMessaging.subscribeToTopic("all_drivers");
//     firebaseMessaging.subscribeToTopic("all_users");
//   }

//   String getRideRequestId(Map<String, dynamic> message) {
//     String rideRequestId = "";
//     if (Platform.isAndroid) {
//       rideRequestId = message['data']['ride_request_id'];
//     } else {
//       rideRequestId = message['ride_request_id'];
//     }
//     return rideRequestId;
//   }

//   void retrieveRideRequestInfo(String rideRequestId, BuildContext context) async {
//     QuerySnapshot dataSnapShot = await databaseMethods.getRideRequest(rideRequestId);
    
//     if (dataSnapShot != null) {
//       assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
//       assetsAudioPlayer.play();

//       Map pickUp = dataSnapShot.docs[0].get("pickUp");
//       double pickUpLocationLat = double.parse(pickUp['latitude']);
//       double pickUpLocationLng = double.parse(pickUp['longitude']);
//       String pickUpAddress = dataSnapShot.docs[0].get("pickUp_address");

//       Map dropOff = dataSnapShot.docs[0].get("dropOff");
//       double dropOffLocationLat = double.parse(dropOff['latitude']);
//       double dropOffLocationLng = double.parse(dropOff['longitude']);
//       String dropOffAddress = dataSnapShot.docs[0].get("dropOff_address");

//       String rideName = dataSnapShot.docs[0].get("rider_name");
//       String ridePhone = dataSnapShot.docs[0].get("rider_phone");

//       RideDetails rideDetails = RideDetails();
//       rideDetails.pickUpAddress = pickUpAddress;
//       rideDetails.dropOffAddress = dropOffAddress;
//       rideDetails.pickUp = LatLng(pickUpLocationLat, pickUpLocationLng);
//       rideDetails.dropOff = LatLng(dropOffLocationLat, dropOffLocationLng);
//       rideDetails.rideRequestId = rideRequestId;
//       rideDetails.riderName = rideName;
//       rideDetails.riderPhone = ridePhone;

//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => NotificationDialog(rideDetails: rideDetails,),
//       );
//     }
//   }
// }