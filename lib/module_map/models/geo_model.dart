class GeoJson {
  late double lat;
  late double lon;

  GeoJson({required this.lat, required this.lon});

  GeoJson.fromJson(Map<String, dynamic> data) {
    if (data == null) {
      return;
    }
    else {
      this.lat = double.tryParse(data['lat'].toString())!;
      this.lon = double.tryParse(data['lon'].toString())!;
    }
    // if (data is List) {
    //   if (data.last is Map) {
    //     json = data.last;
    //   }
    //  else if (data is Map) {
    //     this.lat = double.tryParse(json['lat'].toString())!;
    //     this.lon = double.tryParse(json['lon'].toString())!;
    //   }
    // }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }

}
