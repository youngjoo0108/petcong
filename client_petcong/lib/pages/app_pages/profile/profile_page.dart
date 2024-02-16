import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/constants/style.dart';
import 'package:petcong/controller/profile_controller.dart';
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
                              return CachedNetworkImage(
                                imageUrl: imgUrl,
                                fit: BoxFit.cover,
                                // placeholder: (context, url) =>
                                //     const CircularProgressIndicator(
                                //   color: MyColor.myColor1,
                                // ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              );
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
                        Get.to(const NicknamePage(progress: 0.1));
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
                              color: Color.fromARGB(255, 171, 158, 158),
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
                    String nickname =
                        member?.memberInfo?.nickname ?? 'no response';
                    int age = member?.memberInfo?.age ?? 0;

                    return Text(
                      '$nickname, $age',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Cafe24'),
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
                child: MixinBuilder<ProfileController>(builder: (controller) {
                  MemberProfile? member =
                      controller.profile.value.memberProfile;
                  int pictureCount = member?.memberImgInfosList?.length ?? 0;
                  List<MemberImgInfosList> pictureUrls =
                      member?.memberImgInfosList ?? [];
                  if (pictureCount < 2) {
                    return Container();
                  }
                  return Container(
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
                              for (int i = 1; i < pictureCount; i++)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
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
                                          child: Image.network(
                                            pictureUrls[i].bucketKey ?? '',
                                            fit: BoxFit.cover,
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
                        MixinBuilder<ProfileController>(
                          builder: (controller) {
                            PetProfile? pet =
                                controller.profile.value.petProfile;
                            String description =
                                pet?.petInfo?.description ?? '';
                            if (description == '') {
                              return Container();
                            }
                            return Container(
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
                              child: Center(
                                child: Text(description,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cafe24')),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
