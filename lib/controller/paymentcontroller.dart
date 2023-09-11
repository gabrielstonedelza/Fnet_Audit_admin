import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  bool isLoading = true;
  late List allPayments = [];
  late List allUsersPayments = [];
  late List allUsersPaymentsDates = [];
  late String uToken = "";
  final storage = GetStorage();
  late Timer _timer;

  @override
  void onInit() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    fetchPayments();
    fetchAllUsersPayments();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchPayments();
      fetchAllUsersPayments();
    });
    super.onInit();
  }

  Future<void> fetchPayments() async {
    try {
      isLoading = true;
      const url = "https://agencybankingnetwork.com/get_my_companies_payments/";
      var myLink = Uri.parse(url);
      final response = await http.get(myLink, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });

      if (response.statusCode == 200) {
        final codeUnits = response.body.codeUnits;
        var jsonData = const Utf8Decoder().convert(codeUnits);
        allPayments = json.decode(jsonData);

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

  Future<void> fetchAllUsersPayments() async {
    try {
      isLoading = true;
      const url =
          "https://agencybankingnetwork.com/get_all_companies_payments/";
      var myLink = Uri.parse(url);
      final response = await http.get(myLink);

      if (response.statusCode == 200) {
        final codeUnits = response.body.codeUnits;
        var jsonData = const Utf8Decoder().convert(codeUnits);
        allUsersPayments = json.decode(jsonData);
        for (var i in allUsersPayments) {
          if (!allUsersPaymentsDates
              .contains(i['date_paid'].toString().split("T").first)) {
            allUsersPaymentsDates
                .add(i['date_paid'].toString().split("T").first);
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
}
