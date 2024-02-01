import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gender_page.dart';
import 'nickname_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';
import 'package:petcong/controller/user_controller.dart';

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
  _BirthdayPageState createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String? _errorMessage;

  final _inputFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    // 새로운 값이 기존 값보다 짧고, 새로운 값의 마지막 문자가 '/'가 아닌 경우
    if (newValue.text.length < oldValue.text.length &&
        !newValue.text.endsWith('/')) {
      // 기존 값의 마지막 문자가 '/'인 경우
      if (oldValue.text.endsWith('/')) {
        return TextEditingValue(
          text: newValue.text.substring(0, newValue.text.length - 1),
          selection: TextSelection.collapsed(offset: newValue.text.length - 1),
        );
      }
    }

    if (newValue.text.length == 4 || newValue.text.length == 7) {
      if (!newValue.text.endsWith('/')) {
        return TextEditingValue(
          text: '${newValue.text}/',
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
    const datePattern = r'^(\d{4})\/(\d{2})\/(\d{2})$';
    final match = RegExp(datePattern).firstMatch(value);
    if (match == null) {
      _errorMessage = '유효한 날짜 형식이 아닙니다 (YYYY/MM/DD)';
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
    double progress = 0.1;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(
          value: progress,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 234, 64, 128),
          ),
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
                onPressed: () => Get.off(const NicknamePage(progress: 0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      '내 생일은?',
                      style: TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: 200, // 원하는 너비 설정
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_inputFormatter],
                        decoration:
                            const InputDecoration(hintText: 'YYYY/MM/DD'),
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w400),
                        onChanged: (value) {
                          print("onChanged event triggered");
                          // 상태 업데이트 및 에러 메시지 초기화
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0), // 위 아래로 패딩 6 추가
                      child: ContinueButton(
                        isFilled: _controller.text.isNotEmpty &&
                            _errorMessage == null,
                        buttonText: 'CONTINUE',
                        onPressed: _controller.text.isNotEmpty &&
                                _errorMessage == null
                            ? () {
                                // 'CONTINUE' 버튼을 누르면 입력한 생년월일을 날짜 형식으로 변환하고, 만 나이를 계산하여 UserController의 birthday와 age에 저장
                                DateTime? birthdayDate =
                                    _convertToDate(_controller.text);
                                if (birthdayDate != null) {
                                  UserController userController =
                                      Get.find(); // UserController의 인스턴스 가져오기
                                  userController.birthday =
                                      "${birthdayDate.toLocal()}".split(' ')[0];
                                  int age =
                                      userController.calculateAge(); // 만 나이 계산
                                  userController.age = age; // 만 나이를 age에 저장
                                }

                                // 그 후에 GenderPage로 이동합니다.
                                Get.to(GenderPage(
                                  progress: widget.progress + 1 / 10,
                                ));
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

DateTime? _convertToDate(String input) {
  try {
    List<String> dateParts = input.split('/');
    return DateTime.parse('${dateParts[0]}-${dateParts[1]}-${dateParts[2]}');
  } catch (e) {
    print("Error in _convertToDate: $e"); // 변환 중 에러가 발생했음을 출력
    return null;
  }
}
