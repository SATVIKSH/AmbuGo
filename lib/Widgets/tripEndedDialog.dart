import 'package:codex/Assistants/assistantMethods.dart';
import 'package:codex/Services/database.dart';
import 'package:codex/constants.dart';

import 'package:codex/main.dart';
import 'package:codex/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class TripEndedDialog extends StatelessWidget {
  const TripEndedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.grey[100],
      child: Container(
        margin: EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier!,
            ),
            Text(
              "Trip has Ended",
              style: TextStyle(
                fontSize: 3 * SizeConfig.textMultiplier!,
                color: Color(0xFFa81845),
                fontFamily: "rand Bold",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier!,
            ),
            Divider(
              height: 0.5 * SizeConfig.heightMultiplier!,
              color: Color(0xFFa81845),
              thickness: 2,
            ),
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier!,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Expanded(
                flex: 0,
                child: Container(
                  width: 76 * SizeConfig.widthMultiplier!,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Text(
                          "Thank You For Your Wonderful Service",
                          style: TextStyle(
                            fontSize: 2 * SizeConfig.textMultiplier!,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Brand-Regular",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  AssistantMethods.enableLiveLocationUpdates();
                  await DatabaseMethods().updateDriverDocField(
                      {"newRide": "searching"}, currentDriver!.uid);
                },
                clipBehavior: Clip.hardEdge,
                child: Container(
                  width: 100 * SizeConfig.widthMultiplier!,
                  height: 6 * SizeConfig.heightMultiplier!,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ], gradient: kPrimaryGradientColor),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.widthMultiplier!),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Finish Trip".toUpperCase(),
                          style: TextStyle(
                            fontSize: 2 * SizeConfig.textMultiplier!,
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.hospitalUser,
                          color: Colors.white,
                          size: 6 * SizeConfig.imageSizeMultiplier!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier!,
            ),
          ],
        ),
      ),
    );
  }
}
