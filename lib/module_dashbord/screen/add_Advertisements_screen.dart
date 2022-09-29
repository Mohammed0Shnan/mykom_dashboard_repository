import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_advertisement_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/all_store_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/company_store_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/products_company_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/enum/advertisement_type.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/enum/image_type.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/advertisement_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/company_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/store_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/zone_models.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';
import 'package:my_kom_dist_dashboard/module_upload/upload_bloc.dart';
import 'package:my_kom_dist_dashboard/module_upload/widgets/choose_photo_source_dialog.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class AddAdvertisementsScreen extends StatefulWidget {
  const AddAdvertisementsScreen({Key? key}) : super(key: key);

  @override
  State<AddAdvertisementsScreen> createState() => _AddAdvertisementsScreenState();
}

class _AddAdvertisementsScreenState extends State<AddAdvertisementsScreen> {

  final TextEditingController _routeController =
  TextEditingController();
  final TextEditingController _titleNotificationController =
  TextEditingController();

  final TextEditingController _subTitleNotificationController =
  TextEditingController();
  final TextEditingController _messageTitleController =
  TextEditingController();
  final TextEditingController _messageSubTitleController =
  TextEditingController();

  //final ZoneBloc zoneBloc = ZoneBloc();
  final AllStoreBloc allStoreBloc = AllStoreBloc();
  CompanyStoreBloc  _companyStoreBloc = CompanyStoreBloc();
  final ProductsCompanyBloc productsCompanyBloc = ProductsCompanyBloc();
  final UploadBloc _uploadAdvertisementImageBloc = UploadBloc();
  final AddAdvertisementBloc _addAdvertisementBloc = AddAdvertisementBloc();
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
  String? _productID = null;
  late CompanyModel companyModel;


  bool AdvertisementFormOpen  =false;
  String ? _advertisementImage = null;
  String? advertisementType = null;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('Add Advertisement',style: TextStyle(color: Colors.black87,),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          AlertDialog alert = AlertDialog(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            content: Container(
              height: 250,
              width: 400,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 25,),
                  /// message title input
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
                              controller: _messageTitleController,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'message title .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'message title is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 8,),
                  /// message body input
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
                              controller: _messageSubTitleController,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'message body .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'message body is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(

                        onPressed: (){
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child:Container(
                            height: 30,
                            width: 80,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.black87,
                                    width: 2
                                )
                            ),
                            child: Center(child: Text('Cancel',style: TextStyle(color: Colors.black87,fontSize:15,fontWeight: FontWeight.bold),))),

                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        onPressed: () async{

                          EasyLoading.show();
                          String _messageTitile = _messageTitleController.text.trim();
                          String _messageSubTitle = _messageSubTitleController.text.trim();
                          _addAdvertisementBloc.sendMessage(title:_messageTitile,subTitle:_messageSubTitle).then((value) {
                            if(value){
                              EasyLoading.showSuccess('Message Sending Successfully');
                              Navigator.of(context).pop(context);
                            }else{
                              EasyLoading.showError('An error occurred !');

                            }
                          });


                        },

                        child:Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.blue,
                                  width: 2
                              ),
                              color: Colors.white,

                            ),
                            child: Center(child: Text('Send',style: TextStyle(color: Colors.blue,fontSize:15,fontWeight: FontWeight.bold),))),

                      ),
                    ],
                  ),
                ],
              ),
            ),

          );

