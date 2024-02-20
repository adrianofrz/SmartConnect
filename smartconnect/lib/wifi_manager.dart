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

  void checkWifi() async {
    // Verifica se o Wi-Fi está ativo
    bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!isWifiEnabled) {
      // Wi-Fi não está ativo. Retorne ou exiba uma mensagem para o usuário.
      return;
    }

    //// Obtém informações da rede Wi-Fi conectada
    String? connectionInfo = await WiFiForIoTPlugin.getWiFiAPPreSharedKey();
//
    //// Verifica se a rede conectada é de 2.4 GHz
    //bool is24ghz = connectionInfo.frequency == 2400;
    //if (!is24ghz) {
    //  // Dispositivo conectado a uma rede de 5 GHz. Retorne ou exiba uma mensagem para o usuário.
    //  return;
    //}
//
    //// Lista as redes Wi-Fi disponíveis
    //List<WifiScanResult> scanResults = await WiFiScan.getWifiList();
//
    //// Filtra as redes de 5 GHz com rssi maior ou igual a -70
    //List<WifiScanResult> ghz5Networks = scanResults
    //    .where((result) => result.frequency == 5000 && result.level >= -70)
    //    .toList();
//
    //// Se encontrar uma rede de 5 GHz, conecta-se a ela
    //if (ghz5Networks.isNotEmpty) {
    //  WifiScanResult targetNetwork = ghz5Networks.first;
    //  await WifiIot.connect(targetNetwork.ssid, targetNetwork.password);
    //} else {
    //  // Nenhuma rede de 5 GHz disponível com rssi >= -70. Retorne ou exiba uma mensagem para o usuário.
    //}
  }
}
