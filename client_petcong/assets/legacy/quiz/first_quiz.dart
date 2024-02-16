// // import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:petcong/widgets/continue_button.dart';
// import 'quiz.dart';
// import 'second_quiz.dart';

// class FirstQuizPage extends StatefulWidget {
//   const FirstQuizPage({super.key});

//   @override
//   FirstQuizPageState createState() => FirstQuizPageState();
// }

// class FirstQuizPageState extends State<FirstQuizPage> {
//   final QuizManager quizManager = QuizManager();
//   bool _isButtonDisabled = true; // 버튼 활성화 상태를 저장하는 변수

//   FirstQuizPageState() {
//     quizManager.addQuiz(Quiz(question: '상대방 반려 동물의 이름은?', answer: ''));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('첫 번째 퀴즈')),
//       body: ListView.builder(
//         itemCount: quizManager.getQuizCount(),
//         itemBuilder: (context, index) {
//           Quiz quiz = quizManager.getQuiz(index);

//           return ListTile(
//             title: Text('${quiz.question}의 정답은?'),
//             subtitle: TextField(
//               onChanged: (value) {
//                 setState(() {
//                   _isButtonDisabled = value.isEmpty; // 입력이 있으면 버튼 활성화
//                 });
//                 if (value == quiz.answer) {
//                   print('정답입니다!');
//                 } else {
//                   print('오답입니다. 정답은 ${quiz.answer}입니다.');
//                 }
//               },
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: ContinueButton(
//         isFilled: !_isButtonDisabled,
//         buttonText: 'CONTINUE',
//         onPressed: !_isButtonDisabled
//             ? () {
//                 Get.to(const SecondQuizPage());
//               }
//             : null,
//       ),
//     );
//   }
// }
