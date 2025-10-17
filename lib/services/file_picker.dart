import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<File?> pickDatabaseFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['sqlite', 'db'],
  );

  if (result != null && result.files.single.path != null) {
    return File(result.files.single.path!);
  }

  return null;
}
