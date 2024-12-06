import 'package:connectivity_plus/connectivity_plus.dart';
/// basic common method for checking the internet connection
Future<bool> hasInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  print("My internet Connection${connectivityResult}");
  print(connectivityResult != [ConnectivityResult.none]);
  return connectivityResult[0] == ConnectivityResult.none;
}