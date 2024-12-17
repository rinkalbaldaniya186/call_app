import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:permission_handler/permission_handler.dart';
import 'models/contactList class.dart';
import 'add_page.dart';  // Import the AddPage where contacts can be added

class ListPage extends StatefulWidget {
  final List<contactList> contactListData;

  const ListPage({super.key, required this.contactListData});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  DateTime? selectedDate; // Store the selected date for filtering

  @override
  Widget build(BuildContext context) {
    // Sort contacts by date (most recent first)
    widget.contactListData.sort((a, b) => b.date.compareTo(a.date));

    // Filter contacts if a date is selected
    List<contactList> filteredContacts = selectedDate == null
        ? widget.contactListData
        : widget.contactListData.where((contact) {
      // Compare the date without time part for filtering
      return DateFormat('yyyy-MM-dd').format(contact.date) == DateFormat('yyyy-MM-dd').format(selectedDate!);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact List",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.purple.shade500,
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.white,),
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
          ),
        ],
      ),
      body: filteredContacts.isEmpty
          ? const Center(
        child: Text(
          "No contacts found for the selected date!",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = filteredContacts[index];
          // Format the date to a readable format
          final formattedDate = DateFormat('MMM dd, yyyy').format(contact.date);
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CallButton(contactNumber: contact.contactNumber),
                    IconButton(
                      onPressed: () {
                        _deleteContact(index);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
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
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 5),
                    // Display the formatted date of contact
                    Text(
                      "Added on: $formattedDate",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );

          if (newContact != null) {
            setState(() {
              widget.contactListData.add(newContact);
            });
          }
        },
        backgroundColor: Colors.purple.shade500,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Delete contact from the list and update UI
  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Contact"),
          content: const Text("Are you sure you want to delete this contact?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.contactListData.removeAt(index);
                });
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CallButton extends StatefulWidget {
  final String contactNumber;

  const CallButton({super.key, required this.contactNumber});

  @override
  State<CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<CallButton> {
  bool _isCalling = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        setState(() {
          _isCalling = true;
        });
        await _makeCall();
        setState(() {
          _isCalling = false;
        });
      },
      icon: Icon(
        Icons.call,
        color: _isCalling ? Colors.green : Colors.purple,
        size: 30,
      ),
    );
  }

  Future<void> _makeCall() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      final DirectCaller directCaller = DirectCaller();
      try {
        await directCaller.makePhoneCall(widget.contactNumber, simSlot: 2);
      } catch (e) {
        print("Failed to make the call: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone call permission denied')),
      );
    }
  }
}
