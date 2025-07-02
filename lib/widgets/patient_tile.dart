import 'package:flutter/material.dart';
import '../models/patient.dart';

class PatientTile extends StatelessWidget {
  final Patient patient;
  final VoidCallback onDelete;

  const PatientTile({
    Key? key,
    required this.patient,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        patient.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("📞 ${patient.contact}"),
          Text("📅 ${patient.date}"),
          Text("💊 ${patient.prescription}"),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
