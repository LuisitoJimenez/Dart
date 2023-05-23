import 'dart:io';
import 'dart:typed_data';
import 'package:almacenamiento_imagenes/main.dart';
import 'package:almacenamiento_imagenes/photo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'convert_utility.dart';
import 'dbManager.dart';

 class detailBook extends StatefulWidget {
  final int id;
  detailBook({Key? key, required this.id}) : super(key: key);

  @override
  State<detailBook> createState() => _detailBookState();
}

class _detailBookState extends State<detailBook> {
  Photo? photo;
  late dbManager dbmanager;

  @override
  void initState() {
    super.initState();
    dbmanager = dbManager();
    dbmanager.getPhoto(widget.id).then((photo) {
      setState(() {
        this.photo = photo;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles del libro"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (photo != null) ...[
              Utility.ImageFromBase64String(photo!.photo_name!),
              Text(photo!.name_book!),
              Text(photo!.author_book!),
              Text(photo!.book_publisher!),
              Text(photo!.book_year!),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
