
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';

class AddCompanyRequest {
  late final String id;
  late final String storeId;
  late final String name;
  late final String name2;
  late final String is_active;
  late String description;
  late String imageUrl;
  late List<ProductModel> products;
  AddCompanyRequest({required this.name,required this.name2, required this.description, required this.imageUrl});


  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['store_id'] = this.storeId;
    map['name'] = this.name;
    map['name2'] = this.name2;
    map['is_active'] = true;
    map['imageUrl'] = this.imageUrl;
    map['description'] = this.description;
    return map;
  }
}



