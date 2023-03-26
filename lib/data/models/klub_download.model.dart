class KlubDownload {
  String id;
  bool hasData;
  String? data;
  String blocGroupRef;

  KlubDownload(
      {required this.id,
      required this.data,
      required this.hasData,
      required this.blocGroupRef});

  factory KlubDownload.fromJson(Map<String, dynamic> json) => KlubDownload(
      id: json["id"],
      data: json["data"],
      hasData: json["hasData"],
      blocGroupRef: json["blocGroupRef"]);
}
