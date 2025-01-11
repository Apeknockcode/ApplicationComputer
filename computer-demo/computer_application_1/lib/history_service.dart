import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculator_history.dart';
import 'package:flutter/foundation.dart';
class HistoryService {
  static const String _storageKey = 'calculator_history';
  final SharedPreferences _prefs;
  List<CalculationRecord> _history = [];

  final _historyNotifier = ValueNotifier<List<CalculationRecord>>([]);

  ValueNotifier<List<CalculationRecord>> get historyNotifier =>
      _historyNotifier;

  HistoryService(this._prefs) {
    _loadHistory();
  }

  // 获取所有历史记录
  List<CalculationRecord> get records => List.unmodifiable(_history);

  // 添加新记录
  Future<void> addRecord(String expression, String result) async {
    final record = CalculationRecord(
      expression: expression,
      result: result,
    );

    _historyNotifier.value = [
      CalculationRecord(expression: expression, result: result),
      ..._historyNotifier.value
    ];

    _history.insert(0, record);
    await _saveHistory();
  }

  // 删除记录
  Future<void> deleteRecord(int index) async {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      await _saveHistory();
    }
  }

  // 清空历史记录
  Future<void> clearHistory() async {
    _history.clear();
    await _saveHistory();
  }

  // 从本地存储加载历史记录
  Future<void> _loadHistory() async {
    final String? jsonStr = _prefs.getString(_storageKey);
    if (jsonStr != null) {
      final List<dynamic> jsonList = json.decode(jsonStr);
      _history =
          jsonList.map((json) => CalculationRecord.fromJson(json)).toList();
    }
  }

  // 保存历史记录到本地存储
  Future<void> _saveHistory() async {
    final String jsonStr = json.encode(
      _history.map((record) => record.toJson()).toList(),
    );
    await _prefs.setString(_storageKey, jsonStr);
  }
}
