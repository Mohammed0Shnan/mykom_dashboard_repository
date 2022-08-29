

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kom_dist_dashboard/consts/order_status.dart';
import 'package:my_kom_dist_dashboard/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/response/search_order_response.dart';
import 'package:my_kom_dist_dashboard/module_orders/model/order_model.dart';
import 'package:my_kom_dist_dashboard/module_orders/repository/order_repository/order_repository.dart';
import 'package:my_kom_dist_dashboard/module_orders/response/order_details/order_details_response.dart';
import 'package:rxdart/rxdart.dart';

class OrdersService {
  final  OrderRepository _orderRepository = OrderRepository();
  final AuthPrefsHelper _authPrefsHelper = AuthPrefsHelper();

  final PublishSubject<Map<String,List<OrderModel>>?> orderPublishSubject =
  new PublishSubject();

  final PublishSubject<Map<String,List<OrderModel>>?> zoneOrderPublishSubject =
  new PublishSubject();






  Future<OrderModel?> getOrderDetails(String orderId) async {
    try{
    OrderDetailResponse? response =   await _orderRepository.getOrderDetails(orderId);

    if(response ==null)
      return null;
    OrderModel orderModel = OrderModel() ;
     orderModel.id = response.id;
    orderModel.products = response.products;
    orderModel.payment = response.payment;
    orderModel.orderValue = response.orderValue;
    orderModel.description = response.description;
    orderModel.addressName = response.addressName;
    orderModel.destination = response.destination;
    orderModel.phone = response.phone;
    orderModel.startDate = DateTime.parse(response.startDate) ;
    orderModel.numberOfMonth = response.numberOfMonth;
    orderModel.deliveryTime = response.deliveryTime;
    orderModel.cardId = response.cardId;
    orderModel.status = response.status;
    orderModel.customerOrderID = response.customerOrderID;
    orderModel.productIds = response.products_ides;
    orderModel.note = response.note;
    return orderModel;
    }catch(e){
      return null;
    }
  }



  closeStream(){
    orderPublishSubject.close();
  }

  Future<bool> deleteOrder(String orderId)async{
      bool response = await  _orderRepository.deleteOrder(orderId);
      if(response){
        return true;
      }else{
        return false;
      }
  }

Future<void> getOwnerOrders(String storeId ) async {

  _orderRepository.getOwnerOrders(storeId).listen((event) {
    final Map<String, List<OrderModel>> sortedOrdersList = <String, List<OrderModel>>{};

    event.docs.forEach((elementforsort) {
      //
       Map <String ,dynamic> snapData = elementforsort.data() as Map<String , dynamic>;
       snapData['id'] = elementforsort.id;
       String key = snapData['order_source'];
      OrderModel orderModel = OrderModel.mainDetailsFromJson(snapData);

      if(!sortedOrdersList.containsKey(key)){
        sortedOrdersList[key] = [orderModel];
      }else {
        sortedOrdersList[key]?.add(orderModel);
      }

    });
    orderPublishSubject.add(sortedOrdersList);

  }).onError((e){
    orderPublishSubject.add(null);
  });

}

  Future<void> getZoneOrders(String zone) async {
    _orderRepository.getZoneOrders(zone).listen((event) {
      final List<OrderModel> cur = [];
      final List<OrderModel> pre = [];
      event.docs.forEach((elementforsort) {

        Map <String ,dynamic> snapData = elementforsort.data() as Map<String , dynamic>;
        snapData['id'] = elementforsort.id;

        OrderModel orderModel = OrderModel.mainDetailsFromJson(snapData);
        if(orderModel.status == OrderStatus.FINISHED){
          pre.add(orderModel);
        }else {
          cur.add(orderModel);
        }

      });
      final Map<String, List<OrderModel>> sortedOrdersList = <String, List<OrderModel>>{};
      sortedOrdersList.addAll({'curr':cur});
      sortedOrdersList.addAll({'pre':pre});
      zoneOrderPublishSubject.add(sortedOrdersList);

    }).onError((e){
      orderPublishSubject.add(null);
    });

  }





  /// for page init
 late List<DocumentSnapshot> documentList;
  void getAllOrders(OrderStatus? status) {



    _orderRepository.getAllOrders(status).listen((event) {
     documentList = event.docs;
      final  List<OrderModel> ordersList = [];

      documentList.forEach((elementforsort) {

        Map <String ,dynamic> snapData = elementforsort.data() as Map<String , dynamic>;
        snapData['id'] = elementforsort.id;
        OrderModel orderModel = OrderModel.mainDetailsFromJson(snapData);
        ordersList.add(orderModel);

      });

      orderPublishSubject.add({'all':ordersList});

    }).onError((e){
      orderPublishSubject.add(null);
    });
  }

  void fetchNextOrders(OrderStatus? filter)async {
    await Future.delayed(Duration(seconds:  2));
    _orderRepository.fetchNextOrders( documentList[documentList.length - 1],filter).listen((event) {
    documentList.addAll(event.docs);

      final  List<OrderModel> ordersList = [];

      documentList.forEach((elementforsort) {

        Map <String ,dynamic> snapData = elementforsort.data() as Map<String , dynamic>;
        snapData['id'] = elementforsort.id;
        OrderModel orderModel = OrderModel.mainDetailsFromJson(snapData);
        ordersList.add(orderModel);

      });

      orderPublishSubject.add({'all':ordersList});

    }).onError((e){
      orderPublishSubject.add(null);
    });
  }

 Future<SearchOrderResponse> search(int orderNumber) async{

     OrderModel? orderModel = await _orderRepository.search(orderNumber);
     if(orderModel == null ){
       return SearchOrderResponse(message: null,orderModel: null);
     }
     else if(orderModel.id == ''){
       return SearchOrderResponse(message:false,orderModel: null);

     }
     return SearchOrderResponse(message: true,orderModel:orderModel);



 }



}

