import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HistoryPage extends StatelessWidget {
  final Database db;
  HistoryPage({required this.db});

  Future<List<Map<String, dynamic>>> getHistory() async {
    return await db.query('history', orderBy: 'timestamp DESC');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHistory(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final history = snapshot.data!;
        return ListView.builder(
          itemCount: history.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(history[i]['name']),
            subtitle: Text('${history[i]['number']} \n${history[i]['timestamp']}'),
          ),
        );
      },
    );
  }
}
