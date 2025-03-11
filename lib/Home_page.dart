import 'package:babycare/Profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Schedule_Vaccination.dart';
import 'View_Schedules.dart';
import 'signin_page.dart';
import 'prediction_screen.dart';
import 'diet_recommendation.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      user != null ? user.email![0].toUpperCase() : '?',
                      style: TextStyle(fontSize: 24, color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      user != null ? 'Welcome:' : 'Not logged in',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      user != null ? user.email! : '',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.vaccines),
              title: Text('Schedule Vaccination'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScheduleVaccinationPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('View Schedules'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewSchedulesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Diet Recommendations'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DietRecommendation()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.warning),
              title: Text('Side Effect Prediction'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PredictionScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true, //scrollbar
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome To \n Baby care for children vaccination and nutritional guidance',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     // Handle action for more information
                //   },
                //   child: Text('More Info'),
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: Size(double.infinity, 50),
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                //   ),
                // ),
                SizedBox(height: 20),

                // Vaccination Schedule Table
                Text(
                  'Vaccination Schedule:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Table(
                //   border: TableBorder.all(color: Colors.black, width: 1),
                //   columnWidths: {
                //     0: FlexColumnWidth(2),
                //     1: FlexColumnWidth(3),
                //   },
                //   children: [
                //     // Table Header Row
                //     TableRow(
                //       decoration: BoxDecoration(color: Colors.grey[300]),
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Dose Number',
                //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Vaccines',
                //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ],
                //     ),
                //
                //     // Dose 1
                //     TableRow(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Dose 1\n(Birthdate)',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'BCG, OPV, Hepatitis B -1',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.left,
                //           ),
                //         ),
                //       ],
                //     ),
                //
                //     // Dose 2
                //     TableRow(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Dose 2\n(6th Week)',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'DTwP/Dtap-1, IPV-1, Hib-1, Hep B-2, Rotavirus-1, PCV-1',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.left,
                //           ),
                //         ),
                //       ],
                //     ),
                //
                //     // Dose 3
                //     TableRow(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Dose 3\n(10th Week)',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'DTwP/Dtap-2, IPV-2, Hib-2, Rotavirus-2, PCV-2',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.left,
                //           ),
                //         ),
                //       ],
                //     ),
                //
                //     // Dose 4
                //     TableRow(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Dose 4\n(14th Week)',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'DTwP/Dtap-3, IPV-3, Hib-3, Rotavirus-3, PCV-3',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.left,
                //           ),
                //         ),
                //       ],
                //     ),
                //
                //     // Dose 5
                //     TableRow(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Dose 5\n(6th Month)',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Influenza (Iiv)-1',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.left,
                //           ),
                //         ),
                //       ],
                //     ),
                //
                //     // Dose 6
                //     TableRow(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Dose 6\n(7th Month)',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             'Influenza (Iiv)-2',
                //             style: TextStyle(fontSize: 16),
                //             textAlign: TextAlign.left,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    // Table Header Row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Age Group',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Vaccines',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Birth',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'BCG,OPV,HEPATITIS B -1',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '6 Week',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'DTwP/Dtap-1,IPV-1,Hib-1,Hep B-2,Rotavirus-1 PCV-1',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '10 Week',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'DTwP/Dtap-2,IPV-2,Hib-2,Hep B-3,Rotavirus-2,PCV-2',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '14 week',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'DTwP/Dtap-3,IPV-3,Hib-3,Hep B-4,Rotavirus-3,PCV-3',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '6 Months',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Influenza(Iiv)-1',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '7 Months',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Influenza(Iiv)-2',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '6-9 Months',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Typhoid Conjugate Vaccine',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '9 Months',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'MMR-1',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '12 Months',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Hepatitis A',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '15 Months',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'MMR 2, Varicella-1, PCV Booster',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '16-18 Months',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'DTwP/Dtap-B1, IPV-B1, Hib-B1',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '18-19 Months',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Hep A-2, Varicella-2',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '4-6 Years',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'DTwP/Dtap-B2, IPV-B2, MMR-3',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
