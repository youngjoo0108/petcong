import 'package:flutter/material.dart';
import 'select_image_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:petcong/widgets/create_button.dart';
import 'package:petcong/widgets/delete_button.dart'; // SelectImagePage를 import 해야 합니다.

class PhotoSelectionPage extends StatefulWidget {
  final double progress; // progress 변수 추가

  const PhotoSelectionPage({
    Key? key,
    required this.progress, // progress 파라미터 추가
  }) : super(key: key);

  @override
  _PhotoSelectionPageState createState() => _PhotoSelectionPageState();
}

class _PhotoSelectionPageState extends State<PhotoSelectionPage> {
  bool _isButtonDisabled = false;
  double _progress;

  _PhotoSelectionPageState() : _progress = 7 / 10;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress; // progress 값을 _progress에 할당
  }

  void _increaseProgress() {
    setState(() {
      _progress += 1 / 10;
      if (_progress >= 1.0) {
        _isButtonDisabled = true;
      }
    });
  }

  void _onAddPhoto() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectImagePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(
          value: _progress,
          valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 234, 64, 128)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const Text('사진 첨부', style: TextStyle(fontSize: 24.0)),
                  const SizedBox(height: 20.0),
                  const Text(
                    '최소 2개의 사진을 첨부해주세요!',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 30.0),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Text('사진 ${index + 1}'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: _onAddPhoto,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isButtonDisabled ? null : _increaseProgress,
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
