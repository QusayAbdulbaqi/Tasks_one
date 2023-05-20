

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices{


  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<String> getDeviceToken()async{
    String? token = await messaging.getToken();
        return token!;
  }
}