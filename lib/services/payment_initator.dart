import 'package:flutter_web3/flutter_web3.dart';

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