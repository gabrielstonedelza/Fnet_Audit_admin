import 'dart:async';
import 'dart:convert';

import 'package:audit_admin/constants/app_colors.dart';
import 'package:audit_admin/screens/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class UsersController extends GetxController {
  bool isLoading = false;
  late List allUsers = [];
  late List allUsersSearch = ["Select User"];
  late String uToken = "";
  final storage = GetStorage();
  late Timer _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    fetchAllUsers();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchAllUsers();
    });
    super.onInit();
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading = true;
      const url = "https://agencybankingnetwork.com/all_agents/";
      var myLink = Uri.parse(url);
      final response = await http.get(myLink, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });

      if (response.statusCode == 200) {
        final codeUnits = response.body.codeUnits;
        var jsonData = const Utf8Decoder().convert(codeUnits);
        allUsers = json.decode(jsonData);
        for (var i in allUsers) {
          if (!allUsersSearch.contains(i['username'])) {
            allUsersSearch.add(i['username']);
          }
        }

        update();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  addUser(String email, String username, String fullName, String phoneNum,
      String password1, String password2) async {
    const requestUrl = "https://agencybankingnetwork.com/auth/users/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      // "Authorization": "Token $token"
    }, body: {
      "email": email,
      "username": username,
      "full_name": fullName,
      "company_name": "Fnet Enterprise",
      "phone": phoneNum,
      "password": password1,
      "re_password": password2,
    });
    if (response.statusCode == 201) {
      Get.snackbar("Hurray 😀", "User was added successfully",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackBackground,
          duration: const Duration(seconds: 5));
      Get.offAll(() => const HomePage());
      update();
    } else {
      Get.snackbar(
        "User Error",
        "User with same details already exists or check your internet connection",
        duration: const Duration(seconds: 5),
        colorText: defaultTextColor1,
        backgroundColor: warning,
      );
    }
  }
}
