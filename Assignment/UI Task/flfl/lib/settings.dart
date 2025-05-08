import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SettingsPage extends StatefulWidget {
  final Database db;
  SettingsPage({required this.db});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _backgroundImage;

  @override
  void initState() {
    super.initState();
    _loadImagePath();
  }

  Future<void> _loadImagePath() async {
    final result = await widget.db.query('settings', where: 'key = ?', whereArgs: ['background']);
    if (result.isNotEmpty) {
      setState(() => _backgroundImage = File(result.first['value'] as String));
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final dir = await getApplicationDocumentsDirectory();
      final saved = await File(picked.path).copy('${dir.path}/background.jpg');
      await widget.db.insert(
        'settings',
        {'key': 'background', 'value': saved.path},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      setState(() => _backgroundImage = saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Background Image:'),
          SizedBox(height: 10),
          _backgroundImage != null
              ? Image.file(_backgroundImage!, width: 200, height: 300, fit: BoxFit.cover)
              : Text('No image selected'),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.image),
            label: Text('Choose Image'),
            onPressed: _pickImage,
          )
        ],
      ),
    );
  }
}
