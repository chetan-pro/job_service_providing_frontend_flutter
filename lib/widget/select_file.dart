// ignore_for_file: unused_import

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:image_cropper/image_cropper.dart';

Future selectFile({multi, allow}) async {
  if (!kIsWeb) {
    await checkPermission();
  }
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: multi ?? false,
    type: FileType.custom,
    allowedExtensions: allow ?? ['jpg', 'pdf', 'doc', 'png'],
  );
  return result;
}

Future selectFileweb() async {
  await checkPermission();
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'pdf', 'doc'],
  );
  return result;
}
