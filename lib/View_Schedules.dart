import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';

class ViewSchedulesPage extends StatefulWidget {
  @override
  _ViewSchedulesPageState createState() => _ViewSchedulesPageState();
}

class _ViewSchedulesPageState extends State<ViewSchedulesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('vaccinationSchedules');
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //List<Map<dynamic, dynamic>> scheduledVaccinations = [];
  List<Map<String, dynamic>> scheduledVaccinations = [];

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchSchedules() async {
    String? userId = _auth.currentUser?.uid;

    if (userId != null) {
      try {
        DatabaseEvent event = await _dbRef.child(userId).once();
        DataSnapshot snapshot = event.snapshot;
        //print('Firebase snapshot: ${snapshot.value}');

        if (snapshot.exists && snapshot.value != null) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> tempVaccinations = [];

          data.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              try {
                String scheduledDate = value['scheduledDate'];
                int doseNo = value['doseNo'];
                List<String> vaccines = List<String>.from(value['vaccines']);

                tempVaccinations.add({
                  'date': scheduledDate,
                  'doseNo': doseNo,
                  'vaccines': vaccines,
                });
              } catch (e) {
                print('Error parsing entry with key $key: $e');
              }
            } else {
              print('Skipping invalid entry with key $key');
            }
          });

          if (mounted) {
            setState(() {
              scheduledVaccinations = tempVaccinations;
            });
          }

          scheduleDailyNotifications();
        } else {
          print('No data found in Firebase for this user.');
          if (mounted) {
            setState(() {
              scheduledVaccinations = [];
            });
          }
        }
      } catch (e) {
        print('Error fetching schedules: $e');
        if (mounted) {
          setState(() {
            scheduledVaccinations = [];
          });
        }
      }
    } else {
      print('User ID is null, unable to fetch schedules');
    }
  }

//  void scheduleDailyNotifications() {
//     DateTime now = DateTime.now();
//     DateTime startDate = now.subtract(Duration(days: 10));

//     print('Scheduling notifications for past 10 days');

//     for (var vaccination in scheduledVaccinations) {
//       DateTime scheduledDate = DateTime.parse(vaccination['date']);
//       List<String> vaccines =
//             List<String>.from(vaccination['vaccines'] ?? []);
//       print('Processing vaccination on date: $scheduledDate');

//       if (scheduledDate.isAfter(startDate) && scheduledDate.isBefore(now)) {
//         print('Scheduling notification for date: $scheduledDate');

//         AwesomeNotifications().createNotification(
//           content: NotificationContent(
//             id: scheduledDate.millisecondsSinceEpoch.hashCode,
//             channelKey: 'vac_channel',
//             title: 'Vaccination Reminder',
//             body: 'You have a scheduled vaccination for Dose ${vaccination['doseNo']} on ${DateFormat('yyyy-MM-dd').format(scheduledDate)} with vaccines: ${vaccines.join(', ')}',
//             notificationLayout: NotificationLayout.Default,
//           ),
//           schedule: NotificationCalendar.fromDate(date: scheduledDate),
//         );
//         // AwesomeNotifications().createNotification(
//         //   content: NotificationContent(
//         //     id: scheduledDate.millisecondsSinceEpoch.hashCode,
//         //     channelKey: 'vac_channel',
//         //     title: 'Vaccination Reminder',
//         //     body: 'You have a scheduled vaccination for Dose ${vaccination['doseNo']} on ${DateFormat('yyyy-MM-dd').format(scheduledDate)} with vaccines: ${vaccines.join(', ')}',
//         //     notificationLayout: NotificationLayout.Default,
//         //   ),
//         //   schedule: NotificationCalendar.fromDate(date: Datetime.now),
//         // );
//       } else {
//         print('Vaccination date $scheduledDate is outside the notification window');
//       }
//     }
//   }

  void scheduleDailyNotifications() {
    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(Duration(days: 10));

    print('Scheduling notifications for past 10 days');

    for (var vaccination in scheduledVaccinations) {
      DateTime scheduledDate = DateTime.parse(vaccination['date']);
      List<String> vaccines = List<String>.from(vaccination['vaccines'] ?? []);
      print('Processing vaccination on date: $scheduledDate');

      if (scheduledDate.isAfter(startDate) && scheduledDate.isBefore(now)) {
        print('Scheduling notification for date: $scheduledDate');

        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: scheduledDate.millisecondsSinceEpoch.hashCode,
            channelKey: 'vac_channel',
            title: 'Vaccination Reminder',
            body:
                'You have a scheduled vaccination for Dose ${vaccination['doseNo']} on ${DateFormat('yyyy-MM-dd').format(scheduledDate)} with vaccines: ${vaccines.join(', ')}',
            notificationLayout: NotificationLayout.Default,
          ),
          schedule: NotificationCalendar.fromDate(date: scheduledDate),
        );
        // AwesomeNotifications().createNotification(
        //   content: NotificationContent(
        //     id: scheduledDate.millisecondsSinceEpoch.hashCode,
        //     channelKey: 'vac_channel',
        //     title: 'Vaccination Reminder',
        //     body: 'You have a scheduled vaccination for Dose ${vaccination['doseNo']} on ${DateFormat('yyyy-MM-dd').format(scheduledDate)} with vaccines: ${vaccines.join(', ')}',
        //     notificationLayout: NotificationLayout.Default,
        //   ),
        //   schedule: NotificationCalendar.fromDate(date: Datetime.now),
        // );
      } else {
        print(
            'Vaccination date $scheduledDate is outside the notification window');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Vaccinations'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: scheduledVaccinations.isEmpty
            ? Center(
                child: Text('No scheduled vaccinations found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              )
            : ListView.builder(
                itemCount: scheduledVaccinations.length,
                itemBuilder: (context, index) {
                  var vaccination = scheduledVaccinations[index];
                  List<String> vaccines =
                      List<String>.from(vaccination['vaccines'] ?? []);

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        'Dose: ${vaccination['doseNo']}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(vaccination['date']))}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Vaccines: ${vaccines.join(", ")}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                      leading: Icon(
                        Icons.health_and_safety,
                        color: Colors.deepPurple,
                        size: 40,
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        // Optional: Add action on tap
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
