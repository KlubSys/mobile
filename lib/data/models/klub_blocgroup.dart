class KlubBlocGroup {
  int id;
  String identifier;
  String deployed;
  int? maxBlock;
  String next;
  String previous;
  String data;
  int dataSize;

  KlubBlocGroup(
      {required this.id,
      required this.identifier,
      required this.deployed,
      required this.maxBlock,
      required this.next,
      required this.previous,
      required this.data,
      required this.dataSize});

  factory KlubBlocGroup.fromJson(Map<String, dynamic> json) => KlubBlocGroup(
      id: json["id"],
      identifier: json["identifier"],
      deployed: json["deployed"],
      maxBlock: json["maxBlock"],
      next: json["next"],
      previous: json["previous"],
      data: json["data"],
      dataSize: json["dataSize"]);
}
