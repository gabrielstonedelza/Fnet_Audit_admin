import 'dart:convert';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../controller/userscontroller.dart';
import '../../widgets/loadingui.dart';

class FetchPaymentByDate extends StatefulWidget {
  const FetchPaymentByDate({Key? key}) : super(key: key);

  @override
  State<FetchPaymentByDate> createState() => _FetchPaymentByDateState();
}

class _FetchPaymentByDateState extends State<FetchPaymentByDate> {
  bool bankSelected = false;
  var _currentSelectedUsername = "Select User";
  final UsersController controller = Get.find();
  var _currentSelectedMonth = "1";
  var _currentSelectedYear = "2023";
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
        "https://agencybankingnetwork.com/search_agents_company_payment_by_date/$_currentSelectedUsername/$bMonth/$bYear/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken",
    });

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allAmountReceived = json.decode(jsonData);
      amounts.assignAll(allAmountReceived);
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
          title: const Text("My Payments"),
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
                                title: 'Company: ',
                                itemTitle: 'get_company_name',
                              ),
                              subtitle: Column(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Center(
                                      child: Text("Amount Received",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: defaultTextColor2)),
                                    ),
                                  ),
                                  RowWidget(
                                    items: items,
                                    title: 'User: ',
                                    itemTitle:
                                        'get_company_amount_received_username',
                                  ),
                                  RowWidget(
                                    items: items,
                                    title: 'Amount Received: ',
                                    itemTitle: 'get_company_amount_received'
                                        .toString(),
                                  ),
                                  RowWidget(
                                    items: items,
                                    title: 'Acc No: ',
                                    itemTitle: 'get_account_number',
                                  ),
                                  RowWidget(
                                    items: items,
                                    title: 'Transaction Id: ',
                                    itemTitle: 'get_transaction_id',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        const Text("Date Received: ",
                                            style: TextStyle(
                                                color: defaultTextColor1,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            items['get_amount_received_date']
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
                                                          'get_amount_received_receipt']))),
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
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Center(
                                      child: Text("Amount Paid",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: defaultTextColor2)),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      RowWidget(
                                        items: items,
                                        title: 'User: ',
                                        itemTitle: 'get_agent_username',
                                      ),
                                      RowWidget(
                                        items: items,
                                        title: 'Amount Paid: ',
                                        itemTitle: 'amount1'.toString(),
                                      ),
                                      RowWidget(
                                        items: items,
                                        title: 'Transaction Id: ',
                                        itemTitle: 'transaction_id1',
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          children: [
                                            const Text("Date Paid: ",
                                                style: TextStyle(
                                                    color: defaultTextColor1,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                items['date_paid']
                                                    .toString()
                                                    .split('T')
                                                    .first,
                                                style: const TextStyle(
                                                    color: defaultTextColor1,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                        'get_screenshot_pic1']),
                                                    fit: BoxFit.contain,
                                                  )),
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
                                  items['amount2'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount2'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id2',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic2']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount3'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount3'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id3',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic3']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount4'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount4'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id4',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic4']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount5'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount5'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id5',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic5']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount6'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount6'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id6',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic6']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount7'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount7'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id7',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic7']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount8'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount8'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id8',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic8']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount9'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount9'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id9',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic9']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount10'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount10'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id10',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic10']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount11'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount11'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id11',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic11']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount12'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount12'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id12',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic12']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount13'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount13'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id13',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic13']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount14'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount14'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id14',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic14']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount15'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount15'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id15',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic15']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount16'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount16'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id16',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic16']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount17'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount17'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id17',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic17']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount18'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount18'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id18',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic18']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount19'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount19'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id19',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic19']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  items['amount20'] != "0.00"
                                      ? Column(
                                          children: [
                                            RowWidget(
                                              items: items,
                                              title: 'Amount Paid: ',
                                              itemTitle: 'amount20'.toString(),
                                            ),
                                            RowWidget(
                                              items: items,
                                              title: 'Transaction Id: ',
                                              itemTitle: 'transaction_id20',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text("Date Paid: ",
                                                      style: TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      items['date_paid']
                                                          .toString()
                                                          .split('T')
                                                          .first,
                                                      style: const TextStyle(
                                                          color:
                                                              defaultTextColor1,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                FullScreenWidget(
                                                  disposeLevel:
                                                      DisposeLevel.High,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: NetworkImage(items[
                                                              'get_screenshot_pic20']),
                                                          fit: BoxFit.contain,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                const Text(
                                                  "Tap to enlarge image",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
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
            items[itemTitle].toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: defaultTextColor1),
          ),
        ),
      ],
    );
  }
}
