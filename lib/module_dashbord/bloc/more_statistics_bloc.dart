
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_authorization/model/app_user.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/more_statis_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/order_state_chart.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';

class MoreStatisticsBloc extends Bloc<MoreStatisticsEvent,MoreStatisticsStates>{
  final DashBoardService _service = DashBoardService();

  MoreStatisticsBloc() : super(MoreStatisticsLoadingState()) {

    on<MoreStatisticsEvent>((MoreStatisticsEvent event, Emitter<MoreStatisticsStates> emit) {
      if (event is MoreStatisticsLoadingEvent)
      {
        emit(MoreStatisticsLoadingState());

      }
      else if (event is MoreStatisticsErrorEvent){
        emit(MoreStatisticsErrorState(message: event.message));
      }

      else if (event is MoreStatisticsSuccessEvent){
        emit(MoreStatisticsSuccessState(statistics: event.statistics,message: null));
      }


      // else if (event is CaptainOrderDeletedSuccessEvent){
      //   if(this.state is CaptainOrdersListSuccessState)
      //     {
      //       print(event.orderID);
      //       print('------------------');
      //      List<OrderModel> state = (this.state as  CaptainOrdersListSuccessState ).data;
      //      state.forEach((element) {
      //        print(element.id);
      //      }); print('=============================================');
      //       List<OrderModel> list =[];
      //       state.forEach((element) {
      //         if(element.id != event.orderID)
      //           list.add(element);
      //       });
      //
      //       print(list);
      //       emit(CaptainOrdersListSuccessState(data:list,message:'success'));
      //     }
      //
      //   else
      //   {
      //     emit(CaptainOrderDeletedErrorState(message: 'Success, Refresh!!!',data:List.from(List.from( (this.state as  CaptainOrdersListSuccessState ).data) )));
      //   }
      // }
      // else if(event is CaptainOrderDeletedErrorEvent){
      //   emit(CaptainOrderDeletedErrorState(message: 'Error',data:List.from(List.from( (this.state as  CaptainOrdersListSuccessState ).data) )));
      // }
    });
  }



  void getMoreStatistics(String? storeID) {

    this.add(MoreStatisticsLoadingEvent());
    _service.moreStatisPublishSubject.listen((value) {
      if(value != null){
        this.add(MoreStatisticsSuccessEvent(statistics: value));

      }else
      {
        this.add(MoreStatisticsErrorEvent(message: 'Error In Fetch more statistics !!'));
      }
    });
    _service.getMoreStatistics();
  }

  @override
  Future<void> close() {
  //  _ordersService.closeStream();
    return super.close();
  }

  void getStoreMoreStatistics(String storeID) {
    this.add(MoreStatisticsLoadingEvent());
    _service.moreStatisPublishSubject.listen((value) {
      if(value != null){
        this.add(MoreStatisticsSuccessEvent(statistics: value));

      }else
      {
        this.add(MoreStatisticsErrorEvent(message: 'Error In Fetch more statistics !!'));
      }
    });
    _service.getMoreStoreStatistics(storeID);
  }
}

abstract class MoreStatisticsEvent { }
class MoreStatisticsInitEvent  extends MoreStatisticsEvent  {}

class MoreStatisticsSuccessEvent  extends MoreStatisticsEvent  {
  MoreStatisticsModel  statistics;
  MoreStatisticsSuccessEvent({required this.statistics});
}
class MoreStatisticsLoadingEvent  extends MoreStatisticsEvent  {}

class MoreStatisticsErrorEvent  extends MoreStatisticsEvent  {
  String message;
  MoreStatisticsErrorEvent({required this.message});
}

class MoreStatisticsDeletedErrorEvent  extends MoreStatisticsEvent  {
  String message;
  MoreStatisticsDeletedErrorEvent({required this.message});
}


class MoreStatisticsDeletedSuccessEvent  extends MoreStatisticsEvent  {
  String orderID;
  MoreStatisticsDeletedSuccessEvent({required this.orderID});
}



abstract class MoreStatisticsStates {}

class MoreStatisticsListInitState extends MoreStatisticsStates {}

class MoreStatisticsSuccessState extends MoreStatisticsStates {MoreStatisticsModel  statistics;

  String? message;
  MoreStatisticsSuccessState({required this.statistics,required this.message});
}
class MoreStatisticsLoadingState extends MoreStatisticsStates {}

class MoreStatisticsErrorState extends MoreStatisticsStates {
  String message;
  MoreStatisticsErrorState({required this.message});
}

class MoreStatisticsDeletedErrorState extends MoreStatisticsStates {
  String message;
  List<OrderStateChart>  statistics;
  MoreStatisticsDeletedErrorState({ required this.statistics,required this.message});
}




