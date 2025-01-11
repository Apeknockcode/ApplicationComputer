import 'package:flutter/material.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {

  List<String> numberKey = [
    '7','8','9',
    '6','5','4',
    '3','2','1',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('标准计算器')
      ),
      body: Column(
        children: [
          Expanded(child: Container(
            child:Center(
              child: Text('显示区域'),
            ) 
          )),
          Container(
            child: Row(
              children: [
                Column(
                  children: [
                    Text("+"),
                    Text("7"),
                    Text("8"),
                    Text("1"),
                    Text('%')
                  ],
                ),
                Column(
                  children: [
                    Text("-"),
                    Text("8"),
                    Text("5"),
                    Text("2"),
                    Text('0')
                    
                  ],
                ),
                Column(
                  children: [
                    Text("x"),
                    Text("9"),
                    Text("6"),
                    Text('3'),
                    Text('.')
                  
                  ],
                ),
                Column(
                  children: [
                    Text("÷"),
                    Text("A"),
                    Text('='),
                    Text("D"),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
