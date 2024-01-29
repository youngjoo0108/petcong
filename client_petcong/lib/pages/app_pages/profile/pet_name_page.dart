import 'package:flutter/material.dart';
import 'pet_birthday_page.dart';
import 'package:petcong/widgets/continue_button.dart';

class PetNamePage extends StatefulWidget {
  final double progress;

  const PetNamePage({Key? key, required this.progress}) : super(key: key);

  @override
  _PetNamePageState createState() => _PetNamePageState();
}

class _PetNamePageState extends State<PetNamePage> {
  final _controller = TextEditingController();
  bool _isButtonDisabled = true;
  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonDisabled =
          _controller.text.isEmpty || _controller.text.trim().isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.progress);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: LinearProgressIndicator(
            value: widget.progress,
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
                  onPressed: () => Navigator.pop(context, widget.progress),
                ),
              ),
              const SizedBox(height: 10.0),
              const Center(
                  child: Text('내 반려동물 이름은?', style: TextStyle(fontSize: 32.0))),
              const SizedBox(height: 30.0),
              SizedBox(
                width: 300, // 원하는 너비 설정
                child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      fontSize: 20.0,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: const InputDecoration(
                      hintText: '반려동물 이름을 입력하세요',
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(
                height: 30.0,
              ), // TextField 위젯과 ElevatedButton 위젯 사이에 100픽셀의 공간을 만듭니다.
              ContinueButton(
                isFilled: !_isButtonDisabled,
                buttonText: 'CONTINUE',
                onPressed: !_isButtonDisabled
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetBirthdayPage(
                              petName: _controller.text,
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
      ),
    );
  }
}