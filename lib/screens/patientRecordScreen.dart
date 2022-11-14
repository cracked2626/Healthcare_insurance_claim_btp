import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';

import 'homeScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Claim Insurance'),
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
                child: buildClaimInsuranceDetail(),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  children: [
                    const Text(
                      'Patient Records',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column buildClaimInsuranceDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Create New Claim',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        buildTextField(controller: idController, hint: 'Patient ID'),
        const SizedBox(
          height: 20,
        ),
        buildTextField(controller: nameController, hint: 'Name'),

        const SizedBox(
          height: 20,
        ),
        buildTextField(controller: dobController, hint: 'Date Of Birth'),

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
        // OutlinedButton(
        //   onPressed: () => _selectDate(context),
        //   child: Text(
        //     "Dob $selectedDate",
        //     style: const TextStyle(
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        const SizedBox(
          height: 20,
        ),
        buildElevatedButton(
            title: "Claim Insurance",
            onPressed: () async {
              // Call `eth_gasPrice` as `BigInt`
              final result = await ethereum!.request<BigInt>('eth_gasPrice');
              print(result); // 20000000000
              result; // 5000000000
              result is BigInt; // true
              print('eth conn ${ethereum!.isConnected}');
              final web3provider = Web3Provider.fromEthereum(ethereum!);
              print('web3provider: $web3provider');
              final rpcProvider =
                  JsonRpcProvider("https://bsc-dataseed.binance.org/");
              print('rpcProvider: $rpcProvider');
              // Send 1000000000 wei to `0xcorge`
              final tx = await provider!.getSigner().sendTransaction(
                    TransactionRequest(
                      to: '0xcorge',
                      value: BigInt.from(1000000000),
                    ),
                  );
              print('tx: $tx');
              // tx.hash; // 0xplugh
              //
              // final receipt = await tx.wait();
              //
              // receipt is TransactionReceipt; // true
              // print('receipt: $receipt');
              // final web3provider = Web3Provider.fromEthereum(ethereum!);
              // final contract = Contract(
              //   '0x5FbDB2315678afecb367f032d93F642f64180aa3',
              //   'Insurance.json',
              //   web3provider,
              // );
              // contract.call(
              //   'createClaim',
              //   [
              //     idController.text,
              //     nameController.text,
              //     dobController.text,
              //     hospitalNameController.text,
              //     priceController.text,
              //   ],
              // );
            }),
      ],
    );
  }

  claimInsurance() {}
}

TextField buildTextField(
    {required TextEditingController controller, required String hint}) {
  return TextField(
    controller: controller,
    style: const TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 16.0,
      color: Color(0xff08443C),
    ),
    cursorColor: Colors.black,
    decoration: InputDecoration(
      labelText: hint,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 16.0,
        color: Color(0xff08443C),
      ),

      // isDense: true,
      // contentPadding: EdgeInsets.only(top: 4),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
    ),
  );
}

Center buildText(text) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17.0,
        ),
      ),
    ),
  );
}
