// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class MainDogVideos extends StatefulWidget {
//   const MainDogVideos({super.key});

//   @override
//   State<MainDogVideos> createState() => _MainDogVideosState();
// }

// class _MainDogVideosState extends State<MainDogVideos> {
//   late VideoPlayerController _controller;
//   // var videoLink = 'https://www.youtube.com/shorts/34m1ouKBLr4';
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(
//         "https://firebasestorage.googleapis.com/v0/b/flutter-velog-sample.appspot.com/o/KEYCUTstock_preview_UK14030.mp4?alt=media&token=93f38e19-41f4-4aeb-b6bc-2df9ed9d135a&_gl=1*1o74ov2*_ga*MTMwNTY4NTMwLjE2ODAyNDU1OTc.*_ga_CW55HF8NVT*MTY5NzE4MTg5Ni4yNjkuMS4xNjk3MTgyNDQyLjU3LjAuMA"))
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : Container(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _controller.value.isPlaying
//                 ? _controller.pause()
//                 : _controller.play();
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }
// }
