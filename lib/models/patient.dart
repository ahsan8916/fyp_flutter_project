import 'dart:convert';

class Patient {
  int? id;
  final String name;
  final String contact;
  final String date;
  final String prescription;

  Patient({
    this.id,
    required this.name,
    required this.contact,
    required this.date,
    required this.prescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'date': date,
      'prescription': prescription,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
      date: map['date'],
      prescription: map['prescription'],
    );
  }

  static List<Patient> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((map) => Patient.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  static String toJsonList(List<Patient> patients) {
    final List<Map<String, dynamic>> maps = patients.map((p) => p.toMap()).toList();
    return json.encode(maps);
  }
}
