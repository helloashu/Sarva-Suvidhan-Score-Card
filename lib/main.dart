import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ScoreCardModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const ScoreCardScreen(),
    );
  }
}

class ScoreCardModel with ChangeNotifier {
  String stationName = '';
  DateTime inspectionDate = DateTime.now();
  Map<String, int> scores = {
    'Platform Cleanliness': 0,
    'Urinals': 0,
    'Water Booths': 0,
    'Waiting Area': 0,
  };
  Map<String, String> remarks = {
    'Platform Cleanliness': '',
    'Urinals': '',
    'Water Booths': '',
    'Waiting Area': '',
  };

  void updateStationName(String value) {
    stationName = value;
    notifyListeners();
  }

  void updateInspectionDate(DateTime value) {
    inspectionDate = value;
    notifyListeners();
  }

  void updateScore(String category, int value) {
    scores[category] = value;
    notifyListeners();
  }

  void updateRemark(String category, String value) {
    remarks[category] = value;
    notifyListeners();
  }

  Future<void> saveOffline() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/scorecard.json');
    final data = {
      'stationName': stationName,
      'inspectionDate': inspectionDate.toIso8601String(),
      'scores': scores,
      'remarks': remarks,
    };
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> submit() async {
    final data = {
      'stationName': stationName,
      'inspectionDate': inspectionDate.toIso8601String(),
      'scores': scores,
      'remarks': remarks,
    };
    final response = await http.post(
      Uri.parse('https://httpbin.org/post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      await saveOffline();
    }
  }
}

class ScoreCardScreen extends StatelessWidget {
  const ScoreCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sarva Suvidhan Score Card')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ScoreCardModel>(
          builder: (context, model, child) {
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Station Name'),
                    onChanged: (value) => model.updateStationName(value),
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: model.inspectionDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) model.updateInspectionDate(date);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Inspection Date'),
                      child: Text(model.inspectionDate.toLocal().toString().split(' ')[0]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...model.scores.keys.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          DropdownButton<int>(
                            value: model.scores[category],
                            items: List.generate(11, (i) => i).map((i) => DropdownMenuItem(value: i, child: Text('$i'))).toList(),
                            onChanged: (value) => model.updateScore(category, value!),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Remarks'),
                            onChanged: (value) => model.updateRemark(category, value),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (Form.of(context)?.validate() ?? false) {
                        model.submit().then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Submitted successfully!')),
                          );
                        }).catchError((e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Submission failed')),
                          );
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}