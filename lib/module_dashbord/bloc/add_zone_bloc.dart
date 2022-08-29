import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/zone_models.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';

class ZoneBloc extends Cubit<ZonesState> {

  ZoneBloc() : super(ZonesState(zones: [] ));


  addOne(ZoneModel zone){

    ZonesState newState =  ZonesState(zones: List.from(state.zones)..add(zone));
    print('zones from bloc ');
    print(newState.zones);
     return emit(newState);
  }
  removeOne(ZoneModel zone) {
    ZonesState newState =  ZonesState(zones: List.from(state.zones)..remove(zone));
    return emit(newState);
  }
  clear()=> emit(ZonesState(zones: []));

}
class ZonesState{
  List<ZoneModel> zones;
  ZonesState({required this.zones });
}