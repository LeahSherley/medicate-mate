/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/landing.dart';
import 'package:meditation_app/notifications.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<RemoteMessage> _messages = [];

  @override
  initState() {
    super.initState();
    _addMessage();
  }

  void _addMessage() {
    
     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      setState(() {
        _messages = [..._messages, message];
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Notifications",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const LandingScreen()));
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: _messages.isEmpty
          ? const Center(
              child: Text(
                "No notifications received!",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple,
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                RemoteMessage message = _messages[index];
                return Container(
                  margin:
                      const EdgeInsets.all(20), 
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100], 
                    borderRadius: BorderRadius.circular(10), 
                    border: Border.all(color: Colors.deepPurple), 
                  ),
                  child: ListTile(
                    isThreeLine: true,
                    title: Text(message.notification?.title ?? "", style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),),
                    subtitle: Text(message.sentTime?.toString() ??
                        DateTime.now().toString(), style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ), ),
                    trailing: Icon(
                      Icons.notifications_active,
                      color: Colors.red[200],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, Notify.route,
                          arguments: _messages[index]);
                    },
                  ),
                );
              }),
    );
  }
}*/
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/MyProviders/notification.dart';
import 'package:meditation_app/landing.dart';
import 'package:meditation_app/notifications.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<RemoteMessage> _messages = [
    const RemoteMessage(
    data: <String, String>{
      'key1': 'value1',
      'key2': 'value2',
     
    },
    notification: RemoteNotification(
      title: 'You Got This!',
      body: 'Just a quick reminder that you\'ve got this! Your commitment to health is admirable. Keep going, and know that you\'re making a positive impact.',
    ),
  ),
  ];

  @override
  initState() {
    super.initState();
    _addMessage();
  }

  void _addMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      /*print("Received notification: $message");
      setState(() {
        _messages = [..._messages, message];*/
        Provider.of<NotificationListModel>(context, listen: false)
          .addMessage(message);
      });
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text(
                "My Notifications",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const LandingScreen()));
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.deepPurple,
                ),
              ),
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              //snap: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/medical.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: _messages.isEmpty
            ? const Center(
                child: Text(
                  "No notifications",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  RemoteMessage message = _messages[index];
                  return Container(
                    margin: const EdgeInsets.only(left: 20, right:20, bottom:20,),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepPurple, 
                      style: BorderStyle.none,
                      ),

                      
                    ),

                    child: ListTile(
                      leading: Image.asset("assets/images/medicine-removebg-preview.png",),
                      isThreeLine: true,
                      title: Text(
                        message.notification?.title ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      subtitle:
                       Text(
                        message.notification?.body ?? "",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      
                      /*Text(
                        message.sentTime?.toString() ??
                            DateTime.now().toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),*/
                      trailing: Icon(
                        Icons.notifications_active,
                        color: Colors.red[200],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, Notify.route,
                            arguments: _messages[index]);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

