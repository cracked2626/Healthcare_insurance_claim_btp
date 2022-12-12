import 'dart:developer';

import 'package:btp_project/services/contracts_connector.dart';
import 'package:btp_project/constants/colors.dart';
import 'package:btp_project/widgets/common_widgets.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:intl/intl.dart';

import '../generated/assets.dart';
import '../services/payment_initator.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  DateTime selectedDate = DateTime.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController hospitalNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool showLoading = false;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        Navigator.pop(context);
      });
    }
  }

  final abi = [
    // Some details about the token
    "function name() view returns (string)",
    "function symbol() view returns (string)",

    // Get the account balance
    "function balanceOf(address) view returns (uint)",

    // Send some of your tokens to someone else
    "function transfer(address to, uint amount)",

    // An event triggered whenever anyone transfers to someone else
    "event Transfer(address indexed from, address indexed to, uint amount)"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: buildGradientDecoration(),
          padding: const EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 2.0,
          ),
          child: ListView(
            children: [
              buildTopAppBar(context, title: 'Claim Your Insurance'),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Claim your Health Insurance\nin few Easy Steps',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: darkPurpleTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Text(
                          'Just fill In the details below and get your\ninsurance claim in few minutes',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: darkPurpleTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        buildClaimInsuranceDetail(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 150.0),
                      child: SvgPicture.asset(
                        Assets.imagesUndrawEverywhereTogetherReXe5a,
                        height: 300.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '3 Easy Steps to Claim\nyour Insurance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                            color: darkPurpleTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        buildStepsContainer(
                          title: "Step-1",
                          desc: 'Create Claim By\nfilling the form',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        buildStepsContainer(
                          title: "Step-2",
                          desc: 'Hospital & Lab will\nverify the claim',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        buildStepsContainer(
                          title: "Step-3",
                          desc: 'Insurance Company\nwill process the claim',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Real Time Patient Records on Blockchain',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: darkPurpleTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildPatientRecords(),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildStepsContainer({required String title, required String desc}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfff4e3fa),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color(
            0xffefd6f4,
          ),
          width: 8.0,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffefd6f4),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 5.0,
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: darkPurpleTextColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: darkPurpleTextColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container buildClaimInsuranceDetail() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      padding: const EdgeInsets.all(24),
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTextField(controller: idController, hint: 'Patient ID'),
          const SizedBox(
            height: 20,
          ),
          buildTextField(controller: nameController, hint: 'Name'),
          const SizedBox(
            height: 20,
          ),
          dobField(),
          const SizedBox(
            height: 20,
          ),
          buildTextField(
              controller: hospitalNameController, hint: 'Hospital Name'),
          const SizedBox(
            height: 20,
          ),
          buildTextField(
              controller: priceController, hint: 'Insurance claim price ₹'),
          const SizedBox(
            height: 20,
          ),
          buildElevatedButton(
            title: "Claim Insurance",
            showLoader: showLoading,
            onPressed: () async {
              setState(() {
                showLoading = true;
              });
              await doEthConnectAndCreateContract();
              try {
                final contractsConnector = ContractsConnector();
                final initContract = await contractsConnector.init();
                await contractsConnector.createNewRecord(
                    int.parse(idController.text),
                    nameController.text,
                    dobController.text,
                    hospitalNameController.text,
                    int.parse(priceController.text));
              } catch (e) {
                log("error", error: e);
              }
              await claimInsurance();
              setState(() {
                showLoading = false;
              });
            },
          ),
        ],
      ),
    );
  }

  dobField() {
    return TextField(
      controller: dobController, //editing controller of this TextField
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 16.0,
        color: Color(0xff08443C),
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: darkPurpleTextColor, // <-- SEE HERE
                      onPrimary: Colors.white, // <-- SEE HERE
                      onSurface: purpleTextColor, // <-- SEE HERE
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            darkPurpleTextColor, // button text color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              setState(() {
                dobController.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {
              log("Date is not selected");
            }
          },
          icon: const Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(
              Icons.calendar_today,
              color: darkPurpleTextColor,
            ),
          ),
        ), //icon of text field
        hintText: "Date of claim",
        hintStyle: const TextStyle(
          fontSize: 16.0,
          fontFamily: 'Satoshi',
          color: Colors.grey,
        ), //label text of field
        labelStyle: const TextStyle(
          fontSize: 16.0,
          fontFamily: 'Satoshi',
          color: darkPurpleTextColor,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffe8cbec),
            width: 4,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        suffixIconColor: darkPurpleTextColor,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffe8cbec),
            width: 4,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffe8cbec),
            width: 4,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
      // readOnly:
      //     true, //set it true, so that user will not able to edit text
    );
  }

  claimInsurance() async {
    //  save user data to firebase
    log('claimInsurance called');
    await Future.delayed(const Duration(seconds: 3));
    await FirebaseFirestore.instance
        .collection('InsuranceClaims')
        .doc(idController.text.trim())
        .set({
      'patientId': idController.text.trim(),
      'name': nameController.text.trim(),
      'dob': dobController.text.trim(),
      'hospitalName': hospitalNameController.text.trim(),
      'price': priceController.text.trim(),
      'timeStamp': DateTime.now(),
      'signCount': 0,
      'isApprovedByHospital': false,
      'isApprovedByLab': false,
    });
    clearTextFields();
  }

  clearTextFields() {
    idController.clear();
    nameController.clear();
    dobController.clear();
    hospitalNameController.clear();
    priceController.clear();
  }
}
