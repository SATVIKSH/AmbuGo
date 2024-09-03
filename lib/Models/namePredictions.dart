class NamePredictions {
  String? name;
  String? email;

  NamePredictions({this.name, this.email});

  NamePredictions.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"];
    email = json["email"];
  }
}
