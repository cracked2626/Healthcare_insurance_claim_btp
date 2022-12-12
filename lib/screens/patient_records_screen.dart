import 'dart:developer';

import 'package:btp_project/services/contracts_connector.dart';
import 'package:btp_project/widgets/common_widgets.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:intl/intl.dart';

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
        appBar: AppBar(
          title: const Text('Claim Insurance'),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildClaimInsuranceDetail() {
    print("here oos");
    return SingleChildScrollView(
      child: Column(
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
          TextField(
            controller: dobController, //editing controller of this TextField
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16.0,
              color: Color(0xff08443C),
            ),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () async {
                  print("here");
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
                              primary: Colors.lightBlue, // <-- SEE HERE
                              onPrimary: Colors.black, // <-- SEE HERE
                              onSurface: Colors.blueAccent, // <-- SEE HERE
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Colors.red, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      });
                  print("date picked $pickedDate");
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      print("here i am");
                      dobController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    log("Date is not selected");
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.calendar_today),
                ),
              ), //icon of text field
              labelText: "Choose DOB", //label text of field
              labelStyle: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
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
            // readOnly:
            //     true, //set it true, so that user will not able to edit text
          ),
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
              await doEthConnectAndCreateContract();
              await claimInsurance();
            },
          ),
        ],
      ),
    );
  }

  doEthConnectAndCreateContract() async {
    final contractsConnector = ContractsConnector();
    final initContract = await contractsConnector.init();
    final res = await contractsConnector.createNewRecord(
        int.parse(idController.text),
        nameController.text,
        dobController.text,
        hospitalNameController.text,
        int.parse(priceController.text));

    print("res form contracts $res");
//     final humanReadableAbi = [
//       "function balanceOf(address owner) view returns (uint256 balance)",
//       "function addPerson(tuple(string name, uint16 age) person)",
//       // Or "function addPerson((string name, uint16 age) person)"
//     ];

//     const jsonAbi = '''[
//        {
//     "type": "function",
//     "name": "balanceOf",
//     "constant":true,
//     "stateMutability": "view",
//     "payable":false, "inputs": [
//       { "type": "address", "name": "owner"}
//     ],
//     "outputs": [
//       { "type": "uint256"}
//     ]
//   }
// ]''';

// // Contruct Interface object out of `humanReadableAbi` or `jsonAbi`
//     final humanInterface = Interface(humanReadableAbi);
//     final jsonInterface = Interface(jsonAbi);

// // These two abi interface can be exchanged
//     humanInterface.format(FormatTypes
//         .minimal); // [function balanceOf(address) view returns (uint256)]
//     humanInterface.format(FormatTypes.minimal)[0] ==
//         jsonInterface.format(FormatTypes.minimal)[0]; // true
//     // Call `eth_gasPrice` as `BigInt`
//     final result = await ethereum!.request<BigInt>('eth_gasPrice');
//     print(result); // 20000000000
//     result; // 5000000000
//     result is BigInt; // true
//     print('eth conn ${ethereum!.isConnected}');
//     final web3provider = Web3Provider.fromEthereum(ethereum!);
//     print('web3provider: $web3provider');
//     final rpcProvider = JsonRpcProvider("https://bsc-dataseed.binance.org/");
//     print('rpcProvider: $rpcProvider');
//     // Send 1000000000 wei to `0xcorge`
//     final tx = await web3provider.getSigner().sendTransaction(
//           TransactionRequest(
//             to: '0xA1B023b05996Dd3e85FA2edB3400594806193406',
//             value: BigInt.from(0),
//           ),
//         );
    // // print('tx: ${tx.chainId}');
    // tx.hash; // 0xplugh

    // final receipt = await tx.wait();

    // receipt is TransactionReceipt; // true
    // print('receipt: $receipt');
    // final contract = Contract(
    //   '0xA1B023b05996Dd3e85FA2edB3400594806193406',
    //   abi,
    //   web3provider,
    // );
    // print('contract: $contract');
    // final anotherBusd = Contract(
    //   busdAddress,
    //   Interface(abi),
    //   provider!.getSigner(),
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
  }

  claimInsurance() async {
    //  save user data to firebase
    print('claimInsurance called');
    await Future.delayed(const Duration(seconds: 5));
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
