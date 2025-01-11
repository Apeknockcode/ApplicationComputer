import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "./calculatorApp.dart";
import 'cal.dart';
import './history_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // 确保这行在最前面
  final prefs = await SharedPreferences.getInstance();
  final historyService = HistoryService(prefs);
  runApp(MyApp(historyService: historyService));
}

class MyApp extends StatelessWidget {
  final HistoryService historyService;
  const MyApp({super.key, required this.historyService});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'calculatorApp',
      home: CalculatorApp(
        historyService: historyService,
        cal: Cal(historyService),
      ),
    );
  }
}
