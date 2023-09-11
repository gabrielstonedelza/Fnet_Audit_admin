import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();
  bool isLoading = false;
  List profileDetails = [];
  late String userId = "";
  late String agentPhone = "";
  late String email = "";
  late String agentUniqueCode = "";
  late String agentUsername = "";
  late String agentFullName = "";
  late String companyName = "";
  late String companyNumber = "";
  late String phoneNumber = "";

  Future<void> getUserProfile(String token) async {
    try {
      isLoading = true;

      const profileLink = "https://agencybankingnetwork.com/profile/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        profileDetails = jsonData;
        update();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      // Get.snackbar("Sorry","something happened or please check your internet connection",snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getUserDetails(String token) async {
    try {
      isLoading = true;

      const profileLink = "https://agencybankingnetwork.com/profile/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        profileDetails = jsonData;
        for (var i in profileDetails) {
          userId = i['id'].toString();
          agentPhone = i['get_phone'];
          email = i['get_email'];
        }
        update();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      // Get.snackbar("Sorry","something happened or please check your internet connection",snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }
}
