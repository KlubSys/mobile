import 'dart:async';
import 'dart:collection';

import 'package:klub/application/cubit/klub_cubit.dart';
import 'package:klub/application/tools/print.tool.dart';
import 'package:klub/data/models/klub_bloc.model.dart';
import 'package:klub/data/models/klub_download.model.dart';
import 'package:klub/data/repositories/klub-api.repository.dart';

class KlubDownloadTask extends LinkedListEntry<KlubDownloadTask> {
  final KlubDownload data;
  KlubDownloadTask(this.data);

  @override
  String toString() {
    return 'KLUB DOWNLOAD task ${data.id}';
  }
}

class KlubDownloadTaskService {
  final Queue<KlubDownloadTask> _tasks = Queue<KlubDownloadTask>();
  late StreamSubscription _klubCubitSubscription;
  late HashMap<String, KlubBloc> blocStore = HashMap();
  late Timer _downloadTaskUpdateTimer;

  final KlubApiRepository klubApiRepository;
  final KlubCubit klubCubit;

  KlubDownloadTaskService(
      {required this.klubApiRepository, required this.klubCubit}) {
    logToConsole("Task Download Service initialized");
    _klubCubitSubscription = klubCubit.stream.listen((state) {
      state.blocs.forEach((bloc) {
        if (blocStore.containsKey(bloc.blockGroupRef)) {
          blocStore.update(bloc.blockGroupRef, (value) {
            return bloc;
          });
        } else {
          blocStore.putIfAbsent(bloc.blockGroupRef, () => bloc);
        }
      });
      logToConsole("Blocs Store Updated (Soze) ${blocStore.length}");
    });

    _downloadTaskUpdateTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        var tsk = _tasks.removeFirst();
        logToConsole("Task will be processed");

        var blc = blocStore[tsk.data.blocGroupRef];
        if (blc != null) {
          logToConsole(
              "Bloc group found for download task ${tsk.data.blocGroupRef}");
          await klubApiRepository.updatateDownloadData(tsk.data, blc.data);
        } else {
          logToConsole(
              "Bloc Group Ref Not found for download task ${tsk.data.blocGroupRef}");
        }
      } catch (e) {
        logToConsole(e);
      }
    });
  }

  void addTask(KlubDownload d) {
    if (d.hasData) {
      logToConsole("Task won't be processed");
    } else {
      _tasks.addLast(KlubDownloadTask(d));
      logToConsole("Enqueued Download Task: ${d.id}");
    }
  }

  void clean() {
    _klubCubitSubscription.cancel();
    _downloadTaskUpdateTimer.cancel();
  }
}
