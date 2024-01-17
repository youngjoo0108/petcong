import 'package:flutter/material.dart';
import 'dart:io';
import 'package:petcong/services/my_image_picker.dart'; // MyImagePicker import

class PhotoSelectionPage extends StatefulWidget {
  const PhotoSelectionPage({Key? key}) : super(key: key);

  @override
  _PhotoSelectionPageState createState() => _PhotoSelectionPageState();
}

class _PhotoSelectionPageState extends State<PhotoSelectionPage> {
  final _images = <File>[]; // 업로드한 사진을 저장하는 리스트
  final _picker = MyImagePicker(); // MyImagePicker 인스턴스 생성
  double _progress = 7 / 10;

  void _increaseProgress() {
    setState(() {
      _progress += 1 / 10; // 진행 상황을 증가시킴
    });
  }

  Future<void> _getImage(int index) async {
    if (_images.length >= 6) {
      return; // 이미 6개의 사진을 업로드했다면 아무것도 하지 않음
    }
    final pickedFile = await _picker.getImageFromGallery(); // 갤러리에서 이미지 선택
    if (pickedFile != null) {
      setState(() {
        if (index < _images.length) {
          _images[index] = File(pickedFile.path); // 이미 있는 위치면 이미지 교체
        } else {
          _images.add(File(pickedFile.path)); // 새로운 위치면 이미지 추가
          if (_images.length >= 2) {
            _increaseProgress(); // 사진을 두 장 이상 업로드하면 진행 상황 증가
          }
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index); // 이미지 삭제
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.close), // X 모양의 아이콘
          onPressed: null, // 이전 페이지로 이동하는 기능 삭제
        ),
        title: LinearProgressIndicator(value: _progress), // 상단 진행 상황 바
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            GridView.count(
              crossAxisCount: 3,
              children: List.generate(6, (index) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    if (index < _images.length)
                      Image.file(_images[index]) // 이미지가 있으면 이미지 표시
                    else
                      const Placeholder(
                          fallbackHeight: 100,
                          fallbackWidth: 100), // 이미지가 없으면 Placeholder 표시
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(index < _images.length
                            ? Icons.close
                            : Icons.add), // 이미지가 있으면 'x' 아이콘, 없으면 '+' 아이콘
                        onPressed: () {
                          if (index < _images.length) {
                            _removeImage(index); // 이미지가 있으면 _removeImage 메서드 호출
                          } else {
                            _getImage(index); // 이미지가 없으면 _getImage 메서드 호출
                          }
                        },
                      ),
                    ),
                    if (index < _images.length)
                      const Positioned(
                        top: 0,
                        child: Icon(Icons.star), // 이미지가 있으면 별 모양 아이콘 표시
                      ),
                  ],
                );
              }),
            ),
            ElevatedButton(
              onPressed: _images.length < 2
                  ? null
                  : () {
                      // 이미지가 2개 이상 업로드 되지 않았다면 버튼 비활성화
                      // 다음 페이지로 이동하는 코드를 여기에 추가
                    },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
