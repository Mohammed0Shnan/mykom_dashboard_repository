import 'package:my_kom_dist_dashboard/injecting/components/app.component.dart';
import 'package:my_kom_dist_dashboard/main.dart';
import 'package:my_kom_dist_dashboard/module_authorization/authorization_module.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/login_screen.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/register_screen.dart';
import 'package:my_kom_dist_dashboard/module_authorization/service/auth_service.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/dashboard_module.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/screen/dash_bord_screen.dart';
import 'package:my_kom_dist_dashboard/module_map/map_module.dart';
import 'package:my_kom_dist_dashboard/module_map/screen/map_screen.dart';
import 'package:my_kom_dist_dashboard/module_splash/screen/splash_screen.dart';
import 'package:my_kom_dist_dashboard/module_splash/splash_module.dart';
class AppComponentInjector implements AppComponent {
  AppComponentInjector._();


  static Future<AppComponent> create() async {
    final injector = AppComponentInjector._();
    return injector;
  }

  MyApp _createApp() => MyApp(
_createSplashModule(),
      _createAuthorizationModule(),
      _createMapModule(),
      _createDashBoard()
      );


  SplashModule _createSplashModule() => SplashModule(SplashScreen(AuthService()));

  AuthorizationModule _createAuthorizationModule() =>
      AuthorizationModule( LoginScreen(), RegisterScreen() );

  MapModule _createMapModule() => MapModule(MapScreen());
  DashBoardModule _createDashBoard()=> DashBoardModule(DashBoardScreen());
  MyApp get app {
    return _createApp();
  }
}
