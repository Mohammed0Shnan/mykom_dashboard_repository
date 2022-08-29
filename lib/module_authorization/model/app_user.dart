import 'package:my_kom_dist_dashboard/module_authorization/enums/auth_source.dart';
import 'package:my_kom_dist_dashboard/module_authorization/enums/user_role.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';

class AppUser {
  late final String id;
  late final String email;
  late final AddressModel address;
  late final String user_name;
  late final String storeId;
  late final phone_number;
  late final AuthSource authSource;
  late final UserRole userRole;
  late final String? stripeId;
  late final String? activeCard;

  AppUser(
      {required this.id,
      required this.email,
      required this.authSource,
      required this.userRole,
      required this.address,
      required this.phone_number,
      required this.user_name,
      required this.stripeId,
      required this.activeCard});

  AppUser.fromJsom(Map<String, dynamic> data) {
    this.id = data['id'];
    this.email = data['email'];
    this.storeId = data['store_id']==null?'': data['store_id'];
    this.address = AddressModel.fromJson(data['address']);
    this.phone_number = data['phone'];
    this.user_name = data['userName'];

    late UserRole user_role=UserRole.ROLE_USER;
    if (UserRole.ROLE_OWNER.name == data['userRole']) {
      user_role = UserRole.ROLE_OWNER;
    } else if (UserRole.ROLE_DELIVERY.name == data['userRole']) {
      user_role = UserRole.ROLE_DELIVERY;
    }
    this.userRole = user_role;
  }
}
