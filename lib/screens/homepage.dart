import 'package:audit_admin/screens/payments/payments.dart';
import 'package:audit_admin/screens/searches/amountsearch.dart';
import 'package:audit_admin/screens/searches/paymentsearch.dart';
import 'package:audit_admin/screens/users/adduser.dart';
import 'package:audit_admin/screens/users/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../constants/app_colors.dart';
import '../controller/logincontroller.dart';
import 'amountreceived/amountreceivedsummary.dart';
import 'amountreceived/amountsreceived.dart';

import 'calculatedenominations.dart';
import 'companies/companies.dart';
import 'companies/registercompany.dart';
import 'loginview.dart';
import 'payments/paymentsummary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = GetStorage();
  late String uToken = "";
  late String username = "";
  logoutUser() async {
    storage.remove("token");
    storage.remove("username");

    Get.offAll(() => const LoginView());
    const logoutUrl = "https://agencybankingnetwork.com/auth/token/logout";
    final myLink = Uri.parse(logoutUrl);
    http.Response response = await http.post(myLink, headers: {
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    });

    if (response.statusCode == 200) {
      Get.snackbar("Success", "You were logged out",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackBackground);
      storage.remove("token");
      storage.remove("username");
      Get.offAll(() => const LoginView());
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
    if (storage.read("username") != null) {
      setState(() {
        username = storage.read("username");
      });
    }
  }

  final LoginController controller = Get.find();
  void showOptions() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Card(
        elevation: 12,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                  child: Text("Select",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const FetchAmountByDate());
                      // Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/receive-money.png",
                          width: 50,
                          height: 50,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("Amount Received",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const FetchPaymentByDate());
                      // Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/money.png",
                          width: 50,
                          height: 50,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("Payments",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username, style: const TextStyle(color: defaultTextColor1)),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const CalculateDenominations());
              },
              icon: Image.asset("assets/images/accounting.png",
                  width: 30, height: 30)),
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    buttonColor: primaryColor,
                    title: "Confirm Logout",
                    middleText: "Are you sure you want to logout?",
                    confirm: RawMaterialButton(
                        shape: const StadiumBorder(),
                        fillColor: primaryColor,
                        onPressed: () {
                          logoutUser();
                          Get.back();
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        )),
                    cancel: RawMaterialButton(
                        shape: const StadiumBorder(),
                        fillColor: primaryColor,
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        )));
              },
              icon: const Icon(Icons.logout, size: 30)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(
          //   height: 40,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Get.to(() => const AddNewUser());
                  },
                  child: menuWidget(
                    title1: 'Register',
                    title2: 'User',
                    imagePath: 'assets/images/add-user.png',
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Get.to(() => const AllUsers());
                  },
                  child: menuWidget(
                    title1: 'Users',
                    title2: '',
                    imagePath: 'assets/images/group.png',
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Get.to(() => const Companies());
                  },
                  child: menuWidget(
                    title1: 'Companies',
                    title2: '',
                    imagePath: 'assets/images/corporate.png',
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Get.to(() => const AmountReceivedSummary());
                  },
                  child: menuWidget(
                    title1: 'Amount',
                    title2: 'Summary',
                    imagePath: 'assets/images/corporate.png',
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Get.to(() => const PaymentSummary());
                  },
                  child: menuWidget(
                    title1: 'Payment',
                    title2: 'Summary',
                    imagePath: 'assets/images/money.png',
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {},
                  child: const Column(
                    children: [],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showOptions();
        },
        child: const Icon(Icons.search_rounded, size: 30),
      ),
    );
  }
}

class menuWidget extends StatelessWidget {
  String title1;
  String title2;
  String imagePath;

  menuWidget(
      {super.key,
      required this.title1,
      required this.title2,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 70,
          height: 70,
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Text(
              title1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              title2,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
