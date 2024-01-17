import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'my_image_picker.dart'; // MyImagePicker 클래스가 정의된 파일을 import 합니다.

class MyImageDisplay extends StatelessWidget {
  final MyImagePicker myImagePicker = MyImagePicker();

  MyImageDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // 취소 버튼을 눌렀을 때 수행할 작업을 이곳에 작성합니다.
            // 예를 들어, 이전 화면으로 돌아가는 작업을 수행하려면 아래 코드를 사용할 수 있습니다.
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 완료 버튼을 눌렀을 때 수행할 작업을 이곳에 작성합니다.
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                PickedFile? pickedFile =
                    await myImagePicker.getImageFromGallery();
                if (pickedFile != null) {
                  // 이미지를 표시하는 로직을 여기에 작성하세요.
                }
              },
              child: const Text('갤러리에서 이미지 선택'),
            ),
            ElevatedButton(
              onPressed: () async {
                PickedFile? pickedFile =
                    await myImagePicker.getImageFromCamera();
                if (pickedFile != null) {
                  // 이미지를 표시하는 로직을 여기에 작성하세요.
                }
              },
              child: const Text('사진 찍기'),
            ),
          ],
        ),
      ),
    );
  }
}
