import 'dart:developer';

import 'package:btp_project/services/contracts_connector.dart';
import 'package:btp_project/services/payment_initator.dart';
import 'package:btp_project/widgets/common_widgets.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/colors.dart';
import '../generated/assets.dart';

class LabAdmin extends StatefulWidget {
  const LabAdmin({Key? key}) : super(key: key);

  @override
  State<LabAdmin> createState() => _LabAdminState();
}

class _LabAdminState extends State<LabAdmin> {
  TextEditingController idController = TextEditingController();
  bool showLoading = false;
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
              buildTopAppBar(context, title: 'Approve Patient Insurance'),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: buildAproveRecord(),
                  ),
                  const SizedBox(
                    width: 200,
                  ),
                  Flexible(
                    child: buildRecords(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildRecords() {
    return Column(
      children: [
        const Text(
          'Patient Record',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Table(
          border: TableBorder.all(color: Colors.black),
          children: [
            TableRow(
              children: [
                buildText('Patient ID', isHeading: true),
                buildText('Name', isHeading: true),
                buildText('Date of claim', isHeading: true),
                buildText('Hospital Name', isHeading: true),
                buildText('Amount', isHeading: true),
                buildText('Sign Count', isHeading: true),
              ],
            ),
          ],
        ),
        buildStreamBuilder(),
      ],
    );
  }

  Column buildAproveRecord() {
    return Column(
      children: [
        const Text(
          "Approve Patient's Insurance Claim",
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
          'Just fill in the patient ID and click approve. Patient id can be found in the patient record section.',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: darkPurpleTextColor,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              buildTextField(
                controller: idController,
                hint: 'Patient ID',
              ),
              const SizedBox(
                height: 20,
              ),
              buildElevatedButton(
                title: "Approve Insurance",
                showLoader: showLoading,
                onPressed: () async {
                  setState(() {
                    showLoading = true;
                  });
                  await doEthConnectAndCreateContract();
                  await approveInsurance();
                  setState(() {
                    showLoading = false;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: SvgPicture.asset(
                  Assets.imagesUndrawCertificationReIfll,
                  height: 300.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  approveInsurance() async {
    // check if isApprovedByHospital is true from firestore
    if (idController.text.trim() == "") {
      showSnackBar(context, "Please enter patient ID");
      return;
    }
    try {
      final contractsConnector = ContractsConnector();
      final initContract = await contractsConnector.init();
      final res = await contractsConnector
          .signRecord(int.parse(idController.text.trim()));
    } catch (e) {
      log("Error", error: e);
    }
    setState(() {
      showLoading = true;
    });
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('InsuranceClaims')
        .doc(idController.text.trim())
        .get();

    if (documentSnapshot.exists) {
      print(documentSnapshot['isApprovedByLab']);
      if (documentSnapshot['isApprovedByLab'] == true) {
        // show snackbar
        if (!mounted) return;
        showSnackBar(context, 'Insurance Claim is already Approved');
      } else {
        // show snackbar
        await FirebaseFirestore.instance
            .collection('InsuranceClaims')
            .doc(idController.text.trim())
            .update({
          'signCount': FieldValue.increment(1),
          'isApprovedByLab': true,
        });
        if (!mounted) return;
        showSnackBar(context, 'Insurance Claim Approved Successfully');
      }
    }
    setState(() {
      showLoading = false;
    });
    idController.clear();
    //  find the record with the id and update the status to approved
  }
}
