
import 'package:flutter/material.dart';
import 'package:my_kom_dist_dashboard/abstracts/module/my_module.dart';
import 'package:my_kom_dist_dashboard/module_profile/profile_routes.dart';
import 'package:my_kom_dist_dashboard/module_profile/screen/profile_screen.dart';

class ProfileModule extends MyModule {
  final ProfileScreen userProfileScreen;

  ProfileModule(this.userProfileScreen);

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      ProfileRoutes.PROFILE_SCREEN: (context) => userProfileScreen,
    };
  }
}
