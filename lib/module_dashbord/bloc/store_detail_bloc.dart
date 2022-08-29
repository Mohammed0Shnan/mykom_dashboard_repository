import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/store_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';

class StoreDetailBloc extends Bloc<StoreDetailEvent, StoreDetailStates> {
  final DashBoardService _service = DashBoardService();

  StoreDetailBloc() : super(StoreDetailLoadingState()) {
    
    on<StoreDetailEvent>((StoreDetailEvent event, Emitter<StoreDetailStates> emit) {
      if (event is StoreDetailLoadingEvent)
        emit(StoreDetailLoadingState());
      else if (event is StoreDetailErrorEvent){
        emit(StoreDetailErrorState(message: event.message));
      }
      else if (event is StoreDetailSuccessEvent)
      emit(StoreDetailSuccessState(data: event.data));
    });
  }


  getDetailStore(String id) async{
    this.add(StoreDetailLoadingEvent());
    _service.getStoreDetail(id).then((value) {
      if(value != null){
        this.add(StoreDetailSuccessEvent(data:value ));
      }else
      {
        this.add(StoreDetailErrorEvent(message: 'Error In Fetch Data !!'));
      }
    });
  }


}

abstract class StoreDetailEvent { }
class StoreDetailInitEvent  extends StoreDetailEvent  {}

class StoreDetailSuccessEvent  extends StoreDetailEvent  {
  StoreModel  data;
  StoreDetailSuccessEvent({required this.data});
}

class StoreDetailLoadingEvent  extends StoreDetailEvent  {}

class StoreDetailErrorEvent  extends StoreDetailEvent  {
  String message;
  StoreDetailErrorEvent({required this.message});
}

abstract class StoreDetailStates {}

class StoreDetailInitState extends StoreDetailStates {}

class StoreDetailSuccessState extends StoreDetailStates {
     StoreModel  data;
     StoreDetailSuccessState({required this.data});
}

class StoreDetailLoadingState extends StoreDetailStates {}

class StoreDetailErrorState extends StoreDetailStates {
    String message;
    StoreDetailErrorState({required this.message});
}

