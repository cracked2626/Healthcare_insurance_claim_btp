import 'package:btp_project/screens/patientRecordScreen.dart';
import 'package:flutter/material.dart';

import 'insurance_admin.dart';

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
                  onChanged: (_) {},
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return const InsuranceAdmin();
                        },
                      ),
                    );
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
