import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controller/companiescontroller.dart';

class Companies extends StatefulWidget {
  const Companies({super.key});

  @override
  State<Companies> createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  final CompanyController controller = Get.find();
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
        appBar: AppBar(title: const Text("My Companies")),
        body: GetBuilder<CompanyController>(
          builder: (cController) {
            return ListView.builder(
                itemCount: cController.allCompanies != null
                    ? cController.allCompanies.length
                    : 0,
                itemBuilder: (context, index) {
                  items = cController.allCompanies[index];
                  return Card(
                    color: secondaryColor,
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: RowWidget(
                        items: items,
                        title: 'Name: ',
                        itemTitle: 'name',
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
                            title: 'Email: ',
                            itemTitle: 'email',
                          ),
                          RowWidget(
                            items: items,
                            title: 'Bank: ',
                            itemTitle: 'bank',
                          ),
                          RowWidget(
                            items: items,
                            title: 'Acc No: ',
                            itemTitle: 'account_number',
                          ),
                          RowWidget(
                            items: items,
                            title: 'Phone: ',
                            itemTitle: 'phone',
                          ),
                          RowWidget(
                            items: items,
                            title: 'Whatsapp Phone: ',
                            itemTitle: 'company_whatsapp_phone',
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
