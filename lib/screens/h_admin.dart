import 'package:btp_project/widgets/common_widgets.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/colors.dart';
import '../generated/assets.dart';

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
            color: darkPurpleTextColor,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        const Text(
          'Below table contains records of the patients who have applied for insurance',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: darkPurpleTextColor,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        buildPatientRecords(),
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
                onPressed: () {
                  approveInsurance();
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
