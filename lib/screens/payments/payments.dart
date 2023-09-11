import 'dart:convert';

import 'package:audit_admin/widgets/loadingui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../constants/app_colors.dart';
import '../../controller/paymentcontroller.dart';

class Payments extends StatefulWidget {
  final date_paid;
  const Payments({super.key, required this.date_paid});

  @override
  State<Payments> createState() => _PaymentsState(date_paid: this.date_paid);
}

class _PaymentsState extends State<Payments> {
  final date_paid;
  _PaymentsState({required this.date_paid});
  final PaymentController controller = Get.find();
  late List allPaymentDates = [];
  bool isLoading = true;
  late List allPayments = [];
  late String uToken = "";
  final storage = GetStorage();
  var items;
  Future<void> fetchAllUsersPayments() async {
    const url = "https://agencybankingnetwork.com/get_all_companies_payments/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allPayments = json.decode(jsonData);
      for (var i in allPayments) {
        if (i['date_paid'].toString().split("T").first == date_paid) {
          allPaymentDates.add(i);
        }
      }

      setState(() {
        isLoading = false;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
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
    fetchAllUsersPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Payments")),
        body: isLoading
            ? const LoadingUi()
            : ListView.builder(
                itemCount: allPaymentDates != null ? allPaymentDates.length : 0,
                itemBuilder: (context, index) {
                  items = allPaymentDates[index];
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
                            padding: EdgeInsets.only(top: 10, bottom: 10),
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
                            itemTitle: 'get_company_amount_received_username',
                          ),
                          RowWidget(
                            items: items,
                            title: 'Amount Received: ',
                            itemTitle: 'get_company_amount_received'.toString(),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
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
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    const Text("Date Paid: ",
                                        style: TextStyle(
                                            color: defaultTextColor1,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        items['date_paid']
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
                                            image: NetworkImage(
                                                items['get_screenshot_pic1']),
                                            fit: BoxFit.contain,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Text(
                                    "Tap to enlarge image",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Text("Date Paid: ",
                                              style: TextStyle(
                                                  color: defaultTextColor1,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              items['date_paid']
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
                                              fontWeight: FontWeight.bold),
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
                }));
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
