import 'package:call_app/models/contactList%20class.dart';
import 'package:flutter/material.dart';

class CallHistoryPage extends StatefulWidget {
  final List<contactList> editContactList; // Receive the full list of contacts

  const CallHistoryPage(this.editContactList, {super.key});

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade500,
        title: const Text(
          "Call History",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: widget.editContactList.isEmpty
          ? const Center(
        child: Text(
          "No contacts available.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: widget.editContactList.length, // Show all contacts
        itemBuilder: (context, index) {
          final contact = widget.editContactList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.purple.shade50,
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.purple,
                  child: Text(
                    contact.personName.isNotEmpty
                        ? contact.personName[0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                title: Text(
                  contact.personName.isNotEmpty
                      ? contact.personName
                      : "Unnamed Person",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product: ${contact.productName.isNotEmpty ? contact.productName : "Unnamed Product"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Description: ${contact.description.isNotEmpty ? contact.description : "No Description"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Contact: ${contact.contactNumber.isNotEmpty ? contact.contactNumber : "No Number"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Call Description: ${contact.callDesc!.isNotEmpty ? contact.callDesc : "No Description"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Duration: ${contact.duration!.isNotEmpty ? contact.duration : "No Duration"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
