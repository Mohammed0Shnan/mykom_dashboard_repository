import 'package:flutter/material.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/add_Advertisements_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/add_company_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/add_product_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/add_products_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/add_store_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/all_orders_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/all_store_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/clients_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/statistacses_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/users_screen.dart';

class DashBoardScreen extends StatefulWidget {


  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int current_index = 0;
  bool  drawerIsOpen = false;
  Widget _currentPage = StatistacsesScreen(storeId: 'all',);
  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: ColorsConst.mainColor.withOpacity(0.5),
                child: Column(
                  children: [

DrawerHeader(
  decoration: BoxDecoration(
    color: ColorsConst.mainColor
  ),
  child:      Column(
  children: [
        Container(
      child: Image.asset('assets/new_logo.png',height:100,),
    ),
      Text('DashBoard',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),)
  ],
),
),
                    ListTile(
                      selectedTileColor: Colors.white,
selected: (current_index == 0)?true:false,
                      selectedColor: Colors.white,
                      onTap: (){
                        setState((){
                          _currentPage = StatistacsesScreen(storeId: 'all',);
                          current_index= 0;
                        });
                      },
                      title: Text('Main Screen',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    ),
                    ExpansionTile(title: Text('Add',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16)),
                      children: [
                        ListTile(
                          selected: (current_index == 1)?true:false,
                          selectedTileColor: Colors.white,
                          selectedColor: Colors.white,
                          onTap: (){
                            setState((){
                              _currentPage = AddCompanyScreen();
                              current_index = 1;
                            });

                          },
                          title: Text('Add Company ',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15),),
                        ),
                        ListTile(
                          selected: (current_index == 2)?true:false,
                          selectedTileColor: Colors.white,
                          selectedColor: Colors.white,
                          onTap: (){
                            setState((){
                              _currentPage = AddProductsScreen();
                              current_index = 2;
                            });

                          },
                          title: Text('Add Products',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15),),
                        ),
                        ListTile(
                          selected: (current_index == 3)?true:false,
                          selectedTileColor: Colors.white,
                          selectedColor: Colors.white,
                          onTap: (){
                            setState((){
                              _currentPage = AddAdvertisementsScreen();
                              current_index = 3;
                            });

                          },
                          title: Text('Add Advertizements & Messages',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15),),
                        ),

                      ],
                    ),

                    ListTile(
                      selected: (current_index == 4)?true:false,
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.white,
                      onTap: (){
                        setState((){
                          _currentPage = ALlOrdersScreen();
                          current_index = 4;
                        });

                      },
                      title: Text('Manage Orders',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    ),
                    ListTile(
                      selected: (current_index == 5)?true:false,
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.white,
                      onTap: (){
                        setState((){
                          _currentPage = ClientsScreen();
                          current_index = 5;
                        });

                      },
                      title: Text('Clients',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    ),
                    ListTile(
                      selected: (current_index == 6)?true:false,
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.white,
                      onTap: (){
                        setState((){
                          _currentPage = AllStoreScreen();
                          current_index = 6;
                        });

                      },
                      title: Text('Stores & Update Regions',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    ),
                    ListTile(
                      selected: (current_index == 7)?true:false,
                      selectedTileColor: Colors.white,

                      onTap: (){
                        setState((){
                          _currentPage = AddStoreScreen();
                          current_index = 7;
                        });

                      },
                      title: Text('Add Store & Regions',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    ),


                    ListTile(
                      selected: (current_index == 8)?true:false,
                      selectedTileColor: Colors.white,

                      onTap: (){
                        setState((){
                          _currentPage = UsersScreen();
                          current_index = 8;
                        });


                      },
                      title: Text('Admins & Delivery',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: _currentPage),
          ],
        ),
    );
  }


}
