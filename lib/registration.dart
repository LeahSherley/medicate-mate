import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/login.dart';
import 'package:firebase_database/firebase_database.dart';

class MyRegistration extends StatefulWidget {
  const MyRegistration({super.key});

  @override
  State<MyRegistration> createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<MyRegistration> {
  var password = '';
  var email = '';

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();

    void registration() async {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            color: Colors.deepPurple[300],
          ),
        ),
      );
      final valid = form.currentState!.validate();

      if (valid) {
        form.currentState!.save();

        try {
          /*await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);*/
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          // Get the UID of the newly registered user
          String uid = userCredential.user?.uid ?? '';

          // Create a node in the Realtime Database using the UID
          await FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(uid)
              .set({
            'email': email,
            
          });

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.deepPurple.shade100,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  "Registration Successful!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500),
                )),
          );
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const MyLogin(),
            ),
          );
        } catch (e) {
          if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.deepPurple.shade100,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    "The account already exists for that email.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500),
                  )),
            );
            Navigator.pop(context);
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.deepPurple.shade100,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    "Error during registration",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500),
                  )),
            );
          }
        }
      } else {
        return;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/medication-removebg-preview.png",
              //height: 100
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20),
              //padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: const Text(
                "Welcome to MedicateMate!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade100,
                    Colors.deepPurple.shade50,
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
              child: Form(
                key: form,
                child: Column(
                  children: [
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email Address:',
                          labelStyle: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        autocorrect: false,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return "Enter a valid Email Address";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!;
                        }),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password:',
                          labelStyle: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return "Password should be 6 characters long";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value!;
                        }),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      width: double.infinity,
                      child: OutlinedButton.icon(
                          onPressed: registration,
                          icon: const Icon(
                            Icons.east_rounded,
                            size: 15,
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                          label: const Text(
                            "SignUp",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          )),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
