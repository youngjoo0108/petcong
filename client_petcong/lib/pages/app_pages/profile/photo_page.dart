import 'package:flutter/material.dart';
import 'package:petcong/widgets/continue_button.dart';

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
  final bool _isButtonDisabled = false;

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
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                '최소 2개의 사진을 첨부해주세요',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 300, // GridView의 높이를 설정하세요
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return AspectRatio(
                    aspectRatio: 1.0, // 가로 세로 비율을 1로 설정
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text('사진 ${index + 1}'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            ContinueButton(
              isFilled: !_isButtonDisabled,
              buttonText: 'Continue',
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