// show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
        child:Icon(Icons.message),
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
                  /// Select Company
                  Text('Select Company'),
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
                            child: BlocBuilder<CompanyStoreBloc, CompanyStoreStates> (
                                bloc:_companyStoreBloc,
                                builder: (context, state) {
                                  if (state is CompanyStoreLoadingState) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Company'),
                                        Container(
                                          width: 50,
                                          child: CircularProgressIndicator(),
                                        )
                                      ],
                                    );
                                  } else if (state is CompanyStoreErrorState) {
                                    return ElevatedButton(
                                      child: Text(
                                          'Error in fetch company .. Click to Try Again'),
                                      onPressed: () {
                                        _companyStoreBloc.getcompany(_storeID!);
                                      },
                                    );
                                  } else {
                                    return DropdownButtonFormField<String>(
                                      onTap: () {},
                                      validator: (s) {
                                        return s == null
                                            ? 'company Is Required !'
                                            : null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'company',
                                        hintStyle: TextStyle(fontSize: 16),
                                      ),
                                      items: _getCompanyDropDownList(
                                          state is CompanyStoreSuccessState
                                              ? state.data
                                              : []),
                                      onChanged: (s) {

                                        _companyID = s;
                                        productsCompanyBloc.getProducts(_companyID!);
                                      },
                                    );
                                  }
                                }),
                          )),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:20),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                    ),
                    child: ListTile(
                      title:  Text('Advertisement Type'),subtitle:
                    DropdownButtonFormField<String>(
                      onTap: () {},
                      validator: (s) {
                        return s == null
                            ? 'Store Is Required !'
                            : null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Advertisement Type',
                        hintStyle: TextStyle(fontSize: 16),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: AdvertisementType.ADVERTISEMENT_PRODUCT.name,
                          child: Text(
                            'ADVERTISEMENT PRODUCT',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: AdvertisementType.ADVERTISEMENT_COMPANY.name,
                          child: Text(
                            'ADVERTISEMENT COMPANY',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value:AdvertisementType.ADVERTISEMENT_OFFER.name,
                          child: Text(
                            'ADVERTISEMENT OFFER',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: AdvertisementType.ADVERTISEMENT_EXTERNAL.name,
                          child: Text(
                            'ADVERTISEMENT EXTERNAL',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: AdvertisementType.ADVERTISEMENT_PANAR.name,
                          child: Text(
                            'ADVERTISEMENT PANAR',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                      onChanged: (s) {

                        advertisementType = s;
                        setState(() {

                        });
                      },
                    ),
                    ),
                  ),
                  SizedBox(height: 15,)
                  , Container(
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
                            child: BlocBuilder<ProductsCompanyBloc, ProductsCompanyStates> (
                                bloc:productsCompanyBloc,
                                builder: (context, state) {
                                  if(state is ProductsCompanySuccessState){
                                    print('state is success');
                                    return DropdownButtonFormField<String>(
                                      onTap: () {},
                                      validator: (s) {
                                        return s == null
                                            ? 'Product Is Required !'
                                            : null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Products',
                                        hintStyle: TextStyle(fontSize: 16),
                                      ),
                                      items: _getProductsDropDownList(
                                          state.data
                                      ),
                                      onChanged: (s) {

                                        _productID = s;
                                        setState(() {

                                        });
                                      },
                                    );
                                  }
                                  else if (state is ProductsCompanyErrorState) {
                                    return ElevatedButton(
                                      child: Text(
                                          'Error in fetch products .. Click to Try Again'),
                                      onPressed: () {
                                        allStoreBloc.getAllStore();
                                      },
                                    );
                                  }
                                  else  if(state is ProductsCompanyInitState){
                                    return Container(
                                        child: Row(children: [
                                          Text('products'),
                                        ],)
                                    );
                                  }
                                  else {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Product'),
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


                  ///
                  ///  All PRODUCT


                  // Text('Advertisement Name'),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(15),
                  //   ),
                  //   child: Container(
                  //
                  //     child: ListTile(
                  //
                  //         subtitle: Container(
                  //           height: 50,
                  //           clipBehavior: Clip.antiAlias,
                  //           decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(10),
                  //               boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                  //           ),
                  //           child: TextFormField(
                  //             controller: _routeController,
                  //             decoration: InputDecoration(
                  //                 errorStyle: GoogleFonts.lato(
                  //                   color: Colors.red.shade700,
                  //                   fontWeight: FontWeight.w800,
                  //
                  //
                  //                 ),
                  //                 prefixIcon: Icon(Icons.store),
                  //                 border:InputBorder.none,
                  //                 hintText: 'Advertisement route .'
                  //                 , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                  //
                  //               //S.of(context).name,
                  //             ),
                  //             // Move focus to next
                  //             validator: (result) {
                  //               if (result!.isEmpty) {
                  //                 return 'Advertisement route is Required'; //S.of(context).nameIsRequired;
                  //               }
                  //               return null;
                  //             },
                  //           ),
                  //         )),
                  //   ),
                  // ),
                  SizedBox(height: 10,),
                  Text('Advertisement image'),
                  BlocConsumer<UploadBloc, UploadStates>(
                      bloc: _uploadAdvertisementImageBloc,
                      listener: (context, state) {
                        if(state is UploadSuccessState){
                          _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Advertisement Image successful uploaded')));

                        }
                      },
                      builder: (context, state) {
                        if (state is UploadSuccessState) {
                          _advertisementImage = state.image;

                        }
                        return Container(
                          width: SizeConfig.screenWidth * 0.8,
                          height: 150,

                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              state is UploadLoadingState
                                  ? Container(
                                padding: EdgeInsets.all(20),
                                width: SizeConfig.screenWidth * 0.8,
                                height: 150,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                    child: CircularProgressIndicator()),
                              ): state is UploadInitState?
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20),
                                  // image: DecorationImage(
                                  //   image: new ExactAssetImage('assets/logo3.png'),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              )
                                  :Container(
                                width: SizeConfig.screenWidth * 0.8,
                                height: 150,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(20),

                                ),
                                child: _advertisementImage == null
                                    ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey
                                    // image: DecorationImage(
                                    //   image: new ExactAssetImage('assets/logo3.png'),
                                    //   fit: BoxFit.cover,
                                    // ),

                                  ),
                                )
                                    :  CachedNetworkImage(
                                  imageUrl:_advertisementImage!,
                                  progressIndicatorBuilder: (context, l, ll) =>
                                      Center(
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          child: CircularProgressIndicator(
                                            value: ll.progress,
                                          ),
                                        ),
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
                                        choosePhotoSource(context, _uploadAdvertisementImageBloc,ImageType.ADVERTISEMENT);
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
                  SizedBox(height:20,),
                  Text('Notification Information'),
                  SizedBox(height:10,),

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
                              controller: _titleNotificationController,
                              decoration: InputDecoration(

                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Title Notification'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Title Notification is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height:10,),

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
                              controller: _subTitleNotificationController,
                              decoration: InputDecoration(

                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Sub Title Notification'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Sub Title Notification is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: BlocConsumer<AddAdvertisementBloc, AddAdvertisementStates>(
                        bloc: _addAdvertisementBloc,
                        listener: (context,state)async{
                          if(state is AddAdvertisementSuccessState)
                          {
                            _advertisementImage = null;
                            _storeID = null;
                            _uploadAdvertisementImageBloc.initState();
                            allStoreBloc.getAllStore();
                            setState(() {

                            });
                            snackBarSuccessWidget(context, 'Advertisement Added Successfully!!');
                          }
                          else if(state is AddAdvertisementErrorState)
                          {
                            snackBarSuccessWidget(context, 'Advertisement Added Was Not Created!!');
                          }
                        },
                        builder: (context,state) {
                          bool isLoading = state is AddAdvertisementLoadingState?true:false;
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            clipBehavior: Clip.antiAlias,
                            height:40,
                            width:isLoading?60: 180,
                            padding: EdgeInsets.all(isLoading?8:0 ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: ColorsConst.mainColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:isLoading?Center(child: CircularProgressIndicator(color: Colors.white,)): MaterialButton(
                              onPressed: () async{
                                if(_storeID == null){
                                  _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Please Select Store !!!!')));
                                }
                                else {
                                  //  String route = _routeController.text.trim();
                                  if(advertisementType != null){
                                    if(advertisementType == AdvertisementType.ADVERTISEMENT_PRODUCT.name){
                                      String query =advertisementType.toString()+'|'+_productID!;
                                      String title = _titleNotificationController.text.trim();
                                      String body = _subTitleNotificationController.text.trim();
                                      AdvertisementModel request = AdvertisementModel(id: '', imageUrl: _advertisementImage!, route: query,storeID: _storeID!,title:title,body: body );
                                      _addAdvertisementBloc.addAdvertisement(request);
                                    }else if(advertisementType == AdvertisementType.ADVERTISEMENT_COMPANY.name){
                                      CompanyModel? c =await allStoreBloc.getCompanyFromId(_companyID!);
                                      String query =advertisementType.toString()+'|'+'id='+_companyID!+'&'+'name='+c!.name+'&'+'image='+c.imageUrl;

                                      String title = _titleNotificationController.text.trim();
                                      String body = _subTitleNotificationController.text.trim();
                                      AdvertisementModel request = AdvertisementModel(id: '', imageUrl: _advertisementImage!, route: query,storeID: _storeID!,title:title,body: body );
                                      _addAdvertisementBloc.addAdvertisement(request);
                                    }else{
                                      String query =advertisementType.toString()+'|'+'panar';
                                      String title = _titleNotificationController.text.trim();
                                      String body = _subTitleNotificationController.text.trim();
                                      AdvertisementModel request = AdvertisementModel(id: '', imageUrl: _advertisementImage!, route: query,storeID: _storeID!,title:title,body: body );
                                      _addAdvertisementBloc.addAdvertisement(request);
                                    }

                                  }

                                }

                              },
                              child: Text('Add Advertisement', style: TextStyle(color: Colors.white,
                                  fontSize: 17),),

                            ),
                          );
                        }
                    ),
                  ),

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

  List<DropdownMenuItem<String>> _getCompanyDropDownList(
      List<CompanyModel> companies) {
    if (companies.length == 0) {
      return [
        DropdownMenuItem<String>(
          child: Text(''),
        )
      ];
    }
    else
    {


      var items = <DropdownMenuItem<String>>[];
      if (companies.length == 0) {
        return [
          DropdownMenuItem<String>(
            child: Text(''),
          )
        ];
      }
      items.add(DropdownMenuItem<String>(
        value: 'null',
        child: Text(
          'Null',
          style: TextStyle(fontSize: 16),
        ),
      ));
      companies.forEach((element) {
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



  List<DropdownMenuItem<String>> _getProductsDropDownList(
      List<ProductModel> products) {
    var items = <DropdownMenuItem<String>>[];
    if (products.length == 0) {
      return [
        DropdownMenuItem<String>(
          child: Text(''),
        )
      ];
    }
    products.forEach((element) {
      items.add(DropdownMenuItem<String>(
        value: element.id,
        child: Text(
          '${element.title}',
          style: TextStyle(fontSize: 16),
        ),
      ));
    });
    print(items);
    return items;
  }

}
