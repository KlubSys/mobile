import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klub/application/cubit/klub_cubit.dart';
import 'package:klub/application/services/klub_download_file.service.dart';
import 'package:klub/application/tools/print.tool.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/data/repositories/klub-api.repository.dart';

class KlubFileDownloadComponent extends StatefulWidget {
  final FileDownloadProcess process;
  final Function onSuccess;

  const KlubFileDownloadComponent(
      {super.key, required this.process, required this.onSuccess});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _KlubFileDownloadComponentState();
  }
}

class _KlubFileDownloadComponentState extends State<KlubFileDownloadComponent> {
  late KlubApiRepository _klubApiRepository;

  late int progress;

  @override
  void initState() {
    progress = 0;

    if (widget.process.downloadFileService.started == false) {
      //Subscribe tO download PROGRESS
      widget.process.downloadFileService.onProgress().listen((p) {
        logToConsole(
            "[Download Service ${widget.process.file.filename} | ${widget.process.position} ]Progress $p");
        setState(() {
          progress = p;
        });
      });
      widget.process.downloadFileService.onSuccess().listen((path) {
        logToConsole("Path $path");
        widget.onSuccess(path, widget.process.file, widget.process.position);
      });
      widget.process.downloadFileService.start();
    } else {
      progress = widget.process.downloadFileService.progress ?? 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              (progress != 100) ? Icons.download : Icons.download_done,
              color: (progress != 100) ? Colors.indigo : Colors.greenAccent,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Part ${widget.process.position}-${widget.process.file.filename}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.indigo),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.process.file.fileType} | 4 min ",
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      "$progress %",
                      style: TextStyle(fontSize: 10),
                    ),
                    (progress != 100) ? CircularProgressIndicator() : Text("")
                  ],
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Divider()
      ],
    );
  }
}
