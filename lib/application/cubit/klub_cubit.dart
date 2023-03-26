import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:klub/application/services/klub_download_file.service.dart';
import 'package:klub/application/services/klub_download_task.service.dart';
import 'package:klub/application/tools/print.tool.dart';
import 'package:klub/data/models/klub_bloc.model.dart';
import 'package:klub/data/models/klub_download.model.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/data/repositories/klub-api.repository.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

part 'klub_state.dart';

class KlubCubit extends Cubit<KlubState> {
  final KlubApiRepository _klubApiRepository;
  late KlubDownloadTaskService _downloadTaskService;
  late Timer _loadDownloadTaskstimer;
  late Timer _loadBlocstimer;
  List<KlubDownloadFileService> downloadFileServices =
      List.empty(growable: true);

  //bloc group ref - file paths
  final HashMap<String, String> currentDownloadDataPaths = HashMap();
  //position - bloc group ref
  final HashMap<int, String> currentDownloadDataPositions = HashMap();

  KlubCubit(this._klubApiRepository) : super(KlubInitial()) {
    init();

    _downloadTaskService = KlubDownloadTaskService(
        klubApiRepository: _klubApiRepository, klubCubit: this);
    _loadDownloadTaskstimer =
        Timer.periodic(const Duration(seconds: 3), (Timer t) {
      loadDownloadTasks();
    });

    _loadBlocstimer =
        Timer.periodic(const Duration(seconds: 3), (Timer t) {
      loadBlocs();
    });
  }

  init() async {
    loadFiles();
    loadBlocs();
    loadDownloadTasks();
  }

  void loadFiles() async {
    try {
      var files = await _klubApiRepository.getFiles();
      emit(state.copyWith(files: [...files]));
    } catch (e) {
      logToConsole(e);
    }
  }

  void loadBlocs() async {
    try {
      var blocs = await _klubApiRepository.getBlocs();
      emit(state.copyWith(blocs: [...blocs]));
    } catch (e) {
      logToConsole(e);
    }
  }

  void loadDownloadTasks() async {
    try {
      var tasks = await _klubApiRepository.getDownloadTasks();
      for (var t in tasks) {
        _downloadTaskService.addTask(t);
        logToConsole("Adding Task to service");
      }
      emit(state.copyWith(blocRequestsTasks: [...tasks]));
    } catch (e) {
      logToConsole(e);
    }
  }

  //-- [BEGIN] Download a file
  recomposeFile(KlubFile file) async {
    if (currentDownloadDataPaths.length == file.dataBlocCount) {
      //Create a file
      var dir = (await getExternalStorageDirectories(
              type: StorageDirectory.downloads))!
          .first;
      //await getApplicationDocumentsDirectory();
      final recomposedFile = File('${dir.path}/${file.filename}');
      //var recomposedFileWriter = recomposedFile.;
      for (var position = 1; position <= file.dataBlocCount; position++) {
        var ref = currentDownloadDataPositions[position];
        var path = currentDownloadDataPaths[ref];

        var file = File(path!);
        var content = file.readAsBytesSync();
        await recomposedFile.writeAsBytes(content, mode: FileMode.append);
        //recomposedFileWriter.write(content);
      }

      //await recomposedFileWriter.flush();
      //await recomposedFileWriter.close();
      logToConsole(
          "[DOWNLOAD FILE ${file.filename}] Download finished ${recomposedFile.absolute.path}");
    } else {}
  }

  final _lock = Lock(reentrant: true);
  updateCurrentDownloadSuccess(KlubFile file, int position, String path) async {
    await _lock.synchronized(() {
      logToConsole("[DOWNLOAD FILE ${file.filename}] $position finished");
      var ref = currentDownloadDataPositions[position];
      if (ref != null) {
        currentDownloadDataPaths[ref] = path;
        logToConsole("[DOWNLOAD FILE ${file.filename}] $position Path setted");
      } else {
        logToConsole(
            "[DOWNLOAD FILE ${file.filename}] $position failed ref not found");
      }

      logToConsole(
          "[DOWNLOAD FILE ${file.filename}] Data Length ${currentDownloadDataPaths.length}");

      if (currentDownloadDataPaths.length == file.dataBlocCount) {
        logToConsole(
            "[DOWNLOAD FILE ${file.filename}] All Blocs have been downloaded");
        recomposeFile(file);
      }
    });
  }

  void startDownload(KlubFile file) async {
    try {
      if (file.firstBlockGroupId == null) {
        logToConsole("File was not processed");
        return;
      }
      String currentBlockGroupRef = file.firstBlockGroupId!;
      List<String> blocGroupRefs = List.of([]);
      int position = 1;
      List<FileDownloadProcess> pss = List.of([]);

      for (var i = 1; i <= file.dataBlocCount; i++) {
        currentDownloadDataPositions.putIfAbsent(
            position, () => currentBlockGroupRef);

        var d = KlubDownloadFileService(
            _klubApiRepository, file, position, currentBlockGroupRef);
        FileDownloadProcess ps =
            FileDownloadProcess(file, position, currentBlockGroupRef, d);
        pss.add(ps);
        //emit(state.copyWith(filesDownloads: [ps, ...state.filesDownloads]));

        position += 1;
        //Get the next bloc group
        var ref =
            await _klubApiRepository.getNextBlocGroupRef(currentBlockGroupRef);
        if (ref != null) {
          logToConsole(
              "[DOWNLOAD FILE ${file.filename}] Found next bloc group Ref $ref");
          blocGroupRefs.add(ref);
          currentBlockGroupRef = ref;
        } else {
          logToConsole(
              "[DOWNLOAD FILE ${file.filename}] No next bloc group Ref $ref");
          break;
        }
      }

      emit(state.copyWith(filesDownloads: [...pss, ...state.filesDownloads]));

      logToConsole(
          "[DOWNLOAD FILE ${file.filename}] Total download refs: ${currentDownloadDataPositions.length}");

      //Got next bloc group ref
    } catch (e) {
      logToConsole(e);
    }
  }
  //-- [END] Download a file

  @override
  Future<void> close() {
    _downloadTaskService.clean();
    _loadDownloadTaskstimer.cancel();
    downloadFileServices.forEach((element) {
      element.clean();
    });
    return super.close();
  }
}
