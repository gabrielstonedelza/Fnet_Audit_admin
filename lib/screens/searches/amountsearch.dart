import 'dart:convert';
import 'package:audit_admin/controller/userscontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../widgets/loadingui.dart';

class FetchAmountByDate extends StatefulWidget {
  const FetchAmountByDate({Key? key}) : super(key: key);

  @override
  State<FetchAmountByDate> createState() => _FetchAmountByDateState();
}

class _FetchAmountByDateState extends State<FetchAmountByDate> {
  bool bankSelected = false;
  final UsersController controller = Get.find();

  var _currentSelectedMonth = "1";
  var _currentSelectedYear = "2023";
  var _currentSelectedUsername = "Select User";
  final _formKey = GlobalKey<FormState>();

  late List searchedTransactions = [];
  List months = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
  List years = [
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030",
  ];

  String bMonth = "";
  String bYear = "";

  late List allAmountReceived = [];
  bool isSearching = false;
  late List amounts = [];
  late List amountResults = [];
  bool hasData = false;
  double sum = 0.0;
  double cashReceived = 0.0;
  var items;
  late String uToken = "";
  final storage = GetStorage();

  Future<void> fetchAmountByMonth() async {
    final url =
        "https://agencybankingnetwork.com/search_agents_company_amount_received_by_date/$_currentSelectedUsername/$bMonth/$bYear/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allAmountReceived = json.decode(jsonData);
      amounts.assignAll(allAmountReceived);
      if (kDebugMode) {
        print(amounts);
      }
      for (var i in amounts) {
        sum = sum + double.parse(i['amount_received']);
      }
      setState(() {
        hasData = true;
        isSearching = false;
      });
    } else {
      setState(() {
        hasData = false;
        isSearching = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read("token") != null) {
      setState(() {
        uToken = storage.read("token");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Amount Received"),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20),
            const Padding(
                padding: EdgeInsets.only(left: 35.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text("Username",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text("Month",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text("Year",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: DropdownButton(
                              hint: const Text("Select Username"),
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: controller.allUsersSearch
                                  .map((dropDownStringItem) {
                                return DropdownMenuItem(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                _onDropDownItemSelectedUsername(
                                    newValueSelected);
                              },
                              value: _currentSelectedUsername,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: DropdownButton(
                              hint: const Text("Month"),
                              isExpanded: true,
                              underline: const SizedBox(),
                              // style: const TextStyle(
                              //     color: Colors.black, fontSize: 20),
                              items: months.map((dropDownStringItem) {
                                return DropdownMenuItem(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                _onDropDownItemSelectedMonth(newValueSelected);
                              },
                              value: _currentSelectedMonth,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: DropdownButton(
                              hint: const Text("Years"),
                              isExpanded: true,
                              underline: const SizedBox(),
                              // style: const TextStyle(
                              //     color: Colors.black, fontSize: 20),
                              items: years.map((dropDownStringItem) {
                                return DropdownMenuItem(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                _onDropDownItemSelectedYear(newValueSelected);
                              },
                              value: _currentSelectedYear,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RawMaterialButton(
                onPressed: () {
                  setState(() {
                    isSearching = true;
                    bMonth = _currentSelectedMonth;
                    bYear = _currentSelectedYear;
                  });

                  if (!_formKey.currentState!.validate()) {
                    return;
                  } else {
                    fetchAmountByMonth();
                  }
                },
                // child: const Text("Send"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 8,
                fillColor: secondaryColor,
                splashColor: defaultTextColor1,
                child: const Text(
                  "Search",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: defaultTextColor1),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            isSearching
                ? const LoadingUi()
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: ListView.builder(
                        itemCount: amounts != null ? amounts.length : 0,
                        itemBuilder: (context, index) {
                          items = amounts[index];
                          return Card(
                            color: secondaryColor,
                            elevation: 12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: RowWidget(
                                items: items,
                                title: 'Name: ',
                                itemTitle: 'get_company_name',
                              ),
                              subtitle: Column(
                                children: [
                                  RowWidget(
                                    items: items,
                                    title: 'User: ',
                                    itemTitle: 'get_agent_username',
                                  ),
                                  RowWidget(
                                    items: items,
                                    title: 'Amount: ',
                                    itemTitle: 'amount_received',
                                  ),
                                  RowWidget(
                                    items: items,
                                    title: 'Acc No: ',
                                    itemTitle: 'account_number',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        const Text("Date: ",
                                            style: TextStyle(
                                                color: defaultTextColor1,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            items['date_received']
                                                .toString()
                                                .split('T')
                                                .first,
                                            style: const TextStyle(
                                                color: defaultTextColor1,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      FullScreenWidget(
                                        disposeLevel: DisposeLevel.High,
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Card(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(items[
                                                          'get_receipt_pic']))),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      const Text(
                                        "Tap to enlarge image",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  void _onDropDownItemSelectedMonth(newValueSelected) {
    setState(() {
      _currentSelectedMonth = newValueSelected;
    });
  }

  void _onDropDownItemSelectedYear(newValueSelected) {
    setState(() {
      _currentSelectedYear = newValueSelected;
    });
  }

  void _onDropDownItemSelectedUsername(newValueSelected) {
    setState(() {
      _currentSelectedUsername = newValueSelected;
    });
  }
}

class RowWidget extends StatelessWidget {
  String title;
  String itemTitle;
  RowWidget(
      {super.key,
      required this.items,
      required this.title,
      required this.itemTitle});

  final items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: defaultTextColor1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, bottom: 8),
          child: Text(
            items[itemTitle],
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: defaultTextColor1),
          ),
        ),
      ],
    );
  }
}
