class User {
  String? uid;
  String? name;
  String? email;
  String? username;
  String? hospital;
  String? years;
  String? licencePlate;
  String? status;
  String? phone;
  int? state;
  String? profilePhoto;

  User({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.phone,
    this.state,
    this.profilePhoto,
    this.hospital,
    this.years,
    this.licencePlate,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data["uid"] = user.uid;
    data["name"] = user.name;
    data["email"] = user.email;
    data["username"] = user.username;
    data["status"] = user.status;
    data["phone"] = user.phone;
    data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    data["hospital"] = user.hospital;
    data["years"] = user.years;
    data["licence_plate"] = user.licencePlate;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.phone = mapData['phone'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.hospital = mapData['hospital'];
    this.years = mapData['years'];
    this.licencePlate = mapData['licence_plate'];
  }
}
