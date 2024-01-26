import 'package:flutter/material.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:petcong/widgets/create_button.dart';
import 'package:petcong/widgets/delete_button.dart';
import 'media_page.dart';
import 'dart:io';

// 이미지를 선택하고 화면에 표시되는 기능
class DisplayImage extends StatelessWidget {
  final String imagePath;

  const DisplayImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0), // 둥근 모서리의 크기를 지정합니다.
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(imagePath)),
            fit: BoxFit.cover, // 이미지를 그리드의 크기에 맞게 조절합니다.
          ),
        ),
      ),
    );
  }
}

class PhotoPage extends StatefulWidget {
  final double progress;

  const PhotoPage({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late double _progress;
  final List<String> _photoPaths = []; // 선택한 이미지들의 경로를 저장하는 리스트

  void navigateToMediaPage(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const MediaPage()),
    );
    // MediaPage에서 사진이 추가되었다면 _photoPaths를 업데이트합니다.
    if (result != null) {
      setState(() {
        _photoPaths.add(result);
      });
    }
  }

  void deleteImage(int index) {
    setState(() {
      _photoPaths.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _progress);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: LinearProgressIndicator(
            value: _progress,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 234, 64, 128),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: () => Navigator.pop(context, _progress),
              ),
            ),
            const SizedBox(height: 10.0),
            const Center(
              child: Text('사진 첨부', style: TextStyle(fontSize: 32.0)),
            ),
            const SizedBox(height: 10.0),
            const Center(
              child: Text(
                '최소 2개의 사진을 첨부해주세요',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index < _photoPaths.length) {
                    // 이미지가 선택되었다면 해당 이미지를 표시하고 '-' 버튼을 추가합니다.
                    return Stack(
                      children: [
                        DisplayImage(imagePath: _photoPaths[index]),
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: RoundGradientXButton(
                            onTap: () => deleteImage(index),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // 아직 이미지가 선택되지 않았다면 '+' 버튼을 표시합니다.
                    return GridWithPlusButton(
                      onTap: () => navigateToMediaPage(context),
                    );
                  }
                },
              ),
            ),
            Center(
              // Center 위젯 추가
              child: ContinueButton(
                isFilled: _photoPaths.length >= 2, // 사진이 두 장 이상 추가되었는지 확인합니다.
                buttonText: 'CONTINUE',
                onPressed: null,
                width: 300.0, // 원하는 가로 길이를 설정
                height: 30.0, // 원하는 세로 길이를 설정
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridWithPlusButton extends StatelessWidget {
  final VoidCallback onTap;

  const GridWithPlusButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          right: -5,
          child: RoundGradientPlusButton(onTap: onTap),
        ),
      ],
    );
  }
}
