import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final TextEditingController _ageController = TextEditingController();

  final List<String> _vaccineList = [
    'Vaccine_DTwP/Dtap-2, IPV-2, Hib-2, Hep B-3',
    'Vaccine_DTwP/Dtap-B1, IPV-B1, Hib-B1',
    'Vaccine_Hep A-2, Varicella-2',
    'Vaccine_Hepatitis A',
    'Vaccine_MMR-1',
    'Vaccine_Influenza (IIV)-2',
    'Vaccine_PCV-2',
    'Vaccine_Rotavirus-1',
    'Vaccine_Typhoid Conjugate Vaccine',
  ];

  List<bool> _vaccineStatus = List.filled(9, false); 
  String _predictedEffects = '';

 Future<void> _predictAdverseEffects() async {
    if (_ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter age in weeks.')),
      );
      return;
    }

    int age = int.parse(_ageController.text);
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/predict'), // Use this for Android emulator
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'age': age,
        'vaccines': _vaccineStatus.map((status) => status ? 1 : 0).toList(),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _predictedEffects = json.decode(response.body)['predicted_effects'];
      });
    } else {
      setState(() {
        _predictedEffects = 'Failed to predict adverse effects: ${response.reasonPhrase}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adverse Effects Prediction'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Age in Weeks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.tealAccent),
                    ),
                    //hintText: 'Enter age in Weeks',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                Text(
                  'Vaccination Status',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ...List.generate(_vaccineList.length, (index) {
                  return CheckboxListTile(
                    title: Text(_vaccineList[index]),
                    value: _vaccineStatus[index],
                    activeColor: Colors.teal,
                    onChanged: (bool? value) {
                      setState(() {
                        _vaccineStatus[index] = value!;
                      });
                    },
                  );
                }),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _predictAdverseEffects,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Predict', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Predicted Adverse Effects:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _predictedEffects.isEmpty ? 'No predictions yet.' : _predictedEffects,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
