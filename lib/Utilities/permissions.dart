import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await Permission.camera.request();

    if (!permission.isGranted || permission.isDenied) {
      return PermissionStatus.denied;
    } else {
      return PermissionStatus.granted;
    }
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    PermissionStatus permission = await Permission.microphone.request();
    if (permission.isDenied || !permission.isGranted) {
      return PermissionStatus.denied;
    } else {
      return PermissionStatus.granted;
    }
  }

  static Future<bool> locationPermission() async {
    return await Permission.location.request().isGranted;
  }

  static void _handleInvalidPermissions(PermissionStatus cameraPermissionStatus,
      PermissionStatus microphonePermissionStatus) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to camera and microphone denied",
        details: null,
      );
    } else if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
        details: null,
      );
    }
  }
}
