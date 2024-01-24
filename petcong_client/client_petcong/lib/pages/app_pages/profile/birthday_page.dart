import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gender_page.dart';
import 'nickname_page.dart';

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
    return ProgressProvider(
      progress: widget.progress,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NicknamePage(),
                ),
              );
            },
          ),
          title: LinearProgressIndicator(value: widget.progress),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Text(
                  '내 생일은?',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextFormField(
                  controller: _controller,
                  inputFormatters: [_inputFormatter],
                  decoration: const InputDecoration(hintText: 'YYYY/MM/DD'),
                  onChanged: (value) {
                    setState(() {
                      _validateDate(value);
                    });
                  },
                  validator: (value) => _errorMessage,
                ),
                ElevatedButton(
                  onPressed:
                      _controller.text.isNotEmpty && _errorMessage == null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenderPage(
                                    progress:
                                        ProgressProvider.of(context)!.progress +
                                            1 / 10,
                                  ),
                                ),
                              );
                            }
                          : null,
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
