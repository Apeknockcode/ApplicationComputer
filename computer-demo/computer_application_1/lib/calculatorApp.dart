import 'package:flutter/material.dart';

class calculatorApp extends StatefulWidget {
  const calculatorApp({super.key});

  @override
  State<calculatorApp> createState() => _calculatorAppState();
}

class _calculatorAppState extends State<calculatorApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("我是计算器"),
    );
  }
}
