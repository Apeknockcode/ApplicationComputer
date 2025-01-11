import 'package:flutter/material.dart';
import "./cal.dart";

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  final Cal _cal = Cal();
  List<String> numberKey = [
    '+', '7', '4', '1', '%', //
    '-', '8', '5', '2', '0', //
    '×', '9', '6', '3', '.', //
    '÷', 'A', '', '=', 'D' //
  ];

// 优化按钮样式
  Widget _buildButton(String key) {
    Color backgroundColor;
    Color textColor = Colors.black;

    // 设置不同类型按钮的样式
    if ('+-×÷'.contains(key)) {
      backgroundColor = Colors.orange;
      textColor = Colors.white;
    } else if ('C()⌫'.contains(key)) {
      backgroundColor = Colors.grey[300]!;
    } else if (key == '=') {
      backgroundColor = Colors.blue;
      textColor = Colors.white;
    } else {
      backgroundColor = Colors.white;
    }

    return SizedBox(
      width: 70,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          onPressed: () => setState(() => _cal.addKeys(key)),
          child: Text(
            key,
            style: TextStyle(
              fontSize: 28,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutButton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: numberKey.length,
      itemBuilder: (context, index) => _buildButton(numberKey[index]),
    );
  }

  // Widget _buildLayoutButton() {
  //   final List<Widget> LayoutButton = [];
  //   List<Widget> ButtonList = [];
  //   for (var i = 0; i < numberKey.length; i++) {
  //     var key = numberKey[i];
  //     ButtonList.add(SizedBox(
  //       width: 70,
  //       height: 70,
  //       child: ElevatedButton(
  //           onPressed: () {
  //             _ClickButton(key);
  //           },
  //           child: Text(key, style: TextStyle(fontSize: 32))),
  //     ));
  //     if ((i + 1) % 5 == 0) {
  //       LayoutButton.add(Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: ButtonList));
  //       ButtonList = [];
  //     }
  //   }
  //   return Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: LayoutButton);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('标准计算器')),
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              // 显示表达式
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _cal.expression,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              // 显示结果（只在计算完成时显示）
              if (_cal.hasCalculated) // 新增条件
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _cal.result,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          )),
          Container(
            child: _buildLayoutButton(),
          )
        ],
      ),
    );
  }
}
