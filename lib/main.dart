import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Contacts App',
    home: MyApp(),
  ));
}

class Contact {
  final String name;
  final String phone;
  Contact({required this.name, required this.phone});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Contact> _contacts = [];

  void _showAddContactBottomSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Contact',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      final String name = nameController.text.trim();
                      final String phone = phoneController.text.trim();
                      if (name.isNotEmpty && phone.isNotEmpty) {
                        setState(() {
                          _contacts.add(Contact(name: name, phone: phone));
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditContactBottomSheet(BuildContext context, int index, Contact contact) {
    final TextEditingController nameController = TextEditingController(text: contact.name);
    final TextEditingController phoneController = TextEditingController(text: contact.phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Contact',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      final String name = nameController.text.trim();
                      final String phone = phoneController.text.trim();
                      if (name.isNotEmpty && phone.isNotEmpty) {
                        setState(() {
                          _contacts[index] = Contact(name: name, phone: phone);
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactContainer(int index, Contact contact) {
    String initial = contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?';
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, 0.2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30,
              child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.name, style: const TextStyle(fontSize: 20)),
                  Text(contact.phone, style: const TextStyle(fontSize: 25)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditContactBottomSheet(context, index, contact),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _contacts.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: const Color(0x7400000B),
        leading: const Icon(Icons.contact_phone),
        title: const Text("Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => setState(() => _contacts.clear()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            if (_contacts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("No contacts yet.", style: TextStyle(fontSize: 18)),
              ),
            for (int i = 0; i < _contacts.length; i++) _buildContactContainer(i, _contacts[i]),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            backgroundColor: Colors.black,
            child: const Icon(Icons.add,color: Colors.white,),
            onPressed: () => _showAddContactBottomSheet(context),
          );
        },
      ),
    );
  }
}
