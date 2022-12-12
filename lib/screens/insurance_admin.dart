import 'package:btp_project/services/contracts_connector.dart';
import 'package:btp_project/widgets/common_widgets.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:btp_project/screens/patient_records_screen.dart';

class InsuranceAdmin extends StatefulWidget {
  const InsuranceAdmin({Key? key}) : super(key: key);

  @override
  State<InsuranceAdmin> createState() => _InsuranceAdminState();
}

class _InsuranceAdminState extends State<InsuranceAdmin> {
  List<dynamic> records = [];
  @override
  void initState() {
    super.initState();
    getAllRecordsFromSmartContract();
  }

  getAllRecordsFromSmartContract() async {
    final ContractsConnector _connector = ContractsConnector();
    await _connector.init();
    final allRecords = await _connector.getAllRecords();
    print(allRecords);
    setState(() {
      records = allRecords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Insurance Claims'),
          actions: [
            buildMetaMaskStatus(context),
          ],
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
}
