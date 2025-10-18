// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showAttachmentOptions(
  BuildContext context,
  photoGallery,
  photoCamera,
  remove,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext bc) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery (Photo)'),
              onTap: () {
                Navigator.pop(context);
                photoGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera (Photo)'),
              onTap: () {
                Navigator.pop(context);
                photoCamera();
              },
            ),

            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Colors.red[700],
              ), // Use a distinct color
              title: Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red[700]),
              ),
              onTap: () {
                Navigator.of(context).pop();
                remove();
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<File?>? takePhotoWithCamera() async {
  XFile? file = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 90,
  );

  File imageFile = File(file!.path);
  return (imageFile);
}

Future<File?>? takePhotoWithGallery() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    return File(result.files.single.path!);
  } else {
    return null;
  }
}

Future<void> recordVideoWithCamera(BuildContext context) async {
  final XFile? video = await ImagePicker().pickVideo(
    source: ImageSource.camera,
  );
  if (video != null) {
    handlePickedFile(context, File(video.path));
  } else {
    print('User cancelled camera video');
  }
}

Future<void> pickFile(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'pdf', 'doc', 'png'], // Optional
  );

  if (result != null && result.files.single.path != null) {
    handlePickedFile(context, File(result.files.single.path!));
  } else {
    print('User cancelled file picking');
  }
}

// --- Handle the picked file (upload/send) ---
Future<void> handlePickedFile(BuildContext context, File file) async {
  print('Picked file: ${file.path}');

  try {
    print("Simulating upload for: ${file.path}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sending ${file.path.split('/').last}...')),
    );
    await Future.delayed(const Duration(seconds: 1));
    print("Upload successful (simulated)");
  } catch (e) {
    print("Error handling picked file: $e");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error processing file: $e')));
  }
}
