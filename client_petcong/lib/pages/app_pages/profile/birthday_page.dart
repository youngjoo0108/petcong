import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petcong/controller/signup_controller.dart';
import 'gender_page.dart';
import 'nickname_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';

class ProgressProvider extends InheritedWidget {
  final double progress;

  const ProgressProvider({
    Key? key,
    required this.progress,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ProgressProvider oldWidget) {
    return progress != oldWidget.progress;
  }

  static ProgressProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProgressProvider>();
  }
}

class BirthdayPage extends StatefulWidget {
  final double progress;

  const BirthdayPage({Key? key, required this.progress}) : super(key: key);

  @override
  BirthdayPageState createState() => BirthdayPageState();
}

class BirthdayPageState extends State<BirthdayPage> {
  final Color _color = Colors.transparent;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final SignupController signupController = Get.put(SignupController());

  String? _errorMessage;

  final _inputFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    // 새로운 값이 기존 값보다 짧고, 새로운 값의 마지막 문자가 '-'가 아닌 경우
    if (newValue.text.length < oldValue.text.length &&
        !newValue.text.endsWith('-')) {
      // 기존 값의 마지막 문자가 '-'인 경우
      if (oldValue.text.endsWith('-')) {
        return TextEditingValue(
          text: newValue.text.substring(0, newValue.text.length - 1),
          selection: TextSelection.collapsed(offset: newValue.text.length - 1),
        );
      }
    }

    if (newValue.text.length == 4 || newValue.text.length == 7) {
      if (!newValue.text.endsWith('-')) {
        return TextEditingValue(
          text: '${newValue.text}-',
          selection: TextSelection.collapsed(offset: newValue.text.length + 1),
        );
      }
    }
    return newValue;
  });

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      _errorMessage = '생년월일을 입력해주세요!';
      return _errorMessage;
    }
    const datePattern = r'^(\d{4})\-(\d{2})\-(\d{2})$';
    final match = RegExp(datePattern).firstMatch(value);
    if (match == null) {
      _errorMessage = '유효한 날짜 형식이 아닙니다 (YYYY-MM-DD)';
      return _errorMessage;
    }

    try {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      if (month < 1 || month > 12 || day < 1 || day > 31) {
        _errorMessage = '유효한 날짜가 아닙니다.';
        return _errorMessage;
      }
      if (day == 31 &&
          (month == 2 ||
              month == 4 ||
              month == 6 ||
              month == 9 ||
              month == 11)) {
        _errorMessage = '유효한 날짜가 아닙니다.';
        return _errorMessage;
      }
      if (month == 2 && day > 29) {
        _errorMessage = '유효한 날짜가 아닙니다.';
        return _errorMessage;
      }
      if (month == 2 && day == 29 && year % 4 != 0) {
        _errorMessage = '유효한 날짜가 아닙니다.';
        return _errorMessage;
      }
    } catch (e) {
      _errorMessage = '유효한 날짜가 아닙니다.';
      return _errorMessage;
    }

    _errorMessage = null;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.2;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(
          value: progress,
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
                onPressed: () => Get.off(const NicknamePage(progress: 0.1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      '내 생일은?',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cafe24',
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_inputFormatter],
                        decoration: InputDecoration(
                          hintText: 'YYYY-MM-DD',
                          filled: true,
                          fillColor: _color,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 249, 113, 95)),
                          ),
                        ),
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w400),
                        onChanged: (value) {
                          setState(() {
                            _validateDate(value);
                          });
                        },
                        validator: _validateDate,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ContinueButton(
                        isFilled: _controller.text.isNotEmpty &&
                            _errorMessage == null,
                        buttonText: 'CONTINUE',
                        onPressed: _controller.text.isNotEmpty &&
                                _errorMessage == null
                            ? () {
                                SignupController.to
                                    .addBirthdayAndAge(_controller.text.trim());
                                Get.to(
                                    GenderPage(
                                      progress: widget.progress + 0.1,
                                    ),
                                    transition: Transition.noTransition);
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
