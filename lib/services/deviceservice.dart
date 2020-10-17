import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:kaladasava/models/device.dart';

class DeviceService{

 static Future<Device> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    bool physical;

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model.toString();
        deviceVersion = build.version.toString();
        identifier = build.androidId;
        physical = build.isPhysicalDevice;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name.toString();
        deviceVersion = data.systemVersion.toString();
        identifier = data.identifierForVendor; 
        physical = data.isPhysicalDevice;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
return Device(name:deviceName, version:deviceVersion, id:identifier, physical: physical.toString(), ts:DateTime.now().toUtc().microsecondsSinceEpoch);
}

}