import 'package:my_kom_dist_dashboard/module_orders/model/order_model.dart';

class SearchOrderResponse{
  late OrderModel? orderModel;
  late bool? message;
  SearchOrderResponse({required this.orderModel,required this.message});
}