import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/authorization_routes.dart';
import 'package:my_kom_dist_dashboard/module_authorization/enums/user_role.dart';
import 'package:my_kom_dist_dashboard/module_authorization/model/app_user.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/user_bloc.dart';

import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';


class UsersScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  final UsersBloc _usersBloc = UsersBloc();
  final String ADMINS = 'Admins';
  final String DELIVERS = 'Delivers';
  late String current_tap ;
  @override
  void initState() {
    current_tap = ADMINS;
    _usersBloc.getsUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return BlocProvider.value(
    value: _usersBloc,
    child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('Admins And Delivery',style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showMaterialModalBottomSheet(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
          ),
          ),
          context: context,
          builder:(context){
               return Container(
                 height: 200,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     GestureDetector(
                       onTap: (){
Navigator.pushNamed(context, AuthorizationRoutes.REGISTER_SCREEN,arguments: UserRole.ROLE_DELIVERY);
                       },
                       child: Container(
                         width: 100,
                         height: 70,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20),
                           color: Colors.black12
                         ),
                         child: Center(child: Text('Delivery')),
                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                           Navigator.pushNamed(context, AuthorizationRoutes.REGISTER_SCREEN,arguments: UserRole.ROLE_OWNER);
                       },
                       child: Container(
                         width: 100,
                         height: 70,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                             color: Colors.black12
                         ),
                         child: Center(child: Text('Admin',)),
                       ),
                     )
                   ],
                 ),
               );
          });
        },
        backgroundColor: ColorsConst.mainColor,
        child: Text('Add',style: GoogleFonts.lato(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),

      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
              child: Text('Delivers',style: GoogleFonts.lato(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black45
              ),),
            ),
            SizedBox(height: 8,),
            getAccountSwitcher(),
            SizedBox(height: 8,),

            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: current_tap == ADMINS
                    ? getDelivers()
                    : getAdmins(),
              ),
            ),
          ],
        ),
      ),

    ),
  );
  }
  Widget getAccountSwitcher() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widhtMulti * 3),
      child: BlocBuilder<UsersBloc ,UsersStates >(
        bloc: _usersBloc,
        builder: (context, state) {
          int users =0;
          int admins =0;
          if(state is UsersSuccessState){
            users =state.users.length;
            admins = state.admins.length;
          }
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    current_tap = ADMINS;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: current_tap == ADMINS
                            ? ColorsConst.mainColor
                            : Colors.transparent,

                      ),
                      child: Center(child: Text('Delivers (${users})',style: TextStyle(
                        color: current_tap == ADMINS ?Colors.white: ColorsConst.mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),))),
                ),
              ),
              Expanded(
                child:GestureDetector(
                  onTap: () {
                    current_tap = DELIVERS;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),

                      color:    current_tap == DELIVERS
                          ? ColorsConst.mainColor
                          : Colors.transparent,
                    ),
                    child:Center(child: Text('Admins (${admins})',style: TextStyle(
                        color: current_tap == DELIVERS ?Colors.white: ColorsConst.mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                    ))),
                  ),
                ),
              )

            ],
          );
        }
      ),
    );
  }
  Future<void> onRefreshMyOrder()async {
   // _ordersListBloc.getMyOrders();
  }
 Widget getDelivers(){
    return BlocConsumer<UsersBloc ,UsersStates >(
      bloc: _usersBloc,
      listener: (context ,state){
        // print(state);
        // if (state is CaptainOrderDeletedErrorState){
        //   if(state.message == 'Error'){
        //    snackBarErrorWidget(context, 'Error in deleted !!');
        //   }
        //   else{
        //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
        //   }
        // }
        // else if(state is CaptainOrdersListSuccessState ){
        //   if(state.message !=null){
        //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
        //   }
        // }
      },
      builder: (maincontext,state) {

         if(state is UsersErrorState)
          return Center(
            child: GestureDetector(
              onTap: (){

              },
              child: Container(
                color: ColorsConst.mainColor,
                padding: EdgeInsets.symmetric(),
                child: Text('',style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
              ),
            ),
          );

        else if(state is UsersSuccessState) {
           List<AppUser> users =state.users;

           if(users.isEmpty)
             return Center(
               child: Container(child: Text('Empty !!'),),
             );
           else
          return RefreshIndicator(
          onRefresh: ()=>onRefreshMyOrder(),
          child: ListView.separated(
            itemCount:users.length,
            separatorBuilder: (context,index){
              return SizedBox(height: 8,);
            },
            itemBuilder: (context,index){
              return GestureDetector(
                onTap:(){
                 // Navigator.pushNamed(context, ProfileRoutes.PROFILE_SCREEN,arguments:users[index].id );
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/profile.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Row(
                            children: [
                              Icon(Icons.perm_identity,size: 18,),
                              SizedBox(width: 8,),
                              Text(users[index].user_name,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w800
                              )),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Icon(Icons.email_outlined,size: 18,),
                              SizedBox(width: 8,),
                              Text(users[index].email,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w800
                              )),
                            ],
                          ),
                          SizedBox(height: 8,),

                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,size: 18,),
                              SizedBox(width: 8,),
                              Text(users[index].address.description,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w800,

                              )),
                            ],
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
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
    );
  }

  Widget getAdmins(){
    return BlocConsumer<UsersBloc ,UsersStates >(
        bloc: _usersBloc,
        listener: (context ,state){
          // print(state);
          // if (state is CaptainOrderDeletedErrorState){
          //   if(state.message == 'Error'){
          //    snackBarErrorWidget(context, 'Error in deleted !!');
          //   }
          //   else{
          //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
          //   }
          // }
          // else if(state is CaptainOrdersListSuccessState ){
          //   if(state.message !=null){
          //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
          //   }
          // }
        },
        builder: (maincontext,state) {

          if(state is UsersErrorState)
            return Center(
              child: GestureDetector(
                onTap: (){

                },
                child: Container(
                  color: ColorsConst.mainColor,
                  padding: EdgeInsets.symmetric(),
                  child: Text('',style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
                ),
              ),
            );

          else if(state is UsersSuccessState) {
            List<AppUser> users = state.admins;

            if(users.isEmpty)
              return Center(
                child: Container(child: Text('Empty !!'),),
              );
            else
              return RefreshIndicator(
                onRefresh: ()=>onRefreshMyOrder(),
                child: Stack(
                  children: [
                    ListView.separated(
                      itemCount:users.length,
                      separatorBuilder: (context,index){
                        return SizedBox(height: 8,);
                      },
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                          //  Navigator.pushNamed(context, ProfileRoutes.PROFILE_SCREEN,arguments:users[index].id );

                          },
                          child: Container(
                            height: 120,
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.all(10),
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 80,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/profile.png'),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Row(
                                      children: [
                                        Icon(Icons.perm_identity,size: 18,),
                                        SizedBox(width: 8,),
                                        Text(users[index].user_name,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w800
                                        )),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      children: [
                                        Icon(Icons.email_outlined,size: 18,),
                                        SizedBox(width: 8,),
                                        Text(users[index].email,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w800
                                        )),
                                      ],
                                    ),
                                    SizedBox(height: 8,),

                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,size: 18,),
                                        SizedBox(width: 8,),
                                        Container(
                                          width: SizeConfig.screenWidth * 0.6,
                                          child: Text(users[index].address.description.toString(),overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w800,

                                          )),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // BlocConsumer<NewOrderBloc,CreateOrderStates>(
                    //     bloc: _orderBloc,
                    //     listener: (context,state)async{
                    //       if(state is CreateOrderSuccessState)
                    //       {
                    //         snackBarSuccessWidget(context, 'Order Created Successfully!!');
                    //       }
                    //       else if(state is CreateOrderErrorState)
                    //       {
                    //         snackBarSuccessWidget(context, 'The Order Was Not Created!!');
                    //       }
                    //     },
                    //     builder: (context,state) {
                    //       bool isLoading = state is CreateOrderLoadingState?true:false;
                    //
                    //       return isLoading? Center(child: Container(
                    //         width: 30,
                    //         height: 30,
                    //         child: CircularProgressIndicator(),
                    //       ),):SizedBox.shrink();
                    //
                    //     }
                    // ),

                  ],
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
    );
  }

}
