
import 'package:my_kom_dist_dashboard/consts/order_status.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';
import 'package:my_kom_dist_dashboard/module_orders/response/orders/orders_response.dart';

class CreateOrderRequest {
  late String userId;
  late String storeId;
  late List<ProductModel> products;
  late String deliveryTime;
  late int numberOfMonth;
  late String startDate;
  late String phone;
  late GeoJson destination;
  late String addressName;
  late double orderValue;
  late String description;
  late String payment;
  late String status;
  late String? cardId;
  late int customerOrderID ;

  late List<String> productsIdes;

  CreateOrderRequest(
      {
     required this.userId,
     required this.destination,
     required this.phone,
     required this.payment,
     required this.products,
  required this.numberOfMonth,
  required this.deliveryTime,
  required this.orderValue,
  required this.startDate,
        required this.description,
        required this.addressName,
        required this.cardId,
        required this.customerOrderID
        ,required this.productsIdes
      });

  // CreateOrderRequest.fromJson(Map<String, dynamic> json) {
  //   storeId = json['storeId'];
  //   destination = GeoJson.fromJson(json['destination']);
  //   phone = json['phone'];
  //   payment = json['payment'];
  //   date = json['date'];
  //   products = (json['products']).map((e) => null);
  // }

  Map<String, dynamic> mainDetailsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['userId'] = this.userId;
   // data['storeId'] = this.storeId;
    data['status'] = this.status;
    data['payment'] = this.payment;
    data['description'] = this.description;
    data['order_value'] = this.orderValue;
    data['address_name'] = this.addressName;
    data['customer_order_id'] =this.customerOrderID;
    data['start_date'] = this.startDate;
    data['products_ides'] = this.productsIdes;

    return data;
  }

  Map<String, dynamic> moreDetailsToJson() {

    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = this.userId;
    data['status'] = this.status;
    data['card_id'] = this.cardId==null ? null : this.cardId ;
    data['products_ides'] = this.productsIdes;
    data['customer_order_id'] =this.customerOrderID;
    // data['storeId'] = this.storeId;
    data['products'] = this.products.map((e) =>e.toJson()).toList();
    data['delivery_time'] = this.deliveryTime;
    data['number_of_month'] = this.numberOfMonth;
    data['start_date'] = this.startDate;
    data['customer_order_id'] = this.customerOrderID;
    data['phone'] = this.phone;
    data['destination'] = this.destination.toJson();
    data['order_value'] = this.orderValue;
    data['payment'] = this.payment;
    data['address_name'] = this.addressName;
    data['description'] = this.description;

    return data;
  }
}

