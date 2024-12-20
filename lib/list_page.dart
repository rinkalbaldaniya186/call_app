import 'package:call_app/call_history_page.dart';
import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'add_page.dart';
import 'models/contactList class.dart';

class ListPage extends StatefulWidget {
  final List<contactList> contactListData;

  const ListPage({super.key, required this.contactListData});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    widget.contactListData.sort((a, b) => b.date.compareTo(a.date));

    List<contactList> filteredContacts = selectedDate == null
        ? widget.contactListData
        : widget.contactListData.where((contact) {
      return DateFormat('yyyy-MM-dd').format(contact.date) ==
          DateFormat('yyyy-MM-dd').format(selectedDate!);
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
          // Existing date picker button
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.white),
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
          // Add the Next button to navigate to CallHistoryPage
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallHistoryPage(widget.contactListData),
                ),
              );
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
          final formattedDate =
          DateFormat('MMM dd, yyyy').format(contact.date);
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
                  children: [
                    CallButton(
                      contactNumber: contact.contactNumber,
                      onCallEnded: () {
                        _showEditDialog(contact, index);
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteContact(index);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.edit, color: Colors.orange),
                    //   onPressed: () {
                    //     _showEditDialog(contact, index);
                    //   },
                    // ),
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
                    // const SizedBox(height: 5),
                    // Text(
                    //   "Added on: $formattedDate",
                    //   style: const TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.black45,
                    //   ),
                    // ),
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
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.contactListData.removeAt(index);
                });
                Navigator.of(context).pop();
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

  void _showEditDialog(contactList contact, int index) {
    final TextEditingController _personNameController =
    TextEditingController(text: contact.personName);
    final TextEditingController _productNameController =
    TextEditingController(text: contact.productName);
    final TextEditingController _contactNumberController =
    TextEditingController(text: contact.contactNumber);
    final TextEditingController _descriptionController =
    TextEditingController(text: contact.description);
    final TextEditingController _callDescController =
    TextEditingController(text: contact.callDesc);
    final TextEditingController _durationController =
    TextEditingController(text: contact.duration);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Contact"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _personNameController,
                  decoration: const InputDecoration(labelText: "Person Name"),
                ),
                TextField(
                  controller: _contactNumberController,
                  decoration: const InputDecoration(labelText: "Contact Number"),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _productNameController,
                  decoration: const InputDecoration(labelText: "Product Name"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: _callDescController,
                  decoration:
                  const InputDecoration(labelText: "Call Description"),
                ),
                TextField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: "Duration"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.contactListData[index] = contactList.CallCut(
                    _personNameController.text.trim(),
                    _productNameController.text.trim(),
                    _descriptionController.text.trim(),
                    _contactNumberController.text.trim(),
                    contact.date,
                    _callDescController.text.trim(),
                    _durationController.text.trim(),
                  );
                });
                var EditContactList = widget.contactListData[index];
                Navigator.push(context, MaterialPageRoute(builder: (context) => CallHistoryPage(widget.contactListData),));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact updated successfully!')),
                );
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

class CallButton extends StatefulWidget {
  final String contactNumber;
  final Function onCallEnded;

  const CallButton({
    super.key,
    required this.contactNumber,
    required this.onCallEnded,
  });

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
        widget.onCallEnded();
      },
      icon: Icon(
        Icons.call,
        color: _isCalling ? Colors.green : Colors.purple,
        size: 30,
      ),
    );
  }

  Future<bool> _makeCall() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      final DirectCaller directCaller = DirectCaller();
      try {
        await directCaller.makePhoneCall(widget.contactNumber, simSlot: 2);
        return true;
      } catch (e) {
        print("Failed to make the call: $e");
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone call permission denied')),
      );
      return false;
    }
  }
}
