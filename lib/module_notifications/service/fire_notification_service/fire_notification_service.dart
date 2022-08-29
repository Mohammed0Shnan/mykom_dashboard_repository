import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_kom_dist_dashboard/module_notifications/preferences/notification_preferences/notification_preferences.dart';
import 'package:my_kom_dist_dashboard/utils/logger/logger.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

class FireNotificationService {
  final NotificationsPrefsHelper _prefsHelper =NotificationsPrefsHelper() ;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=
      FlutterLocalNotificationsPlugin();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  static final PublishSubject<String> _onNotificationRecieved =
  PublishSubject();

  static Stream get onNotificationStream => _onNotificationRecieved.stream;

  static late StreamSubscription iosSubscription;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

   Future<void> init(BuildContext context) async {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher')
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route)async{
      Navigator.pushNamed(context, route!);
    });
    FirebaseMessaging.instance.subscribeToTopic('advertisements');

    // if (Platform.isIOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {});
    //
    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }



    var isActive = await _prefsHelper.getIsActive();
    await refreshNotificationToken();

    await setCaptainActive(isActive == true);
  }
   void display(RemoteMessage message) async{
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              'easyapproach',
              'easyapproach channel',
              'this is the channel',
              importance:Importance.max,
              priority: Priority.high
          )
      );
      await  _flutterLocalNotificationsPlugin.show(id, message.notification!.title, message.notification!.title, notificationDetails,
      payload: message.data['route']
      );

    }catch(e) {
      print(e);
    }



  }

  Future<void> refreshNotificationToken() async {
    var token = await _fcm.getToken();

      // this._fcm.configure(
      //   onMessage: (Map<String, dynamic> message) async {
      //     Logger().info('FireNotificationService', 'onMessage: $message');
      //     _onNotificationRecieved.add(message.toString());
      //   },
      //   onLaunch: (Map<String, dynamic> message) async {
      //     Logger().info('FireNotificationService', 'onMessage: $message');
      //   },
      //   onResume: (Map<String, dynamic> message) async {
      //     Logger().info('FireNotificationService', 'onMessage: $message');
      //   },
      // );
    }
  Future<void> sendNotif()async{
   await  _firestore.collection('advertisements/').add({'title':'title from function cloud',
   'body':'body from function cloud',
     'imageUrl':''
   });
  }

  }

  Future<void> setCaptainActive(bool active) async {
    // await _prefsHelper.setIsActive(active);
    // if (active) {
    //   await _fcm.subscribeToTopic('captains');
    // } else {
    //   await _fcm.unsubscribeFromTopic('captains');
    // }
  }


Future sendNotification(String body, String title, bool isAdm) async {


  // final String url = 'https://fcm.googleapis.com/fcm/send';
  // var notification;
  // notification =
  // '{"notification": {"body": "${body}", "title": "${title}", "content_available": "true", "click_action": "FLUTTER_NOTIFICATION_CLICK"}, "priority": "high", "to": "MYTOPIC"}';
  // final response = await http.post(
  //     Uri.parse(url),
  //     headers: <String, String>{
  //       "Content-Type": "application/json",
  //       "Keep-Alive": "timeout=5",
  //       "Authorization": "key=MYKEY"
  //     },
  //     body: notification
  // );
  // print(response.body);
}
