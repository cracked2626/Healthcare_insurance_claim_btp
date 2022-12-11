import 'package:btp_project/constants/routes.dart';
import 'package:btp_project/providers/metaMask_provider.dart';
import 'package:btp_project/widgets/common_widgets.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController metamaskAccountController = TextEditingController();
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
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(24),
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
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
                  ' Please Signup to Continue',
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
                buildTextField(controller: nameController, hint: "Name"),
                const SizedBox(
                  height: 20,
                ),
                buildTextField(
                    controller: passwordController, hint: "Password"),
                const SizedBox(
                  height: 20,
                ),
                buildTextField(
                    controller: rePasswordController,
                    hint: "Re-Enter Password"),
                const SizedBox(
                  height: 20,
                ),
                buildTextField(
                    controller: metamaskAccountController,
                    hint: "Metamask Account"),
                const SizedBox(
                  height: 20,
                ),
                buildElevatedButton(
                  title: "SignUp",
                  showLoader: showSpinner,
                  onPressed: () async {
                    if (initalValue == "Entity Type") {
                      showSnackBar(context, 'Please select entity type');
                      return;
                    } else if (passwordController.text.trim() == "") {
                      showSnackBar(context, 'Please enter password');
                      return;
                    }
                    // final meta = context.read<MetamaskProvider>();
                    // meta.connect();

                    await FirebaseFirestore.instance.collection('users').add({
                      'name': nameController.text,
                      'password': passwordController.text,
                      'entity': initalValue,
                      'walletAccount': metamaskAccountController.text,
                    });
                    setState(() {
                      showSpinner = false;
                    });
                    if (!mounted) return;
                    Navigator.of(context).pushNamed(RoutesName.login);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  ' or',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                buildElevatedButton(
                  title: "Login",
                  showLoader: showSpinner,
                  onPressed: () async {
                    if (!mounted) return;
                    Navigator.of(context).pushNamed(RoutesName.login);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
}
