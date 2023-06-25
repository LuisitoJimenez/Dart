import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reconocimiento_imagenes/crud.dart';
import 'package:reconocimiento_imagenes/dbconections.dart';
import 'package:reconocimiento_imagenes/medicine.dart';
import 'package:tflite/tflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const imageRecognition(),
    );
  }
}

class imageRecognition extends StatefulWidget {
  const imageRecognition({Key? key}) : super(key: key);

  @override
  State<imageRecognition> createState() => _imageRecognitionState();
}

class _imageRecognitionState extends State<imageRecognition> {
  Map myMap = Map();
  List<Medicine> medicine = [];
  List? _outputs;
  File? _image;
  bool isLoading = false;

  _selectData() {
    DBConnections.selectData().then((_medicine) {
      setState(() {
        medicine = _medicine!;
/*         medicine.forEach((element) {
          print(element.name);
        }); */
      });
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadModel().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    DBConnections.createTable();
    _selectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmacia"),
        centerTitle: true,
      ),
      body: isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _image == null
                          ? Container()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                _image!,
                                width: 200.0,
                                height: 200.0,
                              ),
                            ),
                      _outputs != null
                          ? Padding(
                              padding: EdgeInsets.all(20.0),
                              child:
                                  Table(border: TableBorder.all(), children: [
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Nombre',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      medicine[_outputs![0]["index"]]
                                          .name
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dosis',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      medicine[_outputs![0]["index"]]
                                          .dosage
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Descripción',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      medicine[_outputs![0]["index"]]
                                          .description
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Contraindicación',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      medicine[_outputs![0]["index"]]
                                          .contraindication
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ])
                              ]))
                          : Container()
                    ],
                  )),
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: pickedImage,
            child: const Icon(Icons.image),
          ),
          SizedBox(width: 16), // Espacio entre los botones
          FloatingActionButton(
            onPressed: pickedImageCamera,
            child: const Icon(Icons.camera_alt),
          ),
          SizedBox(width: 16), // Espacio entre los botones
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Crud()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  pickedImage() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    setState(() {
      isLoading = true;
      _image = File(image.path.toString());
    });
    classifyImage(File(image.path));
  }

  pickedImageCamera() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(
        source: ImageSource.camera); // Cambiar a ImageSource.camera
    if (image == null) {
      return null;
    }
    setState(() {
      isLoading = true;
      _image = File(image.path.toString());
    });
    classifyImage(File(image.path));
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 5,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      isLoading = false;
      _outputs = output!;
      print(_outputs);
      print(_outputs![0]["index"]);
    });
  }

  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
