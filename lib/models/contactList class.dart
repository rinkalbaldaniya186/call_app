class contactList {
  final String personName;
  final String productName;
  final String description;
  final String contactNumber;
  final DateTime date;
  String? callDesc;
  String? duration;

  contactList(this.personName, this.productName, this.description, this.contactNumber, this.date);

  contactList.CallCut(this.personName, this.productName, this.description,
      this.contactNumber, this.date, this.callDesc, this.duration);
}
