import 'package:btp_project/providers/metaMask_provider.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

BoxDecoration buildGradientDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xffd6d8fe),
        Color(0xfffce0f9),
      ],
    ),
  );
}

ElevatedButton buildElevatedButton(
    {required String title,
    required VoidCallback onPressed,
    bool showLoader = false}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      backgroundColor: const Color(0xffb9589f),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      textStyle: const TextStyle(
        fontFamily: 'Satoshi',
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
      color: const Color(0xff9063a6),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/metamask.png',
                  height: 25,
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
      onPressed: () async{
        final meta = context.read<MetamaskProvider>();
       await meta.connect();
      },
    ),
  );
}

Padding buildTopAppBar(BuildContext context, {required String title}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xff69458b),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff69458b),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(child: buildMetaMaskStatus(context)),
      ],
    ),
  );
}

Container buildPatientRecords() {
  return Container(
    color: const Color(0xfff5e1fa),
    child: Column(
      children: [
        Table(
          border: TableBorder.all(
            color: const Color(0xfff6bfe6),
            width: 4.0,
          ),
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
  );
}
