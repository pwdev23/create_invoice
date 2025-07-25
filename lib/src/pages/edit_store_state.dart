import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

const kLogoPng = 'logo.png';

Future<File> saveImage(File image) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/$kLogoPng';
  return image.copy(path);
}

Future<void> pickImage(Function(Uint8List)? onBytes) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final savedImage = await saveImage(File(pickedFile.path));
    final bytes = await savedImage.readAsBytes();
    onBytes!(bytes);
  }
}

Future<void> loadImage(Function(Uint8List)? onBytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/$kLogoPng';
  if (File(imagePath).existsSync()) {
    final bytes = await File(imagePath).readAsBytes();
    onBytes!(bytes);
  }
}

Future<void> removeImage() async {
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/$kLogoPng';
  final file = File(imagePath);

  if (file.existsSync()) {
    await file.delete();
  }
}
