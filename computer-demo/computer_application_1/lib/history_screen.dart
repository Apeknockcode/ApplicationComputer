import 'package:flutter/material.dart';
import './history_service.dart';
import './calculator_history.dart';
class HistoryScreen extends StatelessWidget {
  final HistoryService historyService;

  const HistoryScreen({
    Key? key,
    required this.historyService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('计算历史'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearHistoryDialog(context),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<CalculationRecord>>(
        valueListenable: historyService.historyNotifier,
        builder: (context, history, child) {
          if (history.isEmpty) {
            return const Center(
              child: Text('暂无计算记录'),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final record = history[index];
              return Dismissible(
                key: Key('history_${record.timestamp.toString()}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) {
                  historyService.deleteRecord(index);
                },
                child: ListTile(
                  title: Text(
                    record.expression,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '= ${record.result}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Text(
                    _formatDateTime(record.timestamp),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => _showRecordDetails(context, record),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}\n'
           '${dateTime.hour}:${dateTime.minute}';
  }

  Future<void> _showClearHistoryDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空历史记录'),
        content: const Text('确定要清空所有计算历史记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      historyService.clearHistory();
    }
  }

  void _showRecordDetails(BuildContext context, CalculationRecord record) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('计算表达式：${record.expression}'),
            const SizedBox(height: 8),
            Text('计算结果：${record.result}'),
            const SizedBox(height: 8),
            Text('计算时间：${_formatDateTime(record.timestamp)}'),
          ],
        ),
      ),
    );
  }
}