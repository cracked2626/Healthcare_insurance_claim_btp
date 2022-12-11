import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractsConnector {
  final String rpcUrl = "http://127.0.0.1:7545";
  final String wsUrl = "ws://127.0.0.1:7545";
  final String privateKey =
      "ef078faccd7931ea9f47721118e209422a03c0a169e8883826f8c68a8094db73";

  Web3Client? _client;
  bool isLoading = false;

  String? abiCode;
  EthereumAddress? _contractAddress;

  Credentials? _credentials;

  DeployedContract? _contract;

  ContractFunction? _newRecord;
  ContractFunction? _signRecord;

  ContractEvent? _recordCreated;
  ContractEvent? _recordSigned;

  String? deployedName;

  ContractsConnector() {
    init();
  }

  init() async {
    _client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    await getAbi();
    await getDeployedContract();
    getCredentials();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("build/contracts/HealthCare.json");
    var abiJson = jsonDecode(abiStringFile);
    abiCode = jsonEncode(abiJson["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(abiJson["networks"]["5777"]["address"]);
  }

  getCredentials() {
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<void> getDeployedContract() async {
    final s = ContractAbi.fromJson(abiCode!, "HealthCare");
    _contract = DeployedContract(s, _contractAddress!);
    print(
        "${_contract!.abi} ${_contract!.address} ${_contract!.functions} ${_contract!.toString()}");
    _newRecord = _contract!.function("newRecord");
    _signRecord = _contract!.function("signRecord");

    _recordCreated = _contract!.event("recordCreated");
    _recordSigned = _contract!.event("recordSigned");
  }

  signRecord(int recID) async {
    isLoading = true;
    await _client!
        .sendTransaction(
            _credentials!,
            Transaction.callContract(
              contract: _contract!,
              function: _signRecord!,
              parameters: [
                BigInt.from(recID),
              ],
            ),
            chainId: 5777)
        .then((value) {
      isLoading = false;
    });
  }

  createNewRecord(
      int id, String patientName, String date, String hName, int price) async {
    isLoading = true;
    await _client!
        .sendTransaction(
            _credentials!,
            Transaction.callContract(
                contract: _contract!,
                function: _newRecord!,
                parameters: [
                  BigInt.from(id),
                  patientName,
                  date,
                  hName,
                  BigInt.from(price)
                ]),
            chainId: 5777)
        .then((value) {
      print("new record added in contract ${value}");
      isLoading = false;
    });
  }
}
