import 'package:flutter/material.dart';
import 'package:my_kom_dist_dashboard/abstracts/module/my_module.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/dashboard_routes.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/dash_bord_screen.dart';


class DashBoardModule extends MyModule {
  final DashBoardScreen _boardScreen;
  DashBoardModule(this._boardScreen);
  @override
  Map<String, WidgetBuilder> getRoutes() => {
    DashboardRoutes.DASHBOARD_SCREEN: (context) => _boardScreen,
      };
}
