import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/advertisement_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/company_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/response/company_store_detail_response.dart';
import 'package:my_kom_dist_dashboard/module_persistence/sharedpref/shared_preferences_helper.dart';
import 'package:rxdart/rxdart.dart';

class CompanyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final PublishSubject<List<ProductModel>?> recommendedProductsPublishSubject =
  new PublishSubject();

  final PublishSubject<List<CompanyModel>?> companyStoresPublishSubject =
  new PublishSubject();
  

  final PublishSubject<List<ProductModel>?> productCompanyStoresPublishSubject =
  new PublishSubject();


  final PublishSubject<List<AdvertisementModel>?> advertisementsCompanyStoresPublishSubject =
  new PublishSubject();

  final SharedPreferencesHelper _preferencesHelper =SharedPreferencesHelper();



 Future<String?> checkStore(String zone)async{
    try {
      String storeId = '';
      /// Get Store From Zone
      ///
      late  QuerySnapshot zone_response;
        zone_response = await _firestore.collection('zones').where('name',arrayContains: zone).get();

     if(zone_response.docs.isNotEmpty){
       Map<String ,dynamic> res =  zone_response.docs[0].data()as Map <String , dynamic> ;
       storeId = res['store_id'];
     }
      /// Default Store
      ///
      if(storeId == ''){
        print(' store not found !!!!!');
        return null;

      }else{

        /// Save Current Store For Check Address Delivery
        ///
        /// Save Store Information
        _getStoreFromZone(storeId);
        _preferencesHelper.setCurrentSubArea(zone);
        print(' store found !!!!!');
        return storeId;
      }
    }catch(e){
      print('Exception !!!!!!!!!!!!!!!!!!!!!');
      print(e);
      return null;
    }
  }

  _getStoreFromZone(String storeId){
     _firestore.collection('stores').doc(storeId).get().then((value) {
       Map<String , dynamic> map = value.data() as  Map<String , dynamic>;
       double minimumPurchase =(1.0) * map['minimum_purchase'] ;
        bool vip =  map['vip'];
       _preferencesHelper.setCurrentStore(storeId);
       _preferencesHelper.setMinimumPurchaseStore(minimumPurchase);
       _preferencesHelper.setVipStore(vip);
     });
  }

  Future<void> getAllCompanies(String storeId) async {
    try {
      /// store detail
      await _firestore
          .collection('companies').where('store_id',isEqualTo: storeId)
          .snapshots()
          .forEach((element) {
        List<CompanyModel> companyList = [];
        element.docs.forEach((element) {
          Map<String, dynamic> map = element.data() as Map<String, dynamic>;
          map['id'] = element.id;
          CompanyStoreDetailResponse res = CompanyStoreDetailResponse.fromJsom(
              map);
          CompanyModel companyModel = CompanyModel(
              id: res.id, name: res.name, imageUrl: res.imageUrl,description:res.description , name2: res.name2 );
          companyModel.storeId = res.storeId;
          companyList.add(companyModel);
        });
        companyStoresPublishSubject.add(companyList);
      });
    }catch(e){
      companyStoresPublishSubject.add(null);
    }
  }

  Future<void> getCompanyProducts(String company_id) async {
    try {
      /// store detail
      await _firestore.collection('products').where('company_id',isEqualTo: company_id)
          .snapshots()
          .forEach((element) {
        List<ProductModel> productsList = [];
        element.docs.forEach((element) {

          Map<String, dynamic> map = element.data() as Map<String, dynamic>;
          print(map);
          map['id'] = element.id;
          ProductModel productModel = ProductModel.fromJson(map);
         // if(!productModel.isRecommended)
          productsList.add(productModel);
        });

        productCompanyStoresPublishSubject.add(productsList);
      });
    }catch(e){
      productCompanyStoresPublishSubject.add(null);

    }

  }

 Future<void> getRecommendedProducts(String? storeId)async {
     try {
       if(storeId ==null ){
         throw Exception();
       }
       await _firestore
           .collection('companies').where('store_id',isEqualTo: storeId)
           .snapshots()
           .forEach((element) {
             List<ProductModel> products=[];

         List<String> companyList = [];
         element.docs.forEach((element) {
           companyList.add(element.id);
         });

         _firestore
             .collection('products').where('company_id' , whereIn:companyList ).snapshots().forEach((pro) {
           pro.docs.forEach((p) {

             Map<String, dynamic> map = p.data() as Map<String, dynamic>;
             print(map);
             map['id'] = p.id;
             ProductModel productModel = ProductModel.fromJson(map);
             products.add(productModel);
           });
           recommendedProductsPublishSubject.add(products);

         });
       });
     }catch(e){
       recommendedProductsPublishSubject.add(null);

     }
  }


  Future<void> getAdvertisements(String? storeId)async {
    try {
      if(storeId ==null ){
        throw Exception();
      }
      await _firestore
          .collection('advertisements').where('storeID',isEqualTo: storeId)
          .snapshots()
          .forEach((element) {
        List<AdvertisementModel> advertisements=[];
        element.docs.forEach((a) {

          Map<String, dynamic> map = a.data() as Map<String, dynamic>;
          print(map);
          map['id'] = a.id;
          AdvertisementModel advertisementModel = AdvertisementModel.fromJson(map);
          advertisements.add(advertisementModel);
        });
        advertisementsCompanyStoresPublishSubject.add(advertisements);
  });
    }catch(e){
      advertisementsCompanyStoresPublishSubject.add(null);
    }
    }

  Future<ProductModel?> getProductDetail(String productId) async{
   try{
     return  await _firestore.collection('products').doc(productId).get().then((value) {
       Map<String, dynamic> map = value.data() as Map<String, dynamic>;
       map['id'] = value.id;
       ProductModel productModel = ProductModel.fromJson(map);
       return productModel;
     });

   }catch(e){
     return null;
   }


  }

  void getCompanyStore(String storeId) {}

  Future<CompanyModel?> getCompanyByID(String companyID) async{
   try{
  return  await  _firestore.collection('companies').doc(companyID).get().then((value) {
       Map<String ,dynamic> _rawData = value.data() as Map<String , dynamic>;
       _rawData['id'] = value.id;
       CompanyStoreDetailResponse _result = CompanyStoreDetailResponse.fromJsom(_rawData);
       CompanyModel _copmpanyModle = CompanyModel(id: _result.id, name: _result.name, name2: _result.name2, imageUrl: _result.imageUrl, description: _result.description);
       return _copmpanyModle;
     });
   }catch(e){
     return null;
   }

  }




}
