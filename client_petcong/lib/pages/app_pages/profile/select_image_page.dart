import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SelectImagePage extends StatefulWidget {
  const SelectImagePage({super.key});

  @override
  _SelectImagePageState createState() => _SelectImagePageState();
}

class _SelectImagePageState extends State<SelectImagePage> {
  final picker = ImagePicker();
  List<XFile>? images;

  Future<void> getImage(ImageSource source) async {
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      images = pickedFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: const Text('취소',
              style: TextStyle(color: Colors.red)), // '취소' 텍스트 추가
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 50), // AppBar와 첫 번째 Row 사이에 간격을 생성합니다.
          Padding(
            padding: const EdgeInsets.only(left: 30.0), // 좌측 패딩 추가
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // 아이템들을 왼쪽으로 정렬
              children: [
                TextButton.icon(
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 20.0), // 아이콘과 라벨 사이에 패딩 추가
                    child: Icon(Icons.camera_alt),
                  ),
                  label: const Text('Camera'),
                  onPressed: () => getImage(ImageSource.camera),
                ),
              ],
            ),
          ),
          const Divider(), // 구분선 추가
          Padding(
            padding: const EdgeInsets.only(left: 30.0), // 좌측 패딩 추가
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // 아이템들을 왼쪽으로 정렬
              children: [
                TextButton.icon(
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 20.0), // 아이콘과 라벨 사이에 패딩 추가
                    child: Icon(Icons.photo_library),
                  ),
                  label: const Text('Gallery'),
                  onPressed: () => getImage(ImageSource.gallery),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          // 선택한 이미지들을 표시하는 GridView입니다.
          if (images != null)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 가로 축에 세 개의 그리드
                  crossAxisSpacing: 8.0, // 그리드 사이의 가로 간격
                  mainAxisSpacing: 8.0, // 그리드 사이의 세로 간격
                ),
                itemCount: images!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.file(File(images![index].path));
                },
              ),
            ),
        ],
      ),
    );
  }
}
