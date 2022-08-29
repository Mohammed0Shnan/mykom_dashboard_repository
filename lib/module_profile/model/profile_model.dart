

import 'package:my_kom_dist_dashboard/module_authorization/enums/user_role.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';

class ProfileModel {
 late String userName;
 late String email;
 late String phone;
 late UserRole userRole;
 late AddressModel address;
 late int ordersNumber;
 late double totalPurchaseValues;
 late double averagePurchaseValues;

  ProfileModel({
   required this.userName,
    required this.phone,
   required this.email,
   required this.userRole,
    required  this.address,
   required this.averagePurchaseValues,
   required this.ordersNumber,
   required this.totalPurchaseValues,


  });
}
