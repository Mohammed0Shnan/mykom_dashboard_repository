import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/requests/add_company_request.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/requests/update_company_request.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';

class AddCompanyBloc extends Bloc<AddCompanyEvent, AddCompanyStates> {
  final DashBoardService _service = DashBoardService();

  AddCompanyBloc() : super(AddCompanyInitState()) {
    
    on<AddCompanyEvent>((AddCompanyEvent event, Emitter<AddCompanyStates> emit) {
      if (event is AddCompanyLoadingEvent)
        emit(AddCompanyLoadingState());
      else if (event is AddCompanyErrorEvent){
        emit(AddCompanyErrorState(message: event.message));
      }
      else if (event is AddCompanySuccessEvent)
      emit(AddCompanySuccessState());
    });
  }


  addCompany(String storeId , AddCompanyRequest request) {
    this.add(AddCompanyLoadingEvent());
    _service.addCompanyToStore(storeId , request).then((value){

      if(value){
        this.add(AddCompanySuccessEvent( ));

      }else
      {
        this.add(AddCompanyErrorEvent(message: 'Error In Fetch Data !!'));
      }
    });
  }

  void updateCompany(String id, CompanyRequest updateRequest) {
    EasyLoading.show();
    _service.updateCompany(id,updateRequest).then((value) {
      if(value){
        EasyLoading.showSuccess('Updated Successfully');}
        else{
          EasyLoading.showError('Error in Update');
      }
      }
    );
  }


}

abstract class AddCompanyEvent { }
class AddCompanyInitEvent  extends AddCompanyEvent  {}

class AddCompanySuccessEvent  extends AddCompanyEvent  {
  AddCompanySuccessEvent();
}

class AddCompanyLoadingEvent  extends AddCompanyEvent  {}

class AddCompanyErrorEvent  extends AddCompanyEvent  {
  String message;
  AddCompanyErrorEvent({required this.message});
}

abstract class AddCompanyStates {}

class AddCompanyInitState extends AddCompanyStates {}

class AddCompanySuccessState extends AddCompanyStates {

     AddCompanySuccessState();
}

class AddCompanyLoadingState extends AddCompanyStates {}

class AddCompanyErrorState extends AddCompanyStates {
    String message;
    AddCompanyErrorState({required this.message});
}

