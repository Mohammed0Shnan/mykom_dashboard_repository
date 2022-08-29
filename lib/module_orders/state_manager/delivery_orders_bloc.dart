
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/consts/order_status.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/response/search_order_response.dart';
import 'package:my_kom_dist_dashboard/module_orders/model/order_model.dart';
import 'package:my_kom_dist_dashboard/module_orders/service/orders/orders.service.dart';

class CaptainOrdersListBloc extends Bloc<CaptainOrdersListEvent,CaptainOrdersListStates>{
  final OrdersService _ordersService = OrdersService();

  CaptainOrdersListBloc() : super(CaptainOrdersListLoadingState()) {

    on<CaptainOrdersListEvent>((CaptainOrdersListEvent event, Emitter<CaptainOrdersListStates> emit) {
      if (event is CaptainOrdersListLoadingEvent)
        {
          emit(CaptainOrdersListLoadingState());

        }
      else if (event is CaptainOrdersListErrorEvent){
        emit(CaptainOrdersListErrorState(message: event.message));
      }

      else if (event is CaptainOrdersListSuccessEvent){
        emit(CaptainOrdersListSuccessState(data: event.data,message: null));
      }
      else if(event is CaptainOrdersListFetchNextLoadingEvent)
        emit(CaptainOrdersFetchNextListSuccessState(data: event.data,message: null));



    });
  }


  void getOwnerOrders(String storeId) {

    this.add(CaptainOrdersListLoadingEvent());
    _ordersService.orderPublishSubject.listen((value) {

      if(value != null){
        this.add(CaptainOrdersListSuccessEvent(data: value));

      }else
      {
        this.add(CaptainOrdersListErrorEvent(message: 'Error In Fetch Data !!'));
      }
    });
    _ordersService.getOwnerOrders(storeId);
  }

  getZoneOrders(String zone){
    this.add(CaptainOrdersListLoadingEvent());
    _ordersService.zoneOrderPublishSubject.listen((value) {

      if(value != null){
        this.add(CaptainOrdersListSuccessEvent(data: value));

      }else
      {
        this.add(CaptainOrdersListErrorEvent(message: 'Error In Fetch Data !!'));
      }
    });
    _ordersService.getZoneOrders(zone);
  }


   getAllOrders(OrderStatus? filter){
     this.add(CaptainOrdersListLoadingEvent());
     _ordersService.orderPublishSubject.listen((value) {

       if(value != null){
         this.add(CaptainOrdersListSuccessEvent(data: value));

       }else
       {
         this.add(CaptainOrdersListErrorEvent(message: 'Error In Fetch Data !!'));
       }
     });
     _ordersService.getAllOrders(filter);
  }

  /// Page Init
  fetchNextOrders(OrderStatus? filter)  {
    // if(this.state is CaptainOrdersListSuccessState)
    //   this.add(CaptainOrdersListFetchNextLoadingEvent(data: (this.state as CaptainOrdersListSuccessState).data ));

    _ordersService.fetchNextOrders(filter);

  }
 Future<bool> deleteOrder(String orderID)async{
  return await _ordersService.deleteOrder(orderID);
   await _ordersService.deleteOrder(orderID).then((value) {
      //
      // if(value){
      //   add(CaptainOrderDeletedSuccessEvent(orderID:orderID));
      // }else{
      //  add(CaptainOrderDeletedErrorEvent(message: 'Error in order deleted !!!'));
      // }
    });
  }

  @override
  Future<void> close() {
    _ordersService.closeStream();
    return super.close();
  }

  Future<SearchOrderResponse> search(int orderNumber)async {

    return await _ordersService.search(orderNumber);

  }



}

abstract class CaptainOrdersListEvent { }
class CaptainOrdersListInitEvent  extends CaptainOrdersListEvent  {}

class CaptainOrdersListSuccessEvent  extends CaptainOrdersListEvent  {
  Map<String, List<OrderModel>> data;
  CaptainOrdersListSuccessEvent({required this.data});
}
class CaptainOrdersListLoadingEvent  extends CaptainOrdersListEvent  {}
class CaptainOrdersListFetchNextLoadingEvent  extends CaptainOrdersListEvent  {
  Map<String, List<OrderModel>> data;
  CaptainOrdersListFetchNextLoadingEvent({required this.data});

}

class CaptainOrdersListErrorEvent  extends CaptainOrdersListEvent  {
  String message;
  CaptainOrdersListErrorEvent({required this.message});
}

class CaptainOrderDeletedErrorEvent  extends CaptainOrdersListEvent  {
  String message;
  CaptainOrderDeletedErrorEvent({required this.message});
}


class CaptainOrderDeletedSuccessEvent  extends CaptainOrdersListEvent  {
  String orderID;
  CaptainOrderDeletedSuccessEvent({required this.orderID});
}



abstract class CaptainOrdersListStates {}

class CaptainOrdersListInitState extends CaptainOrdersListStates {}

class CaptainOrdersListSuccessState extends CaptainOrdersListStates {
  Map<String, List<OrderModel>> data;
  String? message;
  CaptainOrdersListSuccessState({required this.data,required this.message});
}

class CaptainOrdersFetchNextListSuccessState extends CaptainOrdersListStates {
  Map<String, List<OrderModel>> data;
  String? message;
  CaptainOrdersFetchNextListSuccessState({required this.data,required this.message});
}
class CaptainOrdersListLoadingState extends CaptainOrdersListStates {}

class CaptainOrdersListErrorState extends CaptainOrdersListStates {
  String message;
  CaptainOrdersListErrorState({required this.message});
}

class CaptainOrderDeletedErrorState extends CaptainOrdersListStates {
  String message;
  List<OrderModel>  data;
  CaptainOrderDeletedErrorState({ required this.data,required this.message});
}




