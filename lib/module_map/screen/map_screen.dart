import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_map/bloc/map_bloc.dart';
import 'package:my_kom_dist_dashboard/module_map/models/address_model.dart';
import 'package:my_kom_dist_dashboard/module_map/service/map_service.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class MapScreen extends StatefulWidget {

   const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

const kGoogleApiKey = 'AIzaSyD2mHkT8_abpMD9LJl307Qhk7GHWuKqMJw';

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _MapScreenState extends State<MapScreen> {
  final MapService _mapService = MapService();

  Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(24.46515637636609, 54.351306818425655), zoom: 26.0);
  late final TextEditingController _searchController;
  bool? register = null;
  String language ='en';
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      register = ModalRoute.of(context)!.settings.arguments as bool;
    });
    super.initState();
    _searchController = TextEditingController(text: '');
    //mapBloc.getCurrentPosition();
  }

  final Set<Marker> _markers = Set<Marker>();
  late GoogleMapController googleMapController;
  Map<String, dynamic>? location_from_search = null;
  final Mode _mode = Mode.overlay;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapStates>(
      bloc: mapBloc,
      listener: (context, state) async {
        if (state is MapSuccessState) {
          LatLng latLng = LatLng(state.data.latitude, state.data.longitude);
          _searchController.text = state.data.name;
          mapBloc.getGesturePosition(latLng, '').then((value) {
            location_from_search = null;
            _move(latLng);
            getDetailFromLocation(latLng);
          });
        } else if (state is MapErrorState) {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
                icon: Icon(Icons.location_off_sharp),
                message: state.error_message),
          );
        } else if (state is MapSuccessSavePositionState) {
          late AddressModel addressModel;
          if (location_from_search != null) {
            LatLng latLan = location_from_search!['po'] as LatLng;
            String n = location_from_search!['name'] as String;
            addressModel = AddressModel(
                description: n,
                latitude: latLan.latitude,
                longitude: latLan.longitude,
                geoData: {});
            String subArea = await _mapService
                .getSubArea(LatLng(latLan.latitude, latLan.longitude));
            addressModel.subArea = subArea;
          } else {
            addressModel = AddressModel(
                description: _searchController.text,
                latitude: state.latitude,
                longitude: state.longitude,
                geoData: {});
            String subArea = await _mapService
                .getSubArea(LatLng(state.latitude, state.longitude));
            addressModel.subArea = subArea;
          }
          Navigator.pop(context, addressModel);
        } else if (state is MapGestureSuccessState) {
          location_from_search = null;
          LatLng latLng = LatLng(state.data.latitude, state.data.longitude);
          getDetailFromLocation(latLng);
          _mapService.getSubArea(latLng);
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,
                    child: GoogleMap(
                      onTap: (v) {
                        print(v);
                        LatLng latLng = LatLng(v.latitude, v.longitude);
                        mapBloc.getGesturePosition(latLng, '');
                      },
                      markers: _markers,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      zoomGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      zoomControlsEnabled: true,
                      scrollGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                  if (state is MapLoadingState)
                    Positioned.fill(
                      child: Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsConst.mainColor,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _handlePressButton,
                              child: Container(
                                  height: SizeConfig.heightMulti * 6,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: ColorsConst.mainColor
                                                .withOpacity(0.1),
                                            blurRadius: 2,
                                            spreadRadius: 1)
                                      ]),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Icon(
                                          Icons.location_on,
                                          color: ColorsConst.mainColor,
                                        ),
                                      ),

                                      Expanded(
                                        child: Container(
                                            padding: EdgeInsets.all(4),
                                            alignment: Alignment.centerLeft,
                                            height: SizeConfig.heightMulti * 6,
                                            child: Text(
                                              _searchController.text,
                                              style: GoogleFonts.lato(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Icon(
                                        Icons.search,
                                        ),
                                      ),
                                    ],
                                  )
                                  ),
                            ),
                          ),
                        ],
                      )),
                  Positioned(
                      bottom: 15,
                      left: 15,
                      right: 15,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorsConst.mainColor,
                        elevation: 10,
                        child: Container(
                          height: SizeConfig.heightMulti * 7,
                          child: TextButton(
                            onPressed: () {
                              if (location_from_search != null) {
                                LatLng latLan =
                                    location_from_search!['po'] as LatLng;
                                String n =
                                    location_from_search!['name'] as String;
                                mapBloc.saveLocation(latLan, n);
                              } else {
                                if (state is MapGestureSuccessState) {
                                  LatLng latLng = LatLng(state.data.latitude,
                                      state.data.longitude);
                                  mapBloc.saveLocation(latLng, state.data.name);
                                } else {
                                  showTopSnackBar(
                                    context,
                                    CustomSnackBar.info(
                                      backgroundColor: ColorsConst.mainColor,
                                      icon: Icon(Icons.location_on),
                                      message: "Select the address and save !",
                                    ),
                                    displayDuration: Duration(seconds: 1),
                                  );
                                }
                              }
                            },
                            child: Text(
                              register == null
                                  ? 'Save'
                                  : register!
                                      ? 'Save'
                                      : 'Delivery here',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.titleSize * 2.8,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.1),
              child: FloatingActionButton(
                onPressed: () {
                  mapBloc.getCurrentPosition();
                },
                child: Icon(Icons.my_location),
              ),
            ));
      },
    );
  }

  getDetailFromLocation(LatLng latLng) async {
    LocationInformation _currentAddress =
        await _mapService.getPositionDetail(latLng);
    Marker marker = Marker(
        markerId: MarkerId('_current_position'),
        infoWindow: InfoWindow(
          title: _currentAddress.title,
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: latLng);
    _searchController.text = "${_currentAddress.subTitle}";
    _setMarker(marker);
  }

  Future<void> _move(LatLng latLng) async {
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 26.0);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _setMarker(Marker marker) {
    _markers.clear();
    _markers.add(marker);
    setState(() {});
  }

  /// search

  Future<void> _handlePressButton() async {

    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        radius: 1000,
        language: language,
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, "ae")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    _searchController.text = detail.result.name;

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    location_from_search = {'po': LatLng(lat, lng), 'name': detail.result.name};
    _setMarker(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 26.0));
  }
}
