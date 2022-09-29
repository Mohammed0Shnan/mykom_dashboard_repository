
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/company_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/company_service.dart';


class CompanyStoreBloc extends Bloc<CompanyStoreEvent, CompanyStoreStates> {
  final CompanyService _service = CompanyService();
  // final ShopCartBloc shopBloc = shopCartBloc;
  // late StreamSubscription streamSubscription ;
  CompanyStoreBloc() : super(CompanyStoreInitState()) {

    on<CompanyStoreEvent>((CompanyStoreEvent event, Emitter<CompanyStoreStates> emit) {
      if (event is CompanyStoreLoadingEvent)
        emit(CompanyStoreLoadingState());
      else if (event is CompanyStoreErrorEvent){
        emit(CompanyStoreErrorState(message: event.message));
      }
      else if (event is CompanyStoreSuccessEvent){
        emit(CompanyStoreSuccessState(data: event.data));}



      /// Update Company
      if (event is UpdateCompanyStoreLoadingEvent)
        emit(UpdateCompanyStoreLoadingState());
      else if (event is UpdateCompanyStoreErrorEvent){
        emit(UpdateCompanyStoreErrorState(message: event.message));
      }
      else if (event is UpdateCompanyStoreSuccessEvent){
        emit(UpdateCompanyStoreSuccessState(data: event.companyModel));}


      // else if(event is UpdateCompanyStoreSuccessEvent){
      //   _update(event,emit);
      // }

    });
    // streamSubscription = shopBloc.stream.listen((event) {
    //  _update1();
    // });
  }

  // _onSuccessEvent(CompanyStoreSuccessEvent event, Emitter<CompanyStoreStates> emit){

  getcompany(String storeId) async {
    this.add(CompanyStoreLoadingEvent());
    _service.companyStoresPublishSubject.listen((value) {
      if (value != null) {
     
        this.add(CompanyStoreSuccessEvent(data: value));
      } else{
        this.add(CompanyStoreErrorEvent(message: 'Error '));

      }
    });
  
    _service.getAllCompanies(storeId);
  }
  getCompanyById(String companyID) async {
    this.add(UpdateCompanyStoreLoadingEvent());
    _service.getCompanyByID(companyID).then((value) {
      if (value != null) {

        this.add(UpdateCompanyStoreSuccessEvent( value));
      } else{
        this.add(UpdateCompanyStoreErrorEvent(message: 'Error '));

      }
    });

  }
}

abstract class CompanyStoreEvent { }
class CompanyStoreInitEvent  extends CompanyStoreEvent  {}

class CompanyStoreSuccessEvent  extends CompanyStoreEvent  {
  List <CompanyModel>  data;
  CompanyStoreSuccessEvent({required this.data});
}

/// Update Company Events
class UpdateCompanyStoreSuccessEvent  extends CompanyStoreEvent  {
CompanyModel companyModel;
  UpdateCompanyStoreSuccessEvent(this.companyModel);
}

class UpdateCompanyStoreLoadingEvent  extends CompanyStoreEvent  {}

class UpdateCompanyStoreErrorEvent  extends CompanyStoreEvent  {
  String message;
  UpdateCompanyStoreErrorEvent({required this.message});
}



class CompanyStoreLoadingEvent  extends CompanyStoreEvent  {}

class CompanyStoreErrorEvent  extends CompanyStoreEvent  {
  String message;
  CompanyStoreErrorEvent({required this.message});
}

abstract class CompanyStoreStates {}





class CompanyStoreInitState extends CompanyStoreStates {}

/// Update Company States

class UpdateCompanyStoreSuccessState extends CompanyStoreStates {
  CompanyModel  data;
  UpdateCompanyStoreSuccessState({required this.data});
}


class UpdateCompanyStoreLoadingState extends CompanyStoreStates {}

class UpdateCompanyStoreErrorState extends CompanyStoreStates {
  String message;
  UpdateCompanyStoreErrorState({required this.message});
}
class CompanyStoreSuccessState extends CompanyStoreStates {
  List <CompanyModel>  data;
  CompanyStoreSuccessState({required this.data});
}


class CompanyStoreLoadingState extends CompanyStoreStates {}

class CompanyStoreErrorState extends CompanyStoreStates {
    String message;
  CompanyStoreErrorState({required this.message});
}

