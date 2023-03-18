part of 'klub_cubit.dart';

class FileDownloadProcess {
  final KlubFile file;
  final int position;
  final String blockGroupRef;

  final KlubDownloadFileService downloadFileService;

  FileDownloadProcess(this.file, this.position, this.blockGroupRef, this.downloadFileService);
}

@immutable
class KlubState {
  final List<KlubFile> files;
  final List<KlubBloc> blocs;
  final List<FileDownloadProcess> filesDownloads;
  final List<KlubDownload> blocRequestsTasks;

  const KlubState(
      {required this.files,
      required this.blocs,
      required this.blocRequestsTasks,
      required this.filesDownloads});

  KlubState copyWith(
      {List<KlubFile>? files,
      List<KlubBloc>? blocs,
      List<KlubDownload>? blocRequestsTasks,
      List<FileDownloadProcess>? filesDownloads}) {
    return KlubState(
        files: files ?? this.files,
        blocs: blocs ?? this.blocs,
        filesDownloads: filesDownloads ?? this.filesDownloads,
        blocRequestsTasks: blocRequestsTasks ?? this.blocRequestsTasks);
  }
}

class KlubInitial extends KlubState {
  KlubInitial()
      : super(files: [], blocs: [], blocRequestsTasks: [], filesDownloads: []);
}
