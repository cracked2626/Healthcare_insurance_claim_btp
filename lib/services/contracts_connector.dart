import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractsConnector {
  final String rpcUrl = "https://rpc.ankr.com/eth_goerli";
  final String wsUrl = "ws://rpc.ankr.com/eth_goerli";
  final String privateKey =
      "ea35874cfc167c65eff768dd8a4146e03b009aa5dfb65acfefda8b0c51258b35";

  Web3Client? _client;
  bool isLoading = false;

  String? abiCode;
  EthereumAddress? _contractAddress;
  // String _contractAddress;

  Credentials? _credentials;

  DeployedContract? _contract;

  ContractFunction? _newRecord;
  ContractFunction? _signRecord;
  ContractFunction? _allRecords;
  ContractFunction? _getRecordLength;

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
    String abiStringFile = await rootBundle.loadString("abis/HealthCare.json");
    var abiJson = jsonDecode(abiStringFile);
    abiCode = jsonEncode(abiJson["abi"]);

    _contractAddress =
        EthereumAddress.fromHex("0x60DAaa0A59914C0e7E38e8848bf72df337f97ab0");
  }

  getCredentials() {
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<void> getDeployedContract() async {
    final s = ContractAbi.fromJson(abiCode!, "HealthCare");
    _contract = DeployedContract(s, _contractAddress!);
    _newRecord = _contract!.function("newRecord");
    _signRecord = _contract!.function("signRecord");
    _allRecords = _contract!.function("getAllRecords");
    _getRecordLength = _contract!.function("getAllRecordsLength");

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
                gasPrice: EtherAmount.fromUnitAndValue(
                    EtherUnit.gwei, BigInt.from(1000))),
            chainId: 5)
        .then((value) {
      print("contract signed ${value}");
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
                ],
                gasPrice: EtherAmount.fromUnitAndValue(
                    EtherUnit.gwei, BigInt.from(1000))),
            chainId: 5)
        .then((value) {
      print("new record added in contract ${value}");
      isLoading = false;
    });
  }

  Future<List<dynamic>> getAllRecords() async {
    isLoading = true;
    List<dynamic> records = [];
    await _client!.call(
        contract: _contract!, function: _allRecords!, params: []).then((value) {
      print("all records ${value}");
      records = value;
      isLoading = false;
    });
    return records;
  }

  getAllRecordsLength() async {
    isLoading = true;
    await _client!.call(
        contract: _contract!,
        function: _getRecordLength!,
        params: []).then((value) {
      print("all records length ${value}");
      isLoading = false;
    });
  }
}
