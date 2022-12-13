import 'dart:developer';

import 'package:btp_project/screens/patient_records_screen.dart';
import 'package:btp_project/services/contracts_connector.dart';
import 'package:btp_project/widgets/common_widgets.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        appBar: AppBar(
          title: const Text('Lab Admin'),
          actions: [
            buildMetaMaskStatus(context),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: buildAproveRecord(),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: buildRecords(),
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
          'Approve Medical Record',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
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
            await approveInsurance();
          },
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
      log("error $e");
    }
    setState(() {
      showLoading = true;
    });
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('InsuranceClaims')
        .doc(idController.text.trim())
        .get();

    if (documentSnapshot.exists) {
      if (documentSnapshot['isApprovedByLab'] == true) {
        // show snackbar
        if (!mounted) return;
        showSnackBar(context, 'Insurance Claim is already Approved');
      } else {
        // show snackbar
        FirebaseFirestore.instance
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
