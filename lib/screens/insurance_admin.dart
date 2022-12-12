import 'package:btp_project/widgets/common_widgets.dart';
import 'package:btp_project/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/colors.dart';
import '../generated/assets.dart';

class InsuranceAdmin extends StatefulWidget {
  const InsuranceAdmin({Key? key}) : super(key: key);

  @override
  State<InsuranceAdmin> createState() => _InsuranceAdminState();
}

class _InsuranceAdminState extends State<InsuranceAdmin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: buildGradientDecoration(),
          padding: const EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 2.0,
          ),
          child: ListView(
            children: [
              buildTopAppBar(context, title: 'Approved Insurance Claims'),
              const SizedBox(
                width: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 200.0,
                        ),
                        const Text(
                          "All Records are approved\nby Hospital & Lab",
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: darkPurpleTextColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: SvgPicture.asset(
                            Assets.imagesUndrawDiaryRe4jpc,
                            height: 300.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Flexible(
                    child: buildRecords(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildRecords() {
    return Column(
      children: [
        const SizedBox(
          height: 50.0,
        ),
        const Text(
          'Approved Records',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: darkPurpleTextColor,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
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
              buildStreamBuilder(isInsuranceAdmin: true),
            ],
          ),
        ),
      ],
    );
  }
}
