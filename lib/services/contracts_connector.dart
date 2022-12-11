import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractsConnector {
  final String rpcUrl = "http://127.0.0.1:7545";
  final String wsUrl = "ws://127.0.0.1:7545";
  final String privateKey =
      "9101369c4929962ab9b3d9af25151cbd35fa7450a1cd047842d07fe1002093a4";

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
    await getCredentials();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("build/contracts/HealthCare.json");
    var abiJson = jsonDecode(abiStringFile);
    abiCode = jsonEncode(abiJson["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(abiJson["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(abiCode!, "HealthCare"), _contractAddress!);
    _newRecord = _contract!.function("newRecord");
    _signRecord = _contract!.function("signRecord");

    _recordCreated = _contract!.event("RecordCreated");
    _recordSigned = _contract!.event("RecordSigned");
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
      isLoading = false;
    });
  }
}
