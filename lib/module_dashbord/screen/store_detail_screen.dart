
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_zone_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/store_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/store_company_detail_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/store_detail_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/company_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/store_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/company_detail_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/statistacses_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/store_statistacses_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/widgets/add_zone_widget.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/widgets/delete_areart_widget.dart';
import 'package:my_kom_dist_dashboard/module_orders/ui/screens/orders_screen.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class StoreDetailScreen extends StatefulWidget {
  final String storeID;
  StoreDetailScreen(
      {required this.storeID,Key? key});
  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {

  final StoreDetailBloc _storeDetailBloc = StoreDetailBloc();
  final ZoneBloc zoneBloc = ZoneBloc();
  final StoreBloc storeBloc = StoreBloc();
  final StoreCompanyDetailBloc _storeCompanyDetailBloc = StoreCompanyDetailBloc();
  late final String storeId;

  @override
  void initState() {
    //     WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //       storeId = ModalRoute.of(context)!.settings.arguments.toString();
    //       _storeDetailBloc.getDetailStore(storeId);
    // });
    _storeDetailBloc.getDetailStore(widget.storeID);

    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
  }
  bool showCompany = false;
  @override
  Widget build(BuildContext maincontext) {
 //   ShopCartBloc shopCartBlocProvided = context.read<ShopCartBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Store Detail',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<StoreDetailBloc,StoreDetailStates>(
        bloc: _storeDetailBloc,
        builder: (context,state) {
          if(state is StoreDetailSuccessState){
            StoreModel storeModel = state.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50,),
                  Row(
                    children: [
                      Icon(Icons.drive_file_rename_outline),
                      SizedBox(width: 8,),
                      Text('Store Name : ' ,style: GoogleFonts.lato(fontSize: 20,color: Colors.black54,fontWeight: FontWeight.w800),),
                      Text(storeModel.name,style: GoogleFonts.lato(fontSize: 18,color: Colors.black54,fontWeight: FontWeight.w800),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 8,),
                      Text('Location : ' ,style: GoogleFonts.lato(fontSize: 18,color: Colors.black54,fontWeight: FontWeight.w800),),
                      Expanded(child: Container(child: Text(storeModel.locationName,maxLines: 2,style: GoogleFonts.lato(fontSize: 14,color: Colors.black54,fontWeight: FontWeight.w800),))),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 100,
                    child: Row(

                      children: [
                        GestureDetector(
                          onTap:(){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StoreStatisticsScreen(storeID:widget.storeID,storeName: storeModel.name,)));
                          },
                          child: Container(
                            height: 80,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow:[BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 2
                                )]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Icon(Icons.pie_chart),
                                SizedBox(width: 8,),
                                Text('statistics',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                SizedBox(width: 8,),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> OrdersScreen(storeID: storeModel.id,)));
                           },
                          child: Container(
                            height: 80,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow:[BoxShadow(
                                color: Colors.black45,
                                blurRadius: 2
                              )]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Icon(Icons.list_outlined),
                                SizedBox(width: 8,),
                                Text('Orders',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                SizedBox(width: 8,),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Icon(Icons.map_outlined),
                      SizedBox(width: 8,),
                      Text('Regions : ' ,style: GoogleFonts.lato(fontSize: 20,color: Colors.black54,fontWeight: FontWeight.w800),),
                  SizedBox(width: 20,),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: (){
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
                                  child: AddZoneWidget(zoneBloc: zoneBloc,storeID:widget.storeID ,storeBloc: storeBloc,)));

                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Stack(

                    children: [
                      Container(
                        height: SizeConfig.screenHeight*0.23,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
          itemCount:storeModel.zones.length,
                            itemBuilder: (context,index){
                          return  Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all()
                            ),
                              height:180,
                              width: 150,
                              child: Column(
                                children: [
                                  Container(height:90,
                                    child: Image.asset('assets/zone.png',fit: BoxFit.cover,),
                                  ),
                                  SizedBox(height: 8,),
                                  Text(storeModel.zones[index].name.toString(),style: TextStyle(fontSize: SizeConfig.heightMulti * 2.2),),
                          GestureDetector(
                            onTap: (){
                              deleteCheckAlertWidget(maincontext, function: (){
                                String areaID = storeModel.zones[index].id;
                                storeBloc.removeZoneFromStore(areaID);
                              }, message: 'Do you want to delete this area?');
                            },
                            child: Container(
                              color: Colors.red,
                              height: 28,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Delete', style: TextStyle(color: Colors.white,
                                  fontSize: 18),),
                            ),
                          )
                                ],
                              ));
                        }),
                      ),
                      Positioned.fill(child:        BlocConsumer<StoreBloc,StoreStates>(
                          bloc: storeBloc,
                          listener: (context,state)async{
                            if(state is StoreSuccessState)
                            {

                              snackBarSuccessWidget(context, 'Zones Deleted Successfully!!');
                            
                            }
                            else if(state is StoreErrorState)
                            {
                              snackBarSuccessWidget(context, 'The Store Was Not Deleted!!');
                            }
                          },
                          builder: (context,state) {
                            bool isLoading = state is StoreLoadingState?true:false;
                            if(isLoading)
                              return Center(child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.white,),
                                height: 40,width: 40,
                              child: CircularProgressIndicator(color: Colors.blue,),
                              ),);
                            else return SizedBox.shrink();
                          }
                      ) )
                    ],
                  ),

                  SizedBox(height: 30,),
                  GestureDetector(
                      onTap: (){
                        showCompany = ! showCompany;
                        setState(() {
                        });
                        _storeCompanyDetailBloc.getDetailCompanyStore(storeModel.id);
                      },
                        child:  Row(
                          children: [
                            Text('Show Companies : ' ,style: GoogleFonts.lato(fontSize: 20,color: Colors.black54,fontWeight: FontWeight.w800),),
                          Text('Click here ',style: TextStyle(color: Colors.blue),)
                          ],
                        ),
                  ),
                    SizedBox(height: 20,),
                    if(showCompany)
                    BlocBuilder<StoreCompanyDetailBloc,StoreCompanyDetailStates>(
                   bloc: _storeCompanyDetailBloc,
                    builder: (context,state2) {
                      if(state2 is StoreCompanyDetailSuccessState){
                        List<CompanyModel> list = state2.data;
                      return  Container(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:list.length,
                              itemBuilder: (context,index){
                              
                                return  GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> CompanyDetailScreen(company: list[index])));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(
                                          border: Border.all()
                                      ),
                                      height:140,
                                      width: 150,
                                      child: Column(
                                        children: [
                                          Container(height:100,
                                            child: Image.asset('assets/company.png',fit: BoxFit.cover,),
                                          ),
                                          SizedBox(height: 8,),
                                          Expanded(child: Text(list[index].name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,color: Colors.black54),)),
                                          GestureDetector(
                                            onTap: (){
                                              deleteCheckAlertWidget(maincontext, function: (){

                                                _storeCompanyDetailBloc.updateCompanyState(list[index].id,list[index].available?false:true);
                                              }, message:(list[index].available)? 'Do you want to deactivate this company?':'Do you want to activate this company?');
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 80,
                                              color: (list[index].available?Colors.green:Colors.red),
                                              child: Center(child: Text(list[index].available?'Available':'Not Available',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)),
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              }),
                        );

                      }else if(state2 is StoreCompanyDetailErrorState){
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
          }),
                  SizedBox(height: 20,),
                ],
              ),
            );
            
          }else if(state is StoreDetailErrorState){
            return Center(child: Text('Error'));
          }
          else{
            return Center(child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator()));

          }
          return Container(
            child: Column(
              children: [
                
              ],
            ),
          );
        }
      ),
