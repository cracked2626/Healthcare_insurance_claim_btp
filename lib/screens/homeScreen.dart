import 'dart:developer';

import 'package:btp_project/screens/patientRecordScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/metaMask_provider.dart';
import 'hAdmin.dart';
import 'insurance_admin.dart';
import 'labAdmin.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController entityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HealthCare Insurance Claim'),
      ),
      body: Center(
        child: Card(
          elevation: 20.0,
          child: Container(
            height: 500,
            width: 500,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  ' Please Login to Continue',
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
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
                  onPressed: () {
                    sendToScreen(context, const Patient());
                    // findPageName();
                  },
                ),
                MaterialButton(
                  child: Consumer<MetamaskProvider>(
                    builder: (context, meta, child) {
                      String text = '';
                      if (meta.isConnected && meta.isInOperatingChain) {
                        text = 'Metamask connected';
                      } else if (meta.isConnected && !meta.isInOperatingChain) {
                        text = 'Wrong operating chain';
                      } else if (meta.isEnabled) {
                        return const Text(
                          'Connect Metamask',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        text = 'Unsupported Browser';
                      }

                      return Text(
                        text,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  onPressed: () {
                    final meta = context.read<MetamaskProvider>();
                    meta.connect();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  sendToScreen(context, pageClassName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return pageClassName;
        },
      ),
    );
  }

  showSnackBar(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  findPageName() {
    sendToScreen(context, const Patient());
    log(initalValue);
    if (initalValue == "Entity Type") {
      showSnackBar(context, 'Please select entity type');
    } else if (passwordController.text.trim() == "") {
      showSnackBar(context, 'Please enter password');
    }
    FirebaseFirestore.instance.collection('users').add({
      'name': entityController.text,
      'password': passwordController.text,
      'entity': initalValue,
    });
    if (initalValue == "Patient" && passwordController.text == "patient") {
      sendToScreen(context, const Patient());
    } else if (initalValue == "Hospital admin" &&
        passwordController.text == "hadmin") {
      sendToScreen(context, const HospitalAdmin());
    } else if (initalValue == "Lab admin" &&
        passwordController.text == "labadmin") {
      sendToScreen(context, const LabAdmin());
    } else if (initalValue == "Insurance company" &&
        passwordController.text == "insurance") {
      sendToScreen(context, const InsuranceAdmin());
    }
  }
}

ElevatedButton buildElevatedButton(
    {required String title, required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      primary: const Color(0xff08443C),
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

showSnackBar(context, msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}
