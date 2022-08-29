class ZoneModel{
  late String storeID;
  late String id;
  late List<String> name;

  ZoneModel({required this.name});

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['name'] = this.name;
    map['store_id'] = this.storeID;

    return map;
  }

  ZoneModel.fromJson( Map<String, dynamic> map) {
    this.name = List<String>.from(map['name']);
    this.storeID =map['store_id'];
    this.id = map['id'];

  }

}