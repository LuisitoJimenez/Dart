import 'package:almacenamiento_imagenes/formBook.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'convert_utility.dart';
import 'dbManager.dart';
import 'photo.dart';
import 'dart:io';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  late dbManager dbmanager;
  late Future<File> imageFile;
  late Image image;
  late int? selectedId = null;

  @override
  void initState() {
    super.initState();
    dbmanager = dbManager();
    photos = [];
    refreshImages();
  }

  refreshImages() {
    dbmanager.getPhotos().then((images) {
      setState(() {
        photos.clear();
        photos.addAll(images);
      });
    });
  }

  pickImageFromGallery(String name_book, String book_publisher,
      String book_year, String author_book) {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((imgFile) async {
      Uint8List? imageBytes = await imgFile?.readAsBytes();
      if (imageBytes != null) {
        String imgString = Utility.base64String(imageBytes!);
        Photo photo = Photo(
            null, imgString, name_book, book_publisher, book_year, author_book);
        dbmanager.save(photo);
        refreshImages();
      } else {}
    });
  }

  deleteBook(int id) {
    dbmanager.delete(id).then((_) {
      refreshImages();
    });
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        children: photos.map((photo) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedId = photo.id;

                print("El id es:" + photo.id.toString());
                print("El nombre es:" + photo.name_book.toString());
                print("El autor es:" + photo.author_book.toString());
                print("El año es:" + photo.book_year.toString());
                print("El publisher es:" + photo.book_publisher.toString());
              });
            },

             child: Card(
              color: selectedId == photo.id ? Colors.grey : null,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Utility.ImageFromBase64String(photo.photo_name!),
                  ),
                ],
              ),
            ), 
          );
        }).toList(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridView(),
            )
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 5.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: "button1",
              onPressed: () {},
              child: Icon(Icons.edit),
              mini: true
            ),
          ),
          Positioned(
            bottom: 5.0,
            right: 80.0,
            child: FloatingActionButton(
              heroTag: "button2",
              onPressed: () {
                if (selectedId! != null) {
                  deleteBook(selectedId!);
                } else {}
              },
              child: Icon(Icons.remove),
              mini: true,
              backgroundColor: Colors.red
            ),
          ),
          Positioned(
            bottom: 5.0,
            right: 150.0,
            child: FloatingActionButton(
              heroTag: "button3",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const formBook()),
                );
              },
              child: Icon(Icons.add),
              mini:true,
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
