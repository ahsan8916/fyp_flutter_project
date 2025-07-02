import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/local_storage_service.dart';
import '../widgets/patient_tile.dart';

class PatientHomePage extends StatefulWidget {
  @override
  _PatientHomePageState createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  List<Patient> patients = [];
  List<Patient> filteredPatients = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _loadPatients() {
    final data = LocalStorageService.getPatients();
    setState(() {
      patients = data;
      filteredPatients = data;
    });
  }

  void _filterPatients(String query) {
    final results =
        patients.where((patient) {
          final nameLower = patient.name.toLowerCase();
          final contactLower = patient.contact.toLowerCase();
          return nameLower.contains(query.toLowerCase()) ||
              contactLower.contains(query.toLowerCase());
        }).toList();

    setState(() {
      filteredPatients = results;
    });
  }

  Future<void> _addPatient() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController contactController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController prescriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Patient"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: contactController,
                  decoration: InputDecoration(labelText: "Contact"),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: "Date"),
                ),
                TextField(
                  controller: prescriptionController,
                  decoration: InputDecoration(labelText: "Prescription"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    contactController.text.isNotEmpty &&
                    dateController.text.isNotEmpty &&
                    prescriptionController.text.isNotEmpty) {
                  await LocalStorageService.insertPatient(
                    Patient(
                      name: nameController.text,
                      contact: contactController.text,
                      date: dateController.text,
                      prescription: prescriptionController.text,
                    ),
                  );
                  Navigator.pop(context);
                  _loadPatients();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePatient(int id) async {
    await LocalStorageService.deletePatient(id);
    _loadPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🩺 Patient Records"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 240, 180, 52),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name or Contact',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterPatients,
            ),
          ),
          Expanded(
            child:
                filteredPatients.isEmpty
                    ? Center(child: Text("No patients found."))
                    : ListView.builder(
                      itemCount: filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        return PatientTile(
                          patient: patient,
                          onDelete: () => _deletePatient(patient.id!),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPatient,
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 223, 208, 72),
      ),
    );
  }
}
