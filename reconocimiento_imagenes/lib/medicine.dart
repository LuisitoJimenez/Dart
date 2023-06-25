
class Medicine {

  int? id;
  String? name;
  String? dosage;
  String? description;
  String? contraindication;

  Medicine({required this.id, required this.name, required this.dosage, required this.description, required this.contraindication});

  Medicine.FromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dosage = json['dosage'];
    description = json['description'];
    contraindication = json['contraindication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['dosage'] = this.dosage;
    data['description'] = this.description;
    data['contraindication'] = this.contraindication;
    return data;
  }

}