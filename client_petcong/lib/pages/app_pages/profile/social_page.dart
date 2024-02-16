import 'package:flutter/material.dart';
import 'package:petcong/controller/signup_controller.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';
import 'photo_page.dart';
import 'introduce_page.dart';

class SocialPage extends StatefulWidget {
  final double progress;

  const SocialPage({Key? key, required this.progress}) : super(key: key);

  @override
  SocialPageState createState() => SocialPageState();
}

class SocialPageState extends State<SocialPage> {
  final SignupController signupController = Get.put(SignupController());
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _controller1.addListener(_updateButtonState);
    _controller2.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonDisabled =
          _controller1.text.isEmpty && _controller2.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(
          value: widget.progress,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 249, 113, 95),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 32),
                      onPressed: () =>
                          Get.off(const IntroducePage(progress: 0.8)),
                    ),
                    TextButton(
                      child: const Text(
                        '건너뛰기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontFamily: 'Cafe24',
                        ),
                      ),
                      onPressed: () {
                        Get.to(const PhotoPage(
                          progress: 1.0,
                        ));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              const Center(
                  child: Text('SNS',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cafe24',
                      ))),
              const SizedBox(height: 30.0),
              SizedBox(
                width: 300,
                child: TextField(
                    controller: _controller1,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                      fontFamily: 'Cafe24',
                    ),
                    decoration: const InputDecoration(
                      hintText: '카카오톡 아이디를 입력하세요',
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 249, 113, 95),
                        ),
                      ),
                    ),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: 300,
                child: TextField(
                    controller: _controller2,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                      fontFamily: 'Cafe24',
                    ),
                    decoration: const InputDecoration(
                      hintText: '인스타그램 아이디를 입력하세요',
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 249, 113, 95),
                        ),
                      ),
                    ),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 50.0),
              ContinueButton(
                isFilled: !_isButtonDisabled,
                buttonText: 'CONTINUE',
                onPressed: !_isButtonDisabled
                    ? () {
                        SignupController.to.addKakaoId(_controller1.text);
                        SignupController.to.addInstagramId(_controller2.text);

                        Get.to(
                            PhotoPage(
                              progress: widget.progress + 0.1,
                            ),
                            transition: Transition.noTransition);
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
