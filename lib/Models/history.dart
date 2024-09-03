import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  String? createdAt;
  String? status;
  String? dropOff;
  String? pickUp;
  String? riderName;

  History({
    required this.riderName,
    required this.createdAt,
    required this.status,
    required this.dropOff,
    required this.pickUp,
  });

  History.fromSnapshot(DocumentSnapshot historySnap) {
    createdAt = historySnap.get("created_at");
    status = historySnap.get("status");
    dropOff = historySnap.get("dropOff_address");
    pickUp = historySnap.get("pickUp_address");
    riderName = historySnap.get("rider_name");
  }
}
