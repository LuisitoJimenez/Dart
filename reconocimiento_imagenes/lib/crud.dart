import 'package:flutter/material.dart';
import 'package:reconocimiento_imagenes/dbconections.dart';
import 'package:reconocimiento_imagenes/medicine.dart';

class Crud extends StatefulWidget {
  @override
  _CrudState createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  List<Medicine>? _medicines;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  TextEditingController? _nameController;
  TextEditingController? _dosageController;
  TextEditingController? _descriptionController;
  TextEditingController? _contraindicationController;
  TextEditingController? _correoController;
  String _currentID = "";
  bool _isupdating = false;

  @override
  void initState() {
    super.initState();
    _medicines = [];
    _scaffoldKey = GlobalKey();
    _nameController = TextEditingController();
    _dosageController = TextEditingController();
    _descriptionController = TextEditingController();
    _contraindicationController = TextEditingController();
    _selectData();
    DBConnections.createTable();
  }

  _showSnackBar(BuildContext context, String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje.toUpperCase()),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _deleteData() {
    DBConnections.deleteData(_currentID).then((result) {
      if ('success' == result) {
        _nameController!.text = "";
        _dosageController!.text = "";
        _descriptionController!.text = "";
        _contraindicationController!.text = "";
      }
      _selectData();
    });
    _currentID = "";
  }

  _updateData() {
    if (_currentID == "") {
      debugPrint("no hay elementos seleccionados");
    }

    DBConnections.updateData(
            _currentID.toString(),
            _nameController!.text,
            _dosageController!.text,
            _descriptionController!.text,
            _contraindicationController!.text)
        .then((result) {
      if ('success' == result) {
        _nameController!.text = "";
        _dosageController!.text = "";
        _descriptionController!.text = "";
        _contraindicationController!.text = "";
      }
      _selectData();
    });
    _currentID = "";
  }

  _insertData() {
    DBConnections.insertData(_nameController!.text, _dosageController!.text,
            _descriptionController!.text, _contraindicationController!.text)
        .then((result) {
      if ('success' == result) {
        _nameController!.text = "";
        _dosageController!.text = "";
        _descriptionController!.text = "";
        _contraindicationController!.text = "";
        _selectData();
      }
    });
    _currentID = "";
  }

  _selectData() {
    DBConnections.selectData().then((medicines) {
      setState(() {
        _medicines = medicines;
      });
    });
  }

//Body

  SingleChildScrollView _body() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Nombre")),
            DataColumn(label: Text("Dosis")),
            DataColumn(label: Text("Descripción")),
            DataColumn(label: Text("Contraindicación")),
          ],
          rows: _medicines!
              .map((medicine) => DataRow(cells: [
                    DataCell(Text(medicine.id!), onTap: () {
                      _currentID = medicine.id.toString();
                      print("Id Actual");
                      print(_currentID);
                      _isupdating = true;
                      print("Update Status");
                      print(_isupdating);
                      fillTextFields(medicine);
                    }),
                    DataCell(Text(medicine.name!)),
                    DataCell(Text(medicine.dosage!)),
                    DataCell(Text(medicine.description!)),
                    DataCell(Text(medicine.contraindication!)),
                  ]))
              .toList(),
        ));
  }

  String _searchText = "";
  final TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Administración"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              setState(() async {
                _medicines = await _selectData();
              });
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration.collapsed(hintText: "Nombre"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _dosageController,
                      decoration: InputDecoration.collapsed(hintText: "Dosis"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _descriptionController,
                      decoration:
                          InputDecoration.collapsed(hintText: "Descripción"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _contraindicationController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Contraindicación"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: _body(),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (_nameController!.text.isEmpty ||
                  _dosageController!.text.isEmpty ||
                  _descriptionController!.text.isEmpty ||
                  _contraindicationController!.text.isEmpty) {
                _showSnackBar(context, "Aun hay espacios en blanco");
              } else {
                if (_currentID != "") {
                  _showSnackBar(
                      context, "No se permite ingresar el mismo elemento");
                } else {
                  _insertData();
                  _isupdating = false;
                  _selectData();
                }
              }
            },
            child: Icon(Icons.add),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              if (_currentID == "") {
                _showSnackBar(context, "Seleccione un elemento");
              }
              DBConnections.selectData().then((medicines) {
                setState(() {
                  _medicines = medicines;
                });
                if (medicines?.length == 0) {
                  _showSnackBar(context, "No hay elementos para modificar");
                }
              });
              if (_isupdating == true) {
                _updateData();
                _selectData();
              }
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.edit),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              if (_currentID == "") {
                _showSnackBar(context, "Seleccione un elemento");
              }
              DBConnections.selectData().then((medicines) {
                setState(() {
                  _medicines = medicines;
                });
                if (medicines?.length == 0) {
                  _showSnackBar(context, "No hay elementos para eliminar");
                }
              });
              _deleteData();
            },
            backgroundColor: Colors.red,
            child: Icon(Icons.delete),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  void fillTextFields(Medicine medicine) {
    _nameController!.text = medicine.name!;
    _dosageController!.text = medicine.dosage!;
    _descriptionController!.text = medicine.description!;
    _contraindicationController!.text = medicine.contraindication!;
  }

}
