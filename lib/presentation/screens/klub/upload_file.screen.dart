import 'dart:convert';
import 'dart:io';
import 'package:klub/application/tools/print.tool.dart';
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:klub/application/cubit/klub_cubit.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/presentation/widgets/klub_file_download.widget.dart';

const uploadFileUrl = "http://10.0.2.2:8080/api_test/file";

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UploadScreenState();
  }
}

class _UploadScreenState extends State<UploadScreen> {
  late bool isUploading;

  Future<String?> uploadFileToServer(String filename, String url) async {
    try {
      var request = MultipartRequest('POST', Uri.parse(url));
      request.files.add(await MultipartFile.fromPath('file', filename));

      var payload = {
        "isDir": false,
        "filename": filename,
        "fileType": "document",
        "parent": null
      };
      request.fields["data"] = jsonEncode(payload);
      var res = await request.send();
      return res.reasonPhrase;
    } catch (e) {
      logToConsole(e);
      return null;
    }
  }

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    logToConsole("Picking File");
    logToConsole(result);
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        isUploading = true;
      });
      await uploadFileToServer(file.path, uploadFileUrl);
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isUploading != true
              ? ElevatedButton(
                  onPressed: () {
                    uploadFile();
                  },
                  child: const Text('Upload File'),
                )
              : Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 50,
                    ),
                    Text("Veuillez Patienter")
                  ],
                )
        ],
      )),
    );
  }
}
