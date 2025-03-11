import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'notification_controller.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  print("Before initialized");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'vac_channel',
        channelName: 'Vaccination Notifications',
        channelDescription: 'Notification channel for vaccination reminders',
        defaultColor: Color(0xFF9050B5),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
    ],
  );
  print("Notification channel initialized");

  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    print("Are notifications allowed? $isAllowed");
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
      print("Notification permission requested.");
    }
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in the foreground: ${message.notification?.title}');
      if (message.notification != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: DateTime.now().millisecondsSinceEpoch.hashCode,
            channelKey: 'vac_channel',
            title: message.notification?.title,
            body: message.notification?.body,
            notificationLayout: NotificationLayout.Default,
          ),
        );
      }
    });



        // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //       print('Received a message in the foreground: ${message.notification?.title}');
        //       if (message.notification != null) {
        //         AwesomeNotifications().createNotification(
        //           content: NotificationContent(
        //             id: DateTime.now().millisecondsSinceEpoch.hashCode,
        //             channelKey: 'vac_channel',
        //             title: message.notification?.title,
        //             body: message.notification?.body,
        //             notificationLayout: NotificationLayout.Default,
        //           ),
        //         );
        //       }
        //     });



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked! Data: ${message.data}');
    });

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
    print("Notification listeners set.");
  }

  @override
  Widget build(BuildContext context) {
    print("Building MyApp widget.");
    return MaterialApp(
      title: 'Vaccination Scheduler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ScheduleVaccinationPage(),
    );
  }
}

class ScheduleVaccinationPage extends StatefulWidget {
  @override
  _ScheduleVaccinationPageState createState() => _ScheduleVaccinationPageState();
}

class _ScheduleVaccinationPageState extends State<ScheduleVaccinationPage> {
  final TextEditingController dateController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference vaccinationschedulesdata = FirebaseDatabase.instance.ref().child('vaccinationSchedules');
  //final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("users");


  String? selectedDose;
  final List<String> doseOptions = ['1', '2', '3', '4', '5', '6','7','8','9','10','11','12','13'];

  @override
  void initState() {
    super.initState();
  }

  // Map of vaccines for each dose
  final Map<int, List<String>> doseVaccines = {
    1: ['BCG', 'OPV', 'Hepatitis B -1'],
    2: ['DTwP/Dtap-1', 'IPV-1', 'Hib-1', 'Hep B-2', 'Rotavirus-1', 'PCV-1'],
    3: ['DTwP/Dtap-2', 'IPV-2', 'Hib-2', 'Rotavirus-2', 'PCV-2'],
    4: ['DTwP/Dtap-3', 'IPV-3', 'Hib-3', 'Rotavirus-3', 'PCV-3'],
    5: ['Influenza(Iiv)-1'],
    6: ['Influenza(Iiv)-2'],
    7: ['Typhoid Conjugate Vaccine'],
    8: ['MMR-1'],
    9: ['Hepatitis A'],
    10: ['MMR 2 ','Varicella-1','PCV Booster'],
    11: ['DTwP/Dtap-B1,IPV-B1,Hib-B1'],
    12: ['Hep A-2 ','Varicella-2'],
    13: ['DTwP/Dtap-B2,IPV-B2','MMR-3']
  };

  Future<void> scheduleVaccination() async {
    String? userId = _auth.currentUser?.uid;
    print("Scheduling vaccination for user: $userId");

    if (selectedDose == null || dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      print("Fields are not filled correctly.");
      return;
    }

    final doseNo = int.parse(selectedDose!);
    DateTime? scheduledDate;

    try {
      scheduledDate = DateTime.parse(dateController.text);
      print("Parsed scheduled date: $scheduledDate");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid date format. Use YYYY-MM-DD.')));
      print("Error parsing date: $e");
      return;
    }

    if (scheduledDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid date. It cannot be in the past.')));
      print("Scheduled date is in the past.");
      return;
    }

    // Schedule based on selected dose number and reference schedule
    Map<int, int> doseScheduleWeeks = {
      1: 0, // Birthdate 
      2: 6, // 6th week
      3: 10, // 10th week
      4: 14, // 14th week
      5: 26, // 6th month
      6: 30,// 7th month
      7: 34,// 6-9th month
      8: 38,// 9th month
      9: 42,// 12th month
      10:46,// 15th month
      11:50,// 16-18th month
      12: 54,// 18-19th month
      13:58// 4-6th month
    };

    int weeksToAdd = doseScheduleWeeks[doseNo] ?? 0;
    DateTime nextDoseDate = scheduledDate.add(Duration(days: weeksToAdd * 7));

    // Get vaccines for the selected dose
    List<String>? vaccines = doseVaccines[doseNo];

    // Save schedule to Firebase using push to ensure it doesn't overwrite previous doses
    try {
      await vaccinationschedulesdata.child(userId!).push().set({
        'doseNo': doseNo,
        'scheduledDate': nextDoseDate.toIso8601String(),
        'vaccines': vaccines,
      });
      print("Vaccination schedule and vaccines saved to database.");
    } catch (e) {
      print("Error saving schedule to Firebase: $e");
    }

    // Send immediate notification with the first scheduled date and vaccines
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.hashCode,
          channelKey: 'vac_channel',
          title: 'Vaccination Scheduled',
          body: 'Dose $doseNo scheduled for ${DateFormat('yyyy-MM-dd').format(nextDoseDate)} with vaccines: ${vaccines?.join(', ')}',
          notificationLayout: NotificationLayout.Default,
        ),
      );
      //  await AwesomeNotifications().createNotification(
      //   content: NotificationContent(
      //     id: DateTime.now().millisecondsSinceEpoch.hashCode,
      //     channelKey: 'vac_channel',
      //     title: 'Vaccination Scheduled',
      //     body: 'Dose $doseNo scheduled for ${DateFormat('yyyy-MM-dd').format(nextDoseDate)} with vaccines: ${vaccines?.join(', ')}',
      //     notificationLayout: NotificationLayout.Default,
      //   ),
      // );
      print("Immediate notification sent for scheduled date: $nextDoseDate");

      // Schedule future notifications
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: nextDoseDate.millisecondsSinceEpoch.hashCode,
          channelKey: 'vac_channel',
          title: 'Vaccination Reminder',
          body: 'Dose $doseNo scheduled for ${DateFormat('yyyy-MM-dd').format(nextDoseDate)} with vaccines: ${vaccines?.join(', ')}',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(date: nextDoseDate),
      );
      print("Notification scheduled for date: $nextDoseDate");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vaccination scheduled successfully')));
      }
    } catch (e) {
      print("Error sending notifications: $e");
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && mounted) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        print("Started of the vaccine date: ${dateController.text}");
      });
    }
  }

  // Future<void> _selectDates(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && mounted) {
  //     setState(() {
  //       dateController.text = DateFormat('yyyy-MM-dd').format(picked);
  //       print("Started of the vaccine date: ${dateController.text}");
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Schedule Vaccination')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Schedule Your Vaccination', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedDose,
                    items: doseOptions.map((String dose) {
                      return DropdownMenuItem<String>(
                        value: dose,
                        child: Text('Dose $dose'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDose = newValue;
                        print("Selected dose: $selectedDose");
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Dose Number',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    // decoration: InputDecoration(
                    //   labelText: 'Select Dose Number',
                    //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    //   filled: true,
                    //   fillColor: Colors.grey[200],
                    // ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Started of the vaccine date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: scheduleVaccination,
                    child: Text('Schedule Vaccination'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
