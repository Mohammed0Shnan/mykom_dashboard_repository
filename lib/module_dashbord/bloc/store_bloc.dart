

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/store_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/zone_models.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';

class StoreBloc extends Bloc<StoreEvent, StoreStates> {
  final DashBoardService _service = DashBoardService();
  // final ShopCartBloc shopBloc = shopCartBloc;
  // late StreamSubscription streamSubscription ;
  StoreBloc() : super(StoreInitState()) {

    on<StoreEvent>((StoreEvent event, Emitter<StoreStates> emit) {
      if (event is StoreLoadingEvent)
        emit(StoreLoadingState());
      else if (event is StoreErrorEvent){
        emit(StoreErrorState(message: event.message));
      }
      else if (event is StoreSuccessEvent){
        emit(StoreSuccessState());}
      // else if(event is UpdateProductsCompanySuccessEvent){
      //   _update(event,emit);
      // }
    });
    // streamSubscription = shopBloc.stream.listen((event) {
    //  _update1();
    // });
  }

  // _onSuccessEvent(ProductsCompanySuccessEvent event, Emitter<ProductsCompanyStates> emit){
  // List<ProductModel> list = event.data;
  // Map<ProductModel , int> map = <ProductModel , int>{};
  // list.forEach((element) { map.addAll({element: 0});});
  // emit(ProductsCompanySuccessState(data: map));
  // }

  // _update1(){
  //   add(UpdateProductsCompanySuccessEvent());
  //
  // }
  // _update(UpdateProductsCompanySuccessEvent event, Emitter<ProductsCompanyStates> emit){
  //
  //   CartState cartState =  shopBloc.state;
  //   if(this.state is ProductsCompanySuccessState){
  //
  //     Map currentState =( this.state as ProductsCompanySuccessState).data;
  //     if(cartState is CartLoaded){
  //       Map<ProductModel ,int> items = {};
  //       int q=0;
  //       Map<ProductModel ,int> map= cartState.cart.productQuantity(cartState.cart.products) ;
  //
  //
  //       currentState.forEach((key, value) {
  //         bool isAdded = false;
  //         for(int j=0;j<map.keys.length;j++){
  //           ProductModel productModel =   map.keys.elementAt(j);
  //           if(productModel.id == key.id){
  //
  //             q= map.values.elementAt(j);
  //             items.addAll({productModel:q});
  //             isAdded = ! isAdded;
  //
  //           }
  //         }
  //         if(!isAdded){
  //           q=0;
  //           items.addAll({key:q});
  //
  //         }
  //       });
  //       emit(ProductsCompanySuccessState(data: items));
  //     }
  // }


  // getProducts(String compny_id) async {
  //   this.add(ZoneLoadingEvent());
  //   _service.getCompanyProducts(compny_id).then((value) {
  //     if (value != null) {
  //       products = value;
  //       this.add(ZoneSuccessEvent(data: products));
  //     } else{
  //       this.add(ZoneErrorEvent(message: 'Error '));
  //
  //     }
  //   });
  // }
addStore(StoreModel storeModel) async {
  this.add(StoreLoadingEvent());
  _service.addStore(storeModel).then((value) {
    if (value != null) {
      this.add(StoreSuccessEvent());
    } else{
      this.add(StoreErrorEvent(message: 'Error '));
    }
  });
}

  addZonesToStore(StoreModel storeModel) async {
    this.add(StoreLoadingEvent());
    _service.addZonesToStore(storeModel).then((value) {
      if (value != null) {
        this.add(StoreSuccessEvent());
      } else{
        this.add(StoreErrorEvent(message: 'Error '));
      }
    });
  }

  removeZoneFromStore(String zoneID) async {
    this.add(StoreLoadingEvent());
    _service.removeZoneFromStore(zoneID).then((value) {
      if (value) {
        this.add(StoreSuccessEvent());
      } else{
        this.add(StoreErrorEvent(message: 'Error '));
      }
    });
  }
}



abstract class StoreEvent { }
class StoreInitEvent  extends StoreEvent  {}

class StoreSuccessEvent  extends StoreEvent  {

}

class StoreLoadingEvent  extends StoreEvent  {}

class StoreErrorEvent  extends StoreEvent  {
 String message;
 StoreErrorEvent({required this.message});
}

abstract class StoreStates {}

class StoreInitState extends StoreStates {}

class StoreSuccessState extends StoreStates {

}


class StoreLoadingState extends StoreStates {}

class StoreErrorState extends StoreStates {
    String message;
    StoreErrorState({required this.message});
}

