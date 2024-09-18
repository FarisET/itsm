import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> saveImageTempLocally(File imageFile) async {
  final directory = await getApplicationDocumentsDirectory();
  final imagesDir = Directory('${directory.path}/temp_images');

  if (!await imagesDir.exists()) {
    await imagesDir.create(recursive: true);
  }

  String originalFileName = imageFile.path.split('/').last;
  String nameWithoutExtension =
      originalFileName.replaceAll(RegExp(r'\.[^\.]+$'), '');
  String extension = originalFileName.split('.').last;

  int counter = 1;
  String fileName;
  String savedImagePath;

  do {
    fileName = '($counter)$nameWithoutExtension.$extension';
    savedImagePath = '${imagesDir.path}/$fileName';
    counter++;
  } while (await File(savedImagePath).exists());

  try {
    await imageFile.copy(savedImagePath);
    print('Image saved to $savedImagePath');
    return savedImagePath;
  } catch (e) {
    print('Error saving image: $e');
    rethrow;
  }
}

// Future<void> deleteTempImages() async {
//   final directory = await getApplicationDocumentsDirectory();
//   final imagesDir = Directory('${directory.path}/temp_images');

//   if (await imagesDir.exists()) {
//     await imagesDir.delete(recursive: true);
//   }
// }

Future<void> deleteTempImage(String imagePath) async {
  try {
    await File(imagePath).delete();
    ('Image deleted from $imagePath');
  } catch (e) {
    print('Error deleting image: $e');
  }
}
