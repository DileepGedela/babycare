import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Splash Screen.dart'; 
import 'home_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

 
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'vac_imp_channel',
        channelKey: 'vac_channel',
        channelName: 'Vaccination Notifications',
        channelDescription: 'Notification channel for vaccination reminders',
        defaultColor: Color(0xFF9050B5),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey:'vac_imp_channel',
          channelGroupName: 'Group1')
    ],
    debug: true
  );
// Request notification permissions
  await _requestPermissions();

  runApp(MyApp());
}
Future<void> _requestPermissions() async {
  // Check if notifications are allowed
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Care App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false, // Optional: Remove debug banner
    );
  }
}
