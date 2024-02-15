// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:petcong/widgets/continue_button.dart';
// import 'quiz.dart';
// import 'third_quiz.dart'; // ThirdQuizPage를 import하였습니다. 이동할 페이지에 맞게 변경해주세요.

// class SecondQuizPage extends StatefulWidget {
//   const SecondQuizPage({super.key});

//   @override
//   SecondQuizPageState createState() => SecondQuizPageState();
// }

// class SecondQuizPageState extends State<SecondQuizPage> {
//   final QuizManager quizManager = QuizManager();
//   bool _isButtonDisabled = true; // 버튼 활성화 상태를 저장하는 변수

//   SecondQuizPageState() {
//     quizManager.addQuiz(Quiz(question: '상대방 반려 동물의 나이는?', answer: ''));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('두 번째 퀴즈')),
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
//                 Get.to(const ThirdQuizPage()); // 다음 퀴즈 페이지로 이동
//               }
//             : null,
//       ),
//     );
//   }
// }
