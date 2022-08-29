
import 'package:flutter/material.dart';
import 'package:my_kom_dist_dashboard/abstracts/module/my_module.dart';
import 'package:my_kom_dist_dashboard/module_orders/orders_routes.dart';
import 'package:my_kom_dist_dashboard/module_orders/ui/screens/order_detail.dart';
import 'package:my_kom_dist_dashboard/module_orders/ui/screens/owner_orders.dart';

class OrdersModule extends MyModule {

  final OrderDetailScreen _detailScreen;
  OrdersModule(
      this._detailScreen,
  ) ;

  Map<String, WidgetBuilder> getRoutes() {
    return {

       OrdersRoutes.ORDER_DETAIL_SCREEN: (context) => _detailScreen,

    };
  }
}
