import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/MyModels/addpill.dart';
import 'package:meditation_app/MyWidgets/widgets.dart';
import 'package:meditation_app/drawer.dart';
import 'package:meditation_app/pilldesign.dart';
import 'package:meditation_app/pilldialogue.dart';
import 'package:http/http.dart' as http;

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key, this.pillName, this.dosage});
  final String? pillName;
  final String? dosage;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final scaffoldkey = GlobalKey<ScaffoldState>();

  List<Pill> pills = [];
  Pill? removedPill;
  @override
  void initState() {
    _getMedication();
    super.initState();
  }

  /*void _getMedication() async {
    try {
      final url = Uri.https("medicationapp-c4830-default-rtdb.firebaseio.com",
          "medication-list.json");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> list = json.decode(response.body);

        setState(() {
          pills = list.entries
              .map((entry) =>
                  Pill(entry.value['pillName'], entry.value['dosage']))
              .toList();
        });
      } else {
        print(
            "Failed to fetch medication. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching medication: $error");
    }
  }*/
  /*void _getMedication() async {
    try {
      String userUid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final url = Uri.https("medicationapp-c4830-default-rtdb.firebaseio.com",
          "userMedications/$userUid.json");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> list = json.decode(response.body);

        setState(() {
          pills = list.entries
              .map(
                (entry) => Pill(
                  entry.value['pillName']?? "",
                  entry.value['dosage']?? "",
                ),
              )
              .toList();
        });
      } else {
        print(
            "Failed to fetch medication. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching medication: $error");
    }
  }*/
  /*void _getMedication() async {
  try {
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final url = Uri.https(
      "medicationapp-c4830-default-rtdb.firebaseio.com",
      "userMedications/$userUid/medication_list.json",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic>? medicationData = json.decode(response.body);

      if (medicationData != null) {
        final List<Pill> fetchedPills = [];

        medicationData.forEach((key, value) {
          final String pillName = value['pillName'] ?? '';
          final String dosage = value['dosage'] ?? '';

          fetchedPills.add(Pill(pillName, dosage));
        });

        setState(() {
          pills = fetchedPills;
        });
      }
    } else {
      print("Failed to fetch medication. Status code: ${response.statusCode}");
    }
  } catch (error) {
    print("Error fetching medication: $error");
  }
}*/
void _getMedication() async {
  try {
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final url = Uri.https(
      "medicationapp-c4830-default-rtdb.firebaseio.com",
      "userMedications/$userUid/medication-list.json",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic>? userMedications = json.decode(response.body);

      if (userMedications != null) {
        final List<Pill> fetchedPills = [];

        userMedications.forEach((medicationId, medicationData) {
          final String pillName = medicationData['pillName'];
          final String dosage = medicationData['dosage'];

          fetchedPills.add(Pill(pillName, dosage));
        });

        setState(() {
          pills = fetchedPills;
        });
      }
    } else {
      print("Failed to fetch medication. Status code: ${response.statusCode}");
    }
  } catch (error) {
    print("Error fetching medication: $error");
  }
}



  
  Future<void> _removeMedication(String pillName) async {
    try {
      String userUid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final url = Uri.https(
        "medicationapp-c4830-default-rtdb.firebaseio.com",
        "userMedications/$userUid/medication-list/$pillName.json",
      );

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print("Medication removed successfully");
      } else {
        print(
            "Failed to remove medication. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error removing medication: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: MainDrawer(),
      ),
      key: scaffoldkey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.account_circle_rounded,
                  size: 30,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  if (scaffoldkey.currentState!.isDrawerOpen) {
                    scaffoldkey.currentState!.closeDrawer();
                  } else {
                    scaffoldkey.currentState!.openDrawer();
                  }
                },
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    size: 30,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
              expandedHeight: 350.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/medicine2-removebg-preview.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
              ),
              child: const Text(
                "Hello, Friend!👋",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            pills.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
                    child: const Text(
                      "Your medicine schedule is clear today!",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
                    child: const Text(
                      "Your medicine schedule for today:",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
            pills.isEmpty
                ? const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        "No pills for today",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: pills.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(pills[index].pillName),
                        onDismissed: (direction) {
                          setState(() {
                            //pills.removeAt(index);
                            removedPill = pills.removeAt(index);
                            _removeMedication(removedPill!.pillName);
                            
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: mytext("Deleted"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.deepPurple[100],
                            action: SnackBarAction(
                              textColor: Colors.deepPurple,
                              label: "Undo",
                              onPressed: () {
                                setState(() {
                                  pills.insert(index, removedPill!);
                                });
                              },
                            ),
                          ));
                        },
                        child: PillDesign(
                          pillName: pills[index].pillName,
                          dosage: pills[index].dosage,
                        ),
                      );
                    },
                  ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 25,
          color: Colors.grey[700],
        ),
        onPressed: () async {
          final result = await showModalBottomSheet(
            backgroundColor: Colors.deepPurple[300],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            context: context,
            builder: (BuildContext context) {
              return const PillScreen();
            },
          );
          if (result != null && result is Pill) {
            setState(() {
              pills.add(result);
            });
          }
        },
      ),
    );
  }
}
