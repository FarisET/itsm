import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart' as picker;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    try {
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Convert XFile to File
        File file = File(pickedFile.path);
        return file;
      } else {
        return null;
      }
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  Future<File?> pickImageFromCamera() async {
    try {
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        // Convert XFile to File
        File file = File(pickedFile.path);
        return file;
      } else {
        return null;
      }
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  Future<File?> imageToMemoryFile(ui.Image image) async {
    // Convert the Image to a Uint8List
    final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png); // Ensure to get PNG data
    if (byteData == null) {
      print('Error: ByteData is null');
      return null;
    }

    final Uint8List uint8List = byteData.buffer.asUint8List();
    print(
        'uint8List length: ${uint8List.length}'); // Print length to ensure it has data

    // Convert the Uint8List to an Image
    img.Image? imgData;
    try {
      imgData = img.decodePng(uint8List); // Ensure the format is PNG
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }

    if (imgData == null) {
      print('Error: Failed to decode image');
      return null;
    }

    // Get the temporary directory path
    final tempDir = await getTemporaryDirectory();
    if (tempDir == null) {
      print('Error: Temporary directory not accessible');
      return null;
    }
    final tempPath = tempDir.path;

    // Create a File from the Image
    final File file =
        File('$tempPath/image.png'); // Ensure file extension matches format

    // Write the image data to the file
    try {
      await file
          .writeAsBytes(img.encodePng(imgData)); // Ensure to encode as PNG
    } catch (e) {
      print('Error writing image to file: $e');
      return null;
    }

    return file;
  }
}
