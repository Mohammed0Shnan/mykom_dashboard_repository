import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/advertisement_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';

class StoreAdvertisementsBloc extends Bloc<StoreAdvertisementsEvent, StoreAdvertisementsStates> {
  final DashBoardService _service = DashBoardService();

  StoreAdvertisementsBloc() : super(StoreAdvertisementsLoadingState()) {
    
    on<StoreAdvertisementsEvent>((StoreAdvertisementsEvent event, Emitter<StoreAdvertisementsStates> emit) {
      if (event is StoreAdvertisementsLoadingEvent)
        emit(StoreAdvertisementsLoadingState());
      else if (event is StoreAdvertisementsErrorEvent){
        emit(StoreAdvertisementsErrorState(message: event.message));
      }
      else if (event is StoreAdvertisementsSuccessEvent)
      emit(StoreAdvertisementsSuccessState(data: event.data));
    });
  }


  getAdvertisementsStore(String storeID) async{
    this.add(StoreAdvertisementsLoadingEvent());
    _service.getAdvertisementsStore(storeID).then((value) {
      if(value != null){
        this.add(StoreAdvertisementsSuccessEvent(data: value));

      }else{
        this.add(StoreAdvertisementsErrorEvent(message: 'Error in fetch companies !!!'));

      }
    });
  }

  void deleteAdvertisement(String id) async{
    /// emit loading state
     EasyLoading.show();
    _service.deleteAdvertisementsFromStore(id).then((value) {
      if(value){
       /// emit success state
        EasyLoading.showSuccess('Success Deleting');

      }else{

        /// emit error state
        EasyLoading.showError('Error Deleting');
      }
    });
  }




}

abstract class StoreAdvertisementsEvent { }
class StoreDetailInitEvent  extends StoreAdvertisementsEvent  {}

class StoreAdvertisementsSuccessEvent  extends StoreAdvertisementsEvent  {
  List<AdvertisementModel>  data;
  StoreAdvertisementsSuccessEvent({required this.data});
}

class StoreAdvertisementsLoadingEvent  extends StoreAdvertisementsEvent  {}

class StoreAdvertisementsErrorEvent  extends StoreAdvertisementsEvent  {
  String message;
  StoreAdvertisementsErrorEvent({required this.message});
}

abstract class StoreAdvertisementsStates {}

class StoreAdvertisementsInitState extends StoreAdvertisementsStates {}

class StoreAdvertisementsSuccessState extends StoreAdvertisementsStates {
  List<AdvertisementModel> data;
     StoreAdvertisementsSuccessState({required this.data});
}

class StoreAdvertisementsLoadingState extends StoreAdvertisementsStates {}

class StoreAdvertisementsErrorState extends StoreAdvertisementsStates {
    String message;
    StoreAdvertisementsErrorState({required this.message});
}

