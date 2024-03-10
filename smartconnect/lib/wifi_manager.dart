import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartconnect/main.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter/services.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:flutter/foundation.dart';

class WifiManager {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;
  // ignore: recursive_getters
  //BuildContext get context => context;

  WifiManager(/*BuildContext context*/);
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
    List<WiFiAccessPoint> listaRedes = [];
    if (await _canGetScannedResults()) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();

      for (WiFiAccessPoint rede in results) {
        //if (await WiFiForIoTPlugin.isRegisteredWifiNetwork(rede.ssid)) {
        if (await WiFiForIoTPlugin.getSSID() == rede.ssid) {
          listaRedes.add(rede);
        }
      }
      return listaRedes.toList();
      // ignore: use_build_context_synchronously
      //context.setState(() => accessPoints = results);
    }
    return null;
  }

  void checkWifi() async {
    // Verifica se o Wi-Fi está ativo
    bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
    int? frequency = 0;
    //WifiManager wifi = WifiManager(null);
    //final results = wifi.getScannedResults();

    if (!isWifiEnabled) {
      // Wi-Fi não está ativo.
      return;
    }

    //// Obtém informações da rede Wi-Fi conectada
    //String? connectionInfo = await WiFiForIoTPlugin.getWiFiAPPreSharedKey();

    // Verifica se a rede conectada é de 2.4 GHz
    frequency = await WiFiForIoTPlugin.getFrequency();
    if (frequency! > 5000) {
      // Dispositivo conectado a uma rede de 5 GHz. Retorne ou exiba uma mensagem para o usuário.
      return;
    }
    //// Lista as redes Wi-Fi disponíveis
    //List<WiFiAccessPoint> scanNets = [];
    List<WiFiAccessPoint>? scanNets = await getScannedResults();

    // Filtra as redes de 5 GHz com rssi maior ou igual a -70
    try {
      //List<WiFiAccessPoint> ghz5Networks = [];
      for (WiFiAccessPoint redes in scanNets!) {
        if (redes.frequency > 5000 && redes.level >= -70) {
          WiFiForIoTPlugin.showWritePermissionSettings(false);
          await Permission.location.request();
          //await WiFiForIoTPlugin.disconnect();
          await WiFiForIoTPlugin.connect(redes.ssid,
                  bssid: redes.bssid,
                  password: STA_DEFAULT_PASSWORD, //"unless,likely,boaster",
                  joinOnce: true,
                  security: NetworkSecurity.WPA,
                  withInternet: true)
              .then((result) => log(
                  "##########################conectou###############################"));
          break;
        }
      }
    }
    // ignore: non_constant_identifier_names
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
