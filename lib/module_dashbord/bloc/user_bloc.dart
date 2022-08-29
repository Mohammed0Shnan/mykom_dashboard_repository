
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_authorization/model/app_user.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';


class UsersBloc extends Bloc<UsersEvent,UsersStates>{
  final DashBoardService _service = DashBoardService();

  UsersBloc() : super(UsersLoadingState()) {

    on<UsersEvent>((UsersEvent event, Emitter<UsersStates> emit) {
      if (event is UsersLoadingEvent)
      {
        emit(UsersLoadingState());

      }
      else if (event is UsersErrorEvent){
        emit(UsersErrorState(message: event.message));
      }

      else if (event is UsersSuccessEvent){
        emit(UsersSuccessState(users: event.users,admins: event.admins,message: null,clients: event.clients));
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



  void getsUsers() {

    this.add(UsersLoadingEvent());
    _service.usersPublishSubject.listen((value) {

      if(value != null){
        this.add(UsersSuccessEvent(users:value['users']! ,admins:value['admins']!,clients: []));

      }else
      {
        this.add(UsersErrorEvent(message: 'Error In Fetch users !!'));
      }
    });
    _service.users();
  }



  Future<bool> deleteOrder(String orderID)async{
    return true;
    //return await _ordersService.deleteOrder(orderID);
    // await _ordersService.deleteOrder(orderID).then((value) {
    //   //
    //   // if(value){
    //   //   add(CaptainOrderDeletedSuccessEvent(orderID:orderID));
    //   // }else{
    //   //  add(CaptainOrderDeletedErrorEvent(message: 'Error in order deleted !!!'));
    //   // }
    // });
  }

  @override
  Future<void> close() {
  //  _ordersService.closeStream();
    return super.close();
  }

  void getClients() {
    this.add(UsersLoadingEvent());
    _service.usersPublishSubject.listen((value) {

      if(value != null){
        clients=value['clients']!;
        this.add(UsersSuccessEvent(users:[] ,admins:[],clients: clients));

      }else
      {
        this.add(UsersErrorEvent(message: 'Error In Fetch users !!'));
      }
    });
    _service.clients();
  }
  List<AppUser> clients =[];
  search(String query){
    List<AppUser> suggestionList = clients.where((element) => element.user_name.startsWith(query)).toList();
    this.add(UsersSuccessEvent(users:[] ,admins:[],clients:suggestionList));

  }

}

abstract class UsersEvent { }
class UsersInitEvent  extends UsersEvent  {}

class UsersSuccessEvent  extends UsersEvent  {
  List<AppUser>  users;
  List<AppUser>  admins;
  List<AppUser>  clients;
  UsersSuccessEvent({required this.users,required this.admins,required this.clients});
}
class UsersLoadingEvent  extends UsersEvent  {}

class UsersErrorEvent  extends UsersEvent  {
  String message;
  UsersErrorEvent({required this.message});
}

class UsersDeletedErrorEvent  extends UsersEvent  {
  String message;
  UsersDeletedErrorEvent({required this.message});
}


class UsersDeletedSuccessEvent  extends UsersEvent  {
  String orderID;
  UsersDeletedSuccessEvent({required this.orderID});
}



abstract class UsersStates {}

class CaptainOrdersListInitState extends UsersStates {}

class UsersSuccessState extends UsersStates {
  List<AppUser>  users;
  List<AppUser>  admins;
  List<AppUser>  clients;
  String? message;
  UsersSuccessState({required this.users,required this.admins,required this.clients,required this.message});
}
class UsersLoadingState extends UsersStates {}

class UsersErrorState extends UsersStates {
  String message;
  UsersErrorState({required this.message});
}

class UsersDeletedErrorState extends UsersStates {
  String message;
  UsersDeletedErrorState({required this.message});
}




