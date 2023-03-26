class KlubBloc {
  int id;
  String identifier;
  int size;
  String data;
  String blockGroupRef;
  String dataStoreRef;

  KlubBloc(
      {required this.id,
      required this.identifier,
      required this.size,
      required this.data,
      required this.blockGroupRef,
      required this.dataStoreRef});

  factory KlubBloc.fromJson(Map<String, dynamic> json) => KlubBloc(
      id: json["id"],
      identifier: json["identifier"],
      size: json["size"],
      data: json["data"],
      blockGroupRef: json["blockGroupRef"],
      dataStoreRef: json["dataStoreRef"]);
}
