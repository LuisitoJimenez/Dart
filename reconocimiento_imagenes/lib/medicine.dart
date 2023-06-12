
import 'dart:ffi';

class Medicine {

  String? id;
  String? name;
  String? dosage;
  String? description;
  String? contraindication;

  Medicine({required this.id, required this.name, required this.dosage, required this.description, required this.contraindication});

  Medicine.FromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    name = json['m_name'] as String?;
    dosage = json['dosage'] as String?;
    description = json['m_description'] as String?;
    contraindication = json['contraindication'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['m_name'] = this.name;
    data['dosage'] = this.dosage;
    data['m_description'] = this.description;
    data['contraindication'] = this.contraindication;
    return data;
  }

}