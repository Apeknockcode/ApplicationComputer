class Cal {
  // 核心状态
  String _result = '0';
  String _inputExpression = '';
  String _displayExpression = '';

  // 状态标记
  bool _isNewNumber = true;
  bool _hasCalculated = false;

  // Getters
  bool get hasCalculated => _hasCalculated;
  String get result => _result;
  String get expression =>
      _displayExpression.isEmpty ? _result : _displayExpression;

  // 常量定义
  static const _operators = ['+', '-', '×', '÷'];
  static const _maxLength = 15;

  void addKeys(String key) {
    if (_hasCalculated && key.contains(RegExp(r'[0-9]'))) {
      _clear();
    }

    switch (key) {
      case var k when RegExp(r'[0-9.]').hasMatch(k):
        _handleNumber(k);
        break;
      case var k when _operators.contains(k):
        _handleOperator(k);
        break;
      case '=':
        _calculateResult();
        break;
      case 'A':
        _clear();
        break;
      case 'D':
        _handleBackspace();
        break;
    }

    _updateDisplay();
  }

  // 数字处理逻辑
  void _handleNumber(String num) {
    // 处理小数点
    if (num == '.' && _result.contains('.')) return;

    // 处理新数字输入
    if (_isNewNumber) {
      _result = num == '.' ? '0.' : num;
      _isNewNumber = false;
    } else {
      // 处理数字追加
      if (_result == '0' && num != '.') {
        _result = num;
      } else if (_result.length < _maxLength) {
        _result += num;
      }
    }

    // 更新表达式
    _updateExpressionWithNumber();
  }

  void _updateExpressionWithNumber() {
    if (_inputExpression.isEmpty || _hasCalculated) {
      _inputExpression = _result;
    } else {
      final parts = _inputExpression.split(' ');
      if (parts.isNotEmpty) {
        parts[parts.length - 1] = _result;
        _inputExpression = parts.join(' ');
      }
    }
    _hasCalculated = false;
  }

  // 运算符处理逻辑：

  void _handleOperator(String op) {
    if (_hasCalculated) {
      _inputExpression = _result;
      _hasCalculated = false;
    }

    // 处理空表达式或只有0的情况
    if (_inputExpression.isEmpty || _inputExpression == '0') {
      _inputExpression = '0';
    }

    // 替换或添加运算符
    if (_inputExpression.endsWith(' ')) {
      // 替换最后的运算符
      _inputExpression =
          _inputExpression.substring(0, _inputExpression.length - 3) + ' $op ';
    } else {
      _inputExpression += ' $op ';
    }

    _isNewNumber = true;
  }

  // 计算结果的处理：

  void _calculateResult() {
    if (_inputExpression.isEmpty) return;

    try {
      final parts = _inputExpression.trim().split(' ');
      if (parts.isEmpty) return;

      // 确保表达式完整
      if (_operators.contains(parts.last)) {
        parts.removeLast();
      }

      if (parts.isEmpty) return;

      final result = _evaluate(parts);
      _result = _formatResult(result);
      _displayExpression = '$_inputExpression = $_result';
      _inputExpression = _result;
      _hasCalculated = true;
      _isNewNumber = true;
    } catch (e) {
      _handleError();
    }
  }

  double _evaluate(List<String> parts) {
    // 处理乘除
    for (int i = 1; i < parts.length - 1; i += 2) {
      if (parts[i] == '×' || parts[i] == '÷') {
        final a = double.parse(parts[i - 1]);
        final b = double.parse(parts[i + 1]);
        final result = parts[i] == '×' ? a * b : a / b;

        if (parts[i] == '÷' && b == 0) throw Exception('除数不能为零');

        parts[i - 1] = result.toString();
        parts.removeRange(i, i + 2);
        i -= 2;
      }
    }

    // 处理加减
    double result = double.parse(parts[0]);
    for (int i = 1; i < parts.length - 1; i += 2) {
      final num = double.parse(parts[i + 1]);
      result += parts[i] == '+' ? num : -num;
    }

    return result;
  }

  // 辅助方法
  void _handleBackspace() {
    if (_hasCalculated) {
      _clear();
      return;
    }

    if (_inputExpression.isNotEmpty) {
      if (_inputExpression.endsWith(' ')) {
        _inputExpression =
            _inputExpression.substring(0, _inputExpression.length - 3);
        _isNewNumber = false;
      } else {
        _inputExpression =
            _inputExpression.substring(0, _inputExpression.length - 1);
        _result =
            _result.length > 1 ? _result.substring(0, _result.length - 1) : '0';
      }
    }
  }

  String _formatResult(double value) {
    if (value.isInfinite || value.isNaN) throw Exception('计算错误');

    String result = value.toString();
    if (result.endsWith('.0')) {
      return result.substring(0, result.length - 2);
    }
    if (result.contains('e')) {
      return value.toStringAsFixed(10).replaceAll(RegExp(r'0*$'), '');
    }
    return result;
  }

  void _handleError() {
    _clear();
    _result = '错误';
    _displayExpression = '错误';
  }

  void _clear() {
    _result = '0';
    _displayExpression = '';
    _inputExpression = '';
    _isNewNumber = true;
    _hasCalculated = false;
  }

  void _updateDisplay() {
    if (!_hasCalculated) {
      _displayExpression = _inputExpression;
    }
  }
}
