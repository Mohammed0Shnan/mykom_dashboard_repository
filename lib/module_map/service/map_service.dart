import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom_dist_dashboard/module_map/bloc/map_bloc.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';


class MapService {
  // final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<MapData> getCurrentLocation() async {
        try {
          bool serviceEnabled;
          LocationPermission permission;
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            Future.error('Location services are disabled');
            throw('Location services are disabled');
          }

          permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              Future.error('Location permissions are denied');
              throw('Location permissions are denied');

            }
          }

          if (permission == LocationPermission.deniedForever) {
            Future.error(
                'Location permissions are permanently denied, we cannot request permissions.');
            throw( 'Location permissions are permanently denied, we cannot request permissions.');

          }

          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          LocationInformation s = await getPositionDetail(
              LatLng(position.latitude, position.longitude));

          return MapData(name: "${s.title!} ${s.subTitle!}",
              longitude: position.longitude,
              latitude: position.latitude,
              isError: false,
              message: 'success'
          );

        }catch(e){
          return MapData.error(e.toString());
        }


  }

  Future<bool> saveLocation(LatLng latLng ,String description) async {
    return true;
  }

  Future<LocationInformation> getPositionDetail(LatLng latLng) async {
   //
    print('11111111111111111111111111111111111111111111111111');

    List<Placemark> placemarks = await placemarkFromCoordinates(
       latLng.latitude, latLng.longitude,
       localeIdentifier: 'en');
    print('222222222222222222222222222222222222222222222222222222');
   LocationInformation address = _getDetailFromPlacemark(placemarks);
    AddressModel a = AddressModel(description: '', latitude: 0.0, longitude: 0.0, geoData: {});
    // GeoCode geocode = GeoCode();
    // Address add = await geocode.reverseGeocoding(latitude: latLng.latitude, longitude: latLng.longitude);
    // LocationInformation _l = LocationInformation();
    print('33333333333333333333333333333333333333333333333333333333333');
    // _l.title = add.countryName;
    // _l.subTitle = add.streetAddress;
  return  LocationInformation();

  }

  Future<String> getSubArea(LatLng latLng)async{
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: 'en');

    Placemark place1 = placemarks[0];
    print(place1);
    String zone ='';
    if(place1.locality == ''){
      if(place1.subLocality ==''){
        if(place1.subAdministrativeArea ==''){
          zone = place1.administrativeArea!;
        }else{
          zone = place1.subAdministrativeArea!;
        }
      }else{
        zone = place1.subLocality!;
      }
    }else{
      zone=place1.locality!;
    }
    print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    print(zone);
    return zone;
  }



  LocationInformation _getDetailFromPlacemark(List<Placemark>? placemarks) {
    print('_______________________ get sub area in service -------------');
    print(placemarks);
    Placemark place1 = placemarks![0];
    //Placemark place2 = placemarks[1];
    LocationInformation _information = LocationInformation();
    _information.title ="${place1.name}";
    if(place1.street == ''){
 _information.subTitle = "${place1.name} ${place1.thoroughfare} ${place1.subLocality} ${place1.locality}";
    }
    else{
    _information.subTitle = '${place1.street}';
    }
    
        return _information;
  }

 Future<String> getDumyPosition()async{
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Future.error('Location services are disabled');
        throw('Location services are disabled');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Future.error('Location permissions are denied');
          throw('Location permissions are denied');

        }
      }

      if (permission == LocationPermission.deniedForever) {
        Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
        throw( 'Location permissions are permanently denied, we cannot request permissions.');

      }
     String subArea = await getSubArea(LatLng(37.42270380149313, -122.08567522466183));
    return subArea;

    }catch(e){

return '';

    }
  }

 Future<String?> getSubAreaPosition(LatLng? latLng)async {
   late String subArea ;
   try{
     if(latLng == null){
       MapData data =  await getCurrentLocation();
       subArea = await getSubArea(LatLng(data.latitude,data.longitude));
     }else{
       subArea = await getSubArea(latLng);
     }
     return subArea;

   }catch(e){
     return null;
   }
  }

 Future<bool> checkAddressInArea(String storeId,String address) async{
    print(address);
   QuerySnapshot zone_response = await _firestore.collection('zones').where('store_id',isEqualTo: storeId).where('name',arrayContains: address).get();
   return zone_response.docs.length != 0;
  }


}
