import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:klub/application/cubit/klub_cubit.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/presentation/widgets/klub_file_download.widget.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UploadScreenState();
  }
}

class _UploadScreenState extends State<UploadScreen> {
  late bool isUploading;

  Future<String?> uploadFileToServer(filename, url) async {
    var request = MultipartRequest('POST', Uri.parse(url));
    request.files.add(await MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        isUploading = true;
      });
      await uploadFileToServer(file.path, "");
      setState(() {
        isUploading = false;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    isUploading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: ElevatedButton(
        onPressed: () {
          uploadFile();
        },
        child: const Text('Upload File'),
      )),
    );
  }
}
