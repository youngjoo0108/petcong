import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  MediaPageState createState() => MediaPageState();
}

class MediaPageState extends State<MediaPage> {
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImageFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage(
        requestFullMetadata: false, imageQuality: 20);
    List<String> imagePaths = [];

    for (XFile image in images) {
      imagePaths.add(image.path);
    }

    if (imagePaths.isNotEmpty && imagePaths.length < 7) {
      Get.back(result: imagePaths);
    }
  }

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    List<String> imagePaths = [];

    if (photo != null) {
      imagePaths.add(photo.path);
      Get.back(result: imagePaths);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          icon: const Text(
            '취소',
            style: TextStyle(
              color: Color.fromARGB(255, 249, 113, 95),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cafe24',
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: GestureDetector(
                onTap: _pickImageFromGallery,
                child: const Row(
                  children: [
                    Icon(
                      Icons.photo_library,
                      size: 50,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cafe24',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 30,
              thickness: 0.2,
              color: Color.fromARGB(255, 158, 158, 158),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: GestureDetector(
                onTap: _takePicture,
                child: const Row(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 50,
                    ),
                    SizedBox(width: 25),
                    Text(
                      'Camera',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 30,
              thickness: 0.2,
              color: Color.fromARGB(255, 158, 158, 158),
            ),
          ],
        ),
      ),
    );
  }
}
