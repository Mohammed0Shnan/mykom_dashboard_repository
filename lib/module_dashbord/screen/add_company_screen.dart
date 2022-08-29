import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_company1_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/all_store_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/company_store_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/enum/image_type.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/company_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/store_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/zone_models.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/requests/add_company_request.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';
import 'package:my_kom_dist_dashboard/module_upload/upload_bloc.dart';
import 'package:my_kom_dist_dashboard/module_upload/widgets/choose_photo_source_dialog.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({Key? key}) : super(key: key);

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {

  final TextEditingController _nameCompanyController =
  TextEditingController();

  final TextEditingController _name2CompanyController =
  TextEditingController();

  final TextEditingController _desCompanyController =
  TextEditingController();

  final AllStoreBloc allStoreBloc = AllStoreBloc();
  CompanyStoreBloc  _companyStoreBloc = CompanyStoreBloc();
  final UploadBloc _uploadCompanyImageBloc = UploadBloc();
  final AddCompanyBloc _addCompanyBloc = AddCompanyBloc();

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allStoreBloc.getAllStore();
  }

  /// Company Parameters
  late AddressModel addressModel ;
  late List<ZoneModel> zones=[];
  String? _storeID = null;
  String? _companyID = null;
  String? _image = null;
  late CompanyModel companyModel;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('Add Company',style: TextStyle(color: Colors.black87,),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 32),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Selected Store
                  SizedBox(height: 20,),

                  Text('Select Store',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold),),
                  SizedBox(height: 8,),
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
                            child: BlocBuilder<AllStoreBloc, AllStoreStates> (
                                bloc:allStoreBloc,
                                builder: (context, state) {
                                  if(state is AllStoreSuccessState){
                                    print('state is success');
                                    print(state.data);
                                    return DropdownButtonFormField<String>(
                                      onTap: () {},
                                      validator: (s) {
                                        return s == null
                                            ? 'Store Is Required !'
                                            : null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Store',
                                        hintStyle: TextStyle(fontSize: 16),
                                      ),
                                      items: _getCategoriesDropDownList(
                                          state.data
                                      ),
                                      onChanged: (s) {

                                        _storeID = s;
                                        _companyStoreBloc.getcompany(_storeID!);
                                        setState(() {

                                        });
                                      },
                                    );
                                  }
                                  else if (state is AllStoreErrorState) {
                                    return ElevatedButton(
                                      child: Text(
                                          'Error in fetch stores .. Click to Try Again'),
                                      onPressed: () {
                                        allStoreBloc.getAllStore();
                                      },
                                    );
                                  } else {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Stores'),
                                        Container(
                                          width: 50,
                                          child: CircularProgressIndicator(),
                                        )
                                      ],
                                    );
                                  }
                                }),
                          )),
                    ),
                  ),
                  SizedBox(height: 12,),

                  Text('company Name',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
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
                              controller: _nameCompanyController,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'company name .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'company Name is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 12,),
                  Text('company Name (Arabic Name)',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
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
                              controller: _name2CompanyController,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'arabic name .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'arabic name  is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 12,),
                  Text('company description',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(

                      child: ListTile(

                          subtitle: Container(

                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                            ),
                            child: TextFormField(
                              controller: _desCompanyController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'company description .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'company description is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 12,),
                  Text('company image',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
                  BlocConsumer<UploadBloc, UploadStates>(
                      bloc: _uploadCompanyImageBloc,
                      listener: (context, state) {
                        if(state is UploadSuccessState){
                          _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Company Image successful uploaded')));

                        }
                      },
                      builder: (context, state) {
                        if (state is UploadSuccessState) {

                          _image = state.image;
                        }
                        return Container(
                          width: 200,
                          height: 200,

                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              state is UploadLoadingState
                                  ? Container(
                                padding: EdgeInsets.all(20),
                                width: 200,
                                height: 200,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                ),
                                child: Center(
                                    child: CircularProgressIndicator()),
                              ): state is UploadInitState?
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.grey
                                    ,shape: BoxShape.rectangle
                                  // image: DecorationImage(
                                  //   image: new ExactAssetImage('assets/logo3.png'),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              )
                                  :Container(
                                width: 200,
                                height: 200,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.black12,
                                ),
                                child: _image == null
                                    ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey
                                    // image: DecorationImage(
                                    //   image: new ExactAssetImage('assets/logo3.png'),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                )
                                    : CachedNetworkImage(
                                  imageUrl: _image!,
                                  progressIndicatorBuilder: (context, l, ll) =>
                                      CircularProgressIndicator(
                                        value: ll.progress,
                                      ),
                                  errorWidget: (context, s, l) => Icon(Icons.error),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // : Container(
                              // width: 150,
                              // height: 150,
                              // decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     color: Colors.black12,
                              //     image: _image == null
                              //         ? null
                              //         : DecorationImage(
                              //         fit: BoxFit.cover,
                              //         image: AssetImage('assets/logo3.png')))),
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        choosePhotoSource(context, _uploadCompanyImageBloc,ImageType.COMPANY);
                                      },
                                      icon: Icon(
                                        Icons.camera,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      }),

                  SizedBox(height: 40,),
                  Center(
                    child: BlocConsumer<AddCompanyBloc, AddCompanyStates>(
                        bloc: _addCompanyBloc,
                        listener: (context,state)async{
                          if(state is AddCompanySuccessState)
                          {
                            _image = null;
                            _storeID = null;
                            _uploadCompanyImageBloc.initState();

                            _nameCompanyController.clear();
                            _name2CompanyController.clear();
                            _desCompanyController.clear();
                            allStoreBloc.getAllStore();
                            setState(() {

                            });
                            snackBarSuccessWidget(context, 'Company Added Successfully!!');
                          }
                          else if(state is AddCompanyErrorState)
                          {
                            snackBarSuccessWidget(context, 'Company Added Was Not Created!!');
                          }
                        },
                        builder: (context,state) {
                          bool isLoading = state is AddCompanyLoadingState?true:false;
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            clipBehavior: Clip.antiAlias,
                            height: 40,
                            width:isLoading?60: 180,
                            padding: EdgeInsets.all(isLoading?8:0 ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: ColorsConst.mainColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:isLoading?Center(child: CircularProgressIndicator(color: Colors.white,)): MaterialButton(
                              onPressed: () {
                                if(_storeID == null){
                                  _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Please Select Store !!!!')));
                                }
                                else {
                                  String companyName = _nameCompanyController.text.trim();
                                  String arabic_name = _name2CompanyController.text.trim();
                                  String companyDes = _desCompanyController.text.trim();
                                  AddCompanyRequest request = AddCompanyRequest(name: companyName,name2: arabic_name, description:companyDes , imageUrl: _image!);
                                  _addCompanyBloc.addCompany(_storeID!, request);
                                }

                              },
                              child: Text('Add Company', style: TextStyle(color: Colors.white,
                                  fontSize: 17),),

                            ),
                          );
                        }
                    ),
                  ),

                  SizedBox(height: 30,)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getCategoriesDropDownList(
      List<StoreModel> stores) {

    var items = <DropdownMenuItem<String>>[];
    if (stores.length == 0) {
      return [
        DropdownMenuItem<String>(
          child: Text(''),
        )
      ];
    }
    stores.forEach((element) {
      items.add(DropdownMenuItem<String>(
        value: element.id,
        child: Text(
          '${element.name}',
          style: TextStyle(fontSize: 16),
        ),
      ));
    });
    print(items);
    return items;
  }
}
