import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    // 사진이 선택되었다면 이를 PhotoPage로 전달합니다.
    if (photo != null) {
      Get.back(result: photo.path);
    }
  }

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    // 사진이 찍혔다면 이를 PhotoPage로 전달합니다.
    if (photo != null) {
      Get.back(result: photo.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20.0),
          icon: const Text('취소',
              style: TextStyle(
                  color: Color.fromARGB(255, 249, 113, 95),
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: _pickImageFromGallery,
                child: const Row(
                  children: [
                    Icon(Icons.photo_library, size: 50),
                    SizedBox(width: 25),
                    Text('Gallery',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const Divider(
                height: 30,
                thickness: 0.2,
                color: Color.fromARGB(255, 158, 158, 158)),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: _takePicture,
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt, size: 50),
                    SizedBox(width: 25),
                    Text('Camera',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const Divider(
                height: 30,
                thickness: 0.2,
                color: Color.fromARGB(255, 158, 158, 158)),
          ],
        ),
      ),
    );
  }
}
