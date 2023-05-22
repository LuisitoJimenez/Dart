import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'photo.dart';
import 'dbManager.dart';
import 'convert_utility.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SaveImage(),
    );

  }
}

class SaveImage extends StatefulWidget {
  const SaveImage({Key? key}) : super(key: key);

  @override
  State<SaveImage> createState() => _SaveImageState();
}

class _SaveImageState extends State<SaveImage> {

  late List<Photo> photos;
  late dbManager db;
  late Future<File> imageFile;
  late Image image;

  @override
  void initState() {
    super.initState();
    db = dbManager();
    photos = [];
    refreshImages();
  }

  refreshImages() {
    db.getPhotos().then((photos) {
      setState(() {
        photos.clear();
        photos.addAll(photos);
        //this.photos = photos;
      });
    });
  }

  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((imageFile) async {
      Uint8List? imageBytes = await imageFile!.readAsBytes();
      String imagString = Utility.base64String(imageBytes!);
      Photo photo = Photo(null, imagString);
      db.save(photo);
      refreshImages();
    });
  }

  gridView() {
    return Padding(
      padding: const EdgeInsets.all (20.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: photos.map((photo) {
          return Center(
            child: Utility.imageFromBase64String(photo.photoName!),
          );
        }).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Image save'),
        actions: [
          IconButton(
            onPressed: () {
              pickImageFromGallery();
            },
            icon: const Icon(Icons.add_a_photo),
          )
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(child: gridView())
          ],
        ),
      )
    );
  }

}