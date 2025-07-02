// ignore: deprecated_member_use
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient.dart';

class LocalStorageService {
  static const _storageKey = 'patients_data';
  static final _firestore = FirebaseFirestore.instance;
  static final _collection = _firestore.collection('patients');

  // Read all from localStorage
  static List<Patient> _readAll() {
    final data = window.localStorage[_storageKey];
    if (data == null) return [];
    return Patient.fromJsonList(data);
  }

  // Write all to localStorage
  static void _writeAll(List<Patient> patients) {
    window.localStorage[_storageKey] = Patient.toJsonList(patients);
  }

  // Public method to get patients (local only)
  static List<Patient> getPatients() {
    return _readAll();
  }

  // Insert both locally and in Firestore
  static Future<void> insertPatient(Patient patient) async {
    final patients = _readAll();
    final newId = (patients.isNotEmpty ? patients.last.id ?? 0 : 0) + 1;
    patient.id = newId;
    patients.add(patient);
    _writeAll(patients);

    try {
      await _collection.add({
        'id': patient.id,
        'name': patient.name,
        'contact': patient.contact,
        'date': patient.date,
        'prescription': patient.prescription,
      });
    } catch (e) {
      print('🔥 Error writing to Firestore: $e');
    }
  }

  // Delete both locally and in Firestore
  static Future<void> deletePatient(int id) async {
    final patients = _readAll();
    final target = patients.firstWhere((p) => p.id == id, orElse: () => Patient(name: '', contact: '', date: '', prescription: ''));
    patients.removeWhere((p) => p.id == id);
    _writeAll(patients);

    try {
      final snapshot = await _collection.where('id', isEqualTo: id).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('🔥 Error deleting from Firestore: $e');
    }
  }
}
