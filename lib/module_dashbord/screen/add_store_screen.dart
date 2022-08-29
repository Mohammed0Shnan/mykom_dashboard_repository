

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_zone_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/store_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/store_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/zone_models.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/all_store_screen.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';
import 'package:my_kom_dist_dashboard/module_map/map_routes.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';
import 'package:my_kom_dist_dashboard/module_map/models/geo_model.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class AddStoreScreen extends StatefulWidget {
  const AddStoreScreen({Key? key}) : super(key: key);

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {

  final TextEditingController _newAddressController =
  TextEditingController();

  final TextEditingController _storeameController =
  TextEditingController();

  final TextEditingController _minimumPurchesController =
  TextEditingController();

  final TextEditingController _zoneNameController =
  TextEditingController();
  final ZoneBloc zoneBloc = ZoneBloc();
  final StoreBloc storeBloc = StoreBloc();
  final DashBoardService _dashBoardService = DashBoardService();
  late AddressModel addressModel ;
  late AddressModel zoneAddressModel ;
   bool vip_order_service =false ;
  late List<ZoneModel> zones=[];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('Add Product And Company',style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30,),
              /// Store Name
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  child: ListTile(
                      subtitle: Container(
                        height: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                        ),
                        child: TextFormField(
                          controller: _storeameController,
                          decoration: InputDecoration(
                              errorStyle: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w800,
                              ),
                              prefixIcon: Icon(Icons.store),
                              border:InputBorder.none,
                              hintText: 'store name .'
                              , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 18)

                            //S.of(context).name,
                          ),
                          // Move focus to next
                          validator: (result) {
                            if (result!.isEmpty) {
                              return 'Store Name is Required'; //S.of(context).nameIsRequired;
                            }
                            return null;
                          },
                        ),
                      )),
                ),
              ),


              SizedBox(height: 20,),
              ///   Address
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(

                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              controller:
                              _newAddressController,
                              readOnly: true,
                              enableInteractiveSelection: true,

                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon:
                                  Icon(Icons.location_on),
                                  border:InputBorder.none,
                                  hintText: 'Dubai',
                                  hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 18)// S.of(context).email,
                              ),

                              textInputAction: TextInputAction.next,

                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Address is Required'; //S.of(context).emailAddressIsRequired;
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(
                                context, MapRoutes.MAP_SCREEN,arguments: true)
                                .then((value) {
                              if (value != null) {
                                addressModel = (value as AddressModel);
                                _newAddressController.text =
                                    addressModel.description;
                              }
                            });
                          },
                          child: Container(

                            width: SizeConfig.heightMulti * 8.5,
                            height: SizeConfig.heightMulti * 7.5,
                            decoration: BoxDecoration(
                                color: ColorsConst.mainColor,
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: Icon(
                                Icons.my_location_outlined,
                                size: SizeConfig.heightMulti * 4,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )),
              ),

              SizedBox(height: 10,),
              /// Minimum Parch
              ///
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  child: ListTile(
                      subtitle: Container(
                        height: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                        ),
                        child: TextFormField(
                          controller: _minimumPurchesController,
                          decoration: InputDecoration(
                              errorStyle: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w800,
                              ),
                              prefixIcon: Icon(Icons.store),
                              border:InputBorder.none,
                              hintText: 'Minimum Parch .'
                              , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 18)

                            //S.of(context).name,
                          ),
                          // Move focus to next
                          validator: (result) {
                            if (result!.isEmpty) {
                              return 'Minimum Parch is Required'; //S.of(context).nameIsRequired;
                            }
                            return null;
                          },
                        ),
                      )),
                ),
              ),
              SizedBox(height: 10,),
              Switch(value: vip_order_service,  onChanged: (v){
                setState((){
                  vip_order_service = v;
                });
              }),
              SizedBox(height: 20,),
              /// Add Zones
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(

                  child: ListTile(

                      subtitle: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                        ),
                        child: TextFormField(
                          controller: _zoneNameController,
                          decoration: InputDecoration(
                              errorStyle: GoogleFonts.lato(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w800,


                              ),
                             suffixIcon: IconButton(
                               icon: Icon(Icons.add),
                               onPressed: (){
                                 Navigator.pushNamed(
                                     context, MapRoutes.MAP_SCREEN,arguments:true )
                                     .then((value) async{
                                   if (value != null) {
                                     zoneAddressModel = (value as AddressModel);
                                     LatLng latLang = LatLng(zoneAddressModel.latitude, zoneAddressModel.longitude);
                                     List<String> names = await _dashBoardService.getZoneNames(latLang);
                                     _zoneNameController.text = names[0] + ' , ' +names[1];
                                     ZoneModel zone = ZoneModel(name:names);
                                     zoneBloc.addOne(zone);
                                     _zoneNameController.clear();
                                   }
                                 });

                               },
                             ),
                              border:InputBorder.none,
                              hintText: 'zone name .'
                              , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 18)

                            //S.of(context).name,
                          ),
                          // Move focus to next
                          validator: (result) {
                            if (result!.isEmpty) {
                              return 'Zone Name is Required'; //S.of(context).nameIsRequired;
                            }
                            return null;
                          },
                        ),
                      )),
                ),
              ),

              Container(
                height: 150,
                child: BlocBuilder<ZoneBloc,ZonesState>(
                  bloc: zoneBloc,
                  builder: (context,state) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),

                      child: ListView.separated(
                        separatorBuilder: (context,index){
                          return  SizedBox(height: 8,);
                        },
                        shrinkWrap:true ,
                        itemCount: state.zones.length,
                        itemBuilder: (context,index){

                          return   Center(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: double.infinity,

                              //height: 11 * SizeConfig.heightMulti,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade50,
                                  border: Border.all(
                                      color: Colors.black26,
                                      width: 2
                                  )
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [


                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text('English name :  '+state.zones[index].name[1] , style: GoogleFonts.lato(
                                          color: Colors.black54,
                                          fontSize: SizeConfig.titleSize * 2.2,
                                          fontWeight: FontWeight.bold
                                      ),),
                                      SizedBox(height: 4,),
                                      Text('Arabic name :  '+state.zones[index].name[0] , style: GoogleFonts.lato(
                                          color: Colors.black54,
                                          fontSize: SizeConfig.titleSize * 2.2,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Spacer(),
                                  IconButton(onPressed: (){
                                    zoneBloc.removeOne(state.zones[index]);
                                  }, icon: Icon(Icons.delete,color: Colors.red,)),

                                ],
                              ),
                            ),
                          );

                        },

                      ),
                    );
                  }
                ),
              ),
              BlocConsumer<StoreBloc,StoreStates>(
                  bloc: storeBloc,
                  listener: (context,state)async{
                    if(state is StoreSuccessState)
                    {

                      snackBarSuccessWidget(context, 'Store Created Successfully!!');
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>AllStoreScreen()));
                    }
                    else if(state is StoreErrorState)
                    {
                      snackBarSuccessWidget(context, 'The Store Was Not Created!!');
                    }
                  },
                  builder: (context,state) {
                    bool isLoading = state is StoreLoadingState?true:false;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      clipBehavior: Clip.antiAlias,
                      height: 8.44 * SizeConfig.heightMulti,
                      width:isLoading?60: SizeConfig.screenWidth * 0.8,
                      padding: EdgeInsets.all(isLoading?8:0 ),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: ColorsConst.mainColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child:isLoading?Center(child: CircularProgressIndicator(color: Colors.white,)): MaterialButton(
                        onPressed: () {

                          StoreModel store = StoreModel(id: '',zones: []);
                          store.name = _storeameController.text.trim();
                          double _minimumParch =  double.parse(_minimumPurchesController.text.trim());
                          store.location = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                          store.locationName = addressModel.description;
                          store.minimumParch = _minimumParch;
                          store.vipService = vip_order_service;
                          store.zones = zoneBloc.state.zones.map((e) =>ZoneModel(name: e.name) ).toList();
                          storeBloc.addStore(store);
                        },
                        child: Text('Add Store', style: TextStyle(color: Colors.white,
                            fontSize: SizeConfig.titleSize * 2.7),),

                      ),
                    );
                  }
              ),

              // Container(
              //   child: BlocBuilder<AddCompaniesBloc,AddCompanyState>(
              //     bloc: addCompaniesBloc,
              //     builder: (context,state){
              //       return ListView.builder(
              //           itemCount: state.companies.length,
              //           itemBuilder: (context,index){
              //         return Container(
              //           child: ,
              //         );
              //       });
              //     },
              //   ),
              // ),
              // Container(
              //   height: 150,
              //   child: BlocBuilder<ZoneBloc,ZonesState>(
              //       bloc: zoneBloc,
              //       builder: (context,state) {
              //         return Container(
              //           margin: EdgeInsets.symmetric(horizontal: 20),
              //
              //           child: ListView.separated(
              //             separatorBuilder: (context,index){
              //               return  SizedBox(height: 8,);
              //             },
              //             shrinkWrap:true ,
              //             itemCount: state.zones.length,
              //             itemBuilder: (context,index){
              //
              //               return   Center(
              //                 child: Container(
              //                   width: double.infinity,
              //                   height: 6.8 * SizeConfig.heightMulti,
              //                   decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(10),
              //                       color: Colors.grey.shade50,
              //                       border: Border.all(
              //                           color: Colors.black26,
              //                           width: 2
              //                       )
              //                   ),
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.min,
              //
              //                     children: [
              //
              //
              //                       Text(state.zones[index] , style: GoogleFonts.lato(
              //                           color: Colors.black54,
              //                           fontSize: SizeConfig.titleSize * 2.1,
              //                           fontWeight: FontWeight.bold
              //                       ),),
              //                       Spacer(),
              //                       IconButton(onPressed: (){
              //                         zoneBloc.removeOne(state.zones[index]);
              //                       }, icon: Icon(Icons.delete,color: Colors.red,)),
              //
              //                     ],
              //                   ),
              //                 ),
              //               );
              //
              //             },
              //
              //           ),
              //         );
              //       }
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
