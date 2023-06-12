import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reconocimiento_imagenes/medicine.dart';

class DBConnections {
  static const SERVER = "";
  static const _CREATE_TABLE_COMMAND = "CREATE_TABLE";
  static const _SELECT_TABLE_COMMAND = "SELECT_TABLE";

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
}
