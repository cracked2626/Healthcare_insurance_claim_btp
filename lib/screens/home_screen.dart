import 'package:btp_project/widgets/waves.dart';
import 'package:flutter/material.dart';

class LayoutRederer extends StatelessWidget {
  final Widget? child;
  const LayoutRederer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: child != null ? child! : const SizedBox(),
        ),
        // buildCard(),
      ],
    );
  }
}
