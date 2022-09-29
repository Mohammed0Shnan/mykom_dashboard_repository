import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/more_statistics_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/statistics_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/order_state_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/product_statistics_detail.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/widgets/month_statistics_chart.dart';
import 'package:my_kom_dist_dashboard/module_profile/screen/profile_screen.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';

class StatistacsesScreen extends StatefulWidget {
  final String storeId;
   StatistacsesScreen({required this.storeId,Key? key}) : super(key: key);

  @override
  State<StatistacsesScreen> createState() => _StatistacsesScreenState();
}

class _StatistacsesScreenState extends State<StatistacsesScreen> {
  final StatisticsBloc statisticsBloc = StatisticsBloc();
  final StatisticsBloc statisticsMonthlyBloc = StatisticsBloc();

  final MoreStatisticsBloc moreStatisticsBloc = MoreStatisticsBloc();
  double totalSales = 0.0;
  int totalOrdersForThisMonth = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    statisticsBloc.getStatistics(widget.storeId);
    statisticsMonthlyBloc.getMonthlyStatistics(widget.storeId);
    moreStatisticsBloc.getMoreStatistics(widget.storeId);
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('DashBoard',style: TextStyle(color: Colors.black54,fontSize: 22,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Center(
                  child: Text('Daily sales analysis',style: TextStyle(fontSize: 20),),
                ),
                BlocConsumer<StatisticsBloc,StatisticsStates>(
                    bloc: statisticsBloc,
                    listener: (context,state){
                      if(state is StatisticsSuccessState)
                        {
                          double _totalRev = 0.0;
                          int _totalOrdersMonth = 0;
                          state.statistics.forEach((element) {
                            _totalRev += element.revenue;
                            _totalOrdersMonth += element.orders;
                          });
                          setState((){
                            totalSales = _totalRev;
                            totalOrdersForThisMonth = _totalOrdersMonth;
                          });
                        }
                    },
                    builder: (context ,state){
                  if(state is StatisticsSuccessState){
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                  height: 500,
                                  child: CustomBarChart(orderStateChart:state.statistics,)),
                            ),
                SizedBox(height: 30,),


                Container(

                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black12.withOpacity(0.1)
                  )
                  ,height: 500,
                  width: MediaQuery.of(context).size.width  * 0.15,
                  child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Daily Sales' , style: GoogleFonts.lato(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),),
                          ),
                          Expanded(
                            child: ListView.separated(
                              physics: ClampingScrollPhysics(),
                                itemCount: state.statistics.length,
                                separatorBuilder: (context,index){
                                  return Divider(endIndent: 20,indent: 20,thickness: 2,);
                                },
                                itemBuilder: (context,index){
                              return Container(

                                height: 75,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Day : '+state.statistics[index].index.toString() +' ( '+DateFormat('yyyy-MM-dd').format(state.statistics[index].dateTime)+' )',
                                    style: TextStyle(color: Colors.black54,fontSize:SizeConfig.widhtMulti *0.6,fontWeight: FontWeight.w700),)
                                   , Row(
                                     children: [
                                       Text('Sales : ' ,
                                          style: TextStyle(color: Colors.black54,fontSize:SizeConfig.widhtMulti *0.6,fontWeight: FontWeight.w700),),

                                       Text(state.statistics[index].revenue.toString() ,
                                         style: TextStyle(color: ColorsConst.mainColor,fontSize: SizeConfig.widhtMulti *0.6,fontWeight: FontWeight.w700),),

                                     ],
                                   )
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                  ),

                 )

            ],
                        ),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 50),
                                padding: EdgeInsets.all(8),
                                height: 75,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Total daily sales for this month : ',
                                      style: TextStyle(color: Colors.black87,fontSize: 17,fontWeight: FontWeight.w700),)
                                    ,
                                    SizedBox(width: 30,),
                                    Text(totalSales.toString() ,
                                      style: TextStyle(color: ColorsConst.mainColor,fontSize: 17,fontWeight: FontWeight.w700),),

                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 50),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Total Monthly orders for this month : ',
                                      style: TextStyle(color: Colors.black87,fontSize: 17,fontWeight: FontWeight.w700),)
                                    ,
                                    SizedBox(width: 30,),
                                    Text(totalOrdersForThisMonth.toString() ,
                                      style: TextStyle(color: ColorsConst.mainColor,fontSize: 17,fontWeight: FontWeight.w700),),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20,),
                        Divider(color: Colors.black45,),
                        SizedBox(height: 20,),

                        /// Month Statistics
                        BlocConsumer<StatisticsBloc,StatisticsStates>(
                            bloc: statisticsMonthlyBloc,
                            listener: (context,state){
                              if(state is StatisticsSuccessState)
                              {
                                double _totalRev = 0.0;
                                state.statistics.forEach((element) {
                                  _totalRev += element.revenue;
                                });
                                setState((){
                                  totalSales = _totalRev;
                                });
                              }
                            },
                            builder: (context ,state){
                              if(state is StatisticsMonthlySuccessState){
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                          height: 500,
                                          child:MonthStatisticsChart(data:state.statistics)),
                                    ),
                                    SizedBox(height: 30,),


                                    Container(

                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.black12.withOpacity(0.1)
                                      )
                                      ,height: 500,
                                      width: MediaQuery.of(context).size.width  * 0.15,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Monthly Sales' , style: GoogleFonts.lato(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black87,
                                            ),),
                                          ),
                                          Expanded(
                                            child: ListView.separated(
                                                physics: ClampingScrollPhysics(),
                                                itemCount: state.statistics.length,
                                                separatorBuilder: (context,index){
                                                  return Divider(endIndent: 20,indent: 20,thickness: 2,);
                                                },
                                                itemBuilder: (context,index){
                                                  return Container(

                                                    height: 75,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text('${state.statistics.keys.elementAt(index)} : ' +' ( '+DateFormat('yyyy-MM').format(state.statistics[state.statistics.keys.elementAt(index)]!.dateTime )+' )',
                                                          style: TextStyle(color: Colors.black54,fontSize:SizeConfig.widhtMulti *0.6,fontWeight: FontWeight.w700),)
                                                        , Row(
                                                          children: [
                                                            Text('Sales : ' ,
                                                              style: TextStyle(color: Colors.black54,fontSize:SizeConfig.widhtMulti *0.6,fontWeight: FontWeight.w700),),

                                                            Text(state.statistics[state.statistics.keys.elementAt(index)]!.revenue.toString() ,
                                                              style: TextStyle(color: ColorsConst.mainColor,fontSize: SizeConfig.widhtMulti *0.6,fontWeight: FontWeight.w700),),

                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),

                                    )

                                  ],
                                );
                              }else if(state is StatisticsErrorState)
                                return Center(child: Text('Error in get Monthly Statistics'),);
                                else
                                return Center(
                                  child: Container(width: 20,height: 20,child: CircularProgressIndicator(),),
                                );

                          }
                        ),

                      ],
                    );
                  }
                  else if(state is StatisticsErrorState){
                    return Container(child: Text(state.message),);
                  }
                  else{
                    return Center(child: Container(child: CircularProgressIndicator(),));
                  }
                })
                ,
                SizedBox(height: 20,),
                Divider(color: Colors.black45,),
                SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('The five most wanted products',style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              )),
            ),
                BlocBuilder<MoreStatisticsBloc,MoreStatisticsStates>(
                    bloc: moreStatisticsBloc,
                    builder: (context ,state){
                      if(state is MoreStatisticsSuccessState){
                       List<ProductModel> items = state.statistics.products;

                       return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: 10,),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black12.withOpacity(0.1)
                              )
                              ,height: 220,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: items.length,

                                  itemBuilder: (context,index){
                                //  return Container();
                                 return   GestureDetector(
                                      onTap: () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductStatisticsDetail(productModel: items[index],)
                                            )
                                        );
                                      },
                                      child: Container(
                                        height: 250,
                                        width: 200,
                                        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 5))
                                            ]),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 100,
                                              child:  Container(
                                                width: double.infinity,
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  child:  CachedNetworkImage(
                                                    imageUrl: items[index].imageUrl,
                                                    progressIndicatorBuilder:
                                                        (context, l, ll) =>
                                                        CircularProgressIndicator(
                                                          value: ll.progress,
                                                        ),
                                                    errorWidget: (context,
                                                        s, l) =>
                                                        Icon(Icons.error),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 8,left: 8,right: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Row(
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
                                                                    .titleSize
                                                                    ),
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
                                                                      1.2),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [

                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 5),

                                                            child: Text(
                                                              items[index].title,
                                                              style: TextStyle(
                                                                  fontSize: SizeConfig
                                                                      .titleSize *
                                                                      1.2,
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  overflow: TextOverflow
                                                                      .ellipsis),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          items[index]
                                                              .quantity
                                                              .toString() + ' Plot',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.black26,
                                                              fontWeight:
                                                              FontWeight.w700,
                                                              fontSize: SizeConfig
                                                                  .titleSize
                                                                  ),
                                                        ),
                                                      ],
                                                    ),



                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                   );
                                  }),

                            ),
                            SizedBox(height: 20,),
                            Divider(color: Colors.black87,),
                            SizedBox(height: 15,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Top five users',style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              )),
                            ),
                            SizedBox(height: 10,),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black12.withOpacity(0.1)
                              )
                              ,height: 220,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: state.statistics.users.length,

                                  itemBuilder: (context,index){
                                    //  return Container();
                                    return   GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileScreen(userID:  state.statistics.users[index].id)));
                                      },
                                      child: Container(
                                        height: 250,
                                        width: 200,
                                        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 5))
                                            ]),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 80,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage('assets/profile.png'),
                                                      fit: BoxFit.cover
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 8,left: 8,right: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                       state.statistics.users[index]
                                                            .user_name
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    SizedBox(height: 12,),
                                                    Row(
                                                      children: [

                                                      Icon(Icons.email_outlined,color: Colors.black54,),
                                                        SizedBox(width: 8,),
                                                        Text(
                                                          state.statistics.users[index].email,
                                                          style: TextStyle(
                                                              color:
                                                              Colors.black54,
                                                              fontWeight:
                                                              FontWeight.w700,
                                                              fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),



                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    );
                                  }),

                            )
                          ],
                        );
                      }
                      else if(state is MoreStatisticsErrorState){
                        return Container(child: Text(state.message),);
                      }
                      else{
                        return Center(child: Container(child: CircularProgressIndicator(),));
                      }
                    }),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
   CustomBarChart({ required this.orderStateChart, Key? key}) : super(key: key);

  final List<OrderStateChart> orderStateChart;
  @override
  Widget build(BuildContext context) {
    List<charts.Series<OrderStateChart,String>> series = [
      charts.Series(id: 'orders',data:orderStateChart,
          domainFn: (series,_)=>  DateFormat.Md().format(series.dateTime).toString(),  // series.index.toString(),//
      measureFn: (series,_)=>series.orders,
        colorFn: (series,_)=>series.barColor!,

        //   labelAccessorFn: (series ,_)=> '${series.revenue}',


      )
    ];
    return charts.BarChart(
      series,
      animate: true,

      animationDuration: Duration(seconds: 1),
      // behaviors: [
      //   charts.DatumLegend(
      //     outsideJustification: charts.OutsideJustification.endDrawArea,
      //     entryTextStyle: charts.TextStyleSpec(
      //       color: charts.MaterialPalette.purple.shadeDefault
      //     )
      //   )
      // ],

    );
  }
}

