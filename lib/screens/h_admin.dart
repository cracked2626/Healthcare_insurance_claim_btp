import 'package:btp_project/screens/patient_records_screen.dart';
import 'package:btp_project/widgets/common_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HospitalAdmin extends StatefulWidget {
  const HospitalAdmin({Key? key}) : super(key: key);

  @override
  State<HospitalAdmin> createState() => _HospitalAdminState();
}

class _HospitalAdminState extends State<HospitalAdmin> {
  TextEditingController idController = TextEditingController();
  bool showLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hospital Admin'),
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
              Flexible(
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
                buildText('Name'),
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
          onPressed: () {
            approveInsurance();
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
    setState(() {
      showLoading = true;
    });
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('InsuranceClaims')
        .doc(idController.text.trim())
        .get();
    if (!mounted) return;
    if (documentSnapshot.exists) {
      if (documentSnapshot['isApprovedByHospital'] == true) {
        // show snackbar
        showSnackBar(context, 'Insurance is already Approved');
      } else {
        // show snackbar
        FirebaseFirestore.instance
            .collection('InsuranceClaims')
            .doc(idController.text.trim())
            .update({
          'signCount': FieldValue.increment(1),
          'isApprovedByHospital': true,
        });
        showSnackBar(context, 'Insurance Approved Successfully');
      }
    }
    setState(() {
      showLoading = false;
    });
    idController.clear();
    //  find the record with the id and update the status to approved
  }
}
