import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petcong/controller/signup_controller.dart';
import 'package:petcong/pages/app_pages/profile/pet_name_page.dart';
import 'pet_gender_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';

class PetAgePage extends StatefulWidget {
  final String petName;
  final double progress;

  const PetAgePage({
    Key? key,
    required this.petName,
    required this.progress,
  }) : super(key: key);

  @override
  PetAgePageState createState() => PetAgePageState();
}

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue;
  }
}

class PetAgePageState extends State<PetAgePage> {
  final _controller = TextEditingController();
  final SignupController signupController = Get.put(SignupController());
  final numberValidator = ValueNotifier<String?>('Initial value');
  final double _progress = 0.5;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.trim();
      numberValidator.value =
          text.isEmpty ? 'Initial value' : _validateNumber(text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    numberValidator.dispose();
    super.dispose();
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '나이를 입력해주세요';
    }

    try {
      int.parse(value);
    } catch (e) {
      return '유효한 숫자가 아닙니다.';
    }

    return null;
  }

//TODO: change to age
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: () => Get.off(const PetNamePage(progress: 5 / 12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '${widget.petName}의 나이는?',
                    style: const TextStyle(
                        fontSize: 32.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: 200, // 원하는 너비를 설정합니다.
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '나이를 입력해주세요',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        NumberInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ValueListenableBuilder<String?>(
                    valueListenable: numberValidator,
                    builder: (context, value, child) {
                      return SizedBox(
                        child: ContinueButton(
                          isFilled: value ==
                              null, // value가 null인 경우에 버튼이 활성화되도록 수정합니다.
                          buttonText: 'CONTINUE',
                          onPressed:
                              value == null // value가 null인 경우에 버튼이 눌리도록 수정합니다.
                                  ? () {
                                      SignupController.to.addPetAge(10);
                                      Get.to(
                                          PetGenderPage(
                                            petName: widget.petName,
                                            progress: widget.progress + 0.1,
                                          ),
                                          transition: Transition.noTransition);
                                    }
                                  : null,
                        ),
                      );
                    },
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