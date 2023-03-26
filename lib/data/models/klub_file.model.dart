class KlubFile {
  String id;
  bool isDir;
  String filename;
  String fileType;
  int level;
  bool uploaded;
  String? firstBlockGroupId;
  int dataBlocCount;
  String? parentId;

  KlubFile(
      {required this.id,
      required this.isDir,
      required this.filename,
      required this.fileType,
      required this.level,
      required this.uploaded,
      required this.firstBlockGroupId,
      required this.dataBlocCount,
      required this.parentId});

  factory KlubFile.fromJson(Map<String, dynamic> json) => KlubFile(
      id: json["id"],
      isDir: json["isDir"],
      filename: json["filename"],
      fileType: json["fileType"],
      level: json["level"],
      uploaded: json["uploaded"],
      firstBlockGroupId: json["firstBlockGroupId"],
      dataBlocCount: json["dataBlocCount"],
      parentId: json["parentId"]);
}
