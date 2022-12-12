import 'dart:developer';

import 'package:btp_project/constants/routes.dart';
import 'package:btp_project/screens/patient_records_screen.dart';
import 'package:btp_project/widgets/common_widgets.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../providers/metaMask_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController entityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showSpinner = false;
  List<String> items = [
    "Entity Type",
    "Patient",
    "Hospital admin",
    "Lab admin",
    "Insurance company",
  ];
  String initalValue = "Entity Type";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(
        child: Card(
          elevation: 20.0,
          child: Container(
            width: 500,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/nsut.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  const Text(
                    ' Please Login to Continue',
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(30.0),
                    items: items.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        initalValue = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                      color: Color(0xff08443C),
                    ),
                    value: initalValue,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTextField(
                    controller: entityController,
                    hint: 'Name',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTextField(
                    controller: passwordController,
                    hint: 'Password',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildElevatedButton(
                    title: "Login",
                    showLoader: showSpinner,
                    onPressed: () {
                      // sendToScreen(
                      //   context,
                      //   const InsuranceAdmin(),
                      // );
                      findPageName();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text('HealthCare Insurance Claim'),
      actions: [
        buildMetaMaskStatus(context),
      ],
    );
  }

  sendToScreen(context, pageClassName) {
    Navigator.pushNamed(context, pageClassName);
  }

  showSnackBar(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  findPageName() async {
    log(initalValue);
    if (initalValue == "Entity Type") {
      showSnackBar(context, 'Please select entity type');
      return;
    } else if (passwordController.text.trim() == "") {
      showSnackBar(context, 'Please enter password');
      return;
    }
    setState(() {
      showSpinner = true;
    });
    final meta = context.read<MetamaskProvider>();
    meta.connect();

    await FirebaseFirestore.instance.collection('users').add({
      'name': entityController.text,
      'password': passwordController.text,
      'entity': initalValue,
    });
    setState(() {
      showSpinner = false;
    });
    if (!mounted) return;
    if (initalValue == "Patient" && passwordController.text == "patient") {
      sendToScreen(context, RoutesName.patient);
    } else if (initalValue == "Hospital admin" &&
        passwordController.text == "hadmin") {
      sendToScreen(context, RoutesName.hAdmin);
    } else if (initalValue == "Lab admin" &&
        passwordController.text == "labadmin") {
      sendToScreen(context, RoutesName.labAdmin);
    } else if (initalValue == "Insurance company" &&
        passwordController.text == "insurance") {
      sendToScreen(context, RoutesName.insuranceAdmin);
    }
  }
}
