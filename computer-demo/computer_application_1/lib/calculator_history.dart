// 首先创建历史记录模型类：
class CalculationRecord {
  final String expression;    // 计算表达式
  final String result;        // 计算结果
  final DateTime timestamp;   // 计算时间

  CalculationRecord({
    required this.expression,
    required this.result,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // 转换为Map，用于存储
  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // 从Map创建实例
  factory CalculationRecord.fromJson(Map<String, dynamic> json) {
    return CalculationRecord(
      expression: json['expression'],
      result: json['result'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}