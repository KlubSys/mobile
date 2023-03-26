import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:klub/application/tools/print.tool.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/data/models/klub_download.model.dart';
import 'package:klub/data/models/klub_bloc.model.dart';
import 'package:klub/data/providers/apis/klub.api.dart';
import 'package:klub/data/providers/apis/shared/api_response.dart';
import "package:http/http.dart" as http;

class HttpKlubApi extends KlubApi {
  final String entryPointbaseUrl = "http://10.0.2.2:8080";
  final String storeBaseUrl = "http://10.0.2.2:8084";

  final headers = {
    "Content-Type": "application/json",
  };

  @override
  Future<ApiResponse<bool>> deleteDownloadTaskById(String id) async {
    return ApiResponse(data: true, exception: null);
  }

  @override
  Future<ApiResponse<List<KlubBloc>>> getBlocs() async {
    try {
      Response response = await http.get(
          Uri.parse("$storeBaseUrl/api/v1/data_block"),
          headers: {"Content-Type": "application/json"});
      throwIf(response.statusCode >= 400, Exception());

      var body = jsonDecode(response.body);
      List<KlubBloc> data = List.castFrom<dynamic, KlubBloc>(
          body["data"].map((json) => KlubBloc.fromJson(json)).toList());

      return ApiResponse(data: data, exception: null);
    } catch (e) {
      logToConsole(e);
      return ApiResponse(data: null, exception: Exception(""));
    }
  }

  @override
  Future<ApiResponse<KlubDownload>> getDownloadTaskById(String id) async {
    try {
      Response response = await http.get(
          Uri.parse("$storeBaseUrl/api/downloads/$id"),
          headers: {"Content-Type": "application/json"});
      throwIf(response.statusCode >= 400, Exception());

      var body = jsonDecode(response.body);
      KlubDownload data = KlubDownload.fromJson(body);

      return ApiResponse(data: data, exception: null);
    } catch (e) {
      logToConsole(e);
      return ApiResponse(data: null, exception: Exception(""));
    }
  }

  @override
  Future<ApiResponse<List<KlubDownload>>> getDownloadTasks() async {
    try {
      Response response = await http.get(
          Uri.parse("$storeBaseUrl/api/downloads?blocGroupRef='group'"),
          headers: {"Content-Type": "application/json"});
      throwIf(response.statusCode >= 400, Exception());

      var body = jsonDecode(response.body);
      List<KlubDownload> data = List.castFrom<dynamic, KlubDownload>(
          body.map((json) => KlubDownload.fromJson(json)).toList());

      return ApiResponse(data: data, exception: null);
    } catch (e) {
      logToConsole(e);
      return ApiResponse(data: null, exception: Exception("get download tasks"));
    }
  }

  @override
  Future<ApiResponse<List<KlubFile>>> getFiles() async {
    try {
      Response response = await http.get(
          Uri.parse("$entryPointbaseUrl/api_test/file/files"),
          headers: {"Content-Type": "application/json"});
      throwIf(response.statusCode >= 400, Exception());

      logToConsole(response.body);
      var body = jsonDecode(response.body);
      List<KlubFile> data = List.castFrom<dynamic, KlubFile>(
          body.toList().map((json) => KlubFile.fromJson(json)).toList());

      return ApiResponse(data: data, exception: null);
    } catch (e) {
      logToConsole(e);
      return ApiResponse(data: null, exception: Exception(""));
    }
  }

  @override
  Future<ApiResponse<String>> getNextBlocGroupRef(String currentRef) async {
    try {
      Response response = await http.get(
          Uri.parse(
              "$storeBaseUrl/api/v1/block_groups/$currentRef/_nextBlock"),
          headers: {"Content-Type": "application/json"});
      throwIf(response.statusCode >= 400, Exception());

      var body = jsonDecode(response.body);

      return ApiResponse(data: body["ref"], exception: null);
    } catch (e) {
      logToConsole(e);
      return ApiResponse(data: null, exception: Exception(""));
    }
  }

  @override
  Future<ApiResponse<String>> initDownload(String firstBlockGroupId) async {
    try {
      Response response = await http.post(
          Uri.parse(
              "$storeBaseUrl/api/downloads/init?blocGroupRef=$firstBlockGroupId"),
          headers: {"Content-Type": "application/json"});
      throwIf(response.statusCode >= 400, Exception());

      var body = jsonDecode(response.body);

      return ApiResponse(data: body["id"], exception: null);
    } catch (e) {
      logToConsole(e);
      return ApiResponse(data: null, exception: Exception(""));
    }
  }

  @override
  Future<ApiResponse<bool>> updateDownloadTaskData(
      String id, String data) async {
    try {
      Response response = await http.put(
          Uri.parse("$storeBaseUrl/api/downloads/${id}/_data"),
          headers: {"Content-Type": "application/json"},
          body: data);
      throwIf(response.statusCode >= 400, Exception());
      return ApiResponse(data: true, exception: null);
    } catch (e) {
      logToConsole(e);
      return ApiResponse(data: null, exception: Exception(""));
    }
  }
}
