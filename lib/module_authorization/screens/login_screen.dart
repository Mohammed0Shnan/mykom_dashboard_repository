import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_authorization/bloc/cubits.dart';
import 'package:my_kom_dist_dashboard/module_authorization/bloc/login_bloc.dart';
import 'package:my_kom_dist_dashboard/module_authorization/enums/user_role.dart';
import 'package:my_kom_dist_dashboard/module_authorization/screens/reset_password_screen.dart';
import 'package:my_kom_dist_dashboard/module_authorization/service/auth_service.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/dashboard_routes.dart';
import 'package:my_kom_dist_dashboard/utils/size_configration/size_config.dart';

class LoginScreen extends StatefulWidget {
  final LoginBloc _loginBloc = LoginBloc();
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _LoginFormKey = GlobalKey<FormState>();
  final TextEditingController _LoginEmailController = TextEditingController();
  final TextEditingController _LoginPasswordController =
      TextEditingController();

  late final PasswordHiddinCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = PasswordHiddinCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.1,),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: Image.asset('assets/new_logo.png',height:SizeConfig.screenHeight * 0.2,),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text('Welcome',style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 4,),
                Center(
                  child: Text('Sign in to continue',style: GoogleFonts.lato(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.1,),
                Container(
                  height:  SizeConfig.screenHeight * 0.3,
                  width:  SizeConfig.screenWidth * 0.3,
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))


                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Form(
                        key: _LoginFormKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                    title: Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Text('EMAIL',style:GoogleFonts.lato(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 14
                                        ))),
                                    subtitle: Container(
                                      child: SizedBox(
                                        child: TextFormField(

                                          style: TextStyle(fontSize: 18,
                                              height:1
                                          ),
                                          keyboardType: TextInputType.emailAddress,
                                          controller: _LoginEmailController,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              border:OutlineInputBorder(

                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      style:BorderStyle.solid ,
                                                      color: Colors.black87
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                              hintText: 'Email',
                                              hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                                            //S.of(context).name,
                                          ),
                                          textInputAction: TextInputAction.next,
                                          onEditingComplete: () => node.nextFocus(),

                                          validator: (result) {
                                            if (result!.isEmpty) {
                                              return 'Email Address is Required'; //S.of(context).nameIsRequired;
                                            }
                                            if (!_validateEmailStructure(result))
                                              return 'Must write an email address';
                                            return null;
                                          },
                                        ),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height:3,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),

                                ),
                                child: ListTile(
                                  title: Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text('PASSWORD',style:GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 14
                                      ))),
                                  subtitle: BlocBuilder<PasswordHiddinCubit,
                                      PasswordHiddinCubitState>(
                                    bloc: cubit,
                                    builder: (context, state) {
                                      return SizedBox(
                                        child: TextFormField(
                                          controller: _LoginPasswordController,
                                          style: TextStyle(
                                              fontSize: 18,
                                              height: 1
                                          ),
                                          decoration: InputDecoration(
                                              isDense: true,
                                              errorStyle: GoogleFonts.lato(
                                                color: Colors.red.shade700,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                              suffixIconConstraints: BoxConstraints(
                                                minHeight: 20,

                                              ),
                                              suffixIcon: SizedBox(
                                                height: 2,
                                                child: IconButton(
                                                    onPressed: () {
                                                      cubit.changeState();
                                                    },
                                                    icon: state ==
                                                        PasswordHiddinCubitState
                                                            .VISIBILITY
                                                        ? Icon(Icons.visibility)
                                                        : Icon(Icons.visibility_off)),
                                              ),
                                              border:OutlineInputBorder(

                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      style:BorderStyle.solid ,
                                                      color: Colors.black87
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              hintText: 'Password',
                                              hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                                          ),
                                          obscureText:
                                          state == PasswordHiddinCubitState.VISIBILITY
                                              ? false
                                              : true,

                                          textInputAction: TextInputAction.done,
                                          onFieldSubmitted: (v) => node.unfocus(),
                                          // Move focus to next
                                          validator: (result) {
                                            if (result!.isEmpty) {
                                              return '* Password is Required'; //S.of(context).emailAddressIsRequired;
                                            }
                                            if (result.length < 8) {
                                              return '* The password is short, it must be 8 characters long'; //S.of(context).emailAddressIsRequired;
                                            }

                                            return null;
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                        RestPasswordScreen()
                                    ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        right: 20),
                                    child: Text('Forgot password ?',
                                        style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black54,
                                          fontSize:11,
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:15,
                              ),
                              BlocConsumer<LoginBloc, LoginStates>(
                                  bloc: widget._loginBloc,
                                  listener: (context, LoginStates state)async {
                                    if (state is LoginSuccessState) {
                                      EasyLoading.showSuccess(state.message);
                                    //  snackBarSuccessWidget(context, state.message);
                                      UserRole? role = await AuthService().userRole;
                                      if(role != null){

                                        if (role == UserRole.ROLE_OWNER) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context, DashboardRoutes.DASHBOARD_SCREEN,(route)=> false);
                                        }
                                      }

                                    } else if (state is LoginErrorState) {
                                      EasyLoading.showError(state.message);
                                     // snackBarErrorWidget(context, state.message);
                                    }
                                    else if(state is LoginLoadingState)
                                      EasyLoading.show();
                                  },
                                  builder: (context, LoginStates state) {

                                      return ListTile(
                                        title: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 50),
                                          height:55,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10)),
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: ClipRRect(
                                            clipBehavior: Clip.antiAlias,
                                            borderRadius: BorderRadius.circular(10),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(

                                                  primary:ColorsConst.mainColor,
                                                ),
                                                onPressed: () {
                                                  if (_LoginFormKey.currentState!
                                                      .validate()) {
                                                    String email =
                                                    _LoginEmailController.text.trim();
                                                    String password =
                                                    _LoginPasswordController.text
                                                        .trim();
                                                    widget._loginBloc
                                                        .login(email, password);
                                                  }
                                                },
                                                child: Text('LOGIN',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                        15,
                                                        fontWeight: FontWeight.w700))),
                                          ),
                                        ),
                                      );
                                  }),
                              // Container(
                              //   alignment: Alignment.center,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Text(
                              //         'Don\'t have an account ?  ',
                              //         style:  GoogleFonts.lato(
                              //           fontWeight: FontWeight.w800,
                              //           color: Colors.black45,
                              //           fontSize: SizeConfig.titleSize * 1.5,
                              //         ),
                              //       ),
                              //       GestureDetector(
                              //         onTap: () {
                              //           Navigator.pushNamed(
                              //               context,
                              //               AuthorizationRoutes.REGISTER_SCREEN,
                              //               arguments: UserRole.ROLE_USER
                              //           );
                              //         },
                              //         child: Text('Create an account',
                              //             style:  GoogleFonts.lato(
                              //                 fontSize: SizeConfig.titleSize * 2,
                              //                 fontWeight: FontWeight.bold,
                              //                 color: Colors.blue                          )
                              //
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
SizedBox(height: 20,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

          ],
        ),

    );
  }

  bool _validateEmailStructure(String value) {
    //     String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$';
    String pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
