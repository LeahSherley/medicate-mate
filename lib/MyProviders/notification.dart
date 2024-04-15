import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationListModel extends ChangeNotifier {
  List<RemoteMessage> _messages = [];

  List<RemoteMessage> get messages => _messages;

  void addMessage(RemoteMessage message) {
    _messages = [..._messages, message];
    notifyListeners();
  }
}
