import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class InternetController extends GetxController {
  var isConnected = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _checkInternet();
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(
          results.isNotEmpty ? results.first : ConnectivityResult.none);
    });
  }

  Future<void> _checkInternet() async {
    try {
      List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();
      _updateConnectionStatus(
          results.isNotEmpty ? results.first : ConnectivityResult.none);
    } catch (e) {
      print("Error checking internet: $e");
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
    } else {
      isConnected.value = true;
    }
  }
}
