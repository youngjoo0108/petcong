import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petcong/firebase_options.dart';
import 'package:petcong/pages/home_page.dart';
import 'package:petcong/services/my_image_picker.dart';
import 'package:petcong/widgets/display_image.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SelectAndDisplayImage(),
      ),
    );
  }
}

class SelectAndDisplayImage extends StatefulWidget {
  const SelectAndDisplayImage({super.key});

  @override
  _SelectAndDisplayImageState createState() => _SelectAndDisplayImageState();
}

class _SelectAndDisplayImageState extends State<SelectAndDisplayImage> {
  final picker = MyImagePicker();
  PickedFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _imageFile == null
            ? const Text('No image selected.')
            : DisplayImage(imagePath: _imageFile!.path),
        FloatingActionButton(
          onPressed: () async {
            final pickedFile = await picker.getImageFromGallery();
            if (pickedFile != null) {
              setState(() {
                _imageFile = pickedFile;
              });
            } else {
              print('No image selected');
            }
          },
          tooltip: 'Pick Image from Gallery',
          child: const Icon(Icons.photo_library),
        ),
        FloatingActionButton(
          onPressed: () async {
            final pickedFile = await picker.getImageFromCamera();
            if (pickedFile != null) {
              setState(() {
                _imageFile = pickedFile;
              });
            } else {
              print('No image selected');
            }
          },
          tooltip: 'Take a Photo',
          child: const Icon(Icons.camera_alt),
        ),
      ],
    );
  }
}
