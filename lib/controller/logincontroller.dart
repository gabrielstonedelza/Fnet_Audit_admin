import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/app_colors.dart';
import '../screens/homepage.dart';

class LoginController extends GetxController {
  final client = http.Client();
  final storage = GetStorage();
  bool isLoggingIn = false;
  bool isUser = false;
  late int oTP = 0;
  late String myToken = "";
  late String agentUsername = "";

  String errorMessage = "";
  bool isLoading = false;

  loginUser(String username, String password) async {
    const loginUrl = "https://agencybankingnetwork.com/auth/token/login/";
    final myLink = Uri.parse(loginUrl);
    http.Response response = await client.post(myLink,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"username": username, "password": password});

    if (response.statusCode == 200) {
      final resBody = response.body;
      var jsonData = jsonDecode(resBody);
      var userToken = jsonData['auth_token'];
      agentUsername = username;
      storage.write("token", userToken);
      storage.write("username", username);
      isLoggingIn = false;
      isUser = true;
      Get.offAll(() => const HomePage());
    } else {
      Get.snackbar("Sorry 😢", "invalid details",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: warning,
          colorText: defaultTextColor1);
      isLoggingIn = false;
      isUser = false;
      storage.remove("token");
      storage.remove("username");
    }
  }
}
