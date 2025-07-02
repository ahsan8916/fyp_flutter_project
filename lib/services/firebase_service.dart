import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient.dart';

class FirebaseService {
  static final CollectionReference _patients =
      FirebaseFirestore.instance.collection('patients');

  static Future<void> addPatient(Patient patient) async {
    await _patients.add(patient.toMap());
  }

  static Future<List<Patient>> getPatients() async {
    final snapshot = await _patients.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Patient.fromMap(data);
    }).toList();
  }

  static Future<void> deletePatientByName(String name) async {
    final snapshot = await _patients.where('name', isEqualTo: name).get();
    for (var doc in snapshot.docs) {
      await _patients.doc(doc.id).delete();
    }
  }
}
