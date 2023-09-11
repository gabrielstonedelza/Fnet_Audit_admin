import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controller/amountreceivedcontroller.dart';
import 'amountsreceived.dart';

class AmountReceivedSummary extends StatefulWidget {
  const AmountReceivedSummary({Key? key}) : super(key: key);

  @override
  State<AmountReceivedSummary> createState() => _AmountReceivedSummaryState();
}

class _AmountReceivedSummaryState extends State<AmountReceivedSummary> {
  final AmountReceivedController controller = Get.find();
  var items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Received Summary"),
      ),
      body: GetBuilder<AmountReceivedController>(
        builder: (aController) {
          return ListView.builder(
              itemCount: aController.allAllUsersAmountReceivedPaidDates != null
                  ? aController.allAllUsersAmountReceivedPaidDates.length
                  : 0,
              itemBuilder: (context, i) {
                items = aController.allAllUsersAmountReceivedPaidDates[i];
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AmountsReceived(
                              date_received: aController
                                  .allAllUsersAmountReceivedPaidDates[i]);
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Card(
                          color: secondaryColor,
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          // shadowColor: Colors.pink,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Date: ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      items,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        },
      ),
    );
  }
}
