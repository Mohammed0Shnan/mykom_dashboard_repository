

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/consts/order_status.dart';
import 'package:my_kom_dist_dashboard/consts/payment_method.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/update_status_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';
import 'package:my_kom_dist_dashboard/module_orders/model/order_model.dart';
import 'package:my_kom_dist_dashboard/module_orders/state_manager/order_detail_bloc.dart';
import 'package:my_kom_dist_dashboard/module_orders/ui/widgets/delete_order_sheak_alert.dart';
import 'package:my_kom_dist_dashboard/module_orders/util/whatsapp_link_helper.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderID;
  const OrderDetailScreen({required this.orderID,Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderDetailBloc _detailBloc = OrderDetailBloc();
  final UpdateStatusBloc _updateStatusBloc = UpdateStatusBloc();

  late String orderID;
  @override
  void initState() {
    orderID = widget.orderID;
    _detailBloc.getOrderDetail(orderId: orderID);

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   orderID = ModalRoute.of(context)!.settings.arguments.toString();
    //   _detailBloc.getOrderDetail(orderId: orderID);
    //
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
              child: BlocConsumer<UpdateStatusBloc, UpdateStatusStates>(
                  bloc: _updateStatusBloc,
                  listener: (context, state) {
                   
                  },
                  builder: (context, state) {
                    if (state is UpdateStatusLoadingState) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: CircularProgressIndicator(
                            color: ColorsConst.mainColor,
                          ),
                        ),
                      );
                    }

                    return SizedBox.shrink();
                  })),
          BlocConsumer<OrderDetailBloc, OrderDetailStates>(
              bloc: _detailBloc,
              listener: (context, state) {

                if (state is OrderDetailSuccessState){

                 // _updateStatusBloc.initState(state.data.status);
                }
              },
              builder: (context, state) {
                if (state is OrderDetailErrorState)
                  return Center(
                    child: Container(
                      child: Text(state.message),
                    ),
                  );
                else if (state is OrderDetailSuccessState) {
                  OrderModel order = state.data;

                  return Scaffold(
                      backgroundColor: Colors.white,
                    appBar: AppBar(
                      iconTheme: IconThemeData(color: Colors.black87),
                      title: Text('Order Detail',style: TextStyle(color: Colors.black87),),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: false,
                    ),
                      body: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  'Order number : ${order.customerOrderID}',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Destination',
                                          style: GoogleFonts.lato(
                                              fontSize: 16,
                                              color: Colors.black54,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    double late =
                                        order.destination.lat;
                                    double lon =
                                        order.destination.lon;

                                    var url = WhatsAppLinkHelper
                                        .getMapsLink(late, lon);
                                    launchUrl(Uri.parse(url));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                        BorderRadius
                                            .circular(5)),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Go To Delivery',
                                          style: TextStyle(
                                              color:
                                              Colors.white,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      child: Text(order.addressName,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w800)),
                                    )
                                  ],
                                ),
                              ),
                              if(!order.note.isEmpty)
                              SizedBox(
                                height: 15,
                              ),
                              if(!order.note.isEmpty)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.description_outlined,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Note : ',
                                          style: GoogleFonts.lato(
                                              letterSpacing: 1,
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      child: Text(order.note,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w800)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.price_change_outlined,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Price : ',
                                          style: GoogleFonts.lato(
                                              letterSpacing: 1,
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                          order.orderValue.toString() +
                                              '    AED',
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.phone_outlined,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Phone : ',
                                          style: GoogleFonts.lato(
                                              letterSpacing: 1,
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(order.phone.toString(),
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.payments_outlined,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Payment : ',
                                          style: GoogleFonts.lato(
                                              letterSpacing: 1,
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(order.payment.toString(),
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.history_outlined,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Order Date : ',
                                          style: GoogleFonts.lato(
                                              letterSpacing: 1,
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                          DateFormat('yyyy-MM-dd : hh-mm')
                                              .format(order.startDate!),
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.description_outlined,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Description : ',
                                          style: GoogleFonts.lato(
                                              letterSpacing: 1,
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      child: Text(order.description,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w800)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showMaterialModalBottomSheet(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30)),
                                      ),
                                      context: context,
                                      builder: (context) => Container(
                                          height: SizeConfig.screenHeight * 0.9,
                                          child: _buildProductListWidget(
                                              order.products,
                                              ModalScrollController.of(
                                                  context)!)));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5,
                                            offset: Offset(0, 2))
                                      ]),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Products : ',
                                            style: GoogleFonts.lato(
                                                letterSpacing: 1,
                                                fontSize: 16,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue),
                                          child: Icon(
                                            Icons.arrow_drop_up,
                                            color: Colors.white,
                                            size: 26,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  width: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5,
                                            offset: Offset(0, 2))
                                      ]),
                                  child: MaterialButton(
                                    onPressed: (){
                                      deleteOrderAlertWidget(context,_detailBloc,orderID);
                                    },
                                    child: Center(
                                      child: Text('Delete Order' , style: TextStyle(color: Colors.red,fontSize:18,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // bottomNavigationBar:
                      //     BlocConsumer<UpdateStatusBloc, UpdateStatusStates>(
                      //         bloc: _updateStatusBloc,
                      //         listener: (context, state) {
                      //           if (state is UpdateStatusSuccessState) {}
                      //         },
                      //         builder: (context, state) {
                      //           if (state is UpdateStatusSuccessState) {
                      //             return Container(
                      //               height: 50,
                      //               decoration: BoxDecoration(
                      //                 color: ColorsConst.mainColor,
                      //               ),
                      //               child: MaterialButton(
                      //                 onPressed: () {
                      //                   if(order.status != OrderStatus.FINISHED)
                      //                   requestOrderProgress(order);
                      //                 },
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.spaceAround,
                      //                   children: [
                      //                     Text(
                      //                       'Update Status To ',
                      //                       style: TextStyle(
                      //                           color: Colors.white,
                      //                           fontSize:
                      //                               SizeConfig.titleSize * 2.2),
                      //                     ),
                      //                     Icon(
                      //                       Icons.arrow_forward,
                      //                       color: Colors.white,
                      //                     ),
                      //                     Text(
                      //                         _getNextState(
                      //                             state.state, order.payment),
                      //                         style: TextStyle(
                      //                             color: Colors.white,
                      //                             fontSize:
                      //                                 SizeConfig.titleSize *
                      //                                     2.2))
                      //                   ],
                      //                 ),
                      //               ),
                      //             );
                      //           }
                      //        else if (state is UpdateStatusLoadingState) {
                      //          return Container(
                      //               height: 50,
                      //               decoration: BoxDecoration(
                      //                 color: ColorsConst.mainColor,
                      //               ),
                      //               child: Center(
                      //                 child: Container(
                      //                   height: 30,
                      //                   width: 30,
                      //                   child:CircularProgressIndicator(color: Colors.white)
                      //                 ),
                      //               )
                      //             );
                      //      }else
                      //           return SizedBox.shrink();
                      //         })
                              
                              );
                } else {
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: ColorsConst.mainColor,
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget _buildProductListWidget(List<ProductModel> items,ScrollController controller) {

    if (items.length == 0) {
      return Center(
        child:  Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: SizeConfig.screenHeight * 0.3,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Image.asset('assets/empity.png',fit: BoxFit.fill,)),
                SizedBox(height: 10,),
                Text('No data to display',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black45),)
              ],
            )),
      );
    } else {

      return AnimationLimiter(
        child: Column(
          children: [
            Center(
              child: Padding(padding: EdgeInsets.symmetric(vertical: 8),
                child: IconButton(icon: Icon(Icons.arrow_downward_rounded,),onPressed: (){
                  Navigator.pop(context);
                }),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.7,
                    children: List.generate(
                        items.length,
                            (index){
                          return  AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount:3,
                            duration: Duration(milliseconds: 350),
                            child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                  //    Navigator.pushNamed(context, CompanyRoutes.PRODUCTS_DETAIL_SCREEN,arguments:items[index].id );
                                    },
                                    child: Badge(
                                      badgeContent: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        height: SizeConfig.heightMulti * 2.1,
                                        width: SizeConfig.heightMulti * 2.1,
                                        child:
                                        Center(
                                          child: Text(items[index].orderQuantity.toString(),
                                            style: TextStyle(color: Colors.white,
                                                fontSize: SizeConfig.titleSize * 2.1,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1))
                                            ]),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AspectRatio(
                                              aspectRatio:  1.5,
                                              child: Container(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                        // child: Image.network( items[index].imageUrl,
                                                        //   fit: BoxFit.fitHeight,
                                                        // )
                                                        child:  CachedNetworkImage(
                                                          imageUrl: items[index]
                                                              .imageUrl,
                                                          progressIndicatorBuilder:
                                                              (context, l, ll) =>
                                                              Center(
                                                                child: Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  child: CircularProgressIndicator(
                                                                    value: ll.progress,
                                                                    color: Colors.black12,
                                                                  ),
                                                                ),
                                                              ),
                                                          errorWidget: (context,
                                                              s, l) =>
                                                              Center(child: Icon(Icons.error,size: 40,color: Colors.black45,)),
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      color: Colors.white,
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          (items[index].old_price !=
                                                              null)
                                                              ? Text(
                                                            items[index]
                                                                .old_price
                                                                .toString(),
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                                color: Colors
                                                                    .black26,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                                fontSize:
                                                                SizeConfig
                                                                    .titleSize *
                                                                    2.2),
                                                          )
                                                              : SizedBox.shrink(),
                                                          SizedBox(width: 8,),
                                                          Expanded(
                                                            child: Text(
                                                              items[index]
                                                                  .price
                                                                  .toString(),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.green,
                                                                  fontWeight:
                                                                  FontWeight.w700,
                                                                  fontSize: SizeConfig
                                                                      .titleSize *
                                                                      2.7),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Expanded(
                                                      child: Container(
                                                        color: Colors.white,
                                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                                        child: Text(

                                                          items[index].title

                                                          ,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: SizeConfig
                                                                  .titleSize *
                                                                  2,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          );})),
              ),
            ),
          ],
        ),
      );



    }
  }
  String _getNextState(OrderStatus currentState, String paymentMethod) {
    String state = '';
    switch (currentState) {
      case OrderStatus.INIT:
        state = 'GOT CAPTAIN';
        break;
      case OrderStatus.GOT_CAPTAIN:
        state = 'IN STORE';
        break;
      case OrderStatus.IN_STORE:
        state = 'DELIVERING';
        break;
      case OrderStatus.DELIVERING:
        state = paymentMethod == PaymentMethodConst.CASH_MONEY
            ? 'GOT CASH'
            : 'FINISHED';
        break;
      case OrderStatus.GOT_CASH:
        state = 'FINISHED';
        break;
      case OrderStatus.FINISHED:
        state = 'FINISHED';
        break;
      case OrderStatus.DONE:
        // TODO: Handle this case.
        break;
    }
    return state;
  }

  void requestOrderProgress(OrderModel currentOrder) {
    late OrderStatus newStatus;
    switch (currentOrder.status) {
      case OrderStatus.INIT:
        newStatus = OrderStatus.GOT_CAPTAIN;
        break;
      case OrderStatus.GOT_CAPTAIN:
        newStatus = OrderStatus.IN_STORE;
        break;
      case OrderStatus.IN_STORE:
        newStatus = OrderStatus.DELIVERING;
        break;
      case OrderStatus.DELIVERING:
        newStatus = currentOrder.payment == PaymentMethodConst.CASH_MONEY
            ? OrderStatus.GOT_CASH
            : OrderStatus.FINISHED;
        break;
      case OrderStatus.GOT_CASH:
        newStatus = OrderStatus.FINISHED;
        break;
      case OrderStatus.FINISHED:
        break;
      case OrderStatus.DONE:
        // TODO: Handle this case.
        break;
    }
    currentOrder.status = newStatus;
    //_updateStatusBloc.updateOrder(currentOrder);
  }
}
