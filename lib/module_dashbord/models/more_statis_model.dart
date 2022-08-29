
import 'package:my_kom_dist_dashboard/module_authorization/model/app_user.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';

class MoreStatisticsModel {
  late List<AppUser> users;
  late List<ProductModel> products;

  MoreStatisticsModel();

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['orders'] = this.users;

    return map;
  }

}