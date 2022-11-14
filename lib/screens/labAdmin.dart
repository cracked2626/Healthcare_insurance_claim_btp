import 'package:btp_project/screens/patientRecordScreen.dart';
import 'package:flutter/material.dart';

import 'homeScreen.dart';

class LabAdmin extends StatefulWidget {
  const LabAdmin({Key? key}) : super(key: key);

  @override
  State<LabAdmin> createState() => _LabAdminState();
}

class _LabAdminState extends State<LabAdmin> {
  TextEditingController idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lab Admin'),
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
                buildText('Patient ID'),
                buildText('Name'),
                buildText('Date of claim'),
                buildText('Hospital Name'),
                buildText('Amount'),
                buildText('Sign Count'),
              ],
            ),
          ],
        ),
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
          onPressed: () {},
        ),
      ],
    );
  }
}
