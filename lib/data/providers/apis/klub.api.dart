import 'package:klub/data/models/klub_bloc.model.dart';
import 'package:klub/data/models/klub_download.model.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/data/providers/apis/shared/api_response.dart';

abstract class KlubApi {
  Future<ApiResponse<List<KlubFile>>> getFiles();
  Future<ApiResponse<List<KlubBloc>>> getBlocs();
  Future<ApiResponse<List<KlubDownload>>> getDownloadTasks();
  Future<ApiResponse<KlubDownload>> getDownloadTaskById(String id);
  Future<ApiResponse<bool>> deleteDownloadTaskById(String id);

  Future<ApiResponse<bool>> updateDownloadTaskData(String id, String data);

  ///Return the doxnload task id
  Future<ApiResponse<String>> initDownload(String firstBlockGroupId);

  Future<ApiResponse<String>> getNextBlocGroupRef(String currentRef);
}
