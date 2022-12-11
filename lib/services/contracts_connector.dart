import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractsConnector {
  final String rpcUrl = "https://rpc.ankr.com/eth_goerli";
  final String wsUrl = "ws://rpc.ankr.com/eth_goerli";
  final String privateKey =
      "234eef1f8cad42fc8aa5db00d0be474ba7f652a8793451e30b0df3d3ceb703ef";

  Web3Client? _client;
  bool isLoading = false;

  String? abiCode;
  EthereumAddress? _contractAddress;
  // String _contractAddress;

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
    print(abiStringFile);
    print(abiJson);
    abiCode = jsonEncode(abiJson["abi"]);

    _contractAddress =
        EthereumAddress.fromHex("0x38c89bD5ab7c9Aad4b30624Dd13f51CDaBA97ED2");
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
            chainId: 5)
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
            chainId: 5)
        .then((value) {
      print("new record added in contract ${value}");
      isLoading = false;
    });
  }
}
