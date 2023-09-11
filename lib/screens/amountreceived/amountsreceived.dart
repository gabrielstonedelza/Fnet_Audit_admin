import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controller/amountreceivedcontroller.dart';

class AmountsReceived extends StatefulWidget {
  final date_received;
  const AmountsReceived({super.key, required this.date_received});

  @override
  State<AmountsReceived> createState() =>
      _AmountsReceivedState(date_received: this.date_received);
}

class _AmountsReceivedState extends State<AmountsReceived> {
  final date_received;
  _AmountsReceivedState({required this.date_received});
  final AmountReceivedController controller = Get.find();
  late String uToken = "";
  final storage = GetStorage();
  var items;

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
    return Scaffold(
        appBar: AppBar(title: Text("Amounts Received for $date_received")),
        body: GetBuilder<AmountReceivedController>(
          builder: (cController) {
            return ListView.builder(
                itemCount: cController.allAllUsersAmountReceivedPaid != null
                    ? cController.allAllUsersAmountReceivedPaid.length
                    : 0,
                itemBuilder: (context, index) {
                  items = cController.allAllUsersAmountReceivedPaid[index];
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
                          items['d_200'] != 0
                              ? Row(
                                  children: [
                                    const Text(
                                      "GHS 200 Notes ➡️ ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items['d_200'].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          items['d_100'] != 0
                              ? Row(
                                  children: [
                                    const Text(
                                      "GHS 100 Notes ➡️ ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items['d_100'].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          items['d_50'] != 0
                              ? Row(
                                  children: [
                                    const Text(
                                      "GHS 50 Notes ➡️ ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items['d_50'].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          items['d_20'] != 0
                              ? Row(
                                  children: [
                                    const Text(
                                      "GHS 20 Notes ➡️ ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items['d_20'].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          items['d_10'] != 0
                              ? Row(
                                  children: [
                                    const Text(
                                      "GHS 10 Notes ➡️ ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items['d_10'].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          items['d_5'] != 0
                              ? Row(
                                  children: [
                                    const Text(
                                      "GHS 5 Notes ➡️ ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items['d_5'].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          items['d_2'] != 0
                              ? Row(
                                  children: [
                                    const Text(
                                      "GHS 2 Notes ➡️ ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items['d_2'].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          items['d_1'] != 0
                              ? Row(
                                  children: [
                                    const Text(
                                      "GHS 1 Notes ➡️ ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items['d_1'].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Container(),
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
                                                  items['get_receipt_pic']))),
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
                        ],
                      ),
                    ),
                  );
                });
          },
        ));
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
