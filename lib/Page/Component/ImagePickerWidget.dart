import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();

  pickImage({required ImageSource source}) {}
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  // Image

  File? _image;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    print(_image);
    print(_image.runtimeType);

    setState(() {
      _image = imageTemporary;
    });
    return imageTemporary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null
              ? Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      _image!,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 202, 202, 202),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          fixedSize: const Size(180, 180)),
                      onPressed: () {
                        getImage();
                        setState(() {});
                      },
                      child: const Text(
                        'เลือกรูป',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 94, 94, 94)),
                      )),
                ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 4))
                  ],
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add_photo_alternate_outlined,
                      size: 25, color: Color.fromARGB(255, 94, 94, 94)),
                  onPressed: () {
                    getImage();
                    setState(() {});
                  },
                )),
          ),
        ],
      ),
    );
  }
}
