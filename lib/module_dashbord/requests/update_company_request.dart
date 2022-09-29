

class CompanyRequest {
  late final String name;
  late final String name2;
  late String imageUrl;
  CompanyRequest({required this.name,required this.name2, required this.imageUrl});


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['name'] = this.name;
    map['name2'] = this.name2;
    map['imageUrl'] = this.imageUrl;
    return map;
  }
}



