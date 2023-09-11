import 'package:audit_admin/controller/userscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/loadingui.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key? key}) : super(key: key);

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  final UsersController userController = Get.find();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _rePasswordController;
  late final TextEditingController _phoneNumberController;

  final _formKey = GlobalKey<FormState>();
  bool isObscured = true;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _rePasswordFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  final storage = GetStorage();
  late String username = "";
  late String uToken = "";
  late String userCode = "";
  bool isPosting = false;

  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isPosting = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    if (storage.read("username") != null) {
      userCode = storage.read("username");
    }
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _fullNameController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New User"),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 10,
                      cursorColor: secondaryColor,
                      decoration: buildInputDecoration("Username"),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter username";
                        }
                        if (value.length == 4) {
                          Get.snackbar(
                              "Username error", "should be greater than 4",
                              colorText: defaultTextColor1,
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: warning,
                              duration: const Duration(seconds: 5));
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 10,
                      cursorColor: secondaryColor,
                      decoration: buildInputDecoration("Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter email";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: _fullNameController,
                      focusNode: _fullNameFocusNode,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 10,
                      cursorColor: secondaryColor,
                      decoration: buildInputDecoration("Full Name"),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter full name";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      focusNode: _phoneNumberFocusNode,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 10,
                      cursorColor: secondaryColor,
                      decoration: buildInputDecoration("Phone Number"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter phone number";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 10,
                      cursorColor: secondaryColor,
                      decoration: buildInputDecoration("Password"),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == _passwordController.text.length &&
                            value != _passwordController.text) {
                          Get.snackbar(
                              "Password error", "your password don't match",
                              colorText: defaultTextColor1,
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: warning,
                              duration: const Duration(seconds: 5));
                        }
                        return;
                      },
                      controller: _rePasswordController,
                      focusNode: _rePasswordFocusNode,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 10,
                      cursorColor: secondaryColor,
                      decoration: buildInputDecoration("Confirm Password"),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please reenter password";
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  isPosting
                      ? const LoadingUi()
                      : RawMaterialButton(
                          onPressed: () {
                            _startPosting();
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            if (!_formKey.currentState!.validate()) {
                              return;
                            } else {
                              userController.addUser(
                                  _emailController.text.trim(),
                                  _usernameController.text.trim(),
                                  _fullNameController.text.trim(),
                                  _phoneNumberController.text.trim(),
                                  _passwordController.text.trim(),
                                  _rePasswordController.text.trim());
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 8,
                          fillColor: primaryColor,
                          splashColor: defaultColor,
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(String text) {
    return InputDecoration(
      labelStyle: const TextStyle(color: secondaryColor),
      labelText: text,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor, width: 2),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
