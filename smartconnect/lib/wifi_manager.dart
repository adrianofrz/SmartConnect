import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter/services.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:flutter/foundation.dart';

class WifiManager {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;
  // ignore: recursive_getters
  BuildContext get context => context;

  WifiManager(BuildContext context);
  bool get isStreaming => subscription != null;

  Future<bool> _canGetScannedResults() async {
    if (shouldCheckCan) {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        //if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  // ignore: unused_element
  Future<List<WiFiAccessPoint>?> getScannedResults() async {
    if (await _canGetScannedResults()) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();
      return results;
      // ignore: use_build_context_synchronously
      //context.setState(() => accessPoints = results);
    }
    return null;
  }

  void checkWifi() async {}
}
