
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_authorization/model/app_user.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/order_state_chart.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';

class StatisticsBloc extends Bloc<StatisticsEvent,StatisticsStates>{
  final DashBoardService _service = DashBoardService();

  StatisticsBloc() : super(StatisticsLoadingState()) {

    on<StatisticsEvent>((StatisticsEvent event, Emitter<StatisticsStates> emit) {
      if (event is StatisticsLoadingEvent)
      {
        emit(StatisticsLoadingState());

      }
      else if (event is StatisticsErrorEvent){
        emit(StatisticsErrorState(message: event.message));
      }

      else if (event is StatisticsSuccessEvent){
        emit(StatisticsSuccessState(statistics: event.statistics,message: null));
      }
      else if(event is StatisticsMonthlySuccessEvent){
        emit(StatisticsMonthlySuccessState(statistics: event.statistics,message: null));

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



  void getStatistics(String storeID) {

    this.add(StatisticsLoadingEvent());
    _service.getDailyStatistics(storeID).then((value) {
      if(value != null){
        this.add(StatisticsSuccessEvent(statistics: value));

      }else
      {
        this.add(StatisticsErrorEvent(message: 'Error In Fetch statistics !!'));
      }
    });

  }


  void getMonthlyStatistics(String storeID) {

    this.add(StatisticsLoadingEvent());
    _service.getMonthlyStatistics(storeID).then((value) {
      if(value != null){
        this.add(StatisticsMonthlySuccessEvent(statistics: value));

      }else
      {
        this.add(StatisticsErrorEvent(message: 'Error In Fetch statistics !!'));
      }
    });

  }




  @override
  Future<void> close() {
  //  _ordersService.closeStream();
    return super.close();
  }



}

abstract class StatisticsEvent { }
class StatisticsInitEvent  extends StatisticsEvent  {}

class StatisticsSuccessEvent  extends StatisticsEvent  {
  List<OrderStateChart>  statistics;
  StatisticsSuccessEvent({required this.statistics});
}

class StatisticsMonthlySuccessEvent  extends StatisticsEvent  {
 Map<String , OrderStateChart>  statistics;
  StatisticsMonthlySuccessEvent({required this.statistics});
}
class StatisticsLoadingEvent  extends StatisticsEvent  {}

class StatisticsErrorEvent  extends StatisticsEvent  {
  String message;
  StatisticsErrorEvent({required this.message});
}

class StatisticsDeletedErrorEvent  extends StatisticsEvent  {
  String message;
  StatisticsDeletedErrorEvent({required this.message});
}


class StatisticsDeletedSuccessEvent  extends StatisticsEvent  {
  String orderID;
  StatisticsDeletedSuccessEvent({required this.orderID});
}



abstract class StatisticsStates {}

class StatisticsListInitState extends StatisticsStates {}

class StatisticsSuccessState extends StatisticsStates {
  List<OrderStateChart>  statistics;

  String? message;
  StatisticsSuccessState({required this.statistics,required this.message});
}
class StatisticsMonthlySuccessState extends StatisticsStates {
  Map<String ,OrderStateChart>  statistics;

  String? message;
  StatisticsMonthlySuccessState({required this.statistics,required this.message});
}

class StatisticsLoadingState extends StatisticsStates {}

class StatisticsErrorState extends StatisticsStates {
  String message;
  StatisticsErrorState({required this.message});
}

class StatisticsDeletedErrorState extends StatisticsStates {
  String message;
  List<OrderStateChart>  statistics;
  StatisticsDeletedErrorState({ required this.statistics,required this.message});
}




