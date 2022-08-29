import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/advertisement_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';

class AddAdvertisementBloc extends Bloc<AddAdvertisementEvent, AddAdvertisementStates> {
  final DashBoardService _service = DashBoardService();

  AddAdvertisementBloc() : super(AddAdvertisementInitState()) {
    
    on<AddAdvertisementEvent>((AddAdvertisementEvent event, Emitter<AddAdvertisementStates> emit) {
      if (event is AddAdvertisementLoadingEvent)
        emit(AddAdvertisementLoadingState());
      else if (event is AddAdvertisementErrorEvent){
        emit(AddAdvertisementErrorState(message: event.message));
      }
      else if (event is AddAdvertisementSuccessEvent)
      emit(AddAdvertisementSuccessState());
    });
  }


  addAdvertisement(AdvertisementModel request) {
    this.add(AddAdvertisementLoadingEvent());
    _service.addAdvertisementToStore(request).then((value){

      if(value){
        this.add(AddAdvertisementSuccessEvent( ));

      }else
      {
        this.add(AddAdvertisementErrorEvent(message: 'Error In Fetch Data !!'));
      }
    });
  }

 Future<bool> sendMessage({required String title, required String subTitle}) async{
   return await _service.sendNotificationMessage(title:title,subTitle:subTitle);
  }


}

abstract class AddAdvertisementEvent { }
class AddAdvertisementInitEvent  extends AddAdvertisementEvent  {}

class AddAdvertisementSuccessEvent  extends AddAdvertisementEvent  {
  AddAdvertisementSuccessEvent();
}

class AddAdvertisementLoadingEvent  extends AddAdvertisementEvent  {}

class AddAdvertisementErrorEvent  extends AddAdvertisementEvent  {
  String message;
  AddAdvertisementErrorEvent({required this.message});
}

abstract class AddAdvertisementStates {}

class AddAdvertisementInitState extends AddAdvertisementStates {}

class AddAdvertisementSuccessState extends AddAdvertisementStates {

     AddAdvertisementSuccessState();
}

class AddAdvertisementLoadingState extends AddAdvertisementStates {}

class AddAdvertisementErrorState extends AddAdvertisementStates {
    String message;
    AddAdvertisementErrorState({required this.message});
}

