import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex/Assistants/requestAssistant.dart';
import 'package:codex/Models/directionDetails.dart';
import 'package:codex/Models/history.dart';
import 'package:codex/Provider/appData.dart';
import 'package:codex/Services/database.dart';
import 'package:codex/configMaps.dart';
import 'package:codex/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=AIzaSyCZPtd_SAT_zel83HS5tX1bTCRT9ob8pGE";

    var res = await RequestAssistant.getStringRequest(directionUrl);

    if (res == "Failed, No Response!") {
      return null;
    }
    print("check ${res.size()}");
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodePoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    return directionDetails;
  }

  static void disableLiveLocationUpdates() {
    if (homePageStreamSubscription != null) {
      homePageStreamSubscription!.pause();
    }
    Geofire.removeLocation(currentDriver!.uid);
  }

  static void enableLiveLocationUpdates() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    homePageStreamSubscription!.resume();
    Geofire.setLocation(currentDriver!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
  }

  static void retrieveHistoryInfo(BuildContext context) {
    QuerySnapshot driverSnap;
    DatabaseMethods().getDriverByUid(currentDriver!.uid).then((val) {
      driverSnap = val;

      if (driverSnap.docs[0].get("history") != null) {
        Map<dynamic, dynamic> keys = driverSnap.docs[0].get("history");
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false)
            .updateTripsCounter(tripCounter);

        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
    });
  }

  static void obtainTripRequestsHistoryData(BuildContext context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      QuerySnapshot snapShot;
      DatabaseMethods().getRideRequest(key).then((val) {
        snapShot = val;
        if (snapShot != null) {
          DocumentSnapshot historySnap = snapShot.docs[0];
          if (snapShot != null) {
            var history = History.fromSnapshot(historySnap);
            Provider.of<AppData>(context, listen: false)
                .updateTripHistoryData(history);
          }
        }
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
    return formattedDate;
  }
}
