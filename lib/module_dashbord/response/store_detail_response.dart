import 'package:my_kom_dist_dashboard/module_dashbord/models/company_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/zone_models.dart';
import 'package:my_kom_dist_dashboard/module_map/models/geo_model.dart';

class StoreDetailResponse{
  late String id;
  late String name;
  late GeoJson location;
  late String locationName;
  late List<ZoneModel> zones;
  late List<CompanyModel> companies;
  StoreDetailResponse();
  Map<String ,dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['location_name'] = this.locationName;
    data['location'] = this.location.toJson();
    data['zones'] = this.zones.map((e) =>e.toJson()).toList();
    return data;
  }
  StoreDetailResponse.storeDetail(Map<String, dynamic> data){
    this.name= data['name'];
    this.locationName= data['location_name'];
    this.location=GeoJson.fromJson(data['location'] );
    List<ZoneModel> zoneFromResponse = [];

    data['zones'].forEach((v) {
      zoneFromResponse.add(ZoneModel.fromJson(v));
    });

    this.zones = zoneFromResponse;
    //
    // if( data['companies'] != null){
    //   List<CompanyModel> companyFromResponse = [];
    //   data['companies'].forEach((v) {
    //     companyFromResponse.add(CompanyModel.fromJson(v));
    //   });
    //   this.companies = companyFromResponse;
    // }else{
    //   this.companies = [];

    //}


  }

}