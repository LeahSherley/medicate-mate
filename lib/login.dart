
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/landing.dart';
import 'package:meditation_app/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  var password = '';
  var email = '';
  //bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();

    /*void login() async {
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
      } else {
        return;
      }

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      Navigator.pop(context);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.deepPurple.shade100,
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Login Successful!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500),
            )),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LandingScreen(),
        ),
      );
    }*/
    void login() async {
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
      } else {
        return;
      }

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // If login is successful, set 'isLoggedIn' to true
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);

        Navigator.pop(context);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepPurple.shade100,
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Login Successful!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LandingScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.deepPurple.shade100,
              behavior: SnackBarBehavior.floating,
              content: Text(
                "Invalid password. Please try again",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        } else if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.deepPurple.shade100,
              behavior: SnackBarBehavior.floating,
              content: Text(
                "User not found. Please check your email and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
      } catch (e) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.deepPurple.shade100,
              behavior: SnackBarBehavior.floating,
              content: Text(
                "Invalid Credentials",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        print('Unexpected error during login: $e');
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
                          if (value == null || value.trim().isEmpty) {
                            return "Enter Password";
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
                          onPressed: login,
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
                            "LogIn",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          )),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const MyRegistration(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.deepPurple,
                          ),
                        ))
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
