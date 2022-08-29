import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';

import 'package:my_kom_dist_dashboard/module_authorization/model/app_user.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/user_bloc.dart';
import 'package:my_kom_dist_dashboard/module_profile/screen/profile_screen.dart';

import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';


class ClientsScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => ClientsScreenState();
}

class ClientsScreenState extends State<ClientsScreen> {
  final TextEditingController _serachController = TextEditingController();
  final UsersBloc _usersBloc = UsersBloc();
  @override
  void initState() {
    _usersBloc.getClients();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade50,
    appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.black87),
      title: Text('All Clients',style: TextStyle(color: Colors.black87),),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
    ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(

            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 1)
                ]),
            child: SizedBox(
              child: TextFormField(

                controller: _serachController,
                style: TextStyle(
                    height: 1
                ),
                onChanged: (String query){
                  _usersBloc.search(query);
                },
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical:20),
                    border: InputBorder.none,
                    prefixIconConstraints: BoxConstraints(
                      minHeight: 40,

                    ),
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 25,
                        color: Colors.black38,
                      ),
                      onPressed: () {
                        _usersBloc.search(_serachController.text);
                      },
                    ),

                    hintText:'Search By User Name',
                    hintStyle: TextStyle(color: Colors.black26)),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: getClients(),

          ),
        ],
      ),
    ),

  );
  }
  Future<void> onRefreshMyOrder()async {
   // _ordersListBloc.getMyOrders();
  }
  Widget getClients(){
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
            List<AppUser> users = state.clients;

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
                           Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileScreen(userID:users[index].id )));

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
