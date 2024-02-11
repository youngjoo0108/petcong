import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/controller/profile_controller.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/profile_page_model.dart';
import 'package:petcong/pages/app_pages/profile/nickname_page.dart';
import 'package:petcong/services/user_service.dart';

import 'media_page.dart';

class MainProfilePage extends StatelessWidget {
  const MainProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          MyColor.petCongColor3.withOpacity(0.6),
                          MyColor.petCongColor4,
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 6,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        // GestureDetector 위젯 추가
                        onTap: () {
                          Get.to(const MediaPage()); // 이미지를 클릭하면 MediaPage로 이동
                        },
                        child: ClipOval(
                          child: MixinBuilder<ProfileController>(
                            builder: (controller) {
                              MemberProfile? member =
                                  controller.profile.value.memberProfile;
                              String imgUrl =
                                  member?.memberImgInfosList?[0].bucketKey ??
                                      "";
                              if (imgUrl != "") {
                                getPicture(imgUrl).then((url) {
                                  imgUrl = url;
                                });
                              }
                              return Image.network(imgUrl);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const NicknamePage(progress: 1 / 12));
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: const ShapeDecoration(
                          // color: MyColor.myColor4.withOpacity(0.7),
                          color: Colors.white,
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: MixinBuilder<ProfileController>(
                  builder: (controller) {
                    MemberProfile? member =
                        controller.profile.value.memberProfile;
                    PetProfile? pet = controller.profile.value.petProfile;
                    String nickname =
                        member?.memberInfo?.nickname ?? 'no response';
                    int age = member?.memberInfo?.age ?? 0;

                    return Text(
                      '${nickname}, ${age}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Container(
                  // color: const Color.fromRGBO(238, 237, 235, 1),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                // GestureDetector 위젯 추가
                                onTap: () {
                                  Get.to(
                                      const MediaPage()); // 클릭 이벤트 발생 시 MediaPage로 이동
                                },
                                child: Container(
                                  width: 130,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                        child: Image.asset(
                                          'assets/src/test_4.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                // GestureDetector 위젯 추가
                                onTap: () {
                                  Get.to(
                                      const MediaPage()); // 클릭 이벤트 발생 시 MediaPage로 이동
                                },
                                child: Container(
                                  width: 130,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                        child: Image.asset(
                                          'assets/src/test_5.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                // GestureDetector 위젯 추가
                                onTap: () {
                                  Get.to(
                                      const MediaPage()); // 클릭 이벤트 발생 시 MediaPage로 이동
                                },
                                child: Container(
                                  width: 130,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                        child: Image.asset(
                                          'assets/src/test_1.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                // GestureDetector 위젯 추가
                                onTap: () {
                                  Get.to(
                                      const MediaPage()); // 클릭 이벤트 발생 시 MediaPage로 이동
                                },
                                child: Container(
                                  width: 130,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                        child: Image.asset(
                                          'assets/src/test_3.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                // GestureDetector 위젯 추가
                                onTap: () {
                                  Get.to(
                                      const MediaPage()); // 클릭 이벤트 발생 시 MediaPage로 이동
                                },
                                child: Container(
                                  width: 130,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                        child: Image.asset(
                                          'assets/src/test_2.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                // GestureDetector 위젯 추가
                                onTap: () {
                                  Get.to(
                                      const MediaPage()); // 여기를 클릭하면 MediaPage로 이동
                                },
                                child: Container(
                                  width: 130,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        MyColor.petCongColor3,
                                        MyColor.petCongColor4.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Add Picture',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 350,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              MyColor.petCongColor3,
                              MyColor.petCongColor4.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: GetBuilder<UserController>(
                          builder: (controller) {
                            // TextEditingController를 다이얼로그 밖에서 선언
                            final textEditingController = TextEditingController(
                                text: controller.introText);

                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  // 텍스트를 편집할 수 있는 다이얼로그 표시
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('자기소개 편집'),
                                        content: TextField(
                                          controller: textEditingController,
                                          decoration: const InputDecoration(
                                              hintText: '자기소개를 입력하세요'),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('취소'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('확인'),
                                            onPressed: () {
                                              // 확인 버튼을 누르면 TextEditingController의 값을 가져와서 updateIntroText 호출
                                              controller.updateIntroText(
                                                  textEditingController.text);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  controller.introText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
