import 'package:btp_project/screens/patientRecordScreen.dart';
import 'package:flutter/material.dart';

class InsuranceAdmin extends StatefulWidget {
  const InsuranceAdmin({Key? key}) : super(key: key);

  @override
  State<InsuranceAdmin> createState() => _InsuranceAdminState();
}

class _InsuranceAdminState extends State<InsuranceAdmin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Insurance Claims'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          'Approved Records',
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
}
