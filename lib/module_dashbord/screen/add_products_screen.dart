

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_advertisement_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_company1_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_product_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_specefications_bloc.dart';
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
import 'package:my_kom_dist_dashboard/module_dashbord/requests/add_company_request.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/requests/add_product_request.dart';

import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';
import 'package:my_kom_dist_dashboard/module_orders/ui/widgets/delete_order_sheak_alert.dart';
import 'package:my_kom_dist_dashboard/module_upload/upload_bloc.dart';
import 'package:my_kom_dist_dashboard/module_upload/widgets/choose_photo_source_dialog.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final TextEditingController _nameCompanyController =
  TextEditingController();

  final TextEditingController _name2CompanyController =
  TextEditingController();

  final TextEditingController _desCompanyController =
  TextEditingController();

  final TextEditingController _nameProductController =
  TextEditingController();
  final TextEditingController _desProductController =
  TextEditingController();

  final TextEditingController _name2ProductController =
  TextEditingController();
  final TextEditingController _des2ProductController =
  TextEditingController();

  final TextEditingController _priceProductController =
  TextEditingController();

  final TextEditingController _oldPriceProductController =
  TextEditingController();

  final TextEditingController _titleNotificationController =
  TextEditingController();

  final TextEditingController _subTitleNotificationController =
  TextEditingController();

  final TextEditingController _quantityProductController =
  TextEditingController();


  final TextEditingController _messageTitleController =
  TextEditingController();


  final TextEditingController _messageSubTitleController =
  TextEditingController();

  final TextEditingController _routeController =
  TextEditingController();
  //final ZoneBloc zoneBloc = ZoneBloc();
  final AllStoreBloc allStoreBloc = AllStoreBloc();
  CompanyStoreBloc  _companyStoreBloc = CompanyStoreBloc();
  final ProductsCompanyBloc productsCompanyBloc = ProductsCompanyBloc();
  final UploadBloc _uploadCompanyImageBloc = UploadBloc();
  final UploadBloc _uploadAdvertisementImageBloc = UploadBloc();
  final UploadBloc _uploadProductImageBloc = UploadBloc();
  final AddCompanyBloc _addCompanyBloc = AddCompanyBloc();
  final AddAdvertisementBloc _addAdvertisementBloc = AddAdvertisementBloc();
  final AddProductBloc _addProductBloc = AddProductBloc();
  final SpecificationsBloc specificationsBloc = SpecificationsBloc();

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  /// Company Parameters
  late AddressModel addressModel ;
  late List<ZoneModel> zones=[];
  String? _storeID = null;
  String? _companyID = null;
  String? _image = null;
  late CompanyModel companyModel;
 /// Product Parameters
  String ? _imageProduct = null;

  String ? _advertisementImage = null;
  late double price;
  bool isRecommended = false;

  bool  formOpen  =false;

  bool  productFormOpen  =false;

  bool AdvertisementFormOpen  =false;

  String? advertisementType = null;


  /// for advertisemnet
  String? _productID = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allStoreBloc.getAllStore();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('Add Product & Company & Advertisement & Messages',style: TextStyle(color: Colors.black87),),
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
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// Selected Store
              SizedBox(height: 20,),

              Text('Store'),
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


              SizedBox(height: 20,),
              /// Select Company
              Text('Company'),
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
              Divider(color: Colors.black45,height: 5,thickness:3,endIndent: 20,indent: 20,),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                children: [
                  Text('if you choose Null'),
                  GestureDetector(
                      onTap: (){
                        formOpen = ! formOpen;
                        setState(() {

                        });
                      },
                      child: Text('Click here',style: TextStyle(color: Colors.blue),)),
                ],
              )),
              SizedBox(height: 10,),
              if(formOpen)
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  elevation: 5,

                  child: Column(children: [
                  // late final String id;
                  // late final String name;
                  // late String description;
                  // late String imageUrl;
                    Text('company Name'),
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
                    SizedBox(height: 10,),
                    Text('company Name (Arabic Name)'),
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
                    SizedBox(height: 10,),
                    Text('company description'),
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
                    SizedBox(height: 10,),
                    Text('company image'),
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
                            width: 150,
                            height: 150,

                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                state is UploadLoadingState
                                    ? Container(
                                  padding: EdgeInsets.all(20),
                                  width: 150,
                                  height: 150,
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
                                          ,shape: BoxShape.circle
                                    // image: DecorationImage(
                                    //   image: new ExactAssetImage('assets/logo3.png'),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                )
                                :Container(
                                  width: 150,
                                  height: 150,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
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

                    SizedBox(height: 20,),
                    BlocConsumer<AddCompanyBloc, AddCompanyStates>(
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
                                  fontSize: SizeConfig.titleSize * 2.7),),

                            ),
                          );
                        }
                    ),

                  ],),
                ),
              SizedBox(height: 30,)


              /// Add Product Section
              ///




















             , Divider(color: Colors.black45,height: 5,thickness:3,endIndent: 20,indent: 20,),

              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('Add Products '),
                      GestureDetector(
                          onTap: (){
                            productFormOpen = ! productFormOpen;
                            setState(() {

                            });
                          },
                          child: Text('Click here',style: TextStyle(color: Colors.blue),)),
                    ],
                  )),
              SizedBox(height: 10,),


              if(productFormOpen)
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                elevation: 5,

                child: Column(children: [
                  // late final String id;
                  // late final String name;
                  // late String description;
                  // late String imageUrl;
                  SizedBox(height:20,),
                  Text('Add Products'),
                  SizedBox(height: 10,),
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
                              controller: _nameProductController,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'product name .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'product Name is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(height: 10,),
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
                              controller: _name2ProductController,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'product arabic name .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'product arabic name is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('product description'),
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
                              controller: _desProductController,
                              maxLines: 5,
                              decoration: InputDecoration(

                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Product description .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Product description is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('product arabic description'),
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
                              controller: _des2ProductController,
                              maxLines: 5,
                              decoration: InputDecoration(

                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Product arabic description .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Product arabic description is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 10,),
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
                              controller: _quantityProductController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(

                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Quantity .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Product Quantity is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),

                  SizedBox(height: 10,),
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
                              controller: _priceProductController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(

                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Price .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Product Price is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),


                  SizedBox(height: 10,),
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
                              controller: _oldPriceProductController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Old Price .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next

                            ),
                          )),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Text('Product image'),
                  BlocConsumer<UploadBloc, UploadStates>(
                      bloc: _uploadProductImageBloc,
                      listener: (context,state){
                    if (state is UploadSuccessState) {
                      _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Product image successful uploaded')));
                           }
                  },
                      builder: (context, state) {
                        if (state is UploadSuccessState) {
                          _imageProduct = state.image;
                        }
                        return Container(
                          width: 150,
                          height: 150,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              state is UploadLoadingState
                                  ? Container(
                                padding: EdgeInsets.all(20),
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                ),
                                child: Center(
                                    child: CircularProgressIndicator()),
                              )
                                  : state is UploadInitState?
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.grey
                                    ,shape: BoxShape.circle
                                  // image: DecorationImage(
                                  //   image: new ExactAssetImage('assets/logo3.png'),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ):Container(
                                width: 150,
                                height: 150,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                ),
                                child: _imageProduct == null
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
                                  imageUrl: _imageProduct!,
                                  progressIndicatorBuilder: (context, l, ll) =>
                                      CircularProgressIndicator(
                                        value: ll.progress,
                                      ),
                                  errorWidget: (context, s, l) => Icon(Icons.error),
                                  fit: BoxFit.fill,
                                ),
                              ),
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
                                        choosePhotoSource(context, _uploadProductImageBloc,ImageType.PRODUCT);
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
                  //             controller: _speciProductController,
                  //             decoration: InputDecoration(
                  //                 errorStyle: GoogleFonts.lato(
                  //                   color: Colors.red.shade700,
                  //                   fontWeight: FontWeight.w800,
                  //
                  //
                  //                 ),
                  //                 suffixIcon: IconButton(
                  //                   icon: Icon(Icons.add),
                  //                   onPressed: (){
                  //                     String value = _speciProductController.text.trim();
                  //                     sp.name =
                  //                         SpecificationsModel sp = SpecificationsModel(name: name, value: value);
                  //
                  //                     specificationsBloc.addOne(sp);
                  //                     _speciProductController.clear();
                  //                   },
                  //                 ),
                  //                 border:InputBorder.none,
                  //                 hintText: 'zone name .'
                  //                 , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                  //
                  //               //S.of(context).name,
                  //             ),
                  //             // Move focus to next
                  //             validator: (result) {
                  //               if (result!.isEmpty) {
                  //                 return 'Zone Name is Required'; //S.of(context).nameIsRequired;
                  //               }
                  //               return null;
                  //             },
                  //           ),
                  //         )),
                  //   ),
                  // ),
                  // Container(
                  //   height: 100,
                  //   child: BlocBuilder<SpecificationsBloc,SpecificationsState>(
                  //       bloc: specificationsBloc,
                  //       builder: (context,state) {
                  //         return Container(
                  //           margin: EdgeInsets.symmetric(horizontal: 20),
                  //
                  //           child: ListView.separated(
                  //             separatorBuilder: (context,index){
                  //               return  SizedBox(height: 8,);
                  //             },
                  //             shrinkWrap:true ,
                  //             itemCount: state.data.length,
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
                  //                       Text(state.data[index].value +'  :  ', style: GoogleFonts.lato(
                  //                           color: Colors.black54,
                  //                           fontSize: SizeConfig.titleSize * 2.1,
                  //                           fontWeight: FontWeight.bold
                  //                       ),),
                  //                       Text(state.data[index].name , style: GoogleFonts.lato(
                  //                           color: Colors.black54,
                  //                           fontSize: SizeConfig.titleSize * 2.1,
                  //                           fontWeight: FontWeight.bold
                  //                       ),),
                  //                       Spacer(),
                  //                       IconButton(onPressed: (){
                  //                         specificationsBloc.removeOne(state.data[index]);
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text('Recommended'),
                  //
                  //     Checkbox(
                  //       value: isRecommended,
                  //       onChanged: (bool? value) {
                  //         setState(() {
                  //           isRecommended = value!;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 20,),
                  BlocConsumer<AddProductBloc, AddProductStates>(
                      bloc: _addProductBloc,
                      listener: (context,state)async{
                        if(state is AddProductSuccessState)
                        {
                          _imageProduct = null;
                          _uploadProductImageBloc.initState();

                          _nameProductController.clear();
                          _desProductController.clear();
                          _priceProductController.clear();
                          _name2ProductController.clear();
                          _des2ProductController.clear();
                          _oldPriceProductController.clear();
                          _quantityProductController.clear();
                          setState(() {
                          });
                          snackBarSuccessWidget(context, 'Product Added Successfully!!');
                        }
                        else if(state is AddProductErrorState)
                        {
                          snackBarSuccessWidget(context, 'Product Added Was Not Created!!');
                        }
                      },
                      builder: (context,state) {
                        bool isLoading = state is AddProductLoadingState?true:false;
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
                              if(_storeID == null){
                                _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Please Select Store !!!!')));
                              }
                              else if(_companyID == null){
                                _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Please Select Company !!!!')));

                              }
                              else {
                                String productName = _nameProductController.text.trim();
                                String productDes = _desProductController.text.trim();
                                double price = double.parse(_priceProductController.text.trim());
                                String productArabicName = _name2ProductController.text.trim();
                                String productArabicDes = _des2ProductController.text.trim();
                                double? oldPrice = null;
                                if(_oldPriceProductController.text.trim().isNotEmpty){
                                  oldPrice = double.parse(_oldPriceProductController.text.trim());
                                }

                                int quantity = int.parse(_quantityProductController.text.trim());
                                AddProductRequest productRequest = AddProductRequest(isRecommended: isRecommended,title: productName,description: productDes,imageUrl: _imageProduct!,
                                    price: price,quantity: quantity,
                                  arabicName: productArabicName,
                                  arabicDis: productArabicDes,
                                  old_price: oldPrice
                                );
                                _addProductBloc.addProduct(_storeID!, _companyID!, productRequest);
                              }

                            },
                            child: Text('Add Product', style: TextStyle(color: Colors.white,
                                fontSize: SizeConfig.titleSize * 2.7),),

                          ),
                        );
                      }
                  ),

                ],),
              ),
              SizedBox(height: 30,)

              /// Advertisements
              ///
             , Divider(color: Colors.black45,height: 5,thickness:3,endIndent: 20,indent: 20,),

              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('Add Advertisement '),
                      GestureDetector(
                          onTap: (){
                            AdvertisementFormOpen = !AdvertisementFormOpen;
                            setState(() {

                            });
                          },
                          child: Text('Click here',style: TextStyle(color: Colors.blue),)),
                    ],
                  )),
              SizedBox(height: 10,),


              if(AdvertisementFormOpen)
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  elevation: 5,
                  child: Column(
                    children: [
                    // late final String id;
                    // late final String name;
                    // late String description;
                    // late String imageUrl;
                      SizedBox(height: 10,),
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
                    BlocConsumer<AddAdvertisementBloc, AddAdvertisementStates>(
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
                            height: 8.44 * SizeConfig.heightMulti,
                            width:isLoading?60: SizeConfig.screenWidth * 0.8,
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
                                  fontSize: SizeConfig.titleSize * 2.7),),

                            ),
                          );
                        }
                    ),

                  ],),
                ),
              SizedBox(height: 30,)

            ],
          ),
        ),
      ),
    );
  }
  //
  //
  // CompanyModel getCompanyFromID(String id){
  //   late CompanyModel companyModel ;
  //   if(allStoreBloc.state is AllStoreSuccessState) {
  //   List<StoreModel> stores =(allStoreBloc.state as AllStoreSuccessState).data ;
  //   StoreModel? data = null;
  //
  //   stores.forEach((element) {
  //     print('@@@@@@@@@@@@@@@@@');
  //     print(element.name);
  //     if(element.id == _storeID){
  //       print('stroooooooooooooor founf !!!!!!!!');
  //       data = element;
  //     }
  //     print(_storeID);
  //     print('***********************');
  //     print(data);
  //     List<CompanyModel> companies = data!.companies;
  //     companies.forEach((element) {
  //       if(element.id == id)
  //         companyModel = element;
  //
  //     });
  //
  //   });
  //
  // }
  // return companyModel;
  // }


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
   


  }

  List<DropdownMenuItem<String>> _getCategoriesDropDownList(
      List<StoreModel> stores) {
    print('stoooooooooooooooooreeeeeees');
    print(stores);
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




  ////
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

