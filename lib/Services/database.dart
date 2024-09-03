import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex/Models/rideRequest.dart';

import 'package:codex/Models/user.dart' as myUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Reference? _storageReference;
  final CollectionReference rideRequestCollection =
      fireStore.collection("Ride_Requests");
  final CollectionReference driversCollection = fireStore.collection("Drivers");
  final CollectionReference doctorsCollection = fireStore.collection("doctors");
  final CollectionReference usersCollection = fireStore.collection("users");

  Future<myUser.User> getDriverDetails() async {
    User currentDriver = firebaseAuth.currentUser!;
    String uid = currentDriver.uid;
    String? name;
    QuerySnapshot querySnapshot;
    await getDriverByUid(uid).then((val) {
      querySnapshot = val;
      name = querySnapshot.docs[0].get("name");
    });
    Map<String, dynamic> documentSnapshot;
    QuerySnapshot? fromSnap;
    documentSnapshot = await driverSnapToMap(name!, fromSnap!);
    return myUser.User.fromMap(documentSnapshot);
  }

  Future<String> getName() async {
    User currentDriver = firebaseAuth.currentUser!;
    String uid = currentDriver.uid;
    String? name;
    QuerySnapshot querySnapshot;
    await getDriverByUid(uid).then((val) {
      querySnapshot = val;
      name = querySnapshot.docs[0].get("name");
    });
    return name!;
  }

  Future<String> getPhone() async {
    User currentDriver = firebaseAuth.currentUser!;
    String uid = currentDriver.uid;
    String? name;
    QuerySnapshot querySnapshot;
    await getDriverByUid(uid).then((val) {
      querySnapshot = val;
      name = querySnapshot.docs[0].get("phone");
    });
    return name!;
  }

  Future<String> getHospital() async {
    User currentDriver = firebaseAuth.currentUser!;
    String uid = currentDriver.uid;
    String? hospital;
    QuerySnapshot querySnapshot;
    await getDriverByUid(uid).then((val) {
      querySnapshot = val;
      hospital = querySnapshot.docs[0].get("hospital");
    });
    return hospital!;
  }

  Future<String> getEmail() async {
    User currentDriver = firebaseAuth.currentUser!;
    String uid = currentDriver.uid;
    String? email;
    QuerySnapshot querySnapshot;
    await getDriverByUid(uid).then((val) {
      querySnapshot = val;
      email = querySnapshot.docs[0].get("email");
    });
    return email!;
  }

  Future<String> getProfilePhoto() async {
    User currentDriver = firebaseAuth.currentUser!;
    String uid = currentDriver.uid;
    String? profilePhoto;
    QuerySnapshot querySnapshot;
    await getDriverByUid(uid).then((val) {
      querySnapshot = val;
      profilePhoto = querySnapshot.docs[0].get("profile_photo");
    });
    return profilePhoto!;
  }

  getDriverByUsername(String username) async {
    QuerySnapshot driverSnap;
    driverSnap =
        await driversCollection.where("name", isEqualTo: username.trim()).get();

    return driverSnap;
  }

  Future<String> getDriverDocId(String uid) async {
    QuerySnapshot driverSnap;
    driverSnap =
        await driversCollection.where("uid", isEqualTo: uid.trim()).get();
    String id = driverSnap.docs[0].id.trim();
    return id;
  }

  getDriverNewRideStatus(String uid) async {
    QuerySnapshot querySnapshot;
    String? newRide;
    await getDriverByUid(uid).then((val) {
      querySnapshot = val;
      newRide = querySnapshot.docs[0].get("newRide");
    });
    return newRide!;
  }

  updateDriverDocField(Map<String, dynamic> update, String uid) async {
    String docId = await getDriverDocId(uid);
    driversCollection.doc(docId).update(update).catchError((e) {
      print("Update Driver Doc Error ::: ${e.toString()}");
    });
  }

  updateRideRequestDocField(Map<String, dynamic> update, String docId) async {
    rideRequestCollection.doc(docId).update(update).catchError((e) {
      print("Update Ride Request Error ::: ${e.toString()}");
    });
  }

  deleteDriverDocField(String token, String uid) async {
    String docId = await getDriverDocId(uid);
    driversCollection.doc(docId).update({
      token: FieldValue.delete(),
    }).catchError((e) {
      print("Delete Driver Field Error ::: ${e.toString()}");
    });
  }

  Future<String> getUserDocId(String uid) async {
    QuerySnapshot driverSnap;
    driverSnap =
        await usersCollection.where("uid", isEqualTo: uid.trim()).get();
    String id = driverSnap.docs[0].id.trim();
    return id;
  }

  Future<String> getDoctorDocId(String uid) async {
    QuerySnapshot driverSnap;
    driverSnap =
        await doctorsCollection.where("uid", isEqualTo: uid.trim()).get();
    String id = driverSnap.docs[0].id.trim();
    return id;
  }

  getDriverByUid(String uid) async {
    QuerySnapshot driverSnap;
    driverSnap =
        await driversCollection.where("uid", isEqualTo: uid.trim()).get();

    return driverSnap;
  }

  getDriverByUserEmail(String userEmail) async {
    QuerySnapshot driverSnap;
    driverSnap =
        await driversCollection.where("email", isEqualTo: userEmail).get();

    return driverSnap;
  }

  uploadDriverInfo(userMap) {
    driversCollection.add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  getDrivers() async {
    return await driversCollection.snapshots();
  }

  Future<String?> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      print("yes ");
      await _storageReference!.putFile(image);

      var url = await _storageReference?.getDownloadURL();
      // await _storageUploadTask.then((val) async {
      //   url = await val.ref.getDownloadURL();
      // });
      return await url;
    } catch (e) {
      print("upload Image Error :: " + e.toString());
      return null;
    }
  }

  void saveRideRequest({RideRequest? rideRequest, String? uid}) async {
    try {
      Map<String, dynamic> rideRequestMap = rideRequest!.toMap(rideRequest);
      await rideRequestCollection.doc(uid).set(rideRequestMap);
    } catch (e) {
      print("save ride request error ::: " + e.toString());
    }
  }

  void cancelRideRequest({String? uid}) async {
    try {
      await rideRequestCollection.doc(uid).delete();
    } catch (e) {
      print("cancel ride request error ::: " + e.toString());
    }
  }

  Future<Map<String, dynamic>> driverSnapToMap(
      String name, QuerySnapshot snap) async {
    Map<String, dynamic>? map;

    await getDriverByUsername(name).then((val) {
      snap = val;
      map = {
        "uid": snap.docs[0].get("uid"),
        "email": snap.docs[0].get("email"),
        "name": snap.docs[0].get("name"),
        "years": snap.docs[0].get("years"),
        "licence_plate": snap.docs[0].get("licence_plate"),
        "hospital": snap.docs[0].get("hospital"),
        "phone": snap.docs[0].get("phone"),
        "username": snap.docs[0].get("username"),
        "profile_photo": snap.docs[0].get("profile_photo"),
        "state": snap.docs[0].get("state"),
        "status": snap.docs[0].get("status"),
      };
    });

    return map!;
  }

  getRideRequestDoc(String rideRequestId) async {
    DocumentSnapshot requestSnap;
    requestSnap = await rideRequestCollection.doc(rideRequestId).get();
    return requestSnap;
  }

  getRideRequest(String rideRequestId) async {
    QuerySnapshot requestSnap;
    requestSnap = await rideRequestCollection
        .where("uid", isEqualTo: rideRequestId.trim())
        .get();

    return requestSnap;
  }
}
