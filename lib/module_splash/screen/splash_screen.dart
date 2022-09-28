import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/authorization_routes.dart';
import 'package:my_kom_dist_dashboard/module_authorization/enums/user_role.dart';
import 'package:my_kom_dist_dashboard/module_authorization/service/auth_service.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/dashboard_routes.dart';
import 'package:my_kom_dist_dashboard/module_splash/bloc/splash_bloc.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final AuthService _authService;
  // final ProfileService _profileService;

  SplashScreen(
    this._authService,
    // this._profileService,
  );

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    spalshAnimationBloC.playAnimation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getNextRoute().then((route) async {
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
      });
    });
  }

  @override
  void dispose() {
    spalshAnimationBloC.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: SizeConfig.screenHeight,
            ),
            Center(
              child: Container(
                child: BlocConsumer<SpalshAnimationBloC, bool>(
                  bloc: spalshAnimationBloC,
                  listener: (context, state) {},
                  builder: (context, state) {
                    double current_width = 0;
                    if (state) {
                      current_width = SizeConfig.screenWidth * 0.5;
                    } else
                      current_width = 0;
                    return AnimatedContainer(
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(color: ColorsConst.mainColor),
                        child: Image.asset(
                          'assets/new_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 10 * SizeConfig.heightMulti,
                      width: current_width,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getNextRoute() async {
    try {
      // Is LoggedIn
      UserRole? role = await widget._authService.userRole;
      print('***************************');
      if (role != null) {
        if (role == UserRole.ROLE_OWNER) {
          print('splash  owner role ====================================');
          return DashboardRoutes.DASHBOARD_SCREEN;
        } else {
          return AuthorizationRoutes.LOGIN_SCREEN;
        }
      }
      // Is Not LoggedInt
      else {
        return AuthorizationRoutes.LOGIN_SCREEN;
      }
    } catch (e) {
      return AuthorizationRoutes.LOGIN_SCREEN;
    }
  }
}
