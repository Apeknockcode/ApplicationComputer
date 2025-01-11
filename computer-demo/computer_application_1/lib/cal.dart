class Cal {
  String _result = '0';  // 当前输入的数字
  String _displayExpression = '';  // 显示的表达式
  String _inputExpression = '';  // 记录完整的输入内容
  bool _isNewNumber = true;
  bool _lastInputWasOperator = false;
  
  // Getters
  String get result => _result;
  String get expression => _displayExpression.isEmpty ? _result : _displayExpression;

  void addKeys(String key) {
    if (key.contains(RegExp(r'[0-9.]'))) {
      _handleNumber(key);
    } else if (['+', '-', '×', '÷'].contains(key)) {
      _handleOperation(key);
    } else if (key == '=') {
      _calculateResult();
    } else if (key == 'A') {
      _clear();
    } else if (key == 'D') {
      _handleBackspace();
    }
    _updateDisplay();
  }

  void _handleNumber(String num) {
    if (_lastInputWasOperator || _isNewNumber) {
      _result = num;
      _isNewNumber = false;
    } else {
      if (num == '.' && _result.contains('.')) return;
      if (_result.length < 15) {
        _result = _result + num;
      }
    }
    _inputExpression += num;
    _lastInputWasOperator = false;
  }

  void _handleOperation(String op) {
    if (_lastInputWasOperator) {
      // 替换最后一个运算符
      _inputExpression = _inputExpression.substring(0, _inputExpression.length - 3);
      _inputExpression += ' $op ';
    } else {
      _inputExpression += ' $op ';
      _lastInputWasOperator = true;
    }
    _isNewNumber = true;
  }

  void _updateDisplay() {
    _displayExpression = _inputExpression;
  }

  void _calculateResult() {
    if (_inputExpression.isEmpty) return;
    
    try {
      // 分割表达式
      List<String> parts = _inputExpression.trim().split(' ');
      List<double> numbers = [];
      List<String> operators = [];
      
      // 解析表达式
      for (int i = 0; i < parts.length; i++) {
        if (i % 2 == 0) {
          numbers.add(double.parse(parts[i]));
        } else {
          operators.add(parts[i]);
        }
      }

      // 先处理乘除
      for (int i = 0; i < operators.length; i++) {
        if (operators[i] == '×' || operators[i] == '÷') {
          double result;
          if (operators[i] == '×') {
            result = numbers[i] * numbers[i + 1];
          } else {
            if (numbers[i + 1] == 0) throw Exception('除数不能为零');
            result = numbers[i] / numbers[i + 1];
          }
          numbers[i] = result;
          numbers.removeAt(i + 1);
          operators.removeAt(i);
          i--;
        }
      }

      // 处理加减
      double finalResult = numbers[0];
      for (int i = 0; i < operators.length; i++) {
        if (operators[i] == '+') {
          finalResult += numbers[i + 1];
        } else if (operators[i] == '-') {
          finalResult -= numbers[i + 1];
        }
      }

      // 格式化结果
      _result = _formatResult(finalResult);
      _displayExpression = '$_inputExpression = $_result';
      
      // 重置状态
      _inputExpression = _result;
      _isNewNumber = true;
      _lastInputWasOperator = false;
      
    } catch (e) {
      _clear();
      _result = '错误';
      _displayExpression = '错误';
    }
  }

  String _formatResult(double value) {
    if (value.isInfinite || value.isNaN) return '错误';
    
    String result = value.toString();
    if (result.endsWith('.0')) {
      result = result.substring(0, result.length - 2);
    }
    if (result.contains('e')) {
      return value.toStringAsFixed(10).replaceAll(RegExp(r'0*$'), '');
    }
    return result;
  }

  void _handleBackspace() {
    if (_inputExpression.isNotEmpty) {
      if (_inputExpression.endsWith(' ')) {
        // 删除运算符
        _inputExpression = _inputExpression.substring(0, _inputExpression.length - 3);
        _lastInputWasOperator = false;
      } else {
        // 删除数字
        _inputExpression = _inputExpression.substring(0, _inputExpression.length - 1);
      }
      // 更新当前数字显示
      List<String> parts = _inputExpression.trim().split(' ');
      _result = parts.isEmpty ? '0' : parts.last;
    }
  }

  void _clear() {
    _result = '0';
    _displayExpression = '';
    _inputExpression = '';
    _isNewNumber = true;
    _lastInputWasOperator = false;
  }
}