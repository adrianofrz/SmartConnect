import 'package:permission_handler/permission_handler.dart';

class PermissionApp {
  Future<void> requestPermissionWifi() async {
    //var status = await Permission.camera.status;
    //Permission.byValue(31);
    var status = await Permission.nearbyWifiDevices.status;
    if (status.isDenied) {
      // We haven't asked for permission yet or the permission has been denied before, but not permanently.
      if (await Permission.nearbyWifiDevices.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }

      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses =
          await [Permission.location, Permission.nearbyWifiDevices].request();
      //print(statuses[Permission.location]);
    }

    // You can also directly ask permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example, because of parental controls.
    }
  }
}
