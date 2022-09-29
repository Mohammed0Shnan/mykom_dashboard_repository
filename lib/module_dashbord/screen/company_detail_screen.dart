
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_company1_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/add_product_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/company_store_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/bloc/store_products_company_detail_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/enum/image_type.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/company_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/requests/update_company_request.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/requests/update_product_request.dart';
import 'package:my_kom_dist_dashboard/module_upload/upload_bloc.dart';
import 'package:my_kom_dist_dashboard/module_upload/widgets/choose_photo_source_dialog.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class CompanyDetailScreen extends StatefulWidget {
  final CompanyModel company;
  const CompanyDetailScreen({ required this.company, Key? key}) : super(key: key);

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  final StoreProductsCompanyDetailBloc _bloc = StoreProductsCompanyDetailBloc();
  /// for update product
  final AddProductBloc _addProductBloc = AddProductBloc();
  final AddCompanyBloc _addCompanyBloc = AddCompanyBloc();
  CompanyStoreBloc _companyStoreBloc = CompanyStoreBloc();
  final UploadBloc _uploadCompanyImageBloc = UploadBloc();
  final UploadBloc _uploadProductImageBloc = UploadBloc();

  final TextEditingController _productNameController =  TextEditingController();
  final TextEditingController _productDescriptionController=  TextEditingController();
  final TextEditingController _productQuantityController =  TextEditingController();
  final TextEditingController _productArabicDescriptionController=  TextEditingController();
  final TextEditingController _productArabicNameController =  TextEditingController();
  final TextEditingController _productPriceController=  TextEditingController();
  final TextEditingController _productNewPriceController=  TextEditingController();

  final TextEditingController _companyNameController =  TextEditingController();
  final TextEditingController _companyArabicNameController =  TextEditingController();
