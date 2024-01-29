import 'package:flutter/material.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:petcong/widgets/create_button.dart';
import 'package:petcong/widgets/delete_button.dart';
import 'media_page.dart';
import 'dart:io';
import 'icebreak_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

// 이미지를 선택하고 화면에 표시되는 기능
class DisplayVideo extends StatefulWidget {
  final String videoPath;

  const DisplayVideo({Key? key, required this.videoPath}) : super(key: key);

  @override
  _DisplayVideoState createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<DisplayVideo> {
  late VideoPlayerController _controller;
  late String _currentVideoPath;

  @override
  void initState() {
    super.initState();
    _currentVideoPath = widget.videoPath;
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(DisplayVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateVideoPathIfNeeded();
  }

  void _updateVideoPathIfNeeded() async {
    if (widget.videoPath != _currentVideoPath) {
      _controller.dispose();
      _controller = VideoPlayerController.file(File(widget.videoPath));
      await _controller.initialize();
      setState(() {
        _currentVideoPath = widget.videoPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: _controller.value.isInitialized
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class VideoPage extends StatefulWidget {
  final double progress;

  const VideoPage({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late double _progress;
  final List<String> _videoPaths = []; // 선택한 비디오들의 경로를 저장하는 리스트

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  Future<void> navigateToMediaPage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoPaths.add(pickedFile.path);
      });
    } else {
      print('No video selected.');
    }
  }

  void deleteImage(int index) {
    setState(() {
      _videoPaths.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _progress);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: LinearProgressIndicator(
            value: _progress,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 234, 64, 128),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 32),
                    onPressed: () => Navigator.pop(context, _progress),
                  ),
                  TextButton(
                    child: const Text(
                      '건너뛰기',
                      style: TextStyle(
                          fontSize: 18, color: Colors.grey), // 여기에서 색상을 변경했습니다.
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IcebreakPage(
                            progress: _progress + 0.1, // 여기에서 1/10을 더해줍니다.
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 234, 64, 128),
                            Color.fromARGB(255, 238, 128, 95)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: const Text(
                          '개 인기',
                          style: TextStyle(
                            fontSize: 32.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        ' 영상 첨부',
                        style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0), // 원하는 간격을 추가합니다.
                  const Text(
                    // 새로운 텍스트를 추가합니다.
                    '나의 반려견의 개인기 영상을 첨부해주세요',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 250,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0, // 간격을 증가시켰습니다.
                  mainAxisSpacing: 0.0, // 간격을 증가시켰습니다.
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index < _videoPaths.length) {
                    // 영상이 선택되었다면 해당 영상을 표시하고 '-' 버튼을 추가합니다.
                    return Padding(
                      key:
                          Key(_videoPaths[index]), // 각 Padding에 고유한 Key를 할당합니다.
                      padding:
                          const EdgeInsets.all(10.0), // 각 그리드 아이템에 패딩을 추가합니다.
                      child: Stack(
                        clipBehavior: Clip.none, // 이 줄을 추가했습니다.
                        children: [
                          DisplayVideo(
                              videoPath: _videoPaths[index]), // 여기를 수정했습니다.
                          Positioned(
                            bottom: -8,
                            right: -8,
                            child: RoundGradientXButton(
                              onTap: () => deleteImage(index),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // 아직 영상이 선택되지 않았다면 '+' 버튼을 표시합니다.
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GridWithPlusButton(
                          onTap: () => navigateToMediaPage(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 30.0), // 원하는 간격을 추가합니다.
                  ContinueButton(
                    isFilled:
                        _videoPaths.length >= 2, // 사진이 두 장 이상 추가되었는지 확인합니다.
                    buttonText: 'CONTINUE',
                    onPressed: _videoPaths.length >= 2
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IcebreakPage(
                                  progress:
                                      _progress + 0.1, // 여기에서 1/10을 더해줍니다.
                                ),
                              ),
                            );
                          }
                        : null,
                    width: 300.0, // 원하는 가로 길이를 설정
                    height: 30.0, // 원하는 세로 길이를 설정
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

class GridWithPlusButton extends StatelessWidget {
  final VoidCallback onTap;

  const GridWithPlusButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          right: -5,
          child: RoundGradientPlusButton(onTap: onTap),
        ),
      ],
    );
  }
}
