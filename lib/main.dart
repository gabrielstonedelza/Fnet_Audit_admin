import 'package:audit_admin/screens/homepage.dart';
import 'package:audit_admin/screens/loginview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import 'constants/app_colors.dart';
import 'controller/amountreceivedcontroller.dart';
import 'controller/companiescontroller.dart';
import 'controller/logincontroller.dart';
import 'controller/paymentcontroller.dart';
import 'controller/profilecontroller.dart';
import 'controller/userscontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  Get.put(LoginController());
  Get.put(ProfileController());
  Get.put(CompanyController());
  Get.put(AmountReceivedController());
  Get.put(PaymentController());
  Get.put(UsersController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final storage = GetStorage();
  bool hasToken = false;
  late String uToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read("token") != null) {
      uToken = storage.read("token");
      setState(() {
        hasToken = true;
      });
    } else {
      setState(() {
        hasToken = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRight,
      theme: ThemeData(
          primaryColor: primaryColor,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: defaultColor,
          )),
      home: hasToken ? const HomePage() : const LoginView(),
    );
  }
}
