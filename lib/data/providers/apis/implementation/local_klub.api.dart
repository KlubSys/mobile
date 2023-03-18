import 'dart:math';

import 'package:klub/data/models/klub_bloc.model.dart';
import 'package:klub/data/models/klub_download.model.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/data/providers/apis/klub.api.dart';
import 'package:klub/data/providers/apis/shared/api_response.dart';

final _klubBloc = KlubBloc(
    id: 3,
    identifier: "45b7d351-f741-4802-898a-4c20a7898f47",
    size: 12,
    data: "RGF0YSB0ZXN0",
    blockGroupRef: "block1676234915552_debe5d81-6880-4b45-b9f4-d45528af0bff",
    dataStoreRef: "62c43882-32f3-490c-9344-477f93824f43");
final _klubFileOne = KlubFile(
    id: "07e75fdc-943d-4644-8788-7d697aa5841e",
    isDir: false,
    filename: "doc.txt",
    fileType: "document",
    level: 0,
    uploaded: true,
    firstBlockGroupId:
        "block1676234940521_14444f6d-3d55-4885-b884-da1eb0921c06",
    dataBlocCount: 5,
    parentId: null);
final _klubDownloadTask = KlubDownload(
    id: "1",
    hasData: false,
    data: null,
    blocGroupRef: "block1676234915552_debe5d81-6880-4b45-b9f4-d45528af0bff");
final _klubDownloadCompletedTask = KlubDownload(
    id: "1",
    hasData: true,
    data: "RGF0YSB0ZXN0",
    blocGroupRef: "block1676234915552_debe5d81-6880-4b45-b9f4-d45528af0bff");

class LocalKlubApi extends KlubApi {
  @override
  Future<ApiResponse<List<KlubFile>>> getFiles() {
    return Future.delayed(const Duration(seconds: 5), () {
      return ApiResponse(data: List.of([_klubFileOne]));
    });
  }

  @override
  Future<ApiResponse<List<KlubBloc>>> getBlocs() {
    return Future.delayed(const Duration(seconds: 5), () {
      return ApiResponse(data: List.of([_klubBloc]));
    });
  }

  @override
  Future<ApiResponse<List<KlubDownload>>> getDownloadTasks() {
    return Future.delayed(const Duration(seconds: 5), () {
      return ApiResponse(data: List.of([_klubDownloadTask]));
    });
  }

  @override
  Future<ApiResponse<bool>> updateDownloadTaskData(String id, String data) {
    return Future.delayed(const Duration(seconds: 5), () {
      return ApiResponse(data: true);
    });
  }

  @override
  Future<ApiResponse<int>> initDownload(String firstBlockGroupId) {
    return Future.delayed(const Duration(seconds: 5), () {
      return ApiResponse(data: 1);
    });
  }

  @override
  Future<ApiResponse<bool>> deleteDownloadTaskById(int id) {
    return Future.delayed(const Duration(seconds: 5), () {
      return ApiResponse(data: true);
    });
  }

  @override
  Future<ApiResponse<KlubDownload>> getDownloadTaskById(int id) {
    return Future.delayed(const Duration(seconds: 5), () {
      return ApiResponse(data: _klubDownloadCompletedTask);
    });
  }

  @override
  Future<ApiResponse<String>> getNextBlocGroupRef(String currentRef) {
    return Future.delayed(const Duration(seconds: 5), () {
      var t = Random().nextInt(200) + 3;
      return ApiResponse(
          data: "block${t}-1676234915552_debe5d81-6880-4b45-b9f4-d45528af0bff");
    });
  }
}
