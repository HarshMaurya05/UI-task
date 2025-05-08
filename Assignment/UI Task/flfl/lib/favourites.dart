import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:sqflite/sqflite.dart';

class FavoritesPage extends StatefulWidget {
  final Database db;
  FavoritesPage({required this.db});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Contact> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final ids = await widget.db.query('favorites');
    final all = await FlutterContacts.getContacts(withProperties: true);
    final filtered = all.where((c) => ids.any((e) => e['id'] == c.id)).toList();
    setState(() => favorites = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(favorites[i].displayName),
        subtitle: Text(favorites[i].phones.isNotEmpty ? favorites[i].phones.first.number : ''),
      ),
    );
  }
}
