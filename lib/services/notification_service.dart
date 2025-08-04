import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showWelcomeNotificationIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasWelcomed = prefs.getBool('hasWelcomed') ?? false;

    if (!hasWelcomed) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'welcome_channel',
            'Welcome Notifications',
            importance: Importance.high,
            priority: Priority.high,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _plugin.show(
        0,
        '🎉 Welcome to Ecommerce flutter app!',
        'Start exploring amazing deals tailored for you.',
        notificationDetails,
      );

      await prefs.setBool('hasWelcomed', true);
    }
  }
}
