import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference usersdata = FirebaseDatabase.instance.ref().child("users");

  String? username;
  String? phoneNumber;
  String? childName;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      setState(() {
        isLoading = true;
      });

      try {
        DatabaseEvent event = await usersdata.child(userId).child("profile").once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

          setState(() {
            username = data['username'] ?? '';
            phoneNumber = data['phoneNumber'] ?? '';
            childName = data['childName'] ?? '';
          });
        }
      } catch (e) {
        print("Error fetching profile: $e");
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveProfileData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? userId = _auth.currentUser?.uid;
      //print("userid,$userId");

      if (userId != null) {
        try {
          await usersdata.child(userId).child("profile").set({
            "username": username,
            "phoneNumber": phoneNumber,
            "childName": childName,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
        } catch (e) {
          print("Error updating profile: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile. Please try again.')),
          );
        }
      }
    }
  }
// Future<void> _saveProfileData() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       String? userId = _auth.currentUser?.uid;
//       //print("userid,$userId");

//       if (userId != null) {
//         try {
//           await _dbRef.child(userId).child("profile").set({
//             "username": username,
//             "phoneNumber": phoneNumber,
//             "childName": childName,
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Profile updated successfully!')),
//           );
//         } catch (e) {
//           print("Error updating profile: $e");
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error updating profile. Please try again.')),
//           );
//         }
//       }
//     }
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Update Profile',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: username,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username = value;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: phoneNumber,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          phoneNumber = value;
                        },
                      ),
                      SizedBox(height: 16),
                      //   TextFormField(
                      //   initialValue: phoneNumber,
                      //   decoration: InputDecoration(
                      //     labelText: 'Phone Number',
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      //   keyboardType: TextInputType.phone,
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter a phone number';
                      //     }
                      //     return null;
                      //   },
                      //   onSaved: (value) {
                      //     phoneNumber = value;
                      //   },
                      // ),
                      // SizedBox(height: 16),
                      TextFormField(
                        initialValue: childName,
                        decoration: InputDecoration(
                          labelText: 'Child Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the child name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          childName = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfileData,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.deepPurple,
                ),
                child: Text(
                  'Save Profile',
                  style: TextStyle(fontSize: 16,color: Colors.cyan),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
