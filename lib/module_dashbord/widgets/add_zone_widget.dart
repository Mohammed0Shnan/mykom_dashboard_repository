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
import 'package:my_kom_dist_dashboard/module_dashbord/services/DashBoard_services.dart';
import 'package:my_kom_dist_dashboard/module_map/map_routes.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class AddZoneWidget extends StatefulWidget {
  final ZoneBloc zoneBloc;
  final StoreBloc storeBloc;
  final String storeID;
  const AddZoneWidget({ required this.storeBloc, required this.storeID, required this.zoneBloc, Key? key}) : super(key: key);

  @override
  State<AddZoneWidget> createState() => _AddZoneWidgetState();
}

class _AddZoneWidgetState extends State<AddZoneWidget> {
  final DashBoardService _dashBoardService = DashBoardService();

  late AddressModel zoneAddressModel ;
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30,),
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
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: (){
                      Navigator.pushNamed(
                          context, MapRoutes.MAP_SCREEN,arguments:true )
                          .then((value) async{
                        if (value != null) {
                          zoneAddressModel = (value as AddressModel);
                          LatLng latLang = LatLng(zoneAddressModel.latitude, zoneAddressModel.longitude);
                          List<String> names = await _dashBoardService.getZoneNames(latLang);
                          ZoneModel zone = ZoneModel(name:names);
                          widget.zoneBloc.addOne(zone);
                        }
                      });

                    },
                  ),
                )),
          ),
        ),
        Container(
          height: 150,
          child: BlocConsumer<ZoneBloc,ZonesState>(
              bloc: widget.zoneBloc,
              listener: (context,state){
                print('new stateeeeeeeeeeeeeeeeeeeeeeeee');
              },
              builder: (context,state) {
                print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(height: 4,),
                                  Text('Arabic name :  '+state.zones[index].name[0] , style: GoogleFonts.lato(
                                      color: Colors.black54,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ],
                              ),
                              Spacer(),
                              IconButton(onPressed: (){
                                widget.zoneBloc.removeOne(state.zones[index]);
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
            bloc: widget.storeBloc,
            listener: (context,state)async{
              if(state is StoreSuccessState)
              {

                snackBarSuccessWidget(context, 'Zones Created Successfully!!');
                Navigator.pop(context);
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

                    StoreModel store = StoreModel(id: widget.storeID,zones: []);

                    store.zones = widget.zoneBloc.state.zones.map((e) =>ZoneModel(name: e.name) ).toList();
                    widget.storeBloc.addZonesToStore(store);
                  },
                  child: Text('Add Zones', style: TextStyle(color: Colors.white,
                      fontSize: 20),),

                ),
              );
            }
        ),

      ],
    );
  }
}
