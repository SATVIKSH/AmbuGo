import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequest {
  String? createdAt;
  String? driverId;
  String? dropOffAddress;
  String? pickUpAddress;
  String? riderName;
  String? riderPhone;
  Map? dropOff;
  Map? pickUp;

  RideRequest({
    this.createdAt,
    this.driverId,
    this.dropOffAddress,
    this.pickUpAddress,
    this.riderName,
    this.riderPhone,
    this.dropOff,
    this.pickUp,
  });

  Map<String, dynamic> toMap(RideRequest rideRequest) {
    Map<String, dynamic> rideRequestMap = Map();
    rideRequestMap["created_at"] = rideRequest.createdAt;
    rideRequestMap["driver_id"] = rideRequest.driverId;
    rideRequestMap["dropOff_address"] = rideRequest.dropOffAddress;
    rideRequestMap["pickUp_address"] = rideRequest.pickUpAddress;
    rideRequestMap["rider_name"] = rideRequest.riderName;
    rideRequestMap["rider_phone"] = rideRequest.riderPhone;
    rideRequestMap["dropOff"] = rideRequest.dropOff;
    rideRequestMap["pickUp"] = rideRequest.pickUp;

    return rideRequestMap;
  }

  RideRequest.fromMap(Map rideRequestMap) {
    this.createdAt = rideRequestMap["created_at"];
    this.driverId = rideRequestMap["driver_id"];
    this.dropOffAddress = rideRequestMap["dropOff_address"];
    this.pickUpAddress = rideRequestMap["pickUp_address"];
    this.riderName = rideRequestMap["rider_name"];
    this.riderPhone = rideRequestMap["rider_phone"];
    this.dropOff = rideRequestMap["dropOff"];
    this.pickUp = rideRequestMap["pickUp"];
  }
}

class RideDetails {
  String? pickUpAddress;
  String? dropOffAddress;
  LatLng? pickUp;
  LatLng? dropOff;
  String? rideRequestId;
  String? riderName;
  String? riderPhone;

  RideDetails({
    this.pickUpAddress,
    this.dropOffAddress,
    this.pickUp,
    this.dropOff,
    this.rideRequestId,
    this.riderName,
    this.riderPhone,
  });
}
