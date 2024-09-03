import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:codex/AllScreens/loginScreen.dart';
import 'package:codex/AllScreens/newRideScreen.dart';
import 'package:codex/Assistants/assistantMethods.dart';
import 'package:codex/Models/rideRequest.dart';
import 'package:codex/Services/database.dart';
import 'package:codex/main.dart';
import 'package:codex/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails rideDetails;
  NotificationDialog({Key? key, required this.rideDetails}) : super(key: key);
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.white,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier!,
            ),
            Image.asset(
              "images/ambulance_icon2.png",
              width: 17 * SizeConfig.imageSizeMultiplier!,
            ),
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier!,
            ),
            Text(
              "New Ambulance Request",
              style: TextStyle(
                fontFamily: "Brand Bold",
                fontSize: 3 * SizeConfig.textMultiplier!,
                color: Color(0xFFa81845),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier!,
            ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "images/pickicon.png",
                        height: 2 * SizeConfig.heightMultiplier!,
                        width: 4 * SizeConfig.widthMultiplier!,
                      ),
                      SizedBox(
                        width: 2 * SizeConfig.widthMultiplier!,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.pickUpAddress!,
                            style: TextStyle(
                              fontSize: 2.5 * SizeConfig.textMultiplier!,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier!,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "images/desticon.png",
                        height: 2 * SizeConfig.heightMultiplier!,
                        width: 4 * SizeConfig.widthMultiplier!,
                      ),
                      SizedBox(
                        width: 2 * SizeConfig.widthMultiplier!,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.dropOffAddress!,
                            style: TextStyle(
                              fontSize: 2.5 * SizeConfig.textMultiplier!,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier!,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier!,
            ),
            Divider(
              height: 2.0,
              color: Colors.black,
              thickness: 2.0,
            ),
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier!,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      assetsAudioPlayer.stop();
                      assetsAudioPlayer = new AssetsAudioPlayer();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 2.2 * SizeConfig.textMultiplier!,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2 * SizeConfig.widthMultiplier!,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      assetsAudioPlayer.stop();
                      assetsAudioPlayer = new AssetsAudioPlayer();
                      checkRideAvailability(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(
                        fontSize: 2.2 * SizeConfig.textMultiplier!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkRideAvailability(context) async {
    await databaseMethods
        .getDriverNewRideStatus(currentDriver!.uid)
        .then((val) async {
      Navigator.of(context).pop();
      String theRideId = "";
      if (val != null) {
        theRideId = val;
      } else {
        displayToastMessage("Request does not exist!", context);
      }

      if (theRideId == rideDetails.rideRequestId) {
        AssistantMethods.disableLiveLocationUpdates();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewRideScreen(rideDetails: rideDetails)),
        );
        Map<String, dynamic> update = {"newRide": "accepted"};
        await databaseMethods.updateDriverDocField(update, currentDriver!.uid);
      } else if (theRideId == "cancelled") {
        displayToastMessage("Request has been cancelled", context);
        await databaseMethods
            .updateDriverDocField({"newRide": "searching"}, currentDriver!.uid);
      } else if (theRideId == "timeout") {
        displayToastMessage("Request has Timed Out", context);
        await databaseMethods
            .updateDriverDocField({"newRide": "searching"}, currentDriver!.uid);
      } else {
        displayToastMessage("Request does not exist", context);
      }
    });
  }
}
