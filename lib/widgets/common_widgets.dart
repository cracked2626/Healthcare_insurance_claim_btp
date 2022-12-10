
import 'package:btp_project/providers/metaMask_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ElevatedButton buildElevatedButton(
    {required String title,
    required VoidCallback onPressed,
    bool showLoader = false}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff08443C),
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    child: showLoader
        ? const CircularProgressIndicator()
        : Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
  );
}

showSnackBar(context, msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

Padding buildMetaMaskStatus(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: MaterialButton(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Consumer<MetamaskProvider>(
        builder: (context, meta, child) {
          String text = '';
          if (meta.isConnected && meta.isInOperatingChain) {
            text = 'Metamask connected';
          } else if (meta.isConnected && !meta.isInOperatingChain) {
            text = 'Wrong operating chain';
          } else if (meta.isEnabled) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Connect Metamask',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            text = 'Unsupported Browser For Metamask';
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/metamask.png',
                  height: 60,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onPressed: () {
        final meta = context.read<MetamaskProvider>();
        meta.connect();
      },
    ),
  );
}
