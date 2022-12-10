
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextField buildTextField(
    {required TextEditingController controller, required String hint}) {
  return TextField(
    controller: controller,
    style: const TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 16.0,
      color: Color(0xff08443C),
    ),
    cursorColor: Colors.black,
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
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
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
          fontWeight: isHeading ? FontWeight.w900 : FontWeight.normal,
        ),
      ),
    ),
  );
}

StreamBuilder<QuerySnapshot<Map<String, dynamic>>> buildStreamBuilder() {
  return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('InsuranceClaims').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> ds = snapshot.data!.docs[index].data();
                String name = ds['name'];
                String id = ds['patientId'];
                String hospitalName = ds['hospitalName'];
                String price = ds['price'];
                String date = ds['timeStamp'].toDate().toString();
                // format timeStamp to date
                String signCount =
                    ds['signCount'] == null ? '0' : ds['signCount'].toString();

                return Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(
                      children: [
                        buildText(id),
                        buildText(name),
                        buildText(date),
                        buildText(hospitalName),
                        buildText(price),
                        buildText(signCount),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return const Text('Loading...');
        }
        return Text('data :${snapshot.data?.docs.first.data()['patientId']}');
      });
}
