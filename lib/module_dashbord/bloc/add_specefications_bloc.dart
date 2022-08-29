import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';

class SpecificationsBloc extends Cubit<SpecificationsState> {

  SpecificationsBloc() : super(SpecificationsState(data: [] ));


  addOne(SpecificationsModel model ){

    SpecificationsState newState =  SpecificationsState(data: List.from(state.data)..add(model));
     return emit(newState);
  }
  removeOne(SpecificationsModel model) {
    SpecificationsState newState =  SpecificationsState(data: List.from(state.data)..remove(model));
    return emit(newState);
  }
  clear()=> emit(SpecificationsState(data: []));

}
class SpecificationsState{
  List<SpecificationsModel> data;
  SpecificationsState({required this.data });
}