import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/notifications.dart';


Future <void> messages (RemoteMessage? message) async{
   if (message == null || message.notification == null) {
    //print('Invalid message format.');
    return;
  }
  /*print('Title: ${message!.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');*/
  
}


void incomingMessage(RemoteMessage? message){
  if(message == null) return;
  navigatorKey.currentState?.pushNamed(
    Notify.route,
    arguments: message,
  );
}



Future incomingNotification () async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.getInitialMessage().then(incomingMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(incomingMessage);
  //FirebaseMessaging.onMessage.listen(incomingMessage);
  FirebaseMessaging.onBackgroundMessage(messages);
}



class pushNotifications{
  final firebaseNotification =  FirebaseMessaging.instance;
  Future <void> pushNotification() async {
    await firebaseNotification.requestPermission();
   final token =  await firebaseNotification.getToken();
    print("Token: $token");
    incomingNotification();
  }
}
