import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CompanyController extends GetxController {
  bool isLoading = true;
  late List allCompanies = [];
  late List companyDetails = [];
  late List allMyCompanies = [];
  late List myCompanies = ["Select company"];
  late List companyWhatsappPhones = [];
  late List companyNames = ["Select company"];
  late String uToken = "";
  final storage = GetStorage();
  late List companyPhones = [];
  late List companyEmails = [];
  late String companyWhatsappPhone = "";
  late String companyName = "";
  late String companyPhone = "";
  late String companyEmail = "";
  late String companiesAccountNumber = "";
  late String companyId = "";
  late Timer _timer;

  @override
  void onInit() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    fetchCompanies();
    fetchAllMyCompanies();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchAllMyCompanies();
    });
    super.onInit();
  }

  Future<void> fetchCompanies() async {
    try {
      isLoading = true;
      const url = "https://agencybankingnetwork.com/get_all_companies/";
      var myLink = Uri.parse(url);
      final response = await http.get(myLink);

      if (response.statusCode == 200) {
        final codeUnits = response.body.codeUnits;
        var jsonData = const Utf8Decoder().convert(codeUnits);
        allCompanies = json.decode(jsonData);
        for (var i in allCompanies) {
          companyWhatsappPhones.add(i['company_whatsapp_phone']);
          companyPhones.add(i['phone']);
          companyNames.add(i['name']);
          companyEmails.add(i['email']);
          // companiesAccountNumbers.add(i['account_number']);
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

  Future<void> fetchAllMyCompanies() async {
    try {
      isLoading = true;
      const url = "https://agencybankingnetwork.com/get_my_companies/";
      var myLink = Uri.parse(url);
      final response = await http.get(myLink, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });

      if (response.statusCode == 200) {
        final codeUnits = response.body.codeUnits;
        var jsonData = const Utf8Decoder().convert(codeUnits);
        allMyCompanies = json.decode(jsonData);
        for (var i in allMyCompanies) {
          if (!myCompanies.contains(i['name'])) {
            myCompanies.add(i['name']);
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

  Future<void> fetchCompanyByName(String cName) async {
    try {
      isLoading = true;
      final url =
          "https://agencybankingnetwork.com/get_company_by_name/$cName/";
      var myLink = Uri.parse(url);
      final response = await http.get(myLink);

      if (response.statusCode == 200) {
        final codeUnits = response.body.codeUnits;
        var jsonData = const Utf8Decoder().convert(codeUnits);
        companyDetails = json.decode(jsonData);

        for (var i in companyDetails) {
          companyWhatsappPhone = i['company_whatsapp_phone'];
          companyName = i['name'];
          companiesAccountNumber = i['account_number'];
          companyPhone = i['phone'];
          companyEmail = i['email'];
          companyId = i['id'].toString();
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
