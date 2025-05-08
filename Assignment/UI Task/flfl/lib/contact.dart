import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sqflite/sqflite.dart';

class ContactsPage extends StatefulWidget {
  final Database db;
  ContactsPage({required this.db});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final data = await FlutterContacts.getContacts(withProperties: true);
      setState(() => contacts = data);
    }
  }

  void callContact(String name, String number) async {
    await widget.db.insert('history', {
      'name': name,
      'number': number,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void addToFavorites(Contact contact) async {
    await widget.db.insert('favorites', {'id': contact.id}, conflictAlgorithm: ConflictAlgorithm.replace);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${contact.displayName} added to favorites')));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (_, i) {
        final contact = contacts[i];
        final phone = contact.phones.isNotEmpty ? contact.phones.first.number : 'N/A';
        return ListTile(
          title: Text(contact.displayName),
          subtitle: Text(phone),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: Icon(Icons.call), onPressed: () => callContact(contact.displayName, phone)),
              IconButton(icon: Icon(Icons.star_border), onPressed: () => addToFavorites(contact)),
            ],
          ),
        );
      },
    );
  }
}
