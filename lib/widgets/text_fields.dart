import 'package:btp_project/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

TextField buildTextField(
    {required TextEditingController controller, required String hint}) {
  return TextField(
    controller: controller,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
      color: Color(0xff8c61a6),
    ),
    cursorColor: const Color(0xff8c61a6),
    obscureText: hint.contains("Password") ? true : false,
    decoration: InputDecoration(
      labelText: hint,
      labelStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
      ),

      // isDense: true,
      // contentPadding: EdgeInsets.only(top: 4),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffe8cbec),
          width: 4,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffe8cbec),
          width: 4,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffe8cbec),
          width: 4,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    ),
  );
}

Center buildText(text, {bool isHeading = false}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17.0,
          color: darkPurpleTextColor,
          fontWeight: isHeading ? FontWeight.w900 : FontWeight.normal,
        ),
      ),
    ),
  );
}

StreamBuilder<QuerySnapshot<Map<String, dynamic>>> buildStreamBuilder(
    {bool? isInsuranceAdmin}) {
  return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('InsuranceClaims').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> ds = snapshot.data!.docs[index].data();
              String name = ds['name'];
              String id = ds['patientId'];
              String hospitalName = ds['hospitalName'];
              String price = ds['price'];
              String date = ds['timeStamp'].toDate().toString();
              // format date like 8 march 2021
              String signCount =
                  ds['signCount'] == null ? '0' : ds['signCount'].toString();

              return isInsuranceAdmin == true
                  ? signCount == '2'
                      ? Table(
                          border: TableBorder.all(
                            color: const Color(0xfff6bfe6),
                            width: 2.0,
                          ),
                          children: [
                            TableRow(
                              children: [
                                buildText(id),
                                buildText(name),
                                buildText(date),
                                buildText(hospitalName),
                                buildText('Rs. $price'),
                                buildText(signCount),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox()
                  : Table(
                      border: TableBorder.all(
                        color: const Color(0xfff6bfe6),
                        width: 2.0,
                      ),
                      children: [
                        TableRow(
                          children: [
                            buildText(id),
                            buildText(name),
                            buildText(date),
                            buildText(hospitalName),
                            buildText('Rs. $price'),
                            buildText(signCount),
                          ],
                        ),
                      ],
                    );
            },
          );
        } else {
          return const Text('Loading...');
        }
        return Text('data :${snapshot.data?.docs.first.data()['patientId']}');
      });
}
