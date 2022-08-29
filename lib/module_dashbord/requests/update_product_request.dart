
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';

class UpdateProductRequest {
  late final String id;
  late final String name;
  late final double current_price;
  late final  double? discount_price;
  late String description;

  late final String arabicName;
  late final String arabicDis;
  late final int quantity;
  late String imageUrl;

  UpdateProductRequest({required this.name, required this.description,required this.quantity,required this.current_price,required this.arabicName,required this.arabicDis,required this.discount_price});


  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['title'] = this.name;
    map['title2'] = this.arabicName;
   // map['imageUrl'] = this.imageUrl;
    map['description'] = this.description;
    map['description2'] = this.arabicDis;
    map['quantity'] = this.quantity;
    map['price'] = this.discount_price==null? this.current_price:this.discount_price;
    map['old_price'] =this.discount_price==null?null: this.current_price;
    map['isRecommended'] = false;
    // map['specifications'] = this.specifications.map((e) =>e.toJson()).toList();
    return map;
  }
}
