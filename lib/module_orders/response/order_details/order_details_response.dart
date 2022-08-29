
import 'package:my_kom_dist_dashboard/consts/order_status.dart';
import 'package:my_kom_dist_dashboard/module_orders/response/orders/orders_response.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';

class OrderDetailResponse {
  late String id;
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
  late String note;
  late String? cardId;
  late OrderStatus status;
  late int customerOrderID;
  late List<String> products_ides;



  OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.cardId = json['card_id'];
    this.customerOrderID =json['customer_order_id'] ;
    this.destination =GeoJson.fromJson(json['destination'] );
    this.addressName = json['address_name'];
    this.deliveryTime = json['delivery_time'];
    this.description = json['description'];
    this.numberOfMonth = json['number_of_month'];
    this.orderValue = json['order_value'];
    this.payment = json['payment'];
    this.phone = json['phone'];
    this.customerOrderID = json['customer_order_id'];
    this.note = json['note'];
    this.products_ides = json['products_ides'].cast<String>();

    List<ProductModel> productFromResponse = [];
    json['products'].forEach((v) {
      productFromResponse.add(ProductModel.fromJson(v));
    });
    this.products = productFromResponse;

    this.startDate = json['start_date'].toString();

    OrderStatus state = OrderStatus.INIT;
    if(json['status'] == OrderStatus.IN_STORE.name){
      state = OrderStatus.IN_STORE;
    }
    else if(json['status'] == OrderStatus.DELIVERING.name){
      state = OrderStatus.DELIVERING;
    }
    else if(json['status'] == OrderStatus.FINISHED.name){
      state = OrderStatus.FINISHED;
    }
    else if(json['status'] == OrderStatus.GOT_CAPTAIN.name){
      state = OrderStatus.GOT_CAPTAIN;
    }
    else if(json['status'] == OrderStatus.GOT_CASH.name){
      state = OrderStatus.GOT_CASH;
    }
    else
      {
        state = OrderStatus.INIT;
      }
   this.status = state;
  }
}
