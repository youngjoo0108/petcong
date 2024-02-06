import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<Uint8List?> getImageFromS3(String imageUrl) async {
  Uint8List? imageData;
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      imageData = response.bodyBytes;
    }
  } catch (error) {
    if (kDebugMode) {
      print("error");
      print(error.toString());
    }
    rethrow;
  }
  return imageData;
}
