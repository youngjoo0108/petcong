import 'package:flutter/material.dart';
import 'photo_selection_page.dart';
import 'package:petcong/widgets/continue_button.dart';

class IntroducePage extends StatefulWidget {
  final double progress;

  const IntroducePage({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  _IntroducePageState createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> {
  final _controller = TextEditingController();
  bool _isButtonDisabled = true;
  late double _progress;

  void _decreaseProgress() {
    setState(() {
      if (_progress > 0) {
        _progress -= 1 / 10;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
    _controller.addListener(() {
      setState(() {
        _isButtonDisabled = _controller.text.trim().isEmpty;
      });
    });
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
                icon: const Icon(Icons.close, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text('자기 소개 해주세요!', style: TextStyle(fontSize: 40.0)),
            const SizedBox(height: 50.0),
            SizedBox(
              width: 300.0, // 너비를 300으로 설정
              child: TextField(
                controller: _controller,
                style: const TextStyle(
                  fontSize: 20.0, // 텍스트 크기를 20.0으로 설정
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
                decoration: InputDecoration(
                  hintText: '자기 소개',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            ContinueButton(
              isFilled: !_isButtonDisabled,
              buttonText: 'Continue',
              onPressed: !_isButtonDisabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoSelectionPage(
                            progress: widget.progress + 1 / 10,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
