import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/company_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/store_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/requests/add_company_request.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';

class AllStoreBloc extends Bloc<AllStoreEvent, AllStoreStates> {
  final DashBoardService _service = DashBoardService();

  AllStoreBloc() : super(AllStoreLoadingState()) {
    
    on<AllStoreEvent>((AllStoreEvent event, Emitter<AllStoreStates> emit) {
      if (event is AllStoreLoadingEvent)
        emit(AllStoreLoadingState());
      else if (event is AllStoreErrorEvent){
        emit(AllStoreErrorState(message: event.message));
      }
      else if (event is AllStoreSuccessEvent)
      emit(AllStoreSuccessState(data: event.data));
    });
  }


  getAllStore() async{
    this.add(AllStoreLoadingEvent());
    _service.storesPublishSubject.listen((value) {

      if(value != null){
        this.add(AllStoreSuccessEvent(data:value ));
      }else
      {
        this.add(AllStoreErrorEvent(message: 'Error In Fetch Data !!'));
      }
    });
    _service.getAllStores();
  }

  addCompany(String storeId , AddCompanyRequest request){
    _service.addCompanyToStore(storeId , request).then((value){

    });
  }

  Future<CompanyModel?> getCompanyFromId(String id)async{
    CompanyModel? res =await   _service.getCompany(id);
    return res;
  }
}

abstract class AllStoreEvent { }
class AllStoreInitEvent  extends AllStoreEvent  {}

class AllStoreSuccessEvent  extends AllStoreEvent  {
  List<StoreModel>  data;
  AllStoreSuccessEvent({required this.data});
}

class AllStoreLoadingEvent  extends AllStoreEvent  {}

class AllStoreErrorEvent  extends AllStoreEvent  {
  String message;
  AllStoreErrorEvent({required this.message});
}

abstract class AllStoreStates {}

class AllStoreInitState extends AllStoreStates {}

class AllStoreSuccessState extends AllStoreStates {
     List<StoreModel>  data;
  AllStoreSuccessState({required this.data});
}

class AllStoreLoadingState extends AllStoreStates {}

class AllStoreErrorState extends AllStoreStates {
    String message;
  AllStoreErrorState({required this.message});
}