String companyImage = '';
String productImage = '';
  @override
  void initState() {

    _bloc.getDetailProductsCompanyStore(widget.company.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text('Company Detail',style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16,),
          Text('Company English name : ${widget.company.name}'),
          SizedBox(height: 6,),
          Text('Company Arabic name : ${widget.company.name2}'),
          SizedBox(height: 8,),
          Text(
              'Company Available : ${widget.company.available ? 'Yes' : 'No'}'),
          SizedBox(height: 15,),
          TextButton(onPressed: (){
            _companyStoreBloc.getCompanyById(widget.company.id);
            _updateCompanyDetail(widget.company.id);
          }, child: Text('Edit Company Information')),
          SizedBox(height: 16,),

          SizedBox(height: 20,),
          Expanded(
            child: Container(
                child: BlocConsumer<
                    StoreProductsCompanyDetailBloc,
                    StoreProductsCompanyDetailStates>(
                    bloc: _bloc,
                    listener: (context, listenstate){

                    },
                    builder: (context, state2) {
                      if (state2 is StoreProductsCompanyDetailSuccessState) {
                        List<ProductModel> list = state2.data;
                        return _buildProductListWidget(list, ScrollController());
                      } else if (state2 is StoreProductsCompanyDetailErrorState) {
                        return Center(
                          child: Container(

                            child: Text(state2.message),
                          ),
                        );
                      } else {
                        return Center(
                          child: Container(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    })
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListWidget(List<ProductModel> items,
      ScrollController controller) {
    if (items.length == 0) {
      return Center(
        child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: SizeConfig.screenHeight * 0.3,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Image.asset('assets/empity.png', fit: BoxFit.fill,)),
                SizedBox(height: 10,),
                Text('No data to display', style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),)
              ],
            )),
      );
    } else {
      return AnimationLimiter(
        child: Column(
          children: [

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: GridView.count(
                    crossAxisCount: 6,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1,
                    children: List.generate(
                        items.length,
                            (index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount: 3,
                            duration: Duration(milliseconds: 350),
                            child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      /// update product
                                      ///
                                      _productNameController.text =items[index].title;
                                      _productDescriptionController.text =items[index].description;
                                      _productPriceController.text =items[index].old_price ==null?items[index].price.toString():items[index].old_price.toString();
                                      _productArabicNameController.text = items[index].arabicTitle;
                                      _productArabicDescriptionController.text = items[index].arabicDescription;
                                      _productNewPriceController.text =items[index].old_price !=null?items[index].price.toString():items[index].old_price.toString();
                                      _productQuantityController.text = items[index].quantity.toString();
                                      productImage = items[index].imageUrl;
                                      showMaterialModalBottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30)
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) => Container(
                                              height: SizeConfig.screenHeight* 0.8,
                                              child: _updateProductForm(items[index]))
                                      );
                                    },
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 1,
                                                offset: Offset(0, 1))
                                          ]),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1.9,
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      // child: Image.network( items[index].imageUrl,
                                                      //   fit: BoxFit.fitHeight,
                                                      // )
                                                      child: CachedNetworkImage(
                                                        imageUrl: items[index]
                                                            .imageUrl,
                                                        progressIndicatorBuilder:
                                                            (context, l,
                                                            ll) =>
                                                            Center(
                                                              child: Container(
                                                                height: 30,
                                                                width: 30,
                                                                child: CircularProgressIndicator(
                                                                  value: ll
                                                                      .progress,
                                                                  color: Colors
                                                                      .black12,
                                                                ),
                                                              ),
                                                            ),
                                                        errorWidget: (context,
                                                            s, l) =>
                                                            Center(
                                                                child: Icon(
                                                                  Icons.error,
                                                                  size: 40,
                                                                  color: Colors
                                                                      .black45,)),
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    color: Colors.white,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize
                                                          .min,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        (items[index]
                                                            .old_price !=
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
                                                              fontSize:16),
                                                        )
                                                            : SizedBox
                                                            .shrink(),
                                                        SizedBox(width: 8,),
                                                        Expanded(
                                                          child: Text(
                                                            items[index]
                                                                .price
                                                                .toString(),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                                fontSize: 17),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Expanded(
                                                    child: Container(
                                                      color: Colors.white,
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      child: Text(

                                                        items[index].title

                                                        ,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black87,
                                                            fontSize: 17,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            overflow: TextOverflow
                                                                .ellipsis),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          );
                        })),
              ),
            ),
          ],
        ),
      );
    }
  }
  Widget _updateProductForm(ProductModel item) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12,),
            Text('Product image',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
            BlocConsumer<UploadBloc, UploadStates>(
                bloc: _uploadProductImageBloc,
                listener: (context, state) {
                  if(state is UploadSuccessState){
                    EasyLoading.showInfo(''
                        'Product Image successful uploaded');
                  }
                },
                builder: (context, state) {
                  if (state is UploadSuccessState) {

                    productImage = state.image;
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
                        ):Container(
                          width: 200,
                          height: 200,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.black12,
                          ),
                          child:CachedNetworkImage(
                            imageUrl: productImage,
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
                                  choosePhotoSource(context, _uploadProductImageBloc ,ImageType.COMPANY);
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
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('English Name'),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _productNameController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text('Arabic Name'),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _productArabicNameController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text('Current Price (Old Price)'),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _productPriceController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                SizedBox(height : 10,),

                Text('New Price (Discount)'),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _productNewPriceController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                        border: OutlineInputBorder(),
                    hintText: 'Write (null) that you delete the discount'
                    ),

                  ),
                ),
                SizedBox(height: 10,),

                Text('Quantity'),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _productQuantityController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text('Description'),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _productDescriptionController,
                    maxLines: 8,
                    minLines: 5,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                Text('Arabic Description'),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _productArabicDescriptionController,
                    maxLines: 8,
                    minLines: 5,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                BlocConsumer<AddProductBloc, AddProductStates>(
                  bloc: _addProductBloc,
                  listener: (context,state){
                    if(state is AddProductSuccessState){
                      snackBarSuccessWidget(context,'Updated successfully');

                    }else if(state is AddProductErrorState)
                      return snackBarErrorWidget(context, 'Update Error');
                  },
                  builder: (context,state) {
                    if(state is AddProductLoadingState){
                      return Center(child: Container(height: 30,width: 30,
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                      ),

                      );
                    }
                    return GestureDetector(
                      onTap: (){
                        String _name = _productNameController.text.trim();
                        String _arabicName = _productArabicNameController.text.trim();
                        String _des = _productDescriptionController.text.trim();
                        String _arabicDes = _productArabicDescriptionController.text.trim();
                        int _quantity =int.parse( _productQuantityController.text.trim());
                        double _curentPrice =double.parse( _productPriceController.text.trim());
                        double? _newPrice = null;

                        if(_productNewPriceController.text.trim() == 'null'){
                          _newPrice = 0.0;
                        }else
                          _newPrice = double.parse(_productNewPriceController.text.trim());

                          if(_newPrice == 0.0){

                            _newPrice = null;

                          }


                         UpdateProductRequest _updateRequest =  UpdateProductRequest(name:_name , description: _des, quantity: _quantity, current_price: _curentPrice, arabicName: _arabicName, arabicDis: _arabicDes, discount_price: _newPrice,
                         imageUrl:productImage
                         );
                         _addProductBloc.updateProduct(item.id,_updateRequest);
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),

                        ),
                        child: Center(child: Text('Update',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),)),
                      ),
                    );
                  }
                ),
                SizedBox(height: 20,),
                BlocConsumer<AddProductBloc, AddProductStates>(
                    bloc: _addProductBloc,
                    listener: (context,state){
                    },
                    builder: (context,state) {

                      return GestureDetector(
                        onTap: () async{
                          EasyLoading.show();
                          _addProductBloc.deleteProduct(item.id,item.imageUrl).then((value) {
                            if(value){
                              EasyLoading.showSuccess('Success Deleted');

                              Navigator.pop(context);
                            }else{
                              EasyLoading.showError('Error in Delete Product');
                            }
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text('Delete',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600,fontSize: 20),)),
                        ),
                      );
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  _updateCompanyDetail(String companyId){
    showMaterialModalBottomSheet(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
          ),
        ),
        context: context,
        builder: (context) => Container(
            height: SizeConfig.screenHeight* 0.8,
            child:  SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.all(16),
      child: BlocConsumer<CompanyStoreBloc,CompanyStoreStates>(
        bloc: _companyStoreBloc,
        listener: (context,state){
          if(state is UpdateCompanyStoreSuccessState){
            _companyNameController.text = state.data.name;
            _companyArabicNameController.text = state.data.name2;
            companyImage = state.data.imageUrl;
            print(companyImage);
            setState((){});
          }
          else {
            print('error');
          }
        },
        builder: (context,state) {
          if(state is UpdateCompanyStoreLoadingState)
            return Center(
              child: Container(height: 20,width: 20,child: CircularProgressIndicator(),),
            );
          else
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12,),
              Text('company image',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold)),
              BlocConsumer<UploadBloc, UploadStates>(
                  bloc: _uploadCompanyImageBloc,
                  listener: (context, state) {
                    if(state is UploadSuccessState){
             EasyLoading.showInfo('Company Image successful uploaded');
                    }
                  },
                  builder: (context, state) {
                    if (state is UploadSuccessState) {

                      companyImage = state.image;
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
                          ):Container(
                            width: 200,
                            height: 200,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.black12,
                            ),
                            child:CachedNetworkImage(
                              imageUrl: companyImage,
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
             SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('English Name'),

                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _companyNameController,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Arabic Name'),

                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _companyArabicNameController,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),

                  SizedBox(height: 30,),
                  BlocConsumer<AddCompanyBloc, AddCompanyStates>(
                      bloc: _addCompanyBloc,
                      listener: (context,state){
                        if(state is AddCompanySuccessState){
                          snackBarSuccessWidget(context,'Updated successfully');

                        }else if(state is AddCompanyErrorState)
                          return snackBarErrorWidget(context, 'Update Error');
                      },
                      builder: (context,state) {
                        if(state is AddCompanyLoadingEvent){
                          return Center(child: Container(height: 30,width: 30,
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ),

                          );
                        }
                        return GestureDetector(
                          onTap: (){
                            String _name = _companyNameController.text.trim();
                            String _arabicName = _companyArabicNameController.text.trim();


                            CompanyRequest _updateRequest =CompanyRequest(name:_name, name2: _arabicName, imageUrl: companyImage)  ;
                            _addCompanyBloc.updateCompany(companyId,_updateRequest);
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),

                            ),
                            child: Center(child: Text('Update',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),)),
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 20,),

                ],
              ),
            ],
          );
        }
      ),
    ),
    ))
    );
  }

}

