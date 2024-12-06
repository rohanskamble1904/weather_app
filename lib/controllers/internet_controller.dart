import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
/// this class mainly used for checking internet connection
class InternetController extends GetxController{

  Connectivity _connectivity = Connectivity();

  @override
  void onInit() async{
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResultList) {
    if (connectivityResultList.contains(ConnectivityResult.none)) {
      Get.snackbar(
          "You are Offline", "Make sure Internet is connected",
          isDismissible: true,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.snackbar(
            "", "",
            titleText: Text("You are Online"),
            isDismissible: true,
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
        );
        Get.closeCurrentSnackbar();
      }
    }
  }
 static Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult);
    return connectivityResult != ConnectivityResult.none;
  }


}