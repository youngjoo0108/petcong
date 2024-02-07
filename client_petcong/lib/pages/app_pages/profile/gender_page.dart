import 'package:flutter/material.dart';
import 'birthday_page.dart';
import 'prefer_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';

class GenderPage extends StatefulWidget {
  final double progress;

  const GenderPage({Key? key, required this.progress}) : super(key: key);

  @override
  GenderPageState createState() => GenderPageState();
}

class GenderPageState extends State<GenderPage> {
  String _gender = '';
  double _progress = 0.0;
  bool _isButtonDisabled = true; // _isButtonDisabled 변수 선언

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(
          value: _progress,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 249, 113, 95),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 32),
                  onPressed: () =>
                      Get.off(const BirthdayPage(progress: 2 / 12)),
                ),
              ),
              const SizedBox(height: 10.0),
              const Center(child: Text('저는', style: TextStyle(fontSize: 32.0))),
              const SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: 240.0,
                  height: 50.0,
                  child: ContinueButton(
                    isFilled: _gender == '여자',
                    buttonText: '여자예요!', // 이제 이 부분을 수정하여 버튼의 텍스트를 변경할 수 있습니다.
                    onPressed: () {
                      setState(() {
                        _gender = '여자';
                        _isButtonDisabled = false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: SizedBox(
                  width: 240.0,
                  height: 50.0,
                  child: ContinueButton(
                    isFilled: _gender == '남자',
                    buttonText: '남자예요!', // 이제 이 부분을 수정하여 버튼의 텍스트를 변경할 수 있습니다.
                    onPressed: () {
                      setState(() {
                        _gender = '남자';
                        _isButtonDisabled = false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 90.0),
              ContinueButton(
                isFilled: !_isButtonDisabled,
                buttonText: 'CONTINUE',
                onPressed: !_isButtonDisabled
                    ? () {
                        Get.to(PreferPage(
                          progress: widget.progress + 1 / 12,
                        ), transition: Transition.noTransition);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
