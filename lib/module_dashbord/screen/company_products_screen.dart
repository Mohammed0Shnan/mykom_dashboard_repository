import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/store_products_company_detail_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';

class StoreCompanyProductScreen extends StatefulWidget {
  final String companyId;
  const StoreCompanyProductScreen({ required this.companyId , Key? key}) : super(key: key);

  @override
  State<StoreCompanyProductScreen> createState() => _StoreCompanyProductScreenState();
}

class _StoreCompanyProductScreenState extends State<StoreCompanyProductScreen> {
  final StoreProductsCompanyDetailBloc _bloc = StoreProductsCompanyDetailBloc();
  @override
  void initState() {
    _bloc.getDetailProductsCompanyStore(widget.companyId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:   BlocBuilder<StoreProductsCompanyDetailBloc,StoreProductsCompanyDetailStates>(
            bloc: _bloc,
            builder: (context,state2) {
              if(state2 is StoreProductsCompanyDetailSuccessState){
                List<ProductModel> list = state2.data;
                return Column(
                  children: [
                    ...list.map((e) => GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black12)]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('name : '+e.title),
                            Text(e.description)
                          ],),
                      ),
                    ))
                  ],
                );
              }else if(state2 is StoreProductsCompanyDetailErrorState){
                return Center(
                  child: Container(

                    child: Text(state2.message),
                  ),
                );
              }else {
                return Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            })
      ),
    );
  }
}
