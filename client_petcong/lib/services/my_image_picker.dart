import 'package:image_picker/image_picker.dart';

// 갤러리에서 선택, 카메라로 촬영할 때의 케이스 모두 적용
class MyImagePicker {
  final ImagePicker _picker = ImagePicker();

  Future<PickedFile?> getImageFromGallery() async {
    final PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    return pickedFile;
  }

  Future<PickedFile?> getImageFromCamera() async {
    final PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );
    return pickedFile;
  }
}
