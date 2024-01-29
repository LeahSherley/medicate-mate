import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/notificationlist.dart';



class Notify extends StatelessWidget {
  const Notify({Key? key}): super(key: key);

  static const route = '/Notify';

  @override
  Widget build(BuildContext context) {
   
    final arguments = ModalRoute.of(context)!.settings.arguments;
    RemoteMessage? message;
    

    if (arguments != null && arguments is RemoteMessage) {
      message = arguments;
    }
   
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(
          fontSize: 15,
          color: Colors.deepPurple,
          
        ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const NotificationList()));
                
            
          },
        ),
      ),
    body: Container(
      padding: const EdgeInsets.all(12),
      margin:
          const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          //color: Colors.grey[300],
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple[100]!,
              Colors.deepPurple[50]!,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              child: Image.asset(
                "assets/images/medicine-removebg-preview.png",
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 5),
            Text(message?.notification?.title ??
                "No Unread Messages", style: TextStyle(
                  fontSize: 13,
                  color: Colors.deepPurple[200],
                  
                ),),
            Text(message?.notification?.body ?? "", style: TextStyle(
                  fontSize: 13,
                  color: Colors.deepPurple[200],
                  
                ),textAlign: TextAlign.center,),
            // notificationtext(message?.data ??""),
            const SizedBox(height: 15),
            RichText(
              text: const TextSpan(
                text: '© ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: 'MedicateMate',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        //mytext(payload ?? ""),
      ),
    ),
    );
  }
  }