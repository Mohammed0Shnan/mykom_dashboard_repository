

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_kom_dist_dashboard/injecting/components/app.component.dart';
import 'package:my_kom_dist_dashboard/module_authorization/authorization_module.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/dashboard_module.dart';
import 'package:my_kom_dist_dashboard/module_splash/splash_module.dart';
import 'package:my_kom_dist_dashboard/module_splash/splash_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'module_map/map_module.dart';

Future<void> backgroundHandler(RemoteMessage message)async{
  FirebaseMessaging.instance.subscribeToTopic('advertisements');
}
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD2mHkT8_abpMD9LJl307Qhk7GHWuKqMJw",
      authDomain: "mykom-tech-dist.firebaseapp.com",
      projectId: "mykom-tech-dist",
      storageBucket: "mykom-tech-dist.appspot.com",
      messagingSenderId: "686046357650",
      appId: "1:686046357650:web:7b9358804ef56237685e4b",
      measurementId: "G-EMWBX8R71F"
    )
  );
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  final container = await AppComponent.create();
  BlocOverrides.runZoned(
        () {
      return runApp(container.app);
    },
    blocObserver: AppObserver(),
  );
  configLoading();
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  final SplashModule _splashModule;
  final AuthorizationModule _authorizationModule;
  final MapModule _mapModule;
  final DashBoardModule _dashBoardModule;
  MyApp(this._splashModule,
      this._authorizationModule,this._mapModule,this._dashBoardModule);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer;

  @override
  void deactivate() {

    EasyLoading.dismiss();
    super.deactivate();
  }
  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    //FireNotificationService().init(context);

    // FirebaseMessaging.instance.getInitialMessage().then((value) {
    //   if(value != null){
    //     final routeFromMessage = value.data['route'];
    //     Navigator.of(context).pushNamed( DashboardRoutes.DASHBOARD_SCREEN);
    //   }
    // });
    ///


    // FirebaseMessaging.onMessage.listen((event) {
    //   print('##############  notification #############');
    //   if(event.notification != null){
    //     print(event.notification!.body);
    //     print(event.notification!.title);
    //     print(event.notification!.toMap());

    //   }
    //   FireNotificationService().display(event);
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   print('##############  notification Clicked 000000000#############');
    //   final routeFromMessage = event.data['route'];
    //   Navigator.of(context).pushNamed( DashboardRoutes.DASHBOARD_SCREEN);
    //   print(routeFromMessage);
    // });


    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Map<String, WidgetBuilder> routes = {};

    routes.addAll(widget._splashModule.getRoutes());
    routes.addAll(widget._authorizationModule.getRoutes());
    routes.addAll(widget._mapModule.getRoutes());
    routes.addAll(widget._dashBoardModule.getRoutes());

    return FutureBuilder<Widget>(
      initialData: Container(color: Colors.green),
      future: configuratedApp(routes),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        return snapshot.data!;
      },
    );
  }

  Future<Widget> configuratedApp(Map<String, WidgetBuilder> routes) async {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyKom Dashboard',
        routes: routes,
        initialRoute: SplashRoutes.SPLASH_SCREEN,
      builder: EasyLoading.init(),
    );

  }
  @override
  void dispose() {
    super.dispose();
  }
}

class AppObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print(bloc);
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    print(bloc);
    super.onClose(bloc);
  }


}
