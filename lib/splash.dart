import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:meditation_app/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration =  const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        color: Colors.deepPurple,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 12.5,
        color: Colors.grey,
        fontWeight: FontWeight.w700,
      ),
      imagePadding: EdgeInsets.all(30),
      bodyPadding:  EdgeInsets.all(10),
    );

    DotsDecorator dotsDecorator = DotsDecorator(
      size: const Size.square(0.0),
      activeSize: const Size(0.0, 0.0),
      spacing: const EdgeInsets.symmetric(horizontal: 3.0),
      color: Colors.white,
      activeShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );

    return SafeArea(
      child: IntroductionScreen(
        showDoneButton: true,
        done:  Text("Start!", style: TextStyle(
          fontSize: 11,
          color: Colors.grey[700],
        ),),
        onDone: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const MyLogin()
          ));

          
        } ,
        showNextButton: false,
       
        pages: [
          PageViewModel(
            title: "Stay Healthy",
            body:
                "MedicateMate ensures you never forget to take your medicine, providing peace of mind.",
            image: Image.asset("assets/images/medical.webp", width: 700),
            decoration: pageDecoration,
          ),
        ],
        baseBtnStyle: TextButton.styleFrom(
            backgroundColor: Colors.deepPurple[100],
          ),
          dotsDecorator: dotsDecorator,
      ),
    );
  }
}
