import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/MyModels/addpill.dart';
import 'package:meditation_app/MyWidgets/widgets.dart';
import 'package:http/http.dart' as http;

class PillScreen extends StatefulWidget {
  const PillScreen({super.key});

  @override
  State<PillScreen> createState() => _PillScreenState();
}

TextEditingController pillNameController = TextEditingController();
TextEditingController dosageController = TextEditingController();

class _PillScreenState extends State<PillScreen> {
  @override
  /*void dispose() {
    pillNameController.dispose();
    dosageController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Add Pill',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            /*Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const LandingScreen()));*/
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mytext(
              'Pill Name:',
            ),
            TextField(
              controller: pillNameController,
              decoration: InputDecoration(
                hintText: 'Enter pill name',
                hintStyle: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 16),
            mytext(
              'Dosage:',
            ),
            TextField(
              controller: dosageController,
              decoration: InputDecoration(
                hintText: 'Enter dosage e.g 1pill/day',
                hintStyle: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 60),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              height: 40,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  String pillName = pillNameController.text;
                  String dosage = dosageController.text;
                   String userUid = FirebaseAuth.instance.currentUser?.uid ?? "";
                  Navigator.pop(context, Pill(pillName, dosage));
                   if (userUid.isNotEmpty) {
                  final url = Uri.https(
                      "medicationapp-c4830-default-rtdb.firebaseio.com",
                      "userMedications/$userUid/medication-list.json");
                  http.post(url,
                      headers: {
                        "Content-Type": "application/json",
                      },
                      body: json.encode(
                        {
                          "pillName": pillName,
                          "dosage": dosage,
                        },
                      ));
                  pillNameController.clear();
                  dosageController.clear();
                   }
                },
                icon: const Icon(
                  Icons.medication,
                  color: Colors.grey,
                  size: 20,
                ),
                label: mytext("Add Pill"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
