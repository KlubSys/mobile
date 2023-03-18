import 'package:klub/application/tools/print.tool.dart';
import 'package:klub/data/models/klub_bloc.model.dart';
import 'package:klub/data/models/klub_download.model.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/data/providers/apis/klub.api.dart';
import 'package:klub/data/providers/apis/shared/api_response.dart';

class KlubApiRepository {
  final KlubApi _klubApi;

  KlubApiRepository(this._klubApi);

  Future<List<KlubFile>> getFiles() async {
    ApiResponse<List<KlubFile>> res = await _klubApi.getFiles();
    if (res.isSuccessFull()) {
      return res.data!;
    }
    logToConsole("Empty klub files");
    return List.empty();
  }

  Future<List<KlubBloc>> getBlocs() async {
    ApiResponse<List<KlubBloc>> res = await _klubApi.getBlocs();
    if (res.isSuccessFull()) {
      return res.data!;
    }
    logToConsole("Empty klub blocs");
    return List.empty();
  }

  Future<List<KlubDownload>> getDownloadTasks() async {
    ApiResponse<List<KlubDownload>> res = await _klubApi.getDownloadTasks();
    if (res.isSuccessFull()) {
      return res.data!;
    }
    logToConsole("Empty klub download");
    return List.empty();
  }

  Future<void> updatateDownloadData(KlubDownload task, String data) async {
    ApiResponse<bool> res =
        await _klubApi.updateDownloadTaskData(task.id, data);
    if (res.isSuccessFull()) {
      logToConsole("Data Updated");
      return;
    }
    logToConsole("An error occured while updating download task  data");
  }

  Future<int> initFileDownload(KlubFile file) async {
    ApiResponse<int> res = await _klubApi.initDownload(file.firstBlockGroupId!);
    if (res.isSuccessFull()) {
      logToConsole("Download Task inited");
      return res.data!;
    }
    return -1;
  }

  Future<int> initBlocDownload(String blocGroupRef) async {
    ApiResponse<int> res = await _klubApi.initDownload(blocGroupRef);
    if (res.isSuccessFull()) {
      logToConsole("Download Task inited by block");
      return res.data!;
    }
    return -1;
  }

  Future<KlubDownload?> getDownloadById(int id) async {
    ApiResponse<KlubDownload> res = await _klubApi.getDownloadTaskById(id);
    if (res.isSuccessFull()) {
      logToConsole("Download Task Get One By Id success");
      return res.data!;
    }
    return null;
  }

  Future<bool> deleteDownloadById(int id) async {
    ApiResponse<bool> res = await _klubApi.deleteDownloadTaskById(id);
    if (res.isSuccessFull()) {
      logToConsole("Download Task deleted...");
      return res.data!;
    }
    return false;
  }

  Future<String?> getNextBlocGroupRef(String currentRef) async {
    ApiResponse<String> res = await _klubApi.getNextBlocGroupRef(currentRef);
    if (res.isSuccessFull()) {
      logToConsole("Download Task Got next bloc ref");
      if (res.data!.isEmpty) {
        return null;
      }
      return res.data!;
    }
    return null;
  }
}
