import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pr_8_chatting_app/helper/local_notification_services.dart';

class FirebaseNotificationServices {
  static FirebaseNotificationServices firebaseNotificationServices =
      FirebaseNotificationServices._();

  FirebaseNotificationServices._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    NotificationSettings notificationSettings =
        await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      log('Notification Permission Allowed !! ------------------------------------------------------------------ ');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      log('Notification Permission Denied -------------------------------------------------------');
    }
  }

  Future<String?> generateDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    log('\n\nDevice Token:\n\n $token\n');
    return token;
  }

  void onMsgListener() {
    FirebaseMessaging.onMessage.listen(
      (event) {
        NotificationServices.notificationServices.showNotification(
            event.notification!.title!, event.notification!.body!);
      },
    );
  }
}
