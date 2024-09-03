import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class Utils {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static Future<File?> pickImage({required ImageSource source}) async {
    File selectedImage;
    var pickedFile = await ImagePicker().pickImage(
      source: source,
    );
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      return compressImage(selectedImage);
    } else {
      return null;
    }
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int random = Random().nextInt(1000);

    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync())!;
    Im.copyResize(image, width: 500, height: 500);

    return new File('$path/img_emalert2021_$random.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }
}
