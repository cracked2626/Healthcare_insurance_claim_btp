import 'package:flutter/material.dart';
// import 'package:flutter_web3/ethereum.dart';

// class MetamaskProvider extends ChangeNotifier {
//   int currentChain = -1;
//   String currentAddress = '';
//   static const operatingChain = 5;
//   bool get isEnabled => ethereum != null;
//   bool get isInOperatingChain => currentChain == operatingChain;
//   bool get isConnected => isEnabled && currentAddress.isNotEmpty;

//   Future<void> connect() async {
//     if (isEnabled) {
//       final accs = await ethereum!.requestAccount();
//       if (accs.isNotEmpty) currentAddress = accs.first;
//       currentChain = await ethereum!.getChainId();
//       notifyListeners();
//     }
//   }

//   init() {
//     /// in both the cases we clear the data and re-sign in the metamask
//     if (isEnabled) {
//       // whenever the account is changed
//       ethereum!.onAccountsChanged((accounts) {
//         clear();
//       });
//       // whenever the chain is changed
//       ethereum!.onChainChanged((chainId) {
//         clear();
//       });
//       // Subscribe to `message` event, need to convert JS message object to dart object.
//       ethereum!.on('message', (message) {
//         dartify(message); // baz
//       });
//     }
//   }

// // clear method
//   clear() {
//     currentAddress = '';
//     currentChain = -1;
//     notifyListeners();
//   }
// }
