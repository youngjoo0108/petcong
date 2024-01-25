import 'package:flutter/material.dart';
import 'birthday_page.dart';
import 'pet_name_page.dart';
import 'package:petcong/widgets/continue_button.dart';

class GenderPage extends StatefulWidget {
  final double progress;

  const GenderPage({Key? key, required this.progress}) : super(key: key);

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String _gender = '';
  double _progress = 0.0;
  bool _isButtonDisabled = true; // _isButtonDisabled 변수 선언

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  void _increaseProgress() {
    setState(() {
      _progress += 1 / 10;
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
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BirthdayPage(progress: 1 / 10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Center(child: Text('저는', style: TextStyle(fontSize: 32.0))),
            const SizedBox(height: 50.0),
            Center(
              child: SizedBox(
                width: 300.0,
                height: 60.0,
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
            const SizedBox(height: 20.0),
            Center(
              child: SizedBox(
                width: 300.0,
                height: 60.0,
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
            const SizedBox(height: 100.0),
            ContinueButton(
              isFilled: !_isButtonDisabled,
              buttonText: 'Continue',
              onPressed: !_isButtonDisabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetNamePage(
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