//       body: Material(
//
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//            automaticallyImplyLeading: false,
//               toolbarHeight: 11.9 * SizeConfig.heightMulti,
//               pinned: true
//               ,
//               backgroundColor: ColorsConst.mainColor,
//               expandedHeight: SizeConfig.screenHeight * 0.35,
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconWidget(icon:Icons.arrow_back, onPress: (){
//                     Navigator.pop(context);
//                   }),
//                   BlocBuilder<ShopCartBloc,CartState>(
//                       bloc: shopCartBlocProvided,
//                       builder: (context,state) {
//
//                         return Container(
//                           alignment: Alignment.center,
//                           width:SizeConfig.heightMulti *7,
//                           height: SizeConfig.heightMulti *7,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white.withOpacity(0.8)
//                           ),
//                           child:Badge(
//                             // position: BadgePosition.topEnd(top: 0, end: 3),
//                             animationDuration: Duration(milliseconds: 300),
//                             animationType: BadgeAnimationType.slide,
//                             badgeContent: Text(
//                             (state is CartLoaded)?  state.cart.products.length.toString():'0',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             child: IconButton(
//                                 icon: Icon(Icons.shopping_cart_outlined,color: Colors.black,),
//                                 onPressed: () {
//                                   Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);
//                                 }),
//                           ),
//                         );
//                       }
//                   ),
//
//
//                 ],
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 background:     Container(
//             width: double.infinity,
//             child:Text('image'),
//             // child: widget.productModel.imageUrl.length != 0
//             //     ? Container(
//             //         decoration: BoxDecoration(
//             //           image: DecorationImage(
//             //             image: new ExactAssetImage(widget.productModel.imageUrl),
//             //             fit: BoxFit.cover,
//             //           ),
//             //         ),
//             //       )
//             //     : CachedNetworkImage(
//             //         maxHeightDiskCache: 5,
//             //         imageUrl: widget.productModel.imageUrl,
//             //         progressIndicatorBuilder: (context, l, ll) =>
//             //             CircularProgressIndicator(
//             //           value: ll.progress,
//             //         ),
//             //         errorWidget: (context, s, l) => Icon(Icons.error),
//             //         fit: BoxFit.cover,
//             //       ),
//           ),
//
//
//
//               ),
//               bottom: PreferredSize(
//                 preferredSize: Size.fromHeight(20),
//                 child: Container(
//                   padding: EdgeInsets.only(bottom: 10,top: 10),
//                     decoration: BoxDecoration(
//                         color: Colors.white
//                         ,borderRadius: BorderRadius.only(
//
//                       topLeft:Radius.circular(20),
//                         topRight: Radius.circular(20)
//                     ))
//                     ,child: Center(child: Text('title',style: GoogleFonts.lato(
//                   fontWeight: FontWeight.bold,
//                   fontSize: SizeConfig.titleSize * 3.5,
//                   color: Colors.black87
//
//                   )
//                 ))) ,
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 20,),
//                     Text('Description',style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.black54,
//                         fontWeight: FontWeight.w600),),
//                     SizedBox(height: 10,),
//                      ExpadedTextWidget(text: 'description'),
//                        SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Specifications',
//                   style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.black54,
//                       fontWeight: FontWeight.w600),
//                 ),
//
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Column(children: [
//                     Divider(
//                       color: Colors.black,
//
//                       endIndent: 10,
//                     ),
//                    // ...widget.productModel.specifications.map((e) =>       Container(
//                    //   margin: EdgeInsets.symmetric(vertical: 5),
//                    //   child: Row(
//                    //     children: [
//                    //       Text(
//                    //         '${e.name} : ',
//                    //         style: TextStyle(fontWeight: FontWeight.w800),
//                    //       ),
//                    //       Text('${e.value}  '),
//                    //
//                    //     ],
//                    //   ),
//                    // ),),
//                     SizedBox(height: 20,)
//
//                   ]),
//                 ),
//                   ],
//                 ),
//               ),
//             )
//
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.all(8),
//         height: 120,
//         decoration: BoxDecoration(
//             color: Colors.grey.shade200
//             ,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
//         child:               Container(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween
//               ,
//               children: [
//
//                 Container(
//                     width: SizeConfig.widhtMulti * 30
//                     ,height: 6 * SizeConfig.heightMulti
//                     ,  child: LayoutBuilder(
//                   builder:
//                       (BuildContext context, BoxConstraints constraints) {
//                     double w = constraints.maxWidth;
//
//                     return Container(
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(
//                         boxShadow: [BoxShadow(color: Colors.black12)],
//                           borderRadius: BorderRadius.circular(10)
// ,
//                           color: Colors.white.withOpacity(0.1),
//                       ),
//                       child: Stack(
//                         children: [
//                           Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//
//                                 decoration: BoxDecoration(
//                                     color: ColorsConst.mainColor,
//                                     borderRadius: BorderRadius.circular(10)
//                                 ),
//                                 width: w / 3,
//                                 child: IconButton(
//                                     onPressed: () {
//                                         addRemoveBloc.removeOne();
//                                     },
//                                     icon: Icon(
//                                       Icons.remove,
//                                       size: SizeConfig.imageSize * 5,
//                                       color: Colors.white,
//                                     )),
//                               ),
//                               BlocBuilder<AddRemoveProductQuantityBloc , int>(
//                                   bloc:addRemoveBloc ,
//                                   builder: (context,state){
//                                    return  Container(
//                                       child: Text( state.toString(),style: TextStyle(fontWeight: FontWeight.w500,),),
//                                     );
//                                   })
//                            ,
//                               Container(
//                                 decoration: BoxDecoration(
//                                     color: ColorsConst.mainColor,
//                                     borderRadius: BorderRadius.circular(10)
//                                 ),
//                                 width: w / 3,
//                                 child: Center(
//                                   child: IconButton(
//                                       onPressed: () {
//                                         addRemoveBloc.addOne();
//                                       },
//                                       icon: Icon(
//                                         Icons.add,
//                                         size: SizeConfig.imageSize * 5,
//                                         color: Colors.white,
//                                       )),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 )),
//                 Text('100  AED',
//                   style: GoogleFonts.lato(
//                       color: ColorsConst.mainColor,
//                       fontSize: SizeConfig.titleSize * 2.8,
//                       fontWeight: FontWeight.bold
//                   ),
//                 ),
//               ],
//             ),
//
//             Builder(
//               builder:(context)=> Container(
//                 clipBehavior: Clip.antiAlias,
//                 height: 7.3 * SizeConfig.heightMulti,
//                 decoration: BoxDecoration(
//                     color: ColorsConst.mainColor,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: MaterialButton(
//                   onPressed: () {
//                     if(addRemoveBloc.state == 0){
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content:  Text('Select the number of items required',style: TextStyle(color: Colors.white ,letterSpacing: 1, fontWeight: FontWeight.bold,),),
//                         backgroundColor: Colors.black54,
//                         duration: const Duration(seconds: 1),
//
//                       ));
//                     }
//                     else{
//                       // shopCartBlocProvided.addProductsToCart(widget.productModel,addRemoveBloc.state).then((value) {
//                       //
//                       //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       //     content:  Text('${addRemoveBloc.state} Items have been added',style: TextStyle(color: Colors.white ,letterSpacing: 1, fontWeight: FontWeight.bold,),),
//                       //     backgroundColor: Colors.black54,
//                       //     duration: const Duration(seconds: 1),
//                       //
//                       //   ));
//                       //   addRemoveBloc.clear();
//                       // });
//                     }
//
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Add to cart',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: SizeConfig.titleSize * 2.7),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Icon(Icons.shopping_cart_outlined,
//                           color: Colors.white)
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//           ]),
//         ),
//       ),
    );
  }
}



