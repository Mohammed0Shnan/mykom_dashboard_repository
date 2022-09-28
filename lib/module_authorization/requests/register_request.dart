import 'package:my_kom_dist_dashboard/module_authorization/enums/auth_source.dart';
import 'package:my_kom_dist_dashboard/module_authorization/enums/user_role.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';

class RegisterRequest {
  late final String email;
  late final String password;
  late final UserRole userRole;
  RegisterRequest(
      {required this.email,
      required this.password,
      required this.userRole});

  RegisterRequest.fromJson(Map<String, dynamic> map) {
    this.email = map['email'];
    this.password = map['password'];
    this.userRole = map['userRole'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['email'] = this.email;
    //map['password'] = this.password ;
    map['userRole'] = this.userRole.name;
    return map;
  }
}

class ProfileRequest {
  late final String userName;
  late final AddressModel address;
  late final String phone;
  late final String storeId;

  ProfileRequest(
      {required this.userName, required this.address, required this.phone,required this.storeId});

  ProfileRequest.fromJson(Map<String, dynamic> map) {
    this.userName = map['userName'];
    this.address = AddressModel.fromJson(map['address']);
    this.phone = map['phone'];
    this.storeId = map['store_id'] == null ?'':map['store_id'] ;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['userName'] = this.userName;
    map['phone'] = this.phone;

    if(map['store_id'] != ''){
      map['store_id'] = this.storeId;
    }

    map['address'] = this.address.toJson();

    return map;
  }
}
// class RegisterRequest{
//  late final  String email ;
//  late final  String password;
//  late final AddressModel address;
//  late final String user_name;
//  late final phone_number;
//  late final AuthSource authSource;
//  late final UserRole userRole;
//  RegisterRequest({required this.email,required this.password,required this.address,required this.authSource,required this.phone_number,required this.userRole,required this.user_name});

//  RegisterRequest.fromJson(Map<String , dynamic> map){
//   this.email = map['email'];
//   this.password = map['password'];
//   this.address = map['address'];
//   this.authSource = map['authSource'];
//   this.user_name = map['user_name'];
//   this.phone_number = map['phone'];
//   this.userRole = map['userRole'];
//  }

//  Map<String , dynamic> toJson(){
//   Map<String , dynamic> map = {};
//   map['email'] = this.email;
//   //map['password'] = this.password ;
//   map['address'] =this.address.toJson() ;
//   map['authSource'] = this.authSource ;
//   map['user_name'] =this.user_name ;
//   map['phone'] =this.phone_number ;
//  map['userRole'] = this.userRole ;
//   return map; 
//  }


// }