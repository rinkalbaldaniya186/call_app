// import 'package:call_app/list_page.dart';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'models/contactList class.dart';
//
// class AddPage extends StatefulWidget {
//   const AddPage({super.key});
//
//   @override
//   State<AddPage> createState() => _AddPageState();
// }
//
// TextEditingController _personNameController = TextEditingController();
// TextEditingController _productNameController = TextEditingController();
// TextEditingController _descriptionController = TextEditingController();
// final TextEditingController _phoneNumberController = TextEditingController();
// List<contactList> ContactListData = [];
// String _countryCode = '+1';
//
// class _AddPageState extends State<AddPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple.shade500,
//         title: const Text(
//           "Add Contact",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 5,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               const Text(
//                 "Enter Contact Details",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.purple,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Name Field
//               TextFormField(
//                 controller: _personNameController,
//                 decoration: _inputDecoration(
//                   "Person Name",
//                   "Enter Person Name",
//                 ),
//               ),
//               const SizedBox(height: 15),
//               // Product Field
//               TextFormField(
//                 controller: _productNameController,
//                 decoration: _inputDecoration(
//                   "Product Name",
//                   "Enter Product Name",
//                 ),
//               ),
//               const SizedBox(height: 15),
//               // Description Field
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: _inputDecoration(
//                   "Description",
//                   "Enter Description",
//                 ),
//               ),
//               const SizedBox(height: 15),
//               // Phone Number Field with Country Picker
//               Row(
//                 children: [
//                   CountryCodePicker(
//                     onChanged: (countryCode) {
//                       setState(() {
//                         _countryCode = countryCode.dialCode!;
//                       });
//                     },
//                     initialSelection: 'US',
//                     showCountryOnly: false,
//                     showFlagMain: true,
//                     favorite: const ['+91'],
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: _phoneNumberController,
//                       decoration: _inputDecoration(
//                         "Phone Number",
//                         "Enter Phone Number",
//                       ),
//                       keyboardType: TextInputType.phone,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 25),
//               // Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: addData,
//                     style: _buttonStyle(Colors.purple.shade700),
//                     child: const Text(
//                       "Add",
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ListPage(contactListData: ContactListData),
//                         ),
//                       );
//                     },
//                     style: _buttonStyle(Colors.purple.shade700),
//                     child: const Text(
//                       "Next",
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Input decoration helper for text fields
//   InputDecoration _inputDecoration(String labelText, String hintText) {
//     return InputDecoration(
//       labelText: labelText,
//       hintText: hintText,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
//
//   /// Button styling helper
//   ButtonStyle _buttonStyle(Color color) {
//     return ElevatedButton.styleFrom(
//       backgroundColor: color,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//     );
//   }
//
//   /// Add data to the list
//   void addData() {
//     final personName = _personNameController.text.trim().isEmpty
//         ? "Unnamed Person"
//         : _personNameController.text.trim();
//     final productName = _productNameController.text.trim().isEmpty
//         ? "Unnamed Product"
//         : _productNameController.text.trim();
//     final description = _descriptionController.text.trim().isEmpty
//         ? "No Description"
//         : _descriptionController.text.trim();
//     final contactNumber = _phoneNumberController.text.trim().isEmpty
//         ? "No Phone Number"
//         : "$_countryCode ${_phoneNumberController.text.trim()}";
//
//     // Get the current date
//     final currentDate = DateTime.now();
//
//     ContactListData.add(
//       contactList(personName, productName, description, contactNumber, currentDate),
//     );
//
//     // Clear text fields after adding data
//     _personNameController.clear();
//     _productNameController.clear();
//     _descriptionController.clear();
//     _phoneNumberController.clear();
//
//     // Show a success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Contact added successfully!')),
//     );
//   }
// }
import 'package:call_app/list_page.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import for date formatting
import 'models/contactList class.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

TextEditingController _personNameController = TextEditingController();
TextEditingController _productNameController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();
final TextEditingController _phoneNumberController = TextEditingController();
List<contactList> ContactListData = [];
String _countryCode = '+1';
DateTime? _selectedDate;  // Store the selected date

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade500,
        title: const Text(
          "Add Contact",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "Enter Contact Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 20),
              // Name Field
              TextFormField(
                controller: _personNameController,
                decoration: _inputDecoration(
                  "Person Name",
                  "Enter Person Name",
                ),
              ),
              const SizedBox(height: 15),
              // Product Field
              TextFormField(
                controller: _productNameController,
                decoration: _inputDecoration(
                  "Product Name",
                  "Enter Product Name",
                ),
              ),
              const SizedBox(height: 15),
              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration(
                  "Description",
                  "Enter Description",
                ),
              ),
              const SizedBox(height: 15),
              // Phone Number Field with Country Picker
              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (countryCode) {
                      setState(() {
                        _countryCode = countryCode.dialCode!;
                      });
                    },
                    initialSelection: 'US',
                    showCountryOnly: false,
                    showFlagMain: true,
                    favorite: const ['+91'],
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneNumberController,
                      decoration: _inputDecoration(
                        "Phone Number",
                        "Enter Phone Number",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Date Picker Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Select Date: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(
                      _selectedDate == null
                          ? "Select Date"
                          : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                      style: const TextStyle(color: Colors.white), // Set the text color to white
                    ),
                    style: _buttonStyle(Colors.purple.shade700),
                  ),
                ],
              ),


              const SizedBox(height: 25),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: addData,
                    style: _buttonStyle(Colors.purple.shade700),
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListPage(contactListData: ContactListData),
                        ),
                      );
                    },
                    style: _buttonStyle(Colors.purple.shade700),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Input decoration helper for text fields
  InputDecoration _inputDecoration(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  /// Button styling helper
  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
    );
  }

  /// Add data to the list
  void addData() {
    final personName = _personNameController.text.trim().isEmpty
        ? "Unnamed Person"
        : _personNameController.text.trim();
    final productName = _productNameController.text.trim().isEmpty
        ? "Unnamed Product"
        : _productNameController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? "No Description"
        : _descriptionController.text.trim();
    final contactNumber = _phoneNumberController.text.trim().isEmpty
        ? "No Phone Number"
        : "$_countryCode ${_phoneNumberController.text.trim()}";

    // If no date is selected, use the current date
    final currentDate = _selectedDate ?? DateTime.now();

    ContactListData.add(
      contactList(personName, productName, description, contactNumber, currentDate),
    );

    // Clear text fields after adding data
    _personNameController.clear();
    _productNameController.clear();
    _descriptionController.clear();
    _phoneNumberController.clear();
    setState(() {
      _selectedDate = null; // Reset date after adding the contact
    });

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact added successfully!')),
    );
  }

  /// Show date picker and set selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
