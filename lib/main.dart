// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(const ContactPermissionApp());
}

class ContactPermissionApp extends StatelessWidget {
  const ContactPermissionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Permission Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactPermissionExample(),
    );
  }
}

class ContactPermissionExample extends StatefulWidget {
  const ContactPermissionExample({super.key});

  @override
  _ContactPermissionExampleState createState() =>
      _ContactPermissionExampleState();
}

class _ContactPermissionExampleState extends State<ContactPermissionExample> {
  List<Contact> _contacts = [];

  Future<void> _getContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts.toList();
      });
    } else {
      _showPermissionError();
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.contacts.request();
    }
    return status;
  }

  void _showPermissionError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissions Error'),
          content: const Text(
              'Please enable contacts access permission in the system settings.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Permission Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _getContacts,
              child: const Text('Share Contacts'),
            ),
            
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = _contacts[index];
                  String? phone = contact.phones!.isNotEmpty
                      ? contact.phones!.elementAt(0).value
                      : "No Number"; 
                  return ListTile(
                    title: Text(contact.displayName ?? "No Name"),
                    subtitle: Text(phone ?? "No Number"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
