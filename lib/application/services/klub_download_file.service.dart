import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:klub/application/tools/print.tool.dart';
import 'package:klub/data/models/klub_download.model.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/data/repositories/klub-api.repository.dart';
import 'package:path_provider/path_provider.dart';

final dio = Dio();

Future<String> getFilePath(uniqueFileName) async {
  String path = '';

  Directory dir = await getApplicationDocumentsDirectory();

  path = '${dir.path}/$uniqueFileName';

  return path;
}

class KlubDownloadFileService {
  final StreamController<String> _successController =
      StreamController<String>();
  final StreamController<int> _progressController = new StreamController<int>();

  final KlubFile file;
  final int position;
  final String blocGroupRef;
  late Timer? downloadTimer;
  bool canContinue = true;
  bool hasData = false;
  int? progress;
  bool started = false;
  late int? downloadTaskId;
  final KlubApiRepository klubApiRepository;

  KlubDownloadFileService(
      this.klubApiRepository, this.file, this.position, this.blocGroupRef) {
    downloadTaskId = null;
    downloadTimer = null;
    progress = null;
  }

  void start() {
    logToConsole("[KlubDownloadFileService] Start download for ${position}");

    started = true;
    _handleFileDownloadChunk(file, position, blocGroupRef);
  }

  _handleFileDownloadChunk(
      KlubFile file, int position, String blocGroupRef) async {
    while (!(hasData && canContinue)) {
      if (downloadTaskId == null) {
        downloadTaskId = await klubApiRepository.initBlocDownload(blocGroupRef);
        logToConsole(
            "[DOWNLOAD FILE ${file.filename} $position $canContinue] download task init success");
      }

      KlubDownload? task;
      logToConsole(
          "[DOWNLOAD FILE ${file.filename} $position $canContinue] Trying to get the doxnload tasks updated");

      task = await klubApiRepository.getDownloadById(downloadTaskId!);
      //Task not found
      if (task == null) {
        logToConsole(
            "[DOWNLOAD FILE ${file.filename} $position $canContinue] Download File Task - No download task found");
      } else {
        //Task exists but no data yet
        if (task.hasData == false) {
          canContinue = true;
          hasData = false;
          logToConsole(
              "[DOWNLOAD FILE ${file.filename} $position $canContinue] Download File Task - Data not completed yet");
        } else {
          //Our task has been completed
          //_updateCurrentDownload(file, blocGroupRef, position, task.data!);
          var savePath = await getFilePath("download_$position.data");
          canContinue = false;
          hasData = false;
          await dio.download(
              "http://10.0.2.2:8084/api/downloads/0c70a469-bb66-4f05-a7c3-8362b4ff873e/download",
              savePath, onReceiveProgress: (rec, total) {
            var download = (rec / total) * 100;
            progress = download.toInt();

            _progressController.add(progress!);
            logToConsole(
                "[DOWNLOAD FILE ${file.filename} $position $canContinue] Percentage $download [$rec | $total]");
          });
          _successController.add(savePath);

          logToConsole(
              "[DOWNLOAD FILE ${file.filename} $position $canContinue] Download File Task - Got Data");
          await klubApiRepository.deleteDownloadById(downloadTaskId!);
          logToConsole(
              "[DOWNLOAD FILE ${file.filename} $position $canContinue] Download File Task - task deleted");
          break;
        }
      }

      //Just wait for a minute
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  _stopTimer() {
    canContinue = false;
    downloadTimer?.cancel();
  }

  Stream<String> onSuccess() {
    return _successController.stream;
  }

  Stream<int> onProgress() {
    return _progressController.stream;
  }

  void clean() {
    _successController.close();
    _progressController.close();
    downloadTimer?.cancel();
  }
}
