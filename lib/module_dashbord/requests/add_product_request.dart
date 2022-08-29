
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';

class AddProductRequest {
  late final String id;
  late final String companyId;
  late final String title;
  late String description;

  late final String arabicName;
  late String arabicDis;

  late String imageUrl;
  late final int quantity;
  late final double price;
  late final double? old_price;
  late final isRecommended;
  late final List<SpecificationsModel> specifications;

  late List<ProductModel> products;
  AddProductRequest({required this.title,required this.isRecommended, required this.description, required this.imageUrl,required this.quantity,required this.price,required this.arabicName,required this.arabicDis,required this.old_price});


  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['title'] = this.title;
    map['title2'] = this.arabicName;
    map['company_id'] = this.companyId;
    map['imageUrl'] = this.imageUrl;
    map['description'] = this.description;
    map['description2'] = this.arabicDis;
    map['quantity'] = this.quantity;
    map['price'] = this.price;
    map['old_price'] = this.old_price;
    map['isRecommended'] = this.isRecommended;
   // map['specifications'] = this.specifications.map((e) =>e.toJson()).toList();
    return map;
  }
}
