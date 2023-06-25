import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reconocimiento_imagenes/medicine.dart';

class DBConnections {
  static const SERVER = "http://192.168.0.103/pharmacy/sqloperations.php";
  static const _CREATE_TABLE_COMMAND = "CREATE_TABLE";
  static const _SELECT_TABLE_COMMAND = "SELECT_TABLE";
  static const _INSERT_TABLE_COMMAND = "INSERT_DATA";
  static const _UPDATE_TABLE_COMMAND = "UPDATE_DATA";
  static const _DELETE_TABLE_COMMAND = "DELETE_DATA";

  static Future<String> createTable() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_COMMAND;
      final response = await http.post(Uri.parse(SERVER), body: map);
      debugPrint('Table response ${response.body}');
      if (200 == response.statusCode) {
        debugPrint(response.body.toString());
        return response.body;
      } else {
        return "Error";
      }
    } catch (e) {
      debugPrint("Error creating table\nError:" + e.toString());
      return "Error";
    }
  }

  static Future<List<Medicine>?> selectData() async {
    List<Medicine> lista = [];
    try {
      var map = Map<String, dynamic>();
      map['action'] = _SELECT_TABLE_COMMAND;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('select response: ${response.body}');

      if (200 == response.statusCode) {
        List<Medicine>? list = parseResponse(response.body);
        list!.forEach((element) {
          print(element.name);
        });
        return list;
      } else {
        return lista;
      }
    } catch (e) {
      print("Error obteniendo datos");
      print(e.toString());
      return lista;
    }
  }

  static List<Medicine>? parseResponse(String responsebody) {
    final parsedData = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsedData.map<Medicine>((json) => Medicine.FromJson(json)).toList();
  }

  static Future<String> insertData(String m_name, String dosage,
      String m_description, String contraindication) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _INSERT_TABLE_COMMAND;
      map['m_name'] = m_name;
      map['dosage'] = dosage;
      map['m_description'] = m_description;
      map['contraindication'] = contraindication;

      final response = await http.post(Uri.parse(SERVER), body: map);
      print('INSERT response: ${response.body}');

      if (200 == response.statusCode) {
        print("Insert Success");
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error adding data to the table");
      print(e.toString());
      return "error";
    }
  }

// Update
  static Future<String> updateData(String id, String m_name, String dosage,
      String m_description, String contraindication) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_TABLE_COMMAND;
      map['id'] = id;
      map['m_name'] = m_name;
      map['dosage'] = dosage;
      map['m_description'] = m_description;
      map['contraindication'] = contraindication;

      final response = await http.post(Uri.parse(SERVER), body: map);
      print('UPDATE response: ${response.body}');

      if (200 == response.statusCode) {
        print("Update Success");
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error updating data in the table");
      print(e.toString());
      return "error";
    }
  }

  static Future<String> deleteData(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_TABLE_COMMAND;
      map['id'] = id;

      final response = await http.post(Uri.parse(SERVER), body: map);
      print('DELETE response: ${response.body}');

      if (200 == response.statusCode) {
        print("Delete Success");
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error deleting data from the table");
      print(e.toString());
      return "error";
    }
  }
}
