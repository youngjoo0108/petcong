import 'package:flutter/material.dart';
import 'social_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';

class IntroducePage extends StatefulWidget {
  final double progress;

  const IntroducePage({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  IntroducePageState createState() => IntroducePageState();
}

class IntroducePageState extends State<IntroducePage> {
  final _controller = TextEditingController();
  bool _isButtonDisabled = true;
  late double _progress;

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
              Color.fromARGB(255, 249, 113, 95)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.close, size: 32),
                    onPressed: () => Get.back(result: _progress),
                  ),
                  TextButton(
                    child: const Text(
                      '건너뛰기',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    onPressed: () {
                      Get.to(const SocialPage(
                        progress: 9 / 12,
                      ));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            const Text('자기 소개 해주세요!',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600)),
            const SizedBox(height: 30.0),
            SizedBox(
              width: 200.0,
              child: TextField(
                controller: _controller,
                readOnly: true, // TextField를 읽기 전용으로 만듭니다.
                onTap: () async {
                  // TextField를 클릭하면 Dialog가 열립니다.
                  final dialogController = TextEditingController(
                      text: _controller.text); // 이전에 입력했던 텍스트를 Dialog에 표시합니다.
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: TextField(
                          controller: dialogController,
                          maxLines: null, // 여러 줄 입력 가능
                          decoration: const InputDecoration(
                            hintText: '자기 소개',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop(dialogController
                                  .text); // Dialog를 닫고, TextField에 입력한 텍스트를 반환합니다.
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (result != null) {
                    // Dialog에서 반환한 텍스트를 _controller에 설정합니다.
                    _controller.text = result;
                  }
                },
                style: const TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w400,
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
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 50.0),
            ContinueButton(
              isFilled: !_isButtonDisabled,
              buttonText: 'CONTINUE',
              onPressed: !_isButtonDisabled
                  ? () {
                      Get.to(SocialPage(
                        progress: widget.progress + 1 / 12,
                      ));
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
