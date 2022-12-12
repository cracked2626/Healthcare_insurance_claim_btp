import 'dart:developer';

import 'package:btp_project/generated/assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../constants/routes.dart';
import '../providers/metaMask_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/text_fields.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController metamaskAccountController = TextEditingController();
  TextEditingController entityController = TextEditingController();
  bool showSpinnerForSignUp = false;
  bool showSpinnerForLogIn = false;
  List<String> items = [
    "Entity Type",
    "Patient",
    "Hospital admin",
    "Lab admin",
    "Insurance company",
  ];
  String initalValue = "Entity Type";

  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: buildGradientDecoration(),
        padding: const EdgeInsets.symmetric(
          horizontal: 100.0,
          vertical: 2.0,
        ),
        child: ListView(
          children: [
            topAppBar(),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: buildColumn1()),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: SvgPicture.asset(
                    Assets.imagesUndrawFamilyVg76,
                    height: 400,
                    width: 400,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    children: [
                      const Text(
                        'SignUp or Login to Continue',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6b468c),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        padding: const EdgeInsets.all(24),
                        width: 500,
                        child:
                            isLogin ? LoginForm(context) : signUpForm(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDropdown(),
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
          showLoader: showSpinnerForLogIn,
          onPressed: () {
            // sendToScreen(
            //   context,
            //   const InsuranceAdmin(),
            // );
            findPageName();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          ' or',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        buildElevatedButton(
          title: "Sign Up",
          showLoader: showSpinnerForSignUp,
          onPressed: () async {
            setState(() {
              isLogin = false;
              passwordController.clear();
              rePasswordController.clear();
              metamaskAccountController.clear();
              entityController.clear();
              initalValue = "Entity Type";
            });
            // if (!mounted) return;
            // Navigator.of(context)
            //     .pushNamed(RoutesName.login);
          },
        ),
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
      showSpinnerForLogIn = true;
    });
    final meta = context.read<MetamaskProvider>();
    await meta.connect();

    await FirebaseFirestore.instance.collection('users').add({
      'name': entityController.text,
      'password': passwordController.text,
      'entity': initalValue,
    });
    setState(() {
      showSpinnerForLogIn = false;
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
    else{
      showSnackBar(context, "Wrong Details Entered");
    }
  }

  signUpForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDropdown(),
        const SizedBox(
          height: 20,
        ),
        buildTextField(controller: nameController, hint: "Name"),
        const SizedBox(
          height: 20,
        ),
        buildTextField(controller: passwordController, hint: "Password"),
        const SizedBox(
          height: 20,
        ),
        buildTextField(
            controller: rePasswordController, hint: "Re-Enter Password"),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        buildElevatedButton(
          title: "Sign Up",
          showLoader: showSpinnerForSignUp,
          onPressed: () async {
            try {
              if (initalValue == "Entity Type") {
                showSnackBar(context, 'Please select entity type');
                return;
              } else if (passwordController.text.trim() == "") {
                showSnackBar(context, 'Please enter password');
                return;
              }
              setState(() {
                showSpinnerForSignUp = true;
              });
              final meta =
                  Provider.of<MetamaskProvider>(context, listen: false);
             await meta.connect();

              await FirebaseFirestore.instance.collection('users').add({
                'name': nameController.text,
                'password': passwordController.text,
                'entity': initalValue,
                'walletAccount': metamaskAccountController.text,
              });
              setState(() {
                showSpinnerForSignUp = false;
                isLogin = true;
              });

              if (!mounted) return;
              showSnackBar(
                context,
                'Account created successfully, login now to continue',
              );
              // Navigator.of(context).pushNamed(RoutesName.login);
            } catch (e) {
              setState(() {
                showSpinnerForSignUp = false;
              });
              showSnackBar(context, e.toString());
            }
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          ' or',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        buildElevatedButton(
          title: "Login",
          showLoader: showSpinnerForLogIn,
          onPressed: () async {
            setState(() {
              isLogin = true;
            });
            // if (!mounted) return;
            // Navigator.of(context)
            //     .pushNamed(RoutesName.login);
          },
        ),
      ],
    );
  }

  Container buildDropdown() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffedd8f7),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: DropdownButtonFormField<String>(
        borderRadius: BorderRadius.circular(20.0),
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
          fillColor: Color(0xffeed9f8),
          focusColor: Color(0xffeed9f8),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffe8cbec),
              width: 4,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffe8cbec),
              width: 4,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffe8cbec),
              width: 4,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16.0,
          color: Color(0xff8c61a6),
        ),
        value: initalValue,
      ),
    );
  }

  Column buildColumn1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SelectableText(
          'Claim your \nHealth Insurace\nIn minutes',
          style: TextStyle(
            color: Color(
              0xff6b468c,
            ),
            fontSize: 55.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        SelectableText(
          'The first decentralized Blockchain based Health Insurance Platform in India',
          style: TextStyle(
            color: Color(
              0xff6b468c,
            ),
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Padding topAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/nsut.png',
            height: 100,
            width: 100,
          ),
          Row(
            children: [
              reusableTextButton(text: 'Home', onPressed: () {}),
              const SizedBox(
                width: 20,
              ),
              reusableTextButton(text: 'About Us', onPressed: () {}),
              const SizedBox(
                width: 20,
              ),
              reusableTextButton(text: 'Contact Us', onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  TextButton reusableTextButton(
      {required String text, required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: purpleTextColor,
        ),
      ),
    );
  }
}
