import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
          const SizedBox(
            height: 20,
          ),
          buildElevatedButton(
            title: "Claim Insurance",
            showLoader: showLoading,
            onPressed: () async {
              await claimInsurance();
              await doEthConnectAndCreateContract();
            },
          ),
        ],
      ),
    );
  }

  doEthConnectAndCreateContract() async {
    final humanReadableAbi = [
      "function balanceOf(address owner) view returns (uint256 balance)",
      "function addPerson(tuple(string name, uint16 age) person)",
      // Or "function addPerson((string name, uint16 age) person)"
    ];

    const jsonAbi = '''[
       {
    "type": "function",
    "name": "balanceOf",
    "constant":true,
    "stateMutability": "view",
    "payable":false, "inputs": [
      { "type": "address", "name": "owner"}
    ],
    "outputs": [
      { "type": "uint256"}
    ]
  }
]''';

// Contruct Interface object out of `humanReadableAbi` or `jsonAbi`
    final humanInterface = Interface(humanReadableAbi);
    final jsonInterface = Interface(jsonAbi);

// These two abi interface can be exchanged
    humanInterface.format(FormatTypes
        .minimal); // [function balanceOf(address) view returns (uint256)]
    humanInterface.format(FormatTypes.minimal)[0] ==
        jsonInterface.format(FormatTypes.minimal)[0]; // true
    // Call `eth_gasPrice` as `BigInt`
    final result = await ethereum!.request<BigInt>('eth_gasPrice');
    print(result); // 20000000000
    result; // 5000000000
    result is BigInt; // true
    print('eth conn ${ethereum!.isConnected}');
    final web3provider = Web3Provider.fromEthereum(ethereum!);
    print('web3provider: $web3provider');
    final rpcProvider = JsonRpcProvider("https://bsc-dataseed.binance.org/");
    print('rpcProvider: $rpcProvider');
    // Send 1000000000 wei to `0xcorge`
    final tx = await web3provider.getSigner().sendTransaction(
          TransactionRequest(
            to: '0xA1B023b05996Dd3e85FA2edB3400594806193406',
            value: BigInt.from(0),
          ),
        );
    print('tx: $tx');
    tx.hash; // 0xplugh

    final receipt = await tx.wait();

    receipt is TransactionReceipt; // true
    print('receipt: $receipt');
    final contract = Contract(
      '0xA1B023b05996Dd3e85FA2edB3400594806193406',
      abi,
      web3provider,
    );
    print('contract: $contract');
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
    log('claimInsurance called');
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
        fontSize: 16.0,
        color: Colors.grey,
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

Center buildText(text, {bool isHeading = false}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: isHeading ? FontWeight.w900 : FontWeight.normal,
        ),
      ),
    ),
  );
}

StreamBuilder<QuerySnapshot<Map<String, dynamic>>> buildStreamBuilder() {
  return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('InsuranceClaims').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> ds = snapshot.data!.docs[index].data();
                String name = ds['name'];
                String id = ds['patientId'];
                String hospitalName = ds['hospitalName'];
                String price = ds['price'];
                String date = ds['timeStamp'].toDate().toString();
                // format timeStamp to date
                String signCount =
                    ds['signCount'] == null ? '0' : ds['signCount'].toString();

                return Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(
                      children: [
                        buildText(id),
                        buildText(name),
                        buildText(date),
                        buildText(hospitalName),
                        buildText(price),
                        buildText(signCount),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return const Text('Loading...');
        }
        return Text('data :${snapshot.data?.docs.first.data()['patientId']}');
      });
}
