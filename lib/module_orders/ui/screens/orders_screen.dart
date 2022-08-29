import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/consts/order_status.dart';
import 'package:my_kom_dist_dashboard/module_orders/model/order_model.dart';
import 'package:my_kom_dist_dashboard/module_orders/state_manager/delivery_orders_bloc.dart';
import 'package:my_kom_dist_dashboard/module_orders/ui/screens/owner_orders.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class OrdersScreen extends StatefulWidget {
  final String storeID;
  const OrdersScreen({required this.storeID, Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  final CaptainOrdersListBloc _ordersListBloc = CaptainOrdersListBloc();

  @override
  void initState() {
    super.initState();
    _ordersListBloc.getOwnerOrders(widget.storeID);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [

            SizedBox(height: 20,),
            Expanded(
              child: BlocConsumer<CaptainOrdersListBloc ,CaptainOrdersListStates >(
                  bloc: _ordersListBloc,
                  listener: (context ,state){
                  },
                  builder: (maincontext,state) {

                    if(state is CaptainOrdersListErrorState)
                      return  Center(
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            color: ColorsConst.mainColor,
                            child: Text('Error ! , Scroll For Refresh',style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
                          ),
                        ),
                      );

                    else if(state is CaptainOrdersListSuccessState) {
                     Map<String , List<OrderModel>> sections = state.data;
                      if(sections.isEmpty)
                        return Center(
                          child: Container(child: Text('No Orders !!'),),
                        );
                      else
                        return RefreshIndicator(
                          onRefresh: ()=>onRefreshMyOrder(),
                          child:  ListView.separated(
                              itemCount:sections.length,
                              separatorBuilder: (context,index){
                                return SizedBox(height: 8,);
                              },
                              itemBuilder: (context,index){

                                List<OrderModel> cardOrders = sections[sections.keys.elementAt(index)]!;

                                int finishedOrders = 0;
                                int pendingOrders = 0;
                                double value = 0.0;
                                cardOrders.forEach((element) {

                                  if(element.status == OrderStatus.FINISHED){
                                    finishedOrders++;
                                  value+= element.orderValue;
                                  }
                                  else
                                    pendingOrders++;
                                });


                                return  Container(
                                    height: 150,
                                    width: double.infinity,
                                    padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                                    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius:2,
                                            spreadRadius: 1
                                        )
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(sections.keys.elementAt(index),overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                fontSize: 18,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold
                                            )),
                                            SizedBox(height: 20,),
                                            Text('Number of orders all :  ${cardOrders.length}',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w800
                                            )),
                                            SizedBox(height: 8,),
                                            Text('Processed orders :  ${finishedOrders}',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w800
                                            )),
                                            SizedBox(height: 8,),
                                            Text('Pending orders :  ${pendingOrders}',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w800
                                            )),
                                            SizedBox(height: 8,),
                                            Text('Sales value :  ${value}',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w800
                                            )),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> OwnerOrdersScreen(zone:sections.keys.elementAt(index))));
                                          },
                                          child: Row(children: [
                                            Text('Go for orders'),
                                            SizedBox(width: 8,),
                                           Icon(Icons.arrow_forward_ios)
                                          ],),
                                        )
                                      ],
                                    )
                                );
                              },
                            ),

                        );}
                    else  return Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(color: ColorsConst.mainColor,),
                        ),
                      );

                  }
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> onRefreshMyOrder()async {
    _ordersListBloc.getOwnerOrders(widget.storeID);
  }
}
