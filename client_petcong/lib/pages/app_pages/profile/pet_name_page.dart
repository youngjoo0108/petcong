import 'package:flutter/material.dart';
import 'package:petcong/controller/signup_controller.dart';
import 'pet_age_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';
import 'prefer_page.dart';

class PetNamePage extends StatefulWidget {
  final double progress;

  const PetNamePage({Key? key, required this.progress}) : super(key: key);

  @override
  PetNamePageState createState() => PetNamePageState();
}

class PetNamePageState extends State<PetNamePage> {
  final SignupController signupController = Get.put(SignupController());
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
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: () => Get.off(const PreferPage(progress: 0.4)),
              ),
            ),
            const SizedBox(height: 5.0),
            const Center(
                child: Text('내 반려동물 이름은?',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cafe24',
                    ))),
            const SizedBox(height: 30.0),
            SizedBox(
              width: 300,
              child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                    fontFamily: 'Cafe24',
                  ),
                  decoration: const InputDecoration(
                    hintText: '반려동물 이름을 입력하세요',
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
            const SizedBox(
              height: 30.0,
            ),
            ContinueButton(
              isFilled: !_isButtonDisabled,
              buttonText: 'CONTINUE',
              onPressed: !_isButtonDisabled
                  ? () {
                      SignupController.to.addPetName(_controller.text.trim());
                      Get.to(
                          PetAgePage(
                            petName: _controller.text,
                            progress: widget.progress + 0.1,
                          ),
                          transition: Transition.noTransition);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
