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
}
