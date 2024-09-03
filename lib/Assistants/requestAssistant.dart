import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(Uri url) async {
    http.Response response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);
        return decodeData;
      } else {
        return "Failed, No Response!";
      }
    } catch (exp) {
      return "Failed, No Response!";
    }
  }

  static Future<dynamic> getStringRequest(String url) async {
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);

    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);
        return decodeData;
      } else {
        return "Failed, No Response!";
      }
    } catch (exp) {
      return "Failed, No Response!";
    }
  }
}
