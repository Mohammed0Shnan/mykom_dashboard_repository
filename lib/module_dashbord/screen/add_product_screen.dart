import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_product_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/all_store_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/company_store_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/products_company_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/enum/image_type.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/company_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/store_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/zone_models.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/requests/add_product_request.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';
import 'package:my_kom_dist_dashboard/module_upload/upload_bloc.dart';
import 'package:my_kom_dist_dashboard/module_upload/widgets/choose_photo_source_dialog.dart';

class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({Key? key}) : super(key: key);

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {



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


  final TextEditingController _quantityProductController =
  TextEditingController();

  //final ZoneBloc zoneBloc = ZoneBloc();
  final AllStoreBloc allStoreBloc = AllStoreBloc();
  final ProductsCompanyBloc productsCompanyBloc = ProductsCompanyBloc();
  final UploadBloc _uploadProductImageBloc = UploadBloc();
  final AddProductBloc _addProductBloc = AddProductBloc();
  CompanyStoreBloc  _companyStoreBloc = CompanyStoreBloc();

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
  late CompanyModel companyModel;

// Product Parameters
  String ? _imageProduct = null;

  late double price;
  bool isRecommended = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('Add Products',style: TextStyle(color: Colors.black87,),),
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
                  /// Select Company
                  Text('Select Company',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
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
                  SizedBox(height: 12,),

                  Text('Product Name',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
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
                  SizedBox(height: 12,),

                  Text('Product Arabic Name',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
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
                  SizedBox(height: 12,),

                  Text('Product Description',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
                SizedBox(height: 8,),
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
                  SizedBox(height: 12,),
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
                  SizedBox(height: 12,),

                  Text('Product Quantity',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8,),
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
                  SizedBox(height: 12,),

                  Text('Product Price',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8,),
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
                  SizedBox(height: 12,),

                  Text('Product Old Price',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8,),
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
                  SizedBox(height: 12,),

                  Text('Product Image',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8,),
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

                  SizedBox(height: 20,),
                  Center(
                    child: BlocConsumer<AddProductBloc, AddProductStates>(
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





}
