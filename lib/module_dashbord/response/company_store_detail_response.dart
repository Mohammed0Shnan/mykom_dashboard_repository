

class CompanyStoreDetailResponse{
  late String id;
  late final String storeId;
  late String name;
  late String name2;
  late String imageUrl;
  late String description;
  late bool is_active;

  CompanyStoreDetailResponse();

  CompanyStoreDetailResponse.fromJsom(Map<String, dynamic> data){
    this.id= data['id'];
    this.name= data['name'];
    this.name2 = data['name2'];
    this.is_active = data['is_active'];
    this.imageUrl= data['imageUrl'];
    this.description= data['description'];
    this.storeId= data['store_id'];

  }

}